#!/bin/bash

ssh_retry() {
    local host=$1 wait=1 max=60
    until ssh "$host"; do
        echo "Retry in ${wait}s..."
        sleep $wait
        ((wait = wait < max ? wait * 2 : max))
    done
}

ssh_retry $1
