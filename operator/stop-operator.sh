source .env

docker stop $IPFS_OPERATOR_NAME

PINNER_PID=$(cat ./pinner-ipfsd.pid)

# Stop anvil locally
kill $PINNER_PID

rm -rf pinner-ipfsd.pid