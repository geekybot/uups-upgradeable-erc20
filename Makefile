# Makefile for deploying and upgrading MyToken and its proxy

# Load environment variables from .env
ifneq (,$(wildcard .env))
    include .env
    export $(shell sed 's/=.*//' .env)
endif

# Variables
export DEPLOY_SCRIPT=script/DeployMYT.s.sol
export UPGRADE_SCRIPT=script/UpgradeMYT.s.sol
export walletaddress=0x98E23CC1f9A91DF4699D7B329c4cC9cae8150122
export PROXY_ADDRESS=0x251FD4F916dC627bf2dD14D7ca70622adA60BEdf

# Targets

.PHONY: build test clean install deploy upgrade mint balance

install:
	forge install

build:
	forge build

test:
	forge test -vvv

clean:
	forge clean

deploy:
	@echo "Deploying MyToken and Proxy..."
	forge script $(DEPLOY_SCRIPT) --rpc-url $(RPC_ADDRESS) --private-key $(PRIVATE_KEY) --broadcast --verify
	@echo "MyToken and Proxy deployed successfully."

upgrade:
	@echo "Upgrading MyToken to MyTokenV2..."
	forge script $(UPGRADE_SCRIPT) --rpc-url $(RPC_ADDRESS) --private-key $(PRIVATE_KEY) --broadcast --verify
	@echo "MyToken upgraded to MyTokenV2 successfully."

mint:
	@echo "Minting tokens to the specified address..."
	forge script script/MintTokens.s.sol --rpc-url $(RPC_ADDRESS) --private-key $(PRIVATE_KEY) --broadcast
	@echo "Tokens minted successfully."

balance:
	@echo "Checking balance of wallet address $(walletaddress)..."
	cast call $(PROXY_ADDRESS) "balanceOf(address)(uint256)" $(walletaddress) --rpc-url $(RPC_ADDRESS) | awk '{print $$1 / 10^18 " MYT"}'

