// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @custom:security-contact keyrxng@keyrxng.xyz
contract KxyChain is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter public _tokenIdCounter;

    error YouDontHaveAnyKeys(string _error);

    address playground;
    IERC20 keyrxng;

    constructor() ERC721("KxyChain", "CHAIN") {}

    function init(address _playground) external returns (bool) {
        playground = _playground;
        // _setApprovalForAll(address(this), playground, true);
        return true;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://keyrxng.xyz/";
    }

    function safeMint(string memory uri, address _who) public {
        if (keyrxng.balanceOf(_who) == 0) {
            revert YouDontHaveAnyKeys("errrror");
        } else {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(_who, tokenId);
            _setTokenURI(tokenId, uri);
        }
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
