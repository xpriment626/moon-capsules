// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@testing/test.sol";
import "../src/MoonCapsule.sol";
import "../src/KeyNFT.sol";
import "../src/MCFactory.sol";
import {IERC721} from "@openzeppelin/interfaces/IERC721.sol";
import {CheatCodes} from "./interfaces/CheatCodes.sol";

contract CapsuleTest is DSTest {
    CheatCodes vm = CheatCodes(HEVM_ADDRESS);

    event CapsuleCreated(address payable owner);
    event checkAddr(address nftOwner, address capsuleOwner);

    function testOwnerSanityTest() public {
        address payable owner = payable(address(1));
        MCFactory factory = new MCFactory();
        factory.createCapsule(owner);
        MoonCapsule capsule = factory.capsules(owner);
        IERC721 capsuleKey = capsule.keyNFT();
        assertEq(capsuleKey.ownerOf(1), capsule.owner());
    }

    function testCapsuleCreatedEmit() public {
        address payable owner = payable(
            0xA66D38D132461f69b5aA1958233Ee120f513D451
        );
        MCFactory factory = new MCFactory();
        vm.expectEmit(true, false, false, false);
        emit CapsuleCreated(owner);
        factory.createCapsule(owner);
    }
}
