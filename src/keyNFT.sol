/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ERC721 } from "@openzeppelin/token/ERC721/ERC721.sol";
import { ERC721URIStorage } from "@openzeppelin/token/ERC721/extensions/ERC721URIStorage.sol";
import { Ownable } from "@openzeppelin/access/Ownable.sol";

contract KeyNFT is ERC721, Ownable {
    constructor(address _recipient, uint256 _tokenId) ERC721("MyNFT", "NFT") {
        _safeMint(_recipient, _tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

// contract KeyNFT is ERC721, ERC721URIStorage, Ownable {

//     constructor(address _recipient, uint256 _tokenId, string memory _uri) ERC721("MyNFT", "NFT") {
//         _safeMint(_recipient, _tokenId);
//         _setTokenURI(_tokenId, _uri);
//     }

//     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
//         super._burn(tokenId);
//     }

//     function tokenURI(uint256 tokenId)
//         public
//         view
//         override(ERC721, ERC721URIStorage)
//         returns (string memory)
//     {
//         return super.tokenURI(tokenId);
//     }

//     function supportsInterface(bytes4 interfaceId)
//         public
//         view
//         override(ERC721, ERC721URIStorage)
//         returns (bool)
//     {
//         return super.supportsInterface(interfaceId);
//     }
// }