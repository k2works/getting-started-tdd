{ packages ? import <nixpkgs> {} }:
let
  baseShell = import ../../shells/shell.nix { inherit packages; };
  # なでしこ3 の Go 実装（nadesiko3go）の CLI 版 gonako を 3.8.8 タグのコミットで固定して導入する。
  gonakoVersion = "3.8.8";
  gonakoCommit = "f840295acd3d1a81b4e846a0bd33dda1877af9da";
in
packages.mkShell {
  inherit (baseShell) pure;
  buildInputs = baseShell.buildInputs ++ (with packages; [
    go
    gnumake
  ]);
  shellHook = ''
    ${baseShell.shellHook}

    export GONAKO_VERSION="${gonakoVersion}"
    export GOBIN="$(pwd)/apps/nadesiko/bin"
    export PATH="$GOBIN:$PATH"
    # nadesiko3go の go.mod は Go 1.26 以上を要求するため、必要なら新しいツールチェーンを自動取得する。
    export GOTOOLCHAIN=auto

    # gonako が未導入なら固定コミットからビルドする（bin/ は .gitignore 対象）。
    # GUI 版は gtk / webkit2gtk に依存するため、CLI 版（cmd/gonako）のみを導入する。
    if [ ! -x "$GOBIN/gonako" ] && [ -d "$(pwd)/apps/nadesiko" ]; then
      echo "Installing gonako ${gonakoVersion} ..."
      go install "github.com/kujirahand/nadesiko3go/cmd/gonako@${gonakoCommit}" \
        || echo "  (gonako の導入に失敗しました。ネットワークを確認してください)"
    fi

    echo "Nadesiko3 development environment activated"
    echo "  - Go: $(go version)"
    if [ -x "$GOBIN/gonako" ]; then
      echo "  - gonako: $(gonako version)"
    fi
    echo "  使い方: cd apps/nadesiko && make test   （= test/*_test.nako3 を gonako で順に実行）"
  '';
}
