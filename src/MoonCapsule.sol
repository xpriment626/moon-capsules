// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract MoonCapsule {
    address payable owner;

    constructor(address payable _owner) {
        owner = _owner;
    }
}
