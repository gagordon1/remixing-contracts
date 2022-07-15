const DerivativeWork = artifacts.require("DerivativeWork");

const baseURI = "http://www.side-chain.xyz";
const collectionName = "Sound Skiers";
const mintPrice = "500000000000000000" //wei
const collectionSymbol = "SSKI";
const originalCreator = "0x627306090abaB3A6e1400e9345bC60c78a8BEf57"; //accounts[0]
const originalCreatorTokens = 3;
const derivativeCreator = "0x468452829705ace2579fef3fae59333ac33b1ca8"; //test account
const derivativeCreatorTokens = 5;
const maxSupply = 15; //implied 20% REP


module.exports = function (deployer) {
  deployer.deploy(DerivativeWork, baseURI, collectionName, collectionSymbol,  
     maxSupply, mintPrice, originalCreator, originalCreatorTokens, derivativeCreator,
     derivativeCreatorTokens)
};