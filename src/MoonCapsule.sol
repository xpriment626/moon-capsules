// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC721} from "@openzeppelin/interfaces/IERC721.sol";

error NonMatchingKey(address expected);

contract MoonCapsule {
    address payable public owner;
    uint256 public associatedTokenId;
    IERC721 public keyNFT;

    constructor(address payable _owner, uint256 _tokenId, address _keyNFT) {
        owner = _owner;
        associatedTokenId = _tokenId;
        keyNFT = IERC721(_keyNFT);
    }

    function updateOwner(address payable _newOwner) external {
        if (_newOwner == keyNFT.ownerOf(associatedTokenId)) {
            revert NonMatchingKey({
                expected: keyNFT.ownerOf(associatedTokenId)
            });
        }
        owner = _newOwner;
    }
}
