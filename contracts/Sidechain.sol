// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol';

/**
 * Implements the ISidechain interface
 */
 contract Sidechain is ERC721Enumerable{

   address public creator;
   address[] public parents;
   uint16 public REV; // uint16 less than 1000
   uint16 private MAX_OWNERSHIP_VALUE = 1000;
   address public factory; //factory that created this token


  /**
   * Given a creator wallet address, parent contract address and the REV for
   * the work, create the contract
   */
   constructor(address _creator, address[] memory _parents, uint16 _REV)
    ERC721("Sidechain", "SDCN"){
    require(_REV <= MAX_OWNERSHIP_VALUE, "Maximum REV = 1000.");
    parents = _parents;
    REV = _REV;
    creator = _creator;
    factory = msg.sender;
  }

  /**
   * To be called by a factory when it is minting the ancestor ownership
   * tokens.
   */
  function factoryMint(address _to, uint256 _amount) external {
    require(msg.sender == factory, "Only callable by creator of this contract.");
    uint256 supply = totalSupply();
    require(supply + _amount <= MAX_OWNERSHIP_VALUE, "Not enough equity remaining to mint.");

    for(uint256 i; i < _amount; i++){
        _safeMint( _to, supply + i );
    }
  }



  function getCreator() external view returns (address){
  	return creator;
  }

  function getParents() external view returns (address[] memory){
  	return parents;
  }

  function getREV() external view returns (uint16) {
  	return REV;
  }

  function collectCopyrightPayment() external payable{
  	//TODO
  }

}
