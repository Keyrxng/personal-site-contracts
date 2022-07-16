pragma solidity ^0.8.0;

import {Keyrxng} from "./Keyrxng.sol";
import {KxyChain} from "./KxyChain.sol";
import {KeyChainx} from "./KeyChainx.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/interfaces/IERC721.sol";
import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {console} from "forge-std/console.sol";

import {IERC721Receiver} from "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";
import {IERC1155Receiver} from "@openzeppelin/contracts/interfaces/IERC1155Receiver.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Playground is IERC1155Receiver, IERC721Receiver {
    Keyrxng keyrxng;
    KxyChain kxyChain;
    KeyChainx keyChainx;
    address keyrxng_;
    address kxyChain_;
    address keyChainx_;

    uint256 internal constant STARTER_KEY = 100 ether;
    string internal constant STARTER_KEYCHAIN =
        "/static/media/bck.9403adc621c443da6fc6.png";
    uint256 internal constant STARTER_KEYCHAINX = 1;

    mapping(address => mapping(address => uint256)) public timelockedAmounts;
    mapping(address => uint256) public timelockTimestamp;
    mapping(address => mapping(address => mapping(uint256 => uint256)))
        public whenReady; // [user][token][block.timestamp][block.timestamp] *0/1/2 represents enum value

    enum TimelockDuration {
        DAYS2,
        DAYS7,
        DAYS14
    }

    TimelockDuration timelockStatus;

    error NoERC20Balance();
    error NoERC721Balance();
    error NoERC1155Balance();
    error StillTimelocked();
    error NothingTimelocked();
    error InvalidDuration();

    event KeyrxngMinted(address indexed owner, address indexed own);
    event KxyChainMinted(address indexed owner, address indexed own);
    event KeyChainxMinted(address indexed owner, address indexed own);

    constructor(
        Keyrxng _keyrxng,
        KxyChain _kxychain,
        KeyChainx _keychainx
    ) {
        keyrxng = _keyrxng;
        kxyChain = _kxychain;
        keyChainx = _keychainx;
        keyrxng_ = address(_keyrxng);
        kxyChain_ = address(_kxychain);
        keyChainx_ = address(_keychainx);
    }

    function init() public returns (bool) {
        bool token0 = keyrxng.init(address(this));
        bool token1 = kxyChain.init(address(this));
        bool token2 = keyChainx.init(address(this));
        bool success = (token0 && token1 && token2);
        kxyChain.setApprovalForAll(kxyChain_, true);
        kxyChain.setApprovalForAll(msg.sender, true);
        keyChainx.setApprovalForAll(keyChainx_, true);
        keyChainx.setApprovalForAll(msg.sender, true);

        mintERC20(msg.sender);
        return success;
    }

    address dead = 0x0000000000000000000000000000000000000000;

    function mintERC20(address _who) public returns (bool) {
        bool success = keyrxng.mint(_who);
        emit KeyrxngMinted(dead, _who);
        keyrxng.transfer(_who, 1000 ether);
        return success;
    }

    function mintERC721(address _who) public returns (bool) {
        bool success = kxyChain.safeMint(STARTER_KEYCHAIN, address(this));
        emit KxyChainMinted(dead, _who);
        kxyChain.safeTransferFrom(address(this), _who, 0);
        return success;
    }

    function mintERC1155(address _who) public returns (bool) {
        bool success = keyChainx.mint(address(this), 0, 1, "");
        emit KxyChainMinted(dead, _who);
        keyChainx.safeTransferFrom(address(this), _who, 0, 1, "");
        return success;
    }

    function addToTimelock(
        uint256 _amount,
        address _token,
        uint256 _duration
    ) public {
        TimelockDuration status = timelockStatus;

        if (_duration == 0) {
            // timelocked for 2 days
            timelockedAmounts[msg.sender][_token] += _amount;
            timelockTimestamp[msg.sender] = block.timestamp;
            whenReady[msg.sender][_token][block.timestamp] =
                block.timestamp +
                2 days;
        } else if (_duration == 1) {
            // timelock for 7 days
            timelockedAmounts[msg.sender][_token] += _amount;
            timelockTimestamp[msg.sender] = block.timestamp;
            whenReady[msg.sender][_token][block.timestamp] =
                block.timestamp +
                7 days;
        } else if (_duration == 2) {
            // timelocked for 14 days
            timelockedAmounts[msg.sender][_token] += _amount;
            timelockTimestamp[msg.sender] = block.timestamp;
            whenReady[msg.sender][_token][block.timestamp] =
                block.timestamp +
                14 days;
        } else {
            revert InvalidDuration();
        }

        if (_token == address(keyrxng)) {
            // ERC20 transfer
            Keyrxng token = Keyrxng(_token);
            token.transferFrom(msg.sender, address(this), _amount);
        } else if (_token == kxyChain_) {
            // ERC721 transfer
            KxyChain token = KxyChain(_token);
            token.transferFrom(msg.sender, address(this), _amount);
        } else if (_token == keyChainx_) {
            // ERC1155 transfer
            KeyChainx token = KeyChainx(_token);
            token.safeTransferFrom(msg.sender, address(this), 1, _amount, "");
        }
    }

    function getTimelockTimeLeft(address _depositor, address _token)
        public
        returns (uint256)
    {
        return timelockedAmounts[_depositor][_token];
    }

    function withdraw(
        address _depositor,
        address _token,
        TimelockDuration _duration
    ) public returns (uint256) {
        uint256 amount = timelockedAmounts[_depositor][_token];

        if (amount == 0) revert NothingTimelocked();

        if (_token == keyrxng_) {
            // ERC20 transfer
            uint256 whenDepo = timelockTimestamp[msg.sender];
            uint256 readyNow = whenReady[msg.sender][_token][whenDepo];
            bool isReady = readyNow <= block.timestamp;
            if (!isReady) revert StillTimelocked();
            Keyrxng token = Keyrxng(_token);
            token.transferFrom(msg.sender, address(this), amount);
        } else if (_token == kxyChain_) {
            // ERC721 transfer
            uint256 whenDepo = timelockTimestamp[msg.sender];
            uint256 readyNow = whenReady[msg.sender][_token][whenDepo];
            bool isReady = readyNow <= block.timestamp;
            if (!isReady) revert StillTimelocked();

            KxyChain token = KxyChain(_token);
            token.transferFrom(msg.sender, address(this), amount);
        } else if (_token == keyChainx_) {
            // ERC1155
            uint256 whenDepo = timelockTimestamp[msg.sender];
            uint256 readyNow = whenReady[msg.sender][_token][whenDepo];
            bool isReady = readyNow <= block.timestamp;
            if (!isReady) revert StillTimelocked();

            KeyChainx token = KeyChainx(_token);
            token.safeTransferFrom(msg.sender, address(this), 1, amount, "");
        }
    }

    receive() external payable {}

    function onERC721Received(
        address from,
        address to,
        uint256 id,
        bytes memory data
    ) external override returns (bytes4) {
        kxyChain.transferFrom(from, to, id);
        return IERC721Receiver.onERC721Received.selector;
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external override returns (bytes4) {
        keyChainx.safeTransferFrom(operator, from, id, value, data);
        return IERC1155Receiver.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external pure override returns (bytes4) {
        return IERC1155Receiver.onERC1155BatchReceived.selector;
    }

    function supportsInterface(bytes4 interfaceId) public view returns (bool) {
        return supportsInterface(interfaceId);
    }
}
