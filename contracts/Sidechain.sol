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
   address[] public ancestors = new address[](0);

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
    loadAncestors();
  }

  /**
   * Gets all ancestors for a node, including itself.
   */
  function loadAncestors() private{
    ancestors.push(creator);
    if (parents.length > 0){
      for (uint16 i = 0; i< parents.length; i++){
        address[] memory parentAncestors = Sidechain(parents[i]).getAncestors();
        for (uint16 j = 0; j < parentAncestors.length; j++){
          ancestors.push(parentAncestors[j]);

        }
    }
    }
    
  }

  function getAncestors() public view returns (address[] memory){
    return ancestors;
  }

  function getCreator() public view returns (address){
  	return creator;
  }

  function getParents() public view returns (address[] memory){
  	return parents;
  }

  function getREV() public view returns (uint16) {
  	return REV;
  }

  function collectCopyrightPayment() external payable{
  	//TODO
  }

}
