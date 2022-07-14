// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import 'openzeppelin-solidity/contracts/access/Ownable.sol';
import 'openzeppelin-solidity/utils/math/SafeMath.sol';

contract DerivativeWork is ERC721Enumerable, Ownable {

    string baseTokenURI;
    address originalCreator;
    uint256 maxSupply;
    uint256 mintPrice;

    constructor(string baseURI, string collectionName, 
        string collectionSymbol,  uint256 _maxSupply, uint256 _mintPrice, //ether
        address  _originalCreator, uint256 _originalCreatorTokens,
        address _derivativeCreator, uint256 _derivativeCreatorTokens
         ) ERC721(collectionName, collectionSymbol)  {

        require(add(_originalCreatorTokens, _derivativeCreatorTokens) < _maxSupply, "Not enough supply to mint creator and derivate creator tokens.");
        
        setBaseURI(baseURI);

        setOriginalCreator(_originalCreator);

        setTotalSupply(_maxSupply);

        //first tokens get minted to the original creator
        for (uint256 i = 0; i < _originalCreatorTokens; i++){
            _safeMint( _originalCreator, i);
        }

        for (uint256 j = _originalCreatorTokens; j < _originalCreatorTokens + _derivativeCreatorTokens; j++){
            _safeMint( _derivativeCreator, j);
        }
    
        setMintPrice(_mintPrice);

    }

    /**
    Sets the mint price for the collection
    */
    function setMintPrice(uint256 _mintPrice) private internal{
        mintPrice = _mintPrice ether;
    }

    /**
     * Gets the original creator for this derivative work
     */
    function getOriginalCreator() public{
        return originalCreator;
    }

    function setOriginalCreator(address _originalCreator){
        originalCreator = _originalCreator;
    }

    function setTotalSupply(uint256 _maxSupply){
        maxSupply = _maxSupply;
    }

    /**
     * Purchases amount of tokens and transfers to sender
     */
    function buy(uint256 amount) external payable{
        uint256 supply = totalSupply();
        require(msg.value >= mul(amount, mintPrice)); //sent enough ether
        require(supply + amount < maxSupply); //enough supply left

        for (int i = 0; i < amount; i++){
            _safeMint(msg.sender, add(supply, i));
        };

    }


}