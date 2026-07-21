{ packages ? import <nixpkgs> {} }:
let
  baseShell = import ../../shells/shell.nix { inherit packages; };
in
packages.mkShell {
  inherit (baseShell) pure;
  buildInputs = baseShell.buildInputs ++ (with packages; [
    swi-prolog
  ]);
  shellHook = ''
    ${baseShell.shellHook}
    echo "Prolog development environment activated"
    echo "  - SWI-Prolog: $(swipl --version)"
    echo "  使い方: cd apps/prolog && make test   （= swipl -g run_tests でユニットテスト）"
  '';
}
