//SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";
import {MyTokenV2} from "../src/MyTokenV2.sol";
import {MyToken} from "../src/MyToken.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract UpgradeMYT is Script {

    address constant MYT_PROXY_ADDRESS = 0x251FD4F916dC627bf2dD14D7ca70622adA60BEdf; // Replace with actual proxy address

    function run() external returns (address) {
        vm.startBroadcast();
        MyTokenV2 newMYT = new MyTokenV2();
        vm.stopBroadcast();
        address proxy = upgradeMYT(MYT_PROXY_ADDRESS, address(newMYT));
        return proxy;
    }

    function upgradeMYT(address proxyAddress, address newMYT) public returns (address) {
        vm.startBroadcast();
        MyToken proxy = MyToken(payable(proxyAddress));
        proxy.upgradeToAndCall(newMYT,""); // Use the exposed upgradeTo function
        vm.stopBroadcast();
        return address(proxy);
    }
}
