# Homelab Refresh 002 - The terminal environment

#### Benjamin Godfrey

## The problem

Something I like to keep in mind when thinking about machines on my network is their sovereignty. These are machines in their own right, but are part of a bigger picture - a user should be able to move from one to the other without too much resistance. To aid this easy moving from one machine to another, we would like to be able to interact with the machines in a similar way. We want them to look similar, feel similar, and work similarly.

While this config task takes us away from 'homelabbing' for a moment, I think it is worth doing before we get into the meat of what we are taking on. My machines all run Linux, so I ought to know Linux. In the words of the prophet, proper planning prevents piss poor performance.

In practice, this will look like creating templates for `.bashrc`, setting some aliases, and perhaps including some more config for specific tools like vim. I think a nice neat way of doing this would be with bash scripts. If I can create some bash script called `setupEnv` or similar, I can just copy this across to each machine (or better yet, clone it), run it once, and be happy.

## The script

The structure of this script will be easy enough. Something along these lines:

```bash
#!/bin/bash

# declaring some variables
# putting those variables somewhere
```

So our first step is deciding on our variables.

### The prompt

The prompt is something which I have put some thought into before. I like to be able to see who I am and what machine I am on, I like to have a bit of a gap between things, and I like to type onto a new line. As such, I am happy for my prompt to be defined as follows:

```bash
USER_COLOR='\[\e[38;2;32;186;251m\]' #20bafb aqua
OTHER_COLOR='\[\e[38;2;139;233;253m\]' #8be9fd light blue
RESET='\[\e[0m\]'
PS1="\n  ${OTHER_COLOR}╭──${USER_COLOR}\u${OTHER_COLOR}@\h - \w\n  ${OTHER_COLOR}╰─> ${RESET}"
```

I will be lazy here and simply append this to my .bashrc, knowing that it would be applied after all other settings. The second most lazy thing to do would be use some sort of grepping like:

```bash
grep -Ev "^PS1" .bashrc
```

To find lines I do not want and remove them. Who can be bothered.

### The aliases

I have a few aliases which I like to use across the board. These are the basic commands which I find easier to use than the defaults. These are:

```bash
alias cls="clear"
alias py="python"
alias la="ls -la"
alias lah="ls -lah"
function mkcd() {
        mkdir $1 && cd $1;
}
```

### Putting these together

We can put these settings together in a single executable as follows:

```bash
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
```