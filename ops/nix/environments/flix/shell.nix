{ packages ? import <nixpkgs> {} }:
let
  baseShell = import ../../shells/shell.nix { inherit packages; };
  # Flix は単一 jar として配布されるため、apps/flix/flix.toml のバージョンに合わせて取得する。
  flixVersion = "0.75.1";
in
packages.mkShell {
  inherit (baseShell) pure;
  buildInputs = baseShell.buildInputs ++ (with packages; [
    jdk21
  ]);
  shellHook = ''
    ${baseShell.shellHook}

    export FLIX_VERSION="${flixVersion}"
    export FLIX_JAR="$(pwd)/apps/flix/flix.jar"

    # flix.jar が未取得なら flix.toml のバージョンに合わせてダウンロードする（.gitignore 対象）。
    if [ ! -f "$FLIX_JAR" ] && [ -d "$(pwd)/apps/flix" ]; then
      echo "Downloading Flix ${flixVersion} ..."
      curl -fsSL -o "$FLIX_JAR" \
        "https://github.com/flix/flix/releases/download/v${flixVersion}/flix.jar" \
        || echo "  (flix.jar のダウンロードに失敗しました。ネットワークを確認してください)"
    fi

    # `flix <args>` を `java -jar flix.jar <args>` として使えるようにする。
    flix() { java -jar "$FLIX_JAR" "$@"; }
    export -f flix 2>/dev/null || true

    echo "Flix development environment activated"
    echo "  - JDK: $(javac -version 2>&1)"
    if [ -f "$FLIX_JAR" ]; then
      echo "  - Flix: $(java -jar "$FLIX_JAR" --version 2>&1 | head -n 1)"
    else
      echo "  - Flix: flix.jar 未取得（apps/flix で 'flix --version' を実行すると取得されます）"
    fi
    echo "  使い方: cd apps/flix && flix test   （= java -jar flix.jar test）"
  '';
}
