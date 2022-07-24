const Sidechain = artifacts.require("Sidechain.sol");



//Deploy chain of derivative works
module.exports = function (deployer) {
  deployer.deploy(Sidechain)
};
