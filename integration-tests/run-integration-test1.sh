source .env
source ../operator/.env



# Simulated IPFS container to represent a rmeote IPFS server for testing
docker run --rm -d --name $IPFS_SIM_REMOTE \
    -p 4002:4001 \
    -p 5002:5001/tcp \
    -p 4002:4001/udp \
    ipfs/kubo:latest

# Total wait time
total_time=5
# Interval time
interval=1

echo "Waiting for $total_time seconds to allow IPFS daemon to load on docker container."

# Loop until the total time is reached
while [ $total_time -gt 0 ]
do
  echo "$total_time"
  sleep $interval
  total_time=$((total_time - interval))
done

# Pin a file on a remote IPFS server
MSG="Hello, IPFS Today is $(date '+%Y-%m-%d') and the time is $(date '+%H:%M:%S')"
CID1=$(curl -X POST -F file=@- "${IPFS_OPERATOR_API}/add" <<< "${MSG}" | jq -r .Hash)
curl -X POST "${IPFS_OPERATOR_API}/pin/add?arg=${CID1}" | jq

# Open a third window to call the CID emit contract on chain
# hard coded contract addr for now
PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
CID_EMITTER_CONTRACT_ADDR=0x5FbDB2315678afecb367f032d93F642f64180aa3

cast send $CID_EMITTER_CONTRACT_ADDR "emitCIDToPIN(string)" "${CID1}" \
    --private-key $PRIVATE_KEY

# Confirm that the CID was pinned
curl -X POST ${IPFS_OPERATOR_API}/cat?arg=${CID1}
curl -X POST ${IPFS_SIM_REMOTE_API}/cat?arg=${CID1}


docker stop $IPFS_SIM_REMOTE

#../operator/stop-operator.sh
