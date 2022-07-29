// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';

/**
 * Implements the ISidechain interface
 */
 contract Sidechain is ERC721Enumerable{

  event SidechainCreated(address newAddress);

  address public creator;
  address[] public parents;
  uint16 public REV; // uint16 less than 1000
  uint16 private MAX_OWNERSHIP_VALUE = 1000;
  uint16 ancestorCount = 0;


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
    
    address[] memory ancestors = new address[](MAX_OWNERSHIP_VALUE); //largest size the array could conceivably be
    loadAncestors(ancestors, _parents);

    //check for sufficient equity to mint ownership tokens.
    require(getAncestorEquity(ancestors) + _REV <= MAX_OWNERSHIP_VALUE, "Not enough equity remaining to mint.");
    
    //mint tokens to all ancestors
    uint256 supply;
    for (uint16 i = 0; i< ancestorCount; i++){
      address ancestor = ancestors[i];
      supply = totalSupply();
      
      for(uint16 j; j < Sidechain(ancestor).getREV(); j++){
          _safeMint( Sidechain(ancestor).getCreator(), supply + j );
      }
    }
    
    supply = totalSupply();
    //mint remaining equity to creator
    // for(uint16 j; j < MAX_OWNERSHIP_VALUE - supply; j++){
    //       _safeMint( _creator, supply + j );
    //   }
    // this is too slow I think we need to switch to ERC20
    emit SidechainCreated(address(this));
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

   /**
   * loads ancestor contracts into an ancestor array
   */
  function loadAncestors(address[] memory ancestors, address[] memory _parents) private{
    for (uint i = 0; i < _parents.length; i++){
      address parent = _parents[i];
      ancestors[ancestorCount] = parent;
      ancestorCount++;
      loadAncestors(ancestors, Sidechain(parent).getParents());
    }
  }

  function getAncestorEquity(address[] memory  _ancestors) private view returns(uint16){
    uint16 ancestorEquity = 0;
    for (uint16 i = 0; i< ancestorCount;i++){
      address ancestor = _ancestors[i];
      ancestorEquity +=  Sidechain(ancestor).getREV();
    }
    return ancestorEquity;
  }

}