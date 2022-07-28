// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './Sidechain.sol';

contract SidechainFactory{
  mapping(address => bool) private _sidechains; //check if contract is a sidechain
  uint256 ancestorIndex = 0;
  
  event SidechainCreated(address newAddress);
  event LoadedAncestors(address[] ancestors);

  uint16 public MAX_OWNERSHIP_VALUE = 1000;

  /**
   * Creates a sidechain and adds it to our global set of sidechains.
   */
  function createSidechain(address[] memory parents, uint16 REV) external{
    ancestorIndex = 0;
    address[] memory ancestors = new address[](MAX_OWNERSHIP_VALUE); //token could conceivably have 1000 ancestors.
    
    loadAncestors(ancestors, parents);
    emit LoadedAncestors(ancestors);

    //check that there is available equity
    uint16 ancestorOwnership = 0;
    for (uint i = 0; i< ancestorIndex;i++){
      address ancestor = ancestors[i];
      ancestorOwnership +=  Sidechain(ancestor).getREV();
    }
    require(ancestorOwnership + REV <= MAX_OWNERSHIP_VALUE, "Not enough equity remaining to mint.");
    
    //create new sidechain contract
    Sidechain sidechain = new Sidechain(
        msg.sender,
        parents,
        REV
    );
    _sidechains[address(sidechain)] = true;
    
    //mint ancestor ownership to each
    for (uint i = 0; i<ancestorIndex;i++){
      address ancestor = ancestors[i];
      sidechain.factoryMint(Sidechain(ancestor).getCreator(), Sidechain(ancestor).getREV());
    }

    //mint REV amount of tokens to creator of this work
    // sidechain.factoryMint(msg.sender, REV);

    emit SidechainCreated(address(sidechain));
    ancestorIndex = 0;
  }

  /**
   * loads ancestor contracts into ancestor array
   */
  function loadAncestors(address[] memory ancestors, address[] memory parents) internal{
    for (uint i = 0; i < parents.length; i++){
      address parent = parents[i];
      ancestors[ancestorIndex] = parent;
      ancestorIndex++;
      loadAncestors(ancestors, Sidechain(parent).getParents());
    }
  }

}


