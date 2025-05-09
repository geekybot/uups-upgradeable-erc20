// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract MintTokens is Script {
    // Address of the proxy contract
    address constant PROXY_ADDRESS = 0x251FD4F916dC627bf2dD14D7ca70622adA60BEdf; // Replace with your deployed proxy address

    // Address to receive the minted tokens
    address constant RECIPIENT = 0x98E23CC1f9A91DF4699D7B329c4cC9cae8150122;

    // Amount of tokens to mint (1000 tokens with 18 decimals)
    uint256 constant MINT_AMOUNT = 20 * 10**18;

    function run() external {
        vm.startBroadcast();

        // Interact with the proxy contract as MyToken
        MyToken proxy = MyToken(PROXY_ADDRESS);

        // Mint tokens to the recipient
        proxy.mint(RECIPIENT, MINT_AMOUNT);

        vm.stopBroadcast();
    }
}
