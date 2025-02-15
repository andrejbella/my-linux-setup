#!/usr/bin/env bash

CURRENT_DIR="$(dirname "$0")"
ZINIT_HOME="${XDG_CACHE_HOME:-${HOME}/.local/share}/zinit/zinit.git"
FZF_HOME="${HOME}/.fzf"

info()
{
	echo '[INFO] ' "$@"
}

echo
info "Installing tools"
sudo apt update -y && sudo apt install zsh git curl zoxide btop eza micro gcc -y

echo
info "Installing zinit"
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

info "Installing Homebrew"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

info "Installing brew tools"
brew install talosctl fzf kubectx derailed/k9s/k9s

echo
info "Installing additional themes"
BTOP_THEME_DIR="$HOME/.config/btop/themes/"
P10K_DIR="$CURRENT_DIR/powerlevel10k"
THEME_DIR="$CURRENT_DIR/themes"
if [ ! -d "$THEME_DIR" ]; then
	mkdir -p "$THEME_DIR"
fi

###P10K###
sudo rm -rf "$THEME_DIR/powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEME_DIR/powerlevel10k"
cp -f "$CURRENT_DIR/p10k.zsh" "$HOME/.p10k.zsh"

###BTOP###
sudo rm -rf "$BTOP_THEME_DIR"
sudo rm -rf "$THEME_DIR/btop"
git clone https://github.com/rose-pine/btop.git "$THEME_DIR/btop"
mkdir -p "$BTOP_THEME_DIR"
mv -f "$THEME_DIR/btop/rose-pine.theme" "$BTOP_THEME_DIR"

echo
info "Copying .zshrc to ~/"
cp -f "$CURRENT_DIR/zshrc" "$HOME/.zshrc"

echo
info "Installing asdf plugins"
asdf plugin-add kubectl https://github.com/asdf-community/asdf-kubectl.git

chsh -s $(which zsh)

