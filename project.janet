(declare-project
  :name "isjanetthereyet"
  :description ""
  :dependencies ["https://github.com/joy-framework/joy" "https://github.com/andrewchambers/janet-pq" "https://github.com/sepisoad/jurl"]
  :author ""
  :license ""
  :url ""
  :repo "")

(declare-executable
  :name "isjanetthereyet"
  :entry "main.janet")

(phony "server" []
  (do
    (os/shell "pkill -xf 'janet main.janet'")
    (os/shell "janet main.janet")))

(phony "watch" []
  (do
    (os/shell "pkill -xf 'janet main.janet'")
    (os/shell "janet main.janet &")
    (os/shell "fswatch -o src | xargs -n1 -I{} ./watch")))
