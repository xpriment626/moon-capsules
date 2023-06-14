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

    // event CapsuleCreated(address payable owner);
    event CheckAddr(address nftOwner);
    event CheckAmount(uint256 amount);
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

    function testMultiOwnerFund() public {
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

    function testDepositAndWithdraw() public {
        MCFactory factory = new MCFactory();

        /// Alice funds a capsule

        address payable alice = payable(address(1));
        vm.prank(alice);
        factory.createCapsule(alice);
        MoonCapsule capsuleAlice = factory.capsules(alice);
        vm.deal(alice, 10 ether);
        vm.prank(alice);
        payable(address(capsuleAlice)).transfer(10 ether);

        /// Check Alice balance deduction

        uint256 alicePersonal = address(alice).balance;
        assertEq(alicePersonal, 0 ether);

        /// Alice withdraws

        vm.prank(alice);
        capsuleAlice.withdraw(5 ether, 1);

        /// Check balances

        uint256 capsuleBalance = address(capsuleAlice).balance;
        assertEq(capsuleBalance, 5 ether);

        /// Check Alice received 5 ether

        uint256 aliceReceived = address(alice).balance;
        assertEq(aliceReceived, 5 ether);
    }

    function testExpectUniqueness() public {
        MCFactory factory = new MCFactory();
        address payable alice = payable(address(1));
        address payable bob = payable(address(2));
        vm.prank(alice);
        factory.createCapsule(alice);
        vm.prank(bob);
        factory.createCapsule(bob);

        /// Expect different token addresses created

        MoonCapsule capsuleAlice = factory.capsules(alice);
        MoonCapsule capsuleBob = factory.capsules(bob);

        assertNotEq(address(capsuleAlice), address(capsuleBob));

        /// Expect different deposit balances

        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);

        vm.prank(alice);
        payable(address(capsuleAlice)).transfer(10 ether);
        vm.prank(bob);
        payable(address(capsuleBob)).transfer(5 ether);

        assertNotEq(address(capsuleAlice).balance, address(capsuleBob).balance);
    }

    function testERC20DepositAndWithdraw() public {
        MCFactory factory = new MCFactory();
        address payable alice = payable(address(1));

        /// Mint token and send to Alice
        MockERC20 token = new MockERC20();
        token.mint(address(this), 1000);
        token.approve(address(this), 1000);
        assertEq((token.allowance(address(this), address(this))), 1000);
        token.transferFrom(address(this), alice, 1000);
        assertEq(token.balanceOf(alice), 1000);

        /// Alice creates capsule and deposits ERC20 tokens
        vm.startPrank(alice);
        factory.createCapsule(alice);
        MoonCapsule capsule = factory.capsules(alice);
        token.approve(alice, 1000);
        assertEq((token.allowance(alice, alice)), 1000);
        token.transferFrom(alice, address(capsule), 1000);
        assertEq(token.allowance(alice, alice), 0);
        vm.stopPrank();
        assertEq(token.balanceOf(address(capsule)), 1000);
        assertEq(token.balanceOf(alice), 0);

        /// Alice transfer back to herself
        vm.startPrank(alice);
        capsule.withdrawERC20(address(token), 100, 1);
        token.approve(alice, token.balanceOf(alice));
        vm.stopPrank();
        assertEq(token.balanceOf(alice), 100);
        assertEq(token.allowance(alice, alice), 100);

        vm.startPrank(alice);
        capsule.withdrawERC20(address(token), 600, 1);
        token.approve(alice, token.balanceOf(alice));
        vm.stopPrank();
        assertEq(token.balanceOf(alice), 700);
        assertEq(token.allowance(alice, alice), 700);
    }

    function testSwapableOwnership() public {
        MCFactory factory = new MCFactory();
        address payable alice = payable(address(1));
        address payable bob = payable(address(2));
        vm.deal(alice, 10 ether);

        factory.createCapsule(alice);
        MoonCapsule capsule = factory.capsules(alice);

        emit CheckAddr(capsule.ownerOf(1));

        /// Alice funds capsule and transfers to bob
        vm.startPrank(alice);
        payable(address(capsule)).transfer(10 ether);
        capsule.transferFrom(alice, bob, 1);
        vm.stopPrank();

        assertEq(address(capsule).balance, 10 ether);
        assertEq(capsule.ownerOf(1), bob);

        /// Bob can access eth deposited by Alice
        vm.prank(bob);
        capsule.withdraw(5 ether, 1);
        assertEq(address(capsule).balance, 5 ether);
        assertEq(address(bob).balance, 5 ether);
    }

    function testSwapableOwnershipERC20() public {
        MCFactory factory = new MCFactory();
        address payable alice = payable(address(1));
        address payable bob = payable(address(2));

        /// Mint token and send to Alice
        MockERC20 token = new MockERC20();
        token.mint(address(this), 1000);
        token.approve(address(this), 1000);
        assertEq((token.allowance(address(this), address(this))), 1000);
        token.transferFrom(address(this), alice, 1000);
        assertEq(token.balanceOf(alice), 1000);

        /// Alice creates capsule and deposits ERC20 tokens
        vm.startPrank(alice);
        factory.createCapsule(alice);
        MoonCapsule capsule = factory.capsules(alice);
        token.approve(alice, 1000);
        assertEq((token.allowance(alice, alice)), 1000);
        token.transferFrom(alice, address(capsule), 1000);
        assertEq(token.allowance(alice, alice), 0);
        vm.stopPrank();
        assertEq(token.balanceOf(address(capsule)), 1000);
        assertEq(token.balanceOf(alice), 0);

        /// Alice transfers capsule to Bob
        vm.prank(alice);
        capsule.transferFrom(alice, bob, 1);
        assertEq(capsule.ownerOf(1), bob);

        /// Bob withdraws tokens deposited by Alice
        vm.startPrank(bob);
        capsule.withdrawERC20(address(token), 100, 1);
        token.approve(bob, token.balanceOf(bob));
        vm.stopPrank();
        assertEq(token.balanceOf(bob), 100);
        assertEq(token.allowance(bob, bob), 100);

        vm.startPrank(bob);
        capsule.withdrawERC20(address(token), 600, 1);
        token.approve(bob, token.balanceOf(bob));
        vm.stopPrank();
        assertEq(token.balanceOf(bob), 700);
        assertEq(token.allowance(bob, bob), 700);
    }
}
