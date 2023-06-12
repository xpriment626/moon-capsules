// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/token/ERC721/ERC721.sol";

contract MoonCapsule is ERC721 {
    event EthReceived(address sender, uint256 amount);

    constructor(
        address _receiver,
        uint256 _factoryId
    ) ERC721("MoonCapsule", "iMCT") {
        _safeMint(_receiver, _factoryId);
    }

    receive() external payable {
        emit EthReceived(msg.sender, msg.value);
    }
}
