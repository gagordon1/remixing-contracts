import 'openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
pragma solidity ^0.8.0;

/**
 * Implements the ISidechain interface
 */
 contract Sidechain{

   public address parent;
   public uint256 REP;
   private uint256 MAX_OWNERSHIP_VALUE = 1 000 000 //fractions are out of 1mil

  /**
   * Given a parent address and the REP for the work, create the contract
   */
   constructor(address _parent, uint256 _REP){
  	parent = _parent;
    REP = _REP;
    address[] memory ancestors = getAncestors();
    uint256 ancestorOwnership = getAncestorOwnership(ancestors);
    require(ancestorOwnership + REP <= MAX_OWNERSHIP_VALUE); //make sure theres enough equity to create this work
  }

  /**
   * Returns the ownership attributable to a work's ancestors
   */
  function getAncestorOwnership(address[] memory ancestors) internal view returns (uint256){
    uint256 ancestorOwnership = 0;
    for (uint i = 0; i< ancestors.length; i++){
      ancestorOwnership += getAncestorREP(ancestor[i]);
    }
    return ancestorOwnership;
  }

  /**
   * Gets ancestors of the contract
   */
  function getAncestors() internal view returns (address[] memory){
    if(parent == 0){
      return address[] emptyArray;
    }
    address[] memory parentAncestors = parent.getAncestors();
    parentAncestors.push(parent);
    return parentAncestors;
  }

  /**
   * Given an ancestor's contract address, gets its REP
   */
  function getAncestorREP(address ancestor) internal view returns (uint256){
    return ancestor.getREP();
  }

  function getParent() public view returns (address){
  	return parent;
  }

  function getREP() public view returns (uint256) {
  	return REP;
  }

  function collectCopyrightPayment() public payable{
  	//TODO
  }

}
