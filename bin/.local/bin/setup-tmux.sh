#!/bin/bash

if [[ ! -d ~/.tmux/ ]]; then
    mkdir -p ~/.tmux/plugins/ 
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

