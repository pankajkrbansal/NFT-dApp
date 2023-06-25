// // SPDX-License-Identifier:MIT

// pragma solidity >= 0.8.0;

// // import "../node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol";
// import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";
// import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

// contract Marketplace is ReentrancyGuard, ERC721URIStorage {
//     using Counters for Counters.Counter;
//     Counters.Counter tokenCount;

//     address public ownerFeeAccount;
//     uint public immutable listingPrice;
//     uint public itemCount;

//     struct nftItem {
//         uint tokenId;
//         uint price;
//         address payable owner;
//         bool sold;
//         bool isListed;
//     }

//     event TokenListedSuccess (
//         uint256 indexed tokenId,
//         address seller,
//         uint256 price,
//         bool currentlyListed
//     );

//     mapping(uint => nftItem) nftList;

//     constructor() ERC721("BADGERS-NFT", "BNFT") {
//         ownerFeeAccount = payable(msg.sender);
//         listingPrice = 0.01 ether;
//     }

//     function createToken(string calldata _tokenURI, uint price) external payable returns(uint){
//         tokenCount.increment();
//         _safeMint(msg.sender, tokenCount.current());
//         _setTokenURI(tokenCount.current(), _tokenURI);
        
//         nftList[tokenCount.current()] = nftItem(
//             tokenCount.current(),
//             price,
//             payable(msg.sender),
//             false,
//             false
//         );
//         return tokenCount.current();
//     }

//     // function listNFT(tokenCount.current(), price);

//     function listNFT(uint _tokenId, uint price) public payable {
//         require(msg.value > listingPrice, 'Listing Price is 0.01 ETH');
//         require(price>0, 'The price should be greater than 0 ETH');

//         nftList[_tokenId] = nftItem(
//             _tokenId,
//             price,
//             payable(msg.sender),
//             false,
//             true
//         );

//         // _transfer(msg.sender, address(this), _tokenId);

//         approve(address(this), _tokenId);
//         // _transfer(msg.sender, address(this), _tokenId);

//         // pay Marketplace the listing fee
//         (bool success,) = ownerFeeAccount.call{value:msg.value}("");
//         require(success,"Fee Payment To Marketplace Failed");

//         emit TokenListedSuccess(
//             _tokenId,
//             msg.sender,
//             price,
//             true
//         );
//     }

//     function purchaseNFT(uint tokenId)public payable{
//         require(msg.value == nftList[tokenId].price, 'Price Of NFT Not Matched');
//         require(_exists(tokenId), "Token ID is invalid");
//         require(!nftList[tokenId].sold, "NFT Item Already Sold");
        
//         // pay to owner
//         (bool success,) = nftList[tokenId].owner.call{value:msg.value}("");
//         require(success,"Payment To Seller Failed");

//         // transfer NFT To new Buyer 
//         // safeTransferFrom(nftList[tokenId].owner, msg.sender, tokenId);
//         _safeTransfer(nftList[tokenId].owner, msg.sender, tokenId,"");

//         // update owner in the struct storage
//         nftList[tokenId].owner = payable(msg.sender);
//     }


//     function getMyNFT() public view returns(nftItem[] memory){
//         uint currentToken = tokenCount.current();
//         // nftItem[] memory arr = new nftItem[](currentToken);
//         nftItem[] memory arr;
//         for(uint i=1;i<=currentToken;i++) {
//             nftItem storage currentNFT = nftList[i];
//             if(currentNFT.owner == msg.sender) {
//                 // arr.push(currentNFT);
//                 arr[i] = currentNFT;
//             }
//         }
//         return arr;
//     }

//     function getListedNFT() external view returns(nftItem[] memory) {
//         uint currentToken = tokenCount.current();
//         nftItem[] memory listedArr = new nftItem[](currentToken);
//         for(uint i=1;i<=currentToken;i++) {
//             nftItem storage currentNft = nftList[i];
//             if(currentNft.isListed){
//                 listedArr[i] = currentNft;
//             }
//         }
//         return listedArr;
//     }
// }