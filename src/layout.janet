(import joy :prefix "")

(defn app [{:body body :request request}]
  (text/html
    (doctype :html5)
    [:html {:lang "en"}
     [:head
      [:meta {:charset "utf-8"}]
      [:meta {:name "viewport" :content "width=device-width, initial-scale=1"}]
      [:meta {:name "csrf-token" :content (authenticity-token request)}]
      [:link {:href "https://cdn.jsdelivr.net/npm/picnic" :rel "stylesheet"}]
      [:link {:href "/app.css" :rel "stylesheet"}]
      [:title "Is Janet There Yet?"]]
     [:body
      body
      [:script {:src "/app.js"}]]]))
