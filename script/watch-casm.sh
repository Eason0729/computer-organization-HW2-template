#!/bin/bash

MONITOR_DIR="./assembly"
BUILD_SCRIPT="./script/build-casm.sh"

if ! command -v inotifywait &> /dev/null; then
    echo "inotifywait could not be found. Please install inotify-tools."
    exit 1
fi

run_script() {
    echo "Running $BUILD_SCRIPT..."
    "$BUILD_SCRIPT"
}

echo "Monitoring $MONITOR_DIR for changes..."
inotifywait -m -r -e modify,create,delete "$MONITOR_DIR" | while read path action file; do
    run_script
done
