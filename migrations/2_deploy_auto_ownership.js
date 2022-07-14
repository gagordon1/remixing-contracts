const AutoOwnership = artifacts.require("AutoOwnership");

module.exports = function (deployer) {
  deployer.deploy(AutoOwnership);
};