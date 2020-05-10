(import curl)
(import json)

(def github-token (os/getenv "GITHUB_TOKEN"))

(defn chomp [string]
  (first (string/split "\n" string)))

(defn transform-headers [headers]
  (var transformed @{})
  (each h headers ((fn [x]
    (def split (string/split ": " (chomp x)))
    (if (= 2 (length split)) (put transformed (split 0) (split 1)))) h))
  (identity transformed))

(defn http-get [url]
  (var response "")
  (var headers @[])
  (def c (curl/easy/init))
  (:setopt c
    :url url
    :write-function (fn [buf] (set response (string response buf)))
    :header-function (fn [h] (array/concat headers h))
    :http-header @[(string "Authorization: token " github-token)]
    :user-agent "janet-jurl")
  (:perform c)
  @{:body (json/decode response) :headers (transform-headers headers)})

(def links-grammar
'{:url (capture (some (+ :w (set ".+:/%?=&_"))))
  :ws (any :s)
  :relation (capture (some :w))
  :link (sequence "<" :url ">;" :ws "rel=\"" :relation "\"")
  :separator (sequence "," :ws)
  :main (some (sequence :link (? :separator)))})

(defn find-next-link [headers]
  (def link (get headers "Link"))
  (def links (peg/match links-grammar link))
  (if (not (nil? links)) (do
    (def index-of-next (find-index (fn [x] (= x "next")) links))
    (if (nil? index-of-next) nil (in links (- index-of-next 1))))))

(defn not-in-array? [ary item]
  (nil? (find (fn [x] (= x item)) ary)))

(defn now-utc []
  (def date (os/date))
  @[(date :year) (+ 1 (date :month)) (+ 1 (date :month-day)) (date :hours) (date :minutes)])

(defn parse-entry [entry stats]
  (def repo-info (get entry "repository"))
  (def owner-info (get repo-info "owner"))
  (def repo-name (get repo-info "full_name"))
  (def owner-name (get owner-info "login"))

  (put stats :files_no (+ 1 (get stats :files_no)))
  
  (if (not-in-array? (get stats :repos) repo-name)
    (do
      (put stats :repos (array/concat (get stats :repos) repo-name))
      (put stats :repos_no (+ 1 (get stats :repos_no)))))

  (if (not-in-array? (get stats :users) owner-name)
    (do
      (put stats :users (array/concat (get stats :users) owner-name))
      (put stats :users_no (+ 1 (get stats :users_no))))))

(defn get-stats [url stats]
  (print (string "Fetching " url)) 
  (def response (http-get url))
  (def body (get response :body))
  (each entry (get body "items") (parse-entry entry stats))
  
  (def headers (get response :headers))
  (print (string "Rate limit remaining: " (get headers "X-RateLimit-Remaining")))
  (def next-link (find-next-link headers))
  (if (nil? next-link) nil (get-stats next-link stats)))

(def stats @{:files_no 0 :repos_no 0 :users_no 0 :repos @[] :users @[]})

(get-stats `https://api.github.com/search/code?q=extension:janet+NOT+nothack&per_page=100` stats)

(import db)
(db/connect)
(let [now (now-utc)
  current-day (string (now 0) "-" (now 1) "-" (now 2))
  count-query (string "select count(*) from stats where day = '" current-day "'")
  cnt (db/val count-query)
  params {:repos (get stats :repos_no) :users (get stats :users_no) :files (get stats :files_no) :current_timestamp (os/mktime (os/date)) :day [1082 false current-day]}]
  (if (= cnt (int/s64 "0"))
    (let [query "insert into stats (num_repos, num_users, num_files, updated_at, day) values (:repos, :users, :files, :current_timestamp, :day:: date)"]
      (db/execute query params))
    (let [query "update stats set num_repos = :repos, num_users = :users, num_files = :files, updated_at = :current_timestamp where day = :day"]
      (db/execute query params))))