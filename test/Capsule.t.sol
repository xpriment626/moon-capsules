// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@testing/test.sol";
import "../src/MoonCapsule.sol";
import "../src/KeyNFT.sol";
import "../src/MCFactory.sol";
import { IERC721 } from "@openzeppelin/interfaces/IERC721.sol";

contract CapsuleTest is DSTest {

    event checkAddr(address nftOwner, address capsuleOwner);
    function testOwnerSanityTest() public {
        address payable owner = payable(0xA66D38D132461f69b5aA1958233Ee120f513D451);
        MCFactory factory = new MCFactory();
        (KeyNFT key, MoonCapsule capsule) = factory.createCapsule(owner);
        assertEq(address(key.ownerOf(1)), address(capsule.owner()));
        emit checkAddr(address(key.ownerOf(1)), address(capsule.owner()));
    }
}
