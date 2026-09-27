(defproject fizzbuzz-jp "0.1.0-SNAPSHOT"
  :description "なでしこ3 実装を日本語の識別子で Clojure に移植する"
  :license {:name "MIT"}
  :dependencies [[org.clojure/clojure "1.11.1"]]
  ;; 既存 apps/clojure の eastwood・kibit は Clojars から取得できない（403 Forbidden）ため
  ;; plugin は宣言しない。lint と format は Nix 環境の clojure-lsp（clj-kondo・cljfmt 内蔵）で行う。
  :target-path "target/%s")
