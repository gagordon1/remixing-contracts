// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import 'openzeppelin-solidity/contracts/access/Ownable.sol';

contract DerivativeWork is ERC721Enumerable, Ownable {

    string baseURI;
    address originalCreator;
    uint256 maxSupply;
    uint256 mintPrice;

    constructor(string memory _uri, string memory collectionName, 
        string memory collectionSymbol,  uint256 _maxSupply, uint256 _mintPrice, //wei
        address _originalCreator, uint256 _originalCreatorTokens,
        address _derivativeCreator, uint256 _derivativeCreatorTokens
         ) ERC721(collectionName, collectionSymbol)  {

        require(_originalCreatorTokens + _derivativeCreatorTokens < _maxSupply, "Not enough supply to mint creator and derivate creator tokens.");
        
        baseURI = _uri;

        originalCreator = _originalCreator;

        maxSupply = _maxSupply;

        mintPrice = _mintPrice;

        //first tokens get minted to the original creator
        for (uint256 i = 0; i < _originalCreatorTokens; i++){
            _safeMint( _originalCreator, i);
        }

        for (uint256 j = _originalCreatorTokens; j < _originalCreatorTokens + _derivativeCreatorTokens; j++){
            _safeMint( _derivativeCreator, j);
        }
        transferOwnership(_derivativeCreator); //derivative creator now owns the contract

    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    /**
     * Gets the original creator for this derivative work
     */
    function getOriginalCreator() external view returns (address) {
        return originalCreator;
    }

    /**
     * Purchases amount of tokens and transfers to sender
     */
    function buy(uint256 amount) external payable{
        uint256 supply = totalSupply();
        require(msg.value >= amount * mintPrice); //sent enough ether
        require(supply + amount < maxSupply); //enough supply left

        for (uint256 i = 0; i < amount; i++){
            _safeMint(msg.sender, supply + i);
        }

    }

    function withdrawAll() external onlyOwner {
        require(payable(msg.sender).send(address(this).balance)); //send value from contract to contract owner
    }


}