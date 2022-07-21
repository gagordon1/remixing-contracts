// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import 'openzeppelin-solidity/contracts/access/Ownable.sol';

contract DerivativeWork is ERC721Enumerable, Ownable {

    string baseURI;
    uint256 maxSupply;
    uint256 mintPrice;

    constructor(string memory _uri, string memory collectionName, 
        string memory collectionSymbol, uint256 _mintPrice //wei
         ) ERC721(collectionName, collectionSymbol)  {

        require(_originalCreatorTokens + _derivativeCreatorTokens < _maxSupply, "Not enough supply to mint creator and derivate creator tokens.");        
        
        baseURI = _uri;
        maxSupply = _maxSupply;
        mintPrice = _mintPrice;

    }

    /**
     * Gets the mint price for this derivative work
     */
    function getPrice() external view returns (uint256){
        return mintPrice;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    /**
     * Purchases amount of tokens and transfers to sender
     */
    function buy(uint256 amount) external payable{
        uint256 supply = totalSupply();
        require(supply + amount <= maxSupply,      "Requested more than the amount of tokens remaining"); //enough supply left
        require(msg.value >= amount * mintPrice,   "Not enough ether sent"); //sent enough ether
        for (uint256 i = 0; i < amount; i++){
            _safeMint(msg.sender, supply + i);
        }
    }

    /**
     * Allows the contract owner to withdraw the contract's entire value
     */
    function withdrawAll() external onlyOwner {
        require(payable(msg.sender).send(address(this).balance)); //send value from contract to contract owner
    }


}