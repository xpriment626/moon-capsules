// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./MoonCapsule.sol";

contract MCFactory {
    event CapsuleCreated(address payable owner);
    uint256 public tokenId = 1;
    mapping(address => MoonCapsule) public capsules;

    function createCapsule(address _receiver) public {
        MoonCapsule capsule = new MoonCapsule(_receiver, tokenId);
        capsules[_receiver] = capsule;
        tokenId++;
        emit CapsuleCreated(payable(address(capsule)));
    }
}
