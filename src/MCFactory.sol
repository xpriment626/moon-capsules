// SPDX-License_Identifier: MIT
pragma solidity ^0.8.13;

import {MoonCapsule} from "./MoonCapsule.sol";
import {KeyNFT} from "./KeyNFT.sol";

contract MCFactory {
    event CapsuleCreated(address payable owner);

    uint256 public tokenIdCounter = 1;
    mapping(address => MoonCapsule) public capsules;

    function createCapsule(address payable _receiver) external {
        KeyNFT key = new KeyNFT(_receiver, tokenIdCounter);
        MoonCapsule capsule = new MoonCapsule(
            _receiver,
            tokenIdCounter,
            address(key)
        );
        capsules[_receiver] = capsule;
        tokenIdCounter++;
        emit CapsuleCreated(_receiver);
    }
}
