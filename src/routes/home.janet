(import joy :prefix "")

(defn index [request]
  (let [row (db/row "select num_repos, num_users, num_files, day::text as day from stats order by day desc limit 1")]
    [:main
      [:h1 {:class "header"} "Is Janet There Yet?"]
      [:div {:class "flex three numbers"}
        [:div
          [:p "Repositories"]
          [:h2 (get row :num_repos)]]
        [:div
          [:p "Users"]
          [:h2 (get row :num_users)]]
        [:div
          [:p {:class "content"} "Files"]
          [:h2 (get row :num_files)]]]
      [:p 
        [:span "This website is related to "]
        [:a {:href "https://github.com/github/linguist/pull/4674"} "this pull request"]
        [:span " to Github's Linguist. It says that before accepting the language should have not very precise amount of usage."]]
      [:blockquote "In most cases we prefer that each new file extension be in use in hundreds of repositories before supporting them in Linguist."]
      [:section {:class "footer"}
        [:p 
          (string "Powered by Janet (" janet/version ") and Joy (" version "). Data generated on " (row :day) ".")]]]))
