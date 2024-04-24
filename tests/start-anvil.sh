forge script script/testing/M2_Deploy_From_Scratch.s.sol \
    --rpc-url http://localhost:8545 \
    --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
    --broadcast --sig "run(string memory configFile)" \
    -- M2_deploy_from_scratch.anvil.config.json