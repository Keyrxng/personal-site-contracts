// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @custom:security-contact keyrxng@keyrxng.xyz
contract Keyrxng is ERC20, ERC20Burnable, Ownable {
    address playground;

    constructor() ERC20("Keyrxng", "KXY") {}

    function mint(address _who) public {
        _mint(_who, 1000 ether);
    }

    function init(address _playground) external returns (bool) {
        playground = _playground;
        return true;
    }
}
