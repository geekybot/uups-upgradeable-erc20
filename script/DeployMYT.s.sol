//SPDX-License-Identifier : MIT

pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployMYT is Script {

    function run() external returns(address) {
        address proxy = deployProxy();
        return proxy;
    }

    function deployProxy() public returns(address) {
        vm.startBroadcast();
        MyToken myt = new MyToken();
        ERC1967Proxy proxy = new ERC1967Proxy(address(myt), "");
        MyToken(address(proxy)).initialize();
        // Transfer ownership to the deployer
        MyToken(address(proxy)).transferOwnership(msg.sender);
        vm.stopBroadcast();
        return address(proxy);
    }
}