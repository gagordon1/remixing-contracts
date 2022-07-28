// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import 'openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol';

/**
 * Implements the ISidechain interface
 */
 contract Sidechain is ERC721Enumerable{

  event SidechainCreated(address newAddress);
  event LoadedAncestors(address[] ancestors, uint16 count);
  event AllocatedTokens(uint16 amount, address to);
  event AncestorEquity(uint16 value);

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
    
    address[] memory ancestors = new address[](10);
    loadAncestors(ancestors, _parents);
    emit LoadedAncestors(ancestors, ancestorCount);

    //check for sufficient equity to mint ownership tokens.
    require(getAncestorEquity(ancestors) + _REV <= MAX_OWNERSHIP_VALUE, "Not enough equity remaining to mint.");

    emit AncestorEquity(getAncestorEquity(ancestors));
    //mint tokens to all ancestors
    // ancestorMint(ancestors);
    // batchMint(_creator, _REV);
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

  /**
    Gets total supply of the tokens and mints the next {amount} token ids
    to the specified address
   */
  function batchMint(address _to, uint16 _amount) private{
    uint256 supply = totalSupply();
    for(uint256 tokenId = supply; tokenId < supply + _amount; tokenId++){
      _safeMint(_to, tokenId);
      emit AllocatedTokens(_amount, _to);
    }
  }

  /**
   * To be called when minting the ancestor ownership tokens.
   */
  function ancestorMint(address[] memory ancestors) private {
    for (uint16 i = 0; i< ancestorCount; i++){
      address ancestor = ancestors[i];
      batchMint(Sidechain(ancestor).getCreator(), Sidechain(ancestor).getREV());
    }
  }

}
