// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/token/ERC721/ERC721.sol";
import {IERC20} from "@openzeppelin/interfaces/IERC20.sol";

error NotOwner(address caller, address expected);
error InsufficientBalance(uint256 balance, uint256 amount);

contract MoonCapsule is ERC721 {
    constructor(
        address _receiver,
        uint256 _factoryId
    ) ERC721("MoonCapsule", "iMCT") {
        _safeMint(_receiver, _factoryId);
    }

    function withdraw(uint256 _amount, uint256 _tokenId) external payable {
        if (msg.sender != ownerOf(_tokenId)) {
            revert NotOwner({caller: msg.sender, expected: ownerOf(_tokenId)});
        }
        if (address(this).balance < _amount) {
            revert InsufficientBalance({
                balance: address(this).balance,
                amount: _amount
            });
        }
        (bool sent, ) = payable(msg.sender).call{value: _amount}("");
        require(sent, "Withdrawal failed");
    }

    function withdrawERC20(
        address _token,
        uint256 _amount,
        uint256 _tokenId
    ) external {
        if (msg.sender != ownerOf(_tokenId)) {
            revert NotOwner({caller: msg.sender, expected: ownerOf(_tokenId)});
        }
        IERC20(_token).approve(address(this), _amount);
        IERC20(_token).transferFrom(address(this), msg.sender, _amount);
    }

    receive() external payable {}
}
