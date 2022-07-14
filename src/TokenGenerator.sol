pragma solidity ^0.8.0;

import {MockERC20} from "./test/mocks/MockERC20.sol";
import {MockERC721} from "./test/mocks/MockERC721.sol";
import {MockERC1155} from "./test/mocks/MockERC1155.sol";

contract TokenGenerator {
    MockERC20[] public mintedERC20s;
    MockERC721[] public mintedERC721s;
    MockERC1155[] public mintedERC1155s;

    string public constant TOKEN_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    uint256 private s_tokenCounter;

    error DeployError();

    constructor() {}

    function getMintedERC20s() public view returns (uint256) {
        return mintedERC20s.length;
    }

    function getMintedERC721s() public view returns (uint256) {
        return mintedERC721s.length;
    }

    function getMintedERC1155s() public view returns (uint256) {
        return mintedERC1155s.length;
    }

    function deployNewMockERC20(string memory _name, string memory _symbol)
        external
        returns (bool)
    {
        MockERC20 token = new MockERC20(_name, _symbol);
        uint256 len = mintedERC20s.length;
        mintedERC20s.push(token);
        if (mintedERC20s.length == len) {
            revert DeployError();
        }
        return true;
    }

    function deployNewMockERC721(string memory _name, string memory _symbol)
        external
        returns (bool)
    {
        MockERC721 token = new MockERC721(_name, _symbol);
        uint256 len = mintedERC721s.length;
        mintedERC721s.push(token);
        if (mintedERC721s.length == len) {
            revert DeployError();
        }
        return true;
    }

    function deployNewMockERC1155() external returns (bool) {
        MockERC1155 token = new MockERC1155();
        uint256 len = mintedERC1155s.length;
        mintedERC1155s.push(token);
        if (mintedERC1155s.length == len) {
            revert DeployError();
        }
        return true;
    }
}
