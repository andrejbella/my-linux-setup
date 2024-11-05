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
sudo apt update -y && sudo apt install zsh git curl zoxide btop eza micro -y

echo
info "Installing zinit"
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

echo
info "Installing fzf"
sudo rm -rf /usr/bin/fzf
FZF_LATEST_VERSION=$(git ls-remote --tags --sort="v:refname" "https://github.com/junegunn/fzf" | tail -n1 | sed -E 's/.*\/v?//; s/\^\{\}//')
wget "https://github.com/junegunn/fzf/releases/download/v$FZF_LATEST_VERSION/fzf-$FZF_LATEST_VERSION-linux_amd64.tar.gz"
tar -xzf "fzf-$FZF_LATEST_VERSION-linux_amd64.tar.gz"
sudo mv fzf /usr/bin/
rm fzf-$FZF_LATEST_VERSION-linux_amd64.tar.gz

info "Installing Homebrew"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew analytics off

info "Installing brew tools"
brew install talosctl

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

chsh -s $(which zsh)

