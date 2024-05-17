ANVIL_PID=$(cat ./anvil.pid)

# Stop anvil locally
kill $ANVIL_PID

rm -rf ./anvil.pid