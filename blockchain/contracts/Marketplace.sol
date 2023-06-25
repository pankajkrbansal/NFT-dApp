// SPDX-License-Identifier:MIT
pragma solidity >=0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract Marketplace {

    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemSolds;

    address payable marketPlaceOwner;
    uint listingPrice = 0.0001 ether;

    struct MarketItem {
        uint itemId;
        address nftContract;
        uint tokenId;
        address payable seller;
        address payable owner;
        uint price;
        bool sold;
    }

    mapping(uint => MarketItem) idToMarketItem;

    event MarketItemCreated {
        uint itemId;
        address nftContract;
        uint tokenId;
        address seller;
        address owner;
        uint price;
        bool sold;
    }

    constructor() {
        marketPlaceOwner = payable(msg.sender);
    }

    function getListingPrice() public view returns(uint) {
        return listingPrice;
    }

    function createMarketItem(address _nftContract, uint _tokenId, uint _price) public payable nonReentrant {
        require(_price > 0, 'Price must be atleast 1 wei');
        require(msg.value == listingPrice, 'Price cannot be less than 0.0001 ether');

        _itemIds.increment();
        uint currentId = _itemsIds.current();

        idToMarketItem[_tokenId] = MarketItem(
            currentId,
            _nftContract,
            _tokenId,
            payable(msg.sender),
            payable(address(0)),
            _price,
            false
        );

        IERC721(_nftContract).transferFrom(msg.sender, address(this), _tokenId);

        emit MarketItemCreated(
            currentId,
            _nftContract,
            _tokenId,
            msg.sender,
            address(0),
            _price,
            false
        );
    }   

    // function to sell the NFT
    function createMarketSale(address _nftContract, uint _itemId) public payable {
        uint price = MarketItem[_itemId].price;
        uint tokenId = MarketItem[_itemId].tokenId;
        require(msg.value == price,"Please Pay The Displayed Amount");
        
        // transfer the price amount of nft to seller
        idToMarketItem[_itemId].seller.transfer(msg.value);

        // transfer the nft to the caller of this function
        IERC721(_nftContract).transferFrom(idToMarketItem[_itemId].seller, msg.sender, tokenId);

        // set owner for the sold nft
        idToMarketItem[_itemId].owner = payable(msg.sender);

        // changing sold field to true
        idToMarketItem[_itemId].sold = true;

        _itemSolds.increment();

        // transfer listing price to owner of market place
        payable(marketPlaceOwner).transfer(listingPrice);
    }

    function fetchMarketItems() public view returns(MarketItem[] memory) {
        
        uint unsoldItemCount = _itemIds.current() - _itemSolds.current();
        MarketItem[] memory item = new MarketItem(unsoldItemCount);

        uint count = 0;

        for(uint i=1; i <= _itemIds.current(); i++) {
            if(idToMarketItem[i].owner == address(0)){
                item[count] = idToMarketItem[i];
                count++;
            }
        }
        return item;
    }

    function fetchMyNFTs() public view returns(MarketItem[] memory) {
        uint itemLength = _itemsIds.current();
        MarketItem[] items;
        uint count = 0;
        for(uint i = 1;i <= itemLength; i++) {
            if(idToMarketItem[i].seller == msg.sender){
                items[count] = idToMarketItem[i];
                count++;
            }
        }
        return items;   
    }
}
