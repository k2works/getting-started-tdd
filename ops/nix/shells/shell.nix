{ packages ? import <nixpkgs> {} }:
packages.mkShell {
  buildInputs = with packages; [
    git
    curl
    wget
    vim-full
    vimPlugins.vimspector
    python3
    tmux
    zip
    unzip
    nodejs_22
    gh
    universal-ctags
  ];
  # ホスト環境から完全に分離する
  pure = true;
  shellHook = ''
    # Git safe.directory 設定（コンテナ環境対応）
    git config --global --add safe.directory /srv 2>/dev/null || true
    git config --global --add safe.directory "$(pwd)" 2>/dev/null || true

    # Vim 設定の反映
    VIMRC_SRC="${./.vimrc}"
    VIMRC_DEST="$HOME/.vimrc"
    if [ -f "$VIMRC_SRC" ]; then
      ln -sf "$VIMRC_SRC" "$VIMRC_DEST"
      # Ensure dein.vim is installed and plugins are up to date
      # coc.nvim 'release' branch contains pre-built index.js
      echo "Linked $VIMRC_SRC to $VIMRC_DEST"
    fi

    COC_SETTINGS_DIR="$HOME/.vim"
    COC_SETTINGS_FILE="$COC_SETTINGS_DIR/coc-settings.json"
    mkdir -p "$COC_SETTINGS_DIR"
    cat > "$COC_SETTINGS_FILE" <<EOF
{
  "java.jdt.ls.java.home": "$JAVA_HOME"
}
EOF
    echo "Wrote $COC_SETTINGS_FILE"

    VIMSPECTOR_SRC="${packages.vimPlugins.vimspector}"
    VIMSPECTOR_DEST="$HOME/.vim/pack/plugins/start/vimspector"
    mkdir -p "$(dirname "$VIMSPECTOR_DEST")"
    ln -sfn "$VIMSPECTOR_SRC" "$VIMSPECTOR_DEST"
    echo "Linked $VIMSPECTOR_SRC to $VIMSPECTOR_DEST"

    # tmux 設定の反映
    TMUX_CONF_SRC="${./.tmux.conf}"
    TMUX_CONF_DEST="$HOME/.tmux.conf"
    if [ -f "$TMUX_CONF_SRC" ]; then
      ln -sf "$TMUX_CONF_SRC" "$TMUX_CONF_DEST"
      echo "Linked $TMUX_CONF_SRC to $TMUX_CONF_DEST"
    fi

    echo "Welcome to the common development environment"
  '';
}
