pragma solidity ^0.8.0;

import {Keyrxng} from "./Keyrxng.sol";
import {KxyChain} from "./KxyChain.sol";
import {KeyChainx} from "./KeyChainx.sol";
import {IERC721Receiver} from '@openzeppelin/contracts/interfaces/IERC721Receiver.sol';
import {IERC1155Receiver} from '@openzeppelin/contracts/interfaces/IERC1155Receiver.sol';
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract Playground is IERC1155Receiver, IERC721Receiver {
    Keyrxng keyrxng;
    KxyChain kxyChain;
    KeyChainx keyChainx;

    uint256 internal constant STARTER_KEY = 100 ether;
    string internal constant STARTER_KEYCHAIN =
        "https://keyrxng.xyz/static/media/bck.9403adc621c443da6fc6.png";
    uint256 internal constant STARTER_KEYCHAINX = 1;

    mapping(address => mapping(address => uint)) public timelockedAmounts;
    mapping(address => uint) public timelockTimestamp;
    mapping(address => mapping(address => mapping(uint => uint))) public whenReady; // [user][token][0/1/2][block.timestamp] *0/1/2 represents enum value

    enum timelockDuration {DAYS2, DAYS7, DAYS14}

    error NoERC20Balance();
    error NoERC721Balance();
    error NoERC1155Balance();
    error StillTimelocked();
    error NothingTimelocked();
    error InvalidDuration();

    constructor(
        Keyrxng _keyrxng,
        KxyChain _kxychain,
        KeyChainx _keychainx
    ) {
        keyrxng = _keyrxng;
        kxyChain = _kxychain;
        keyChainx = _keychainx;
    }

    function mintERC20() public {
        keyrxng.mint(msg.sender, STARTER_KEY);
    }

    function mintERC721() public {
        if(keyrxng.balanceOf(msg.sender == 0)) {
            revert NoERC20Balance()
        }
        kxyChain.safeMint(to, uri);
        (msg.sender, STARTER_KEYCHAIN);
    }

    function mintERC1155() public {
        if(kxyChain.balanceOf(msg.sender == 0)) {
            revert NoERC20Balance()
        })
        keyChainx.mint(msg.sender, STARTER_KEYCHAINX, 1, "");
    }

    function addToTimelock(uint _amount, address _token, timelockDuration _duration) public {
        if(_token == address(keyrxng)) {
            // ERC20 transfer
            _token = Keyrxng(_token);

        }else if (_token == address(KxyChain)) {
            // ERC721 transfer
            _token = KxyChain(_token);
        }else if (_token == address(KeyChainx)) {
            // ERC1155 transfer
            _token = KeyChainx(_token);
        }

         if(_duration = 0) {
            // timelocked for 2 days
            _token.transferFrom(msg.sender, address(this), _amount);
            timelockedAmounts[msg.sender][_token] += _amount;
            timelockTimestamp[msg.sender] = block.timestamp;
            whenReady[msg.sender][address(_token)][0] = block.timestamp + 2 days;
            
        }else if (_duartion = 1) {
            // timelock for 7 days
            _token.transferFrom(msg.sender, address(this), _amount);
            timelockedAmounts[msg.sender][_token] += _amount;
            timelockTimestamp[msg.sender] = block.timestamp;
            whenReady[msg.sender][address(_token)][1] = block.timestamp + 7 days;

        }else if(_duration = 2) {
            // timelocked for 14 days
            _token.transferFrom(msg.sender, address(this), _amount);
            timelockedAmounts[msg.sender][_token] += _amount;
            timelockTimestamp[msg.sender] = block.timestamp;
            whenReady[msg.sender][address(_token)][2] = block.timestamp + 14 days;
        }else{
            revert InvalidDuration();
        }
       
    }

    function getTimelockTimeLeft(address _depositor, address _token) public returns(uint){
        return timelockedAmounts[_depositor][_token];
    }

    function withdraw(address _depositor, address _token, timelockDuration _duration) public returns(uint){
        uint amount = timelockedAmounts[_depositor][_token];

        if(amount == 0) revert NothingTimelocked()
        
        if(_token == address(keyrxng)) {
            // ERC20 transfer
            uint readyNow = whenReady[msg.sender][_token][_duration];
            bool isReady = readyNow <= block.timestamp;
            if(!isReady) revert StillTimelocked()
            Keyrxng(_token).transferFrom(address(this), msg.sender, timelockAmounts[msg.sender], _token)
        }else if (_token == address(KxyChain)) {
            // ERC721 transfer
            uint readyNow = whenReady[msg.sender][_token][_duration];
            bool isReady = readyNow <= block.timestamp;
            if(!isReady) revert StillTimelocked()
            KxyChain(_token).transferFrom(address(this), msg.sender, timelockAmounts[msg.sender], _token)
        }else if (_token == address(KeyChainx)) {
            // ERC1155 transfer
            uint readyNow = whenReady[msg.sender][_token][_duration];
            bool isReady = readyNow <= block.timestamp;
            if(!isReady) revert StillTimelocked();
            KeyChainx(_token).transferFrom(address(this), msg.sender, timelockAmounts[msg.sender], _token)
        }

    }

    receive() external payable {}


    function onERC721Received(address, address, uint256, bytes memory) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external pure override returns (bytes4) {
        return IERC1155Receiver.onERC1155Received.selector;

    }
    
}
