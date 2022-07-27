// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;
import 'openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol';

// contract SidechainFactory{
//   Sidechain[] private _sidechains;
//
//   function createSidechain(address[] memory parents, uint16 REV) public {
//         Sidechain sidechain = new Sidechain(
//             name,
//             msg.sender
//         );
//         _sidechains.push(sidechain);
//     }
// }
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
   constructor(address _creator, address[] memory _parents, uint16 _REV)
    ERC721("Sidechain", "SDCN"){
    require(_REV <= MAX_OWNERSHIP_VALUE, "Maximum REV = 1000.");
    parents = _parents;
    REV = _REV;
    creator = _creator;
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
