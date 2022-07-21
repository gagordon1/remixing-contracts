const Sidechain = artifacts.require("Sidechain");


module.exports = function (deployer) {
  deployer.deploy(Sidechain)
};