const SidechainFactory = artifacts.require("SidechainFactory");
const Sidechain = artifacts.require("Sidechain");
const truffleAssert = require('truffle-assertions');

const testNetwork1 = [
  [0,[], 200],
  [1,[], 100],
  [2,[0,1], 300],
  [3,[1], 100],
  [4,[1], 200],
  [5,[2], 200],
  [6,[2,3], 200],
  [7,[3], 200],
  [8,[4], 400],
  [9,[8], 200],
]

/**
* Given a network similar to testNetwork1, returns an object
* mapping creator (index into creator array) to the address of their
* deployed sidechain,
*/
async function createNetwork(network, factory, creators){
  const addressMap = {}
  for (const sidechainData of network) {
    let parents = sidechainData[1].map(index => addressMap[index])
    let result = await factory.createSidechain(parents, sidechainData[2],
      {from : creators[sidechainData[0]]})
    let newAddress = result.logs[1].args.newAddress
    let ancestors = result.logs[0].args.ancestors
    addressMap[sidechainData[0]] = newAddress
  }
  return addressMap
}

contract("SidechainFactory", (accounts) => {
  const creators = accounts;
/**
   * Constructs the factory contract asserting and doesnt throw errors
   * */
  it("constructs a sidechain factory and can deploy a Sidechain contract", async () =>{
    const factory = await SidechainFactory.new();
    const result = await factory.createSidechain([], 200, {from : creators[0]})
    const newAddress = result.logs[1].args.newAddress
    let deployed = await Sidechain.at(newAddress)
    assert.equal(await deployed.getCreator(), creators[0])
  });

  /**
   * Constructs the factory and asserts that a network of sidechains can
   * be created
   * */
  it("can deploy a network of Sidechain Contracts", async () =>{
    const factory = await SidechainFactory.new();
    const addressMap = await createNetwork(testNetwork1, factory, creators);
  });
});
