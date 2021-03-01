//SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

/**
 * @title Tech Insurance tor
 * @dev 
 * Step1: Complete the functions in the insurance smart contract
 * Step2:Add any required methods that are needed to check if the function are called correctly, 
 * and also add a modifier function that allows only the owner can run the changePrice function.
 * Step3: Add any error handling that may occur in any function
 * Step4: Add a modifer function to check the time if the client insurance is valid.
 * Step5 (opcional): Add a refund function that refunds money back to the client after one week. Guaranteed Money Back Plan.  
 * Step6: implement ERC 721 Token to this contract and change what it needs to be changed e.g. 
 * 
 () function.
 * 
 */
 import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
    contract  TechInsurance is ERC721{
    
     
    /** 
     * Defined two structs
     * 
     * 
     */
    struct Product {
        uint productId;
        string productName;
        uint price;
        bool offered;
    }
     
    struct Client {
        bool isValid;
        uint time;
    }
    
    
    mapping(uint => Product) public productIndex;
    mapping(address => mapping(uint => Client)) public client;
    
    uint productCounter;
    
    address payable insOwner;
    constructor(address payable _insOwner) ERC721("NFT-Example", "NEX"){
        insOwner = _insOwner;
    }
 
    function addProduct(uint _productId, string memory _productName, uint _price ) public {
             productIndex[productCounter] = Product( _productId,   _productName, _price, true);
             productCounter++;
    }
    
    
    function doNotOffer(uint _productIndex) public {
             require( productIndex[_productIndex].offered == false, "ALREADY NOT OFFERED");
             productIndex[_productIndex].offered=false;
    }
    
    function forOffer(uint _productIndex) public {
             require( productIndex[_productIndex].offered == true, "ALREADY  OFFERED");
             productIndex[_productIndex].offered=true;
    }
    
    function changePrice(uint _productIndex, uint _price) public onlyOwner{
            productIndex[_productIndex].price=_price;
    }
      modifier onlyOwner(){
        require(msg.sender == insOwner, "YOU ARE NOT THE OWNER");
        _;
    }
    
    /**
    * @dev 
    * Every client buys an insurance, 
    * you need to map the client's address to the id of product to struct client, using (client map)
    */
    function buyInsurance(uint _productIndex) public payable isTimeValid( _productIndex){
        client[msg.sender][_productIndex]=Client(true, block.timestamp);
    } 
     modifier isTimeValid(uint _productIndex){
        require(block.timestamp <= client[msg.sender][_productIndex].time + 365 days, "the insurance expired");
        _;
    }
      
    
}

