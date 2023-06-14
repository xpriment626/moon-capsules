// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@testing/test.sol";
import "../src/MoonCapsule.sol";
import "../src/MCFactory.sol";
import {IERC721} from "@openzeppelin/interfaces/IERC721.sol";
import {CheatCodes} from "./interfaces/CheatCodes.sol";
import {IERC20} from "@openzeppelin/interfaces/IERC20.sol";
import {MockERC20} from "./mocks/MockERC20.sol";

contract CapsuleTest is DSTest {
    CheatCodes vm = CheatCodes(HEVM_ADDRESS);

    event CheckAddr(address nftOwner);
    event CheckAmount(uint256 amount);
    event EthReceived(address sender, uint256 amount);

    /// Test that owners are correctly assigned
    function test_OwnerSanity() public {
        MCFactory factory = new MCFactory();
        address payable alice = payable(address(1));
        vm.prank(alice);
        factory.createCapsule(alice);
        MoonCapsule capsule = factory.capsules(alice);
        address owner = capsule.ownerOf(1);
        assertEq(owner, alice);
    }

    /// Test that multiple owners are correctly assigned
    function test_MultiOwner() public {
        MCFactory factory = new MCFactory();

        /// Alice creates a capsule
        address payable alice = payable(address(1));
        address payable bob = payable(address(2));
        vm.prank(alice);
        factory.createCapsule(alice);
        MoonCapsule capsuleAlice = factory.capsules(alice);
        address owner = capsuleAlice.ownerOf(1);

        /// Bob creates a capsule
        vm.prank(bob);
        factory.createCapsule(bob);
        MoonCapsule capsuleBob = factory.capsules(bob);
        address owner2 = capsuleBob.ownerOf(2);
        assertEq(owner, alice);
        assertEq(owner2, bob);
    }

    /// Test that ownership updates as expected when capsules are transferred
    function test_SwapableOwnership() public {
        MCFactory factory = new MCFactory();
        address payable alice = payable(address(1));
        address payable bob = payable(address(2));

        factory.createCapsule(alice);
        MoonCapsule capsule = factory.capsules(alice);

        emit CheckAddr(capsule.ownerOf(1));

        /// Alice transfers capsule to bob
        vm.startPrank(alice);
        capsule.transferFrom(alice, bob, 1);
        assertEq(capsule.ownerOf(1), bob);
    }
}
