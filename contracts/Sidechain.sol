// SPDX-License-Identifier: MIT

import 'openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
pragma solidity ^0.8.0;

/**
 * Implements the ISidechain interface
 */
 contract Sidechain is ERC721Enumerable{

   address public creator;
   address[] public parents;
   uint16 public REV; // uint16 less than 1000
   uint16 private MAX_OWNERSHIP_VALUE = 1000;

  /**
   * Given a creator wallet address, parent contract address and the REV for
   * the work, create the contract
   */
   constructor(address _creator, address[] memory _parents, uint16 _REV){
    require(_REV <= MAX_OWNERSHIP_VALUE, "Maximum REV = 1000.");
    parents = _parents;
    REV = _REV;
    creator = _creator;
  }

  function getAncestors() internal returns(address[] memory){
    address[] memory out = [creator];
    for (int i = 0; i< parents.length; i++){
      out.push(parents[i]);
      address[] memory ancestors = parents[i].getAncestors();
      for (int j = 0; j < ancestors.length; j++){
        out.push(ancestors[j])

      }
    }
    return out;
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
