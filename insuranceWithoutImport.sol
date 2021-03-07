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
    contract  TechInsurance {
    
     
    /** 
     * Defined two structs
     * 
     * * 
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
    mapping (uint256 => address) private _owners;
    mapping(address => uint256) public _balances;
    mapping(uint => Product) public productIndex;
    mapping(address => mapping(uint => Client)) public client;
    
    uint productCounter;
    
    address payable insOwner;
    constructor(address payable _insOwner){
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
    function balanceOf(address owner) public view   returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }
    
    function _transfer(address from, address to, uint256 tokenId) internal  {
        //require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");


        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

    }
    function ownerOf(uint256 tokenId) public view  returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }
      
    
}

