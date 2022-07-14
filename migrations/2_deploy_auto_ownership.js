const AutoOwnership = artifacts.require("AutoOwnership");

const baseURI = "http://www.side-chain.xyz";
const collectionName = "Sound Skiers";
const mintPrice = .5; //ether
const collectionSymbol = "SSKI";
const originalCreator = "0x627306090abaB3A6e1400e9345bC60c78a8BEf57"; //accounts[0]
const originalCreatorTokens = 3;
const maxSupply = 15; //implied 20% REP

module.exports = function (deployer) {
  deployer.deploy(AutoOwnership, baseURI, collectionName, mintPrice, collectionSymbol, 
    originalCreator, originalCreatorTokens, maxSupply);
};