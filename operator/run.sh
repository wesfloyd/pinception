#!/bin/bash

# Launch the daemon process in the background
ipfs daemon &

# Run the Node.js command
node node run-ipfs-pinner.js