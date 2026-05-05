{ packages ? import <nixpkgs> {} }:
let
  baseShell = import ../../shells/shell.nix { inherit packages; };
  codeLLDB = packages.vscode-extensions.vadimcn.vscode-lldb;
in
packages.mkShell {
  inherit (baseShell) pure;
  buildInputs = baseShell.buildInputs ++ (with packages; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    just
    codeLLDB
  ]);
  shellHook = ''
    ${baseShell.shellHook}
    export CODELLDB_PATH="${codeLLDB}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb"
    echo "Rust development environment activated"
    echo "  - rustc: $(rustc --version)"
    echo "  - cargo: $(cargo --version)"
    echo "  - codelldb: $CODELLDB_PATH"
  '';
}
