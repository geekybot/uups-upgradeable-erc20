# Upgradable Token Proxy

## Overview

This project implements an upgradable ERC20 token using OpenZeppelin's upgradeable contracts. It includes two versions of the token:

1. **MyToken**: The initial version of the token with basic minting functionality.
2. **MyTokenV2**: An upgraded version of the token that introduces a minting limit.

The project uses the UUPS (Universal Upgradeable Proxy Standard) pattern to enable contract upgrades while maintaining state.

## Features

- **Upgradeable Contracts**: Built using OpenZeppelin's UUPS proxy pattern.
- **Minting Functionality**: Allows the owner to mint tokens.
- **Minting Limit (V2)**: Adds a restriction on the maximum number of tokens that can be minted in a single transaction.

## Prerequisites

- [Foundry](https://book.getfoundry.sh/) installed on your system.
- [Node.js](https://nodejs.org/) (optional, for managing dependencies if needed).

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd upgradable-token-proxy
   ```

2. Install dependencies using Foundry:
   ```bash
   forge install
   ```

3. Verify that the OpenZeppelin contracts are installed in the `lib` directory.

## Build Instructions

1. Clean the project (optional):
   ```bash
   forge clean
   ```

2. Build the project:
   ```bash
   forge build
   ```

3. Run tests to ensure everything works:
   ```bash
   forge test
   ```

## Usage with Makefile

The `Makefile` provides convenient commands for deploying, upgrading, minting tokens, and checking balances.

### Available Commands

1. **Install Dependencies**:
   ```bash
   make install
   ```

2. **Build the Project**:
   ```bash
   make build
   ```

3. **Run Tests**:
   ```bash
   make test
   ```

4. **Clean Build Artifacts**:
   ```bash
   make clean
   ```

5. **Deploy Contracts**:
   Deploy the `MyToken` contract and its proxy:
   ```bash
   make deploy
   ```

6. **Upgrade Contracts**:
   Upgrade the proxy to use the `MyTokenV2` implementation:
   ```bash
   make upgrade
   ```

7. **Mint Tokens**:
   Mint tokens to a specified address:
   ```bash
   make mint
   ```

8. **Check Balance**:
   Check the balance of a wallet address:
   ```bash
   make balance walletaddress=<WALLET_ADDRESS>
   ```

   Example:
   ```bash
   make balance walletaddress=0x98E23CC1f9A91DF4699D7B329c4cC9cae8150122
   ```

   The balance will be displayed in human-readable format (divided by `10^18`).

## Project Structure

```
upgradable-token-proxy/
├── src/
│   ├── MyToken.sol        # Initial version of the token
│   ├── MyTokenV2.sol      # Upgraded version of the token
├── script/
│   ├── DeployMYT.s.sol    # Script to deploy MyToken and proxy
│   ├── UpgradeMYT.s.sol   # Script to upgrade MyToken to MyTokenV2
│   ├── MintTokens.s.sol   # Script to mint tokens
├── lib/                   # Dependencies (e.g., OpenZeppelin contracts)
├── out/                   # Build artifacts
├── foundry.toml           # Foundry configuration
├── Makefile               # Makefile for managing tasks
└── README.md              # Project documentation
```

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
