#!/bin/bash

TASK="$@"
MONITOR_DIRS=("./assembly" "./exercise" "./include")

if ! command -v inotifywait &> /dev/null; then
    echo "inotifywait could not be found. Please install inotify-tools."
    exit 1
fi

run_script() {
    echo "============================================="
    echo "Running $TASK..."
    just build $TASK
    just run $TASK
}

monitor_directory() {
    local dir="$1"
    echo "Monitoring $dir for changes..."
    inotifywait -m -r -e modify,create,delete "$dir" | while read path action file; do
        run_script
    done
}

for dir in "${MONITOR_DIRS[@]}"; do
    monitor_directory "$dir" &
done

wait
