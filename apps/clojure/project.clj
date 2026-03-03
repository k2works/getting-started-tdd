(defproject fizzbuzz "0.1.0-SNAPSHOT"
  :description "FizzBuzz - TDD practice in Clojure"
  :license {:name "MIT"}
  :dependencies [[org.clojure/clojure "1.11.1"]]
  :plugins [[lein-cloverage "1.2.4"]
            [lein-kibit "0.1.8"]
            [jonase/eastwood "1.4.3"]
            [lein-bikeshed "0.5.2"]]
  :bikeshed {:verbose true
             :max-line-length 100}
  :aliases {"complexity" ["run" "-m" "complexity-checker"]}
  :main ^:skip-aot fizzbuzz.core
  :target-path "target/%s"
  :profiles {:dev {:source-paths ["dev"]}
             :uberjar {:aot :all
                       :jvm-opts ["-Dclojure.compiler.direct-linking=true"]}})
