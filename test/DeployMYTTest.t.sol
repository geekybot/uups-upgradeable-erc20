// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {DeployMYT} from "../script/DeployMYT.s.sol";
import {MyToken} from "../src/MyToken.sol";
import {MyTokenV2} from "../src/MyTokenV2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {UpgradeMYT} from "../script/UpgradeMYT.s.sol";

contract DeployMYTTest is Test {
    DeployMYT deployer;
    UpgradeMYT upgrader;
    MyToken public myToken;
    address public userA;
    address public userB;
    address public owner;
    address ercProxyAddress;

    function setUp() public {
        deployer = new DeployMYT();
        upgrader = new UpgradeMYT();

        ercProxyAddress = deployer.deployProxy();
        myToken = MyToken(ercProxyAddress);
        console.log("token address", address(myToken));
        // Setup test addresses
        userA = makeAddr("userA");
        userB = makeAddr("userB");
        owner = address(this);

        // Verify ownership
        assertEq(myToken.owner(), owner);
    }

    function testDeployment() public view {
        // Test token name and symbol
        assertEq(myToken.name(), "MyToken");
        assertEq(myToken.symbol(), "MYT");

        // Test initial total supply
        assertEq(myToken.totalSupply(), 0);

        // Test decimals
        assertEq(myToken.decimals(), 18);
    }

    function testMintTokens() public {
        // Mint tokens to users
        vm.startPrank(owner);
        myToken.mint(userA, 100 * 10 ** 18); // 100 MYT
        myToken.mint(userB, 50 * 10 ** 18); // 50 MYT
        vm.stopPrank();

        // Check balances
        assertEq(myToken.balanceOf(userA), 100 * 10 ** 18);
        assertEq(myToken.balanceOf(userB), 50 * 10 ** 18);
        assertEq(myToken.totalSupply(), 150 * 10 ** 18);
    }

    function testTransferTokens() public {
        // First mint tokens to userA
        vm.startPrank(owner);
        myToken.mint(userA, 100 * 10 ** 18);
        vm.stopPrank();

        // UserA transfers tokens to UserB
        vm.startPrank(userA);
        myToken.transfer(userB, 30 * 10 ** 18);
        vm.stopPrank();

        // Check balances after transfer
        assertEq(myToken.balanceOf(userA), 70 * 10 ** 18);
        assertEq(myToken.balanceOf(userB), 30 * 10 ** 18);
    }

    function testMintByNonOwner() public {
        vm.startPrank(userA);
        vm.expectRevert();
        myToken.mint(userB, 100 * 10 ** 18); // This should fail
        vm.stopPrank();
    }

    function testUpgradeWorks() public {
        // mint tokens before upgrade
        vm.startPrank(owner);
        myToken.mint(userA, 100 * 10 ** 18); // 100 MYT
        myToken.mint(userB, 50 * 10 ** 18); // 50 MYT
        vm.stopPrank();

        // Check balances
        assertEq(myToken.balanceOf(userA), 100 * 10 ** 18);
        assertEq(myToken.balanceOf(userB), 50 * 10 ** 18);
        assertEq(myToken.totalSupply(), 150 * 10 ** 18);

        // deploy new ones

        MyTokenV2 mytV2 = new MyTokenV2();
        console.log("implementation address v2 ==> ", address(mytV2));
        console.log("before upgrade v1 ==> ", address(address(myToken)));
        vm.prank(MyToken(ercProxyAddress).owner());
        MyToken(ercProxyAddress).transferOwnership(msg.sender);

        address proxy = upgrader.upgradeMYT(ercProxyAddress, address(mytV2));
        console.log("proxy==>>>>>>", proxy);

        mytV2 = MyTokenV2(proxy);
        console.log("after upgrade v2 ==> ", address(mytV2));
        
        uint256 userABalance = mytV2.balanceOf(userA);
        uint256 userBBalance = mytV2.balanceOf(userB);

        assertEq(mytV2.totalSupply(), 150 * 10 ** 18);

        assertEq(userABalance, 100 * 10 ** 18);
        assertEq(userBBalance, 50 * 10 ** 18);

        // test new rule applied, if more than 50 tokens can be minted
        vm.startPrank(MyToken(ercProxyAddress).owner());
        vm.expectRevert();
        mytV2.mint(userB, 51 * 10 ** 18);
        mytV2.mint(userB, 20 * 10 ** 18);
        userBBalance = mytV2.balanceOf(userB);
        assertEq(userBBalance, 70 * 10 ** 18);
        vm.stopPrank();
    }
}
