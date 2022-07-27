const Sidechain = artifacts.require("Sidechain.sol");

const creator1 = '0x627306090abaB3A6e1400e9345bC60c78a8BEf57'
const parent1 = [];
const rev1 = 200;

const creator2 = '0x627306090abaB3A6e1400e9345bC60c78a8BEf57'
const parent2 = [];
const rev2 = 200;

//Deploy chain of derivative works
module.exports = async function (deployer) {
  await deployer.deploy(Sidechain, creator1, parent1, rev1);
  let instance = await Sidechain.deployed()
  console.log(instance.address)
};
