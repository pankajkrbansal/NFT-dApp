// SPDX-License-Identifier:MIT

pragma solidity >= 0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

contract NFT is ERC721URIStorage{
    using Counters for Counters.Counter;
    Counters.Counter private tokenCount;

    address nftMarketAddr;

    constructor(address _nftMarketAddr) ERC721("MY-NFT", "PKB_NFT"){
        nftMarketAddr = _nftMarketAddr;
    }

    function mintNFT(string memory _tokenURI) external returns(uint){
        uint tokenId = tokenCount.current();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        setApprovalForAll(nftMarketAddr, true);
        tokenCount.increment();
        return tokenId;
    }
}