// SPDX-License-Identifier: GNU

pragma solidity ^0.8.1;

import "hardhat/console.sol";
// nft OpenZeppelin Contracts imports
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract DeNFT is ERC721URIStorage {
    // OpenZeppelin to help us keep track of _tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("DeNft", "DENFT") {
        console.log("initing NFT contract, Owner=", msg.sender);
    }

    function makeAnEpicNFT() public {
      // current NFT item count with the help of _tokenIds.current() in the contract
      // will start with 0
      uint256 tokenId = _tokenIds.current();
      // mint the NFT to requested user i.e msg.sender
      _safeMint(msg.sender, tokenId);
      // Set the NFTs
      // string memory _tokenURI = "https://jsonkeeper.com/b/EWYE";
      _setTokenURI(tokenId, "https://jsonkeeper.com/b/RUUS"); 
      // save and increament id for next nft
      _tokenIds.increment();
      // log
      console.log("An NFT w/ ID %s has been minted to %s", tokenId, msg.sender);
    }
}
