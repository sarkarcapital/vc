anvil --fork-url https://reth-ethereum.ithaca.xyz/rpc

forge build

export DEPLOYMENT_PRIVATE_KEY="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80" # from anvil

# from https://github.com/aragon/osx/blob/main/packages/artifacts/src/addresses.json
export DAO_FACTORY_ADDRESS="0x246503df057A9a85E0144b6867a828c99676128B"
export PLUGIN_REPO_ADDRESS="0xcf59C627b7a4052041C4F16B4c635a960e29554A"
export PLUGIN_SETUP_PROCESSOR_ADDRESS="0xE978942c691e43f65c1B7c7F8f1dc8cDF061B13f"

mkdir artifacts
forge script script/Deploy.sol --rpc-url http://127.0.0.1:8545 --broadcast -vvvv
cd npm-artifacts
chmod+x prepare-abi.sh
./prepare-abi.sh