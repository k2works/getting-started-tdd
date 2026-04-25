{ packages ? import <nixpkgs> {} }:
let
  baseShell = import ../../shells/shell.nix { inherit packages; };
  phpWithXdebug = packages.php.withExtensions ({ enabled, all }: enabled ++ [
    all.xdebug
  ]);
in
packages.mkShell {
  inherit (baseShell) pure;
  buildInputs = baseShell.buildInputs ++ (with packages; [
    phpWithXdebug
    php83Packages.composer
    phpactor
  ]);
  shellHook = ''
    ${baseShell.shellHook}
    echo "PHP development environment activated"
    echo "  - PHP: $(php --version | head -n 1)"
    echo "  - Composer: $(composer --version)"
    echo "  - PHPActor: phpactor --version (not always available in CLI directly)"
  '';
}
