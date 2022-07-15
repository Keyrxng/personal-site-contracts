pragma solidity ^0.8.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MockERC20 is Ownable, ERC20 {
    constructor(string memory _name, string memory _symbol)
        ERC20(_name, _symbol)
    {
        _mint(tx.origin, 1000000 ether);
        transferOwnership(tx.origin);
    }

    function deployNewToken(string memory _name, string memory _symbol)
        internal
        virtual
        returns (ERC20)
    {
        ERC20 token = new ERC20(_name, _symbol);
        return token;
    }
}
