const CoolCats = artifacts.require("CoolCatsSidechainCompliant.sol");



//Deploy chain of derivative works
module.exports = function (deployer) {
  deployer.deploy(CoolCats)
};
