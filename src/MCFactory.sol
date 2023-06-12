// SPDX-License_Identifier: MIT
pragma solidity ^0.8.13;

import {MoonCapsule} from "./MoonCapsule.sol";
import {KeyNFT} from "./KeyNFT.sol";

contract MCFactory {
    event CapsuleCreated(
        address capsuleAddress,
        address keyAddress,
        address receiver,
        uint256 tokenId
    );

    uint256 public tokenIdCounter = 1;

    function createCapsule(
        address payable _receiver
    ) external returns (KeyNFT, MoonCapsule) {
        KeyNFT key = new KeyNFT(_receiver, tokenIdCounter);
        MoonCapsule capsule = new MoonCapsule(
            _receiver,
            tokenIdCounter,
            address(key)
        );
        emit CapsuleCreated(
            address(capsule),
            address(key),
            _receiver,
            tokenIdCounter
        );
        tokenIdCounter++;
        return (key, capsule);
    }
}
