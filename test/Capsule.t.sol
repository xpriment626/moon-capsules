// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@testing/test.sol";
import "../src/MoonCapsule.sol";
import "../src/MCFactory.sol";
import {IERC721} from "@openzeppelin/interfaces/IERC721.sol";
import {CheatCodes} from "./interfaces/CheatCodes.sol";

contract CapsuleTest is DSTest {
    CheatCodes vm = CheatCodes(HEVM_ADDRESS);

    // event CapsuleCreated(address payable owner);
    event CheckAddr(address nftOwner);
    event EthReceived(address sender, uint256 amount);

    function testOwnerSanityTest() public {
        MCFactory factory = new MCFactory();
        address payable alice = payable(address(1));
        vm.prank(alice);
        factory.createCapsule(alice);
        MoonCapsule capsule = factory.capsules(alice);
        address owner = capsule.ownerOf(1);
        assertEq(owner, alice);
    }

    function testMultiOwner() public {
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

    function testMultiOwnerBalances() public {
        MCFactory factory = new MCFactory();

        /// Alice funds a capsule
        address payable alice = payable(address(1));
        address payable bob = payable(address(2));
        vm.prank(alice);
        factory.createCapsule(alice);
        MoonCapsule capsuleAlice = factory.capsules(alice);
        vm.deal(alice, 10 ether);
        vm.prank(alice);
        payable(address(capsuleAlice)).transfer(10 ether);

        /// Bob funds a capsule
        vm.prank(bob);
        factory.createCapsule(bob);
        MoonCapsule capsuleBob = factory.capsules(bob);
        vm.deal(bob, 10 ether);
        vm.prank(bob);
        payable(address(capsuleBob)).transfer(10 ether);

        /// Check balances
        uint256 aliceBalance = address(capsuleAlice).balance;
        uint256 bobBalance = address(capsuleBob).balance;

        assertEq(aliceBalance, 10 ether);
        assertEq(bobBalance, 10 ether);
    }
}
