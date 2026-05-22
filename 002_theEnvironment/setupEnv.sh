#!/bin/bash

CUSTOM_FILE="$HOME/.custombashrc"

cat > "$CUSTOM_FILE" <<'EOF'
USER_COLOR='\[\e[38;2;32;186;251m\]'
OTHER_COLOR='\[\e[38;2;139;233;253m\]'
RESET='\[\e[0m\]'
PS1="\n  ${OTHER_COLOR}╭──${USER_COLOR}\u${OTHER_COLOR}@\h - \w\n  ${OTHER_COLOR}╰─> ${RESET}"

alias cls="clear"
alias py="python"
alias la="ls -la"
alias lah="ls -lah"

mkcd() {
    mkdir -p "$1" && cd "$1"
}
EOF

if ! grep -q 'source ~/.custombashrc' "$HOME/.bashrc"; then
    echo '' >> "$HOME/.bashrc"
    echo '# custom config' >> "$HOME/.bashrc"
    echo 'source ~/.custombashrc' >> "$HOME/.bashrc"
fi