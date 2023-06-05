// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { IERC721 } from "@openzeppelin/interfaces/IERC721.sol";

contract MoonCapsule {

    address payable public owner;
    uint256 public associatedTokenId;
    IERC721 public keyNFT;

    constructor(address payable _owner, uint256 _tokenId, address _keyNFT)  {
        owner = _owner;
        associatedTokenId = _tokenId;
        keyNFT = IERC721(_keyNFT);
    }

    function updateOwner(address payable _newOwner) external {
        require(_newOwner == keyNFT.ownerOf(associatedTokenId), "NFT owner does not match new owner");
        owner = _newOwner;
    }
}
