// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";

/// @custom:security-contact keyrxng@keyrxng.xyz
contract KeyChainx is ERC1155, Ownable, ERC1155Supply {
    address playground;
    IERC721 kxychain;

    error YouDontHaveAKeyChain();

    constructor() ERC1155("https://keyrxng.xyz/") {}

    function init(address _playground) external returns (bool) {
        playground = _playground;
        // _setApprovalForAll(playground, playground, true);
        _setApprovalForAll(address(this), playground, true);
        return true;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public returns (bool) {
        _mint(account, id, amount, data);
        setApprovalForAll(address(this), true);
        return true;
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public {
        _mintBatch(to, ids, amounts, data);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
