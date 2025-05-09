// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.22;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title MyToken - An upgradeable ERC20 token
/// @notice This contract implements an upgradeable ERC20 token with minting functionality.
/// @dev Uses OpenZeppelin's upgradeable contracts.
contract MyToken is Initializable, ERC20Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
    /// @notice Constructor is disabled for upgradeable contracts.
    constructor() {}

    /// @notice Initializes the token with a name and symbol.
    /// @dev This function must be called only once after deployment.
    function initialize() public initializer {
        __ERC20_init("MyToken", "MYT");
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    /// @notice Mints new tokens to the specified address.
    /// @param to The address to receive the minted tokens.
    /// @param amount The amount of tokens to mint.
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

   

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
    
}
