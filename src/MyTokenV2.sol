// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

import {ERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title MyTokenV2 - An upgraded version of MyToken
/// @notice This contract adds a minting limit to the original MyToken.
/// @dev Uses OpenZeppelin's upgradeable contracts.
contract MyTokenV2 is Initializable, ERC20Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
    /// @notice The maximum amount of tokens that can be minted in a single transaction.
    uint256 public constant MAXIMUM_TOKEN_MINT_ALLOWED = 50 * 10**18;

    /// @notice Error thrown when the mint amount exceeds the maximum allowed.
    error MyToken__MaximumAllowedTokenToMintIs50();

    /// @notice Constructor is disabled for upgradeable contracts.
    constructor() {}

    /// @notice Initializes the upgraded token.
    /// @dev This function must be called only once after deployment.
    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    /// @notice Mints new tokens to the specified address with a limit.
    /// @param to The address to receive the minted tokens.
    /// @param amount The amount of tokens to mint.
    /// @dev Reverts if the mint amount exceeds the maximum allowed.
    function mint(address to, uint256 amount) public onlyOwner {
        if (amount >= MAXIMUM_TOKEN_MINT_ALLOWED) {
            revert MyToken__MaximumAllowedTokenToMintIs50();
        }
        _mint(to, amount);
    }

    /// @notice Authorizes the upgrade of the contract.
    /// @param newImplementation The address of the new implementation contract.
    /// @dev Only the owner can authorize upgrades.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}


}
