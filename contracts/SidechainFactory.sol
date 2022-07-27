// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './Sidechain.sol';

contract SidechainFactory{
  mapping(address => bool) private _sidechains; //check if contract is a sidechain
  event SidechainCreated(address newAddress);

  address[] private ancestors;
  uint16 public MAX_OWNERSHIP_VALUE = 1000;

  /**
   * Creates a sidechain and adds it to our global set of sidechains.
   */
  function createSidechain(address[] memory parents, uint16 REV) external{

    delete ancestors; //clear array
    loadAncestors(parents);

    //check that there is available equity
    uint16 ancestorOwnership = 0;
    for (uint i = 0; i<ancestors.length;i++){
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
    for (uint i = 0; i<ancestors.length;i++){
      address ancestor = ancestors[i];
      sidechain.factoryMint(Sidechain(ancestor).getCreator(), Sidechain(ancestor).getREV());
    }

    //mint REV amount of tokens to creator of this work
    sidechain.factoryMint(msg.sender, REV);

    emit SidechainCreated(address(sidechain));
  }

  /**
   * loads ancestor contracts into factory storage
   */
  function loadAncestors(address[] memory parents) internal{
    for (uint i = 0; i < parents.length; i++){
      address parent = parents[i];
      ancestors.push(parent);
      loadAncestors(Sidechain(parent).getParents());
    }
  }

}
