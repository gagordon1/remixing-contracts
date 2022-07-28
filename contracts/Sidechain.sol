// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol';

/**
 * Implements the ISidechain interface
 */
 contract Sidechain is ERC721Enumerable{

  event SidechainCreated(address newAddress);
  event LoadedAncestors(address[] ancestors);

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
    
    address[] memory ancestors = new address[](MAX_OWNERSHIP_VALUE);
    loadAncestors(ancestors, parents);
    emit LoadedAncestors(ancestors);

  }

  /**
   * To be called when minting the ancestor ownership tokens.
   */
  function factoryMint(address _to, uint256 _amount) private {
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

   /**
   * loads ancestor contracts into an ancestor array
   */
  function loadAncestors(address[] memory ancestors, address[] memory parents) private{
    for (uint i = 0; i < parents.length; i++){
      address parent = parents[i];
      ancestors[ancestorCount] = parent;
      ancestorCount++;
      loadAncestors(ancestors, Sidechain(parent).getParents());
    }
  }

}
