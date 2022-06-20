// SPDX-License-Identifier: GNU

pragma solidity ^0.8.1;

import "hardhat/console.sol";
// nft OpenZeppelin Contracts imports
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import { Base64 } from "./lib/Base64.sol";

contract DeNFT is ERC721URIStorage {
    // event on mint
    event nftMinted(address sender, uint256 tokenId);
    // some 3 random arrays of words 
    string[] firstWords = ["Red", "BlackRed", "Yellow", "VeryYellow", "Blue", "DarkBlue", "Brown", "BlackBrown", "Purple", "RedPurple", "Silver", "BlackVeryMuch"];
    string[] secondWords = ["Icetea", "VeryIcetea", "Ayran", "VeryAyran", "Nescafe", "Turkish Coffee"];
    string[] thirdWords = ["Tomatto", "Ocra", "Potato", "Reddish", "Cabbage", "GreenChilli", "VeryChilli", "RedChilli"];
    // string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // some color for svg
    string[] materialColors = ["#f44336", "#e91e63", "#9c27b0", "#3f51b5", "#2196f3", "#03a9f4", "#00bcd4", "#009688", "#4caf50", "#8bc34a", "#cddc39", "#ffeb3b", "#ffc107", "#ff9800", "#ff5722", "#795548", "#9e9e9e", "#607d8b"];

    // OpenZeppelin to help us keep track of _tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("DeNft", "DENFT") {
        console.log("initing NFT contract, Owner=", msg.sender);
    }

     // function to randomly pick a word from each array.
    function pickRandomWordFromArr(uint256 tokenId, string memory initalword, string[] memory wordsArr) public pure returns (string memory) {
      // I seed the random generator. More on this in the lesson. 
      uint256 rand = random(string(abi.encodePacked(initalword, Strings.toString(tokenId))));
      // Squash the # between 0 and the length of the array to avoid going out of bounds.
      rand = rand % wordsArr.length;
      return wordsArr[rand];
    }
    // random function helper
    function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
    }
    function pickRandomColor(uint256 tokenId) public view returns (string memory) {
      uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
      rand = rand % materialColors.length;
      return materialColors[rand];
    }

    function mintAnNFT() public {
      // current NFT item count with the help of _tokenIds.current() in the contract
      // will start with 0
      uint256 tokenId = _tokenIds.current();
      // pick 3 words and combine
      string memory first = pickRandomWordFromArr(tokenId, "FIRST_WORD", firstWords);
      string memory second = pickRandomWordFromArr(tokenId, "SECOND_WORD", secondWords);
      string memory third = pickRandomWordFromArr(tokenId, "THIRD_WORD", thirdWords);
      string memory combinedWord = string(abi.encodePacked(first, second, third));
      string memory randomColor = pickRandomColor(tokenId);
      console.log("\n--------------------");
      console.log("random 1st, 2nd, 3rd and combinedWord is: "first, second, third, combinedWord);
      console.log("random color: ", randomColor);
      console.log("--------------------\n");
      // Add cmbined word in our svg
      // string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));
      
      // random color + word SVG.
      string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));

      // prepare JSON metadata and base64 encode it
      string memory json = Base64.encode(
          bytes(
              string(
                  abi.encodePacked(
                      '{"name": "',
                      // We set the title of our NFT as the generated word.
                      combinedWord,
                      '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                      // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                      Base64.encode(bytes(finalSvg)),
                      '"}'
                  )
              )
          )
      );
      // prepend data:application/json;base64, 
      // prepend in order to comply with proper base64 string
      string memory finalTokenUri = string(
          abi.encodePacked("data:application/json;base64,", json)
      );
      console.log("\n--------------------");
      console.log(finalTokenUri);
      console.log("--------------------\n");
      // mint the NFT to requested user i.e msg.sender
      _safeMint(msg.sender, tokenId);
      // Set the NFTs
      // string memory _tokenURI = "https://jsonkeeper.com/b/EWYE";
      // "data:application/json;base64,ewogICAgIm5hbWUiOiAiRXBpY0xvcmRIYW1idXJnZXIiLAogICAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0S0lDQWdJRHh6ZEhsc1pUNHVZbUZ6WlNCN0lHWnBiR3c2SUhkb2FYUmxPeUJtYjI1MExXWmhiV2xzZVRvZ2MyVnlhV1k3SUdadmJuUXRjMmw2WlRvZ01UUndlRHNnZlR3dmMzUjViR1UrQ2lBZ0lDQThjbVZqZENCM2FXUjBhRDBpTVRBd0pTSWdhR1ZwWjJoMFBTSXhNREFsSWlCbWFXeHNQU0ppYkdGamF5SWdMejRLSUNBZ0lEeDBaWGgwSUhnOUlqVXdKU0lnZVQwaU5UQWxJaUJqYkdGemN6MGlZbUZ6WlNJZ1pHOXRhVzVoYm5RdFltRnpaV3hwYm1VOUltMXBaR1JzWlNJZ2RHVjRkQzFoYm1Ob2IzSTlJbTFwWkdSc1pTSStSWEJwWTB4dmNtUklZVzFpZFhKblpYSThMM1JsZUhRK0Nqd3ZjM1puUGc9PSIKfQ=="
      _setTokenURI(tokenId, finalTokenUri); 
      // save and increament id for next nft
      _tokenIds.increment();
      // log as nft minted
      console.log("An NFT w/ ID %s has been minted to %s", tokenId, msg.sender);
      // emit event that nft is minted
      emit nftMinted(msg.sender, tokenId);
    }
}
