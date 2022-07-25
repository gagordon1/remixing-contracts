const Sidechain = artifacts.require("Sidechain");
const truffleAssert = require('truffle-assertions');
const { toBN } = web3.utils;
/**
* Gets the lineage for a Sidechain leaf (walks up until roots)
*/
const getLineage = async (node, contractFromAddress) =>{
  let out = [await node.getCreator()]
  const parents = await node.getParents();
  if (parents.length == 0){
    return out
  }
  else{

    for (const parent of parents){
      out = out.concat(await getLineage(contractFromAddress[parent]));
    }
    return out;
  }
}

contract("Sidechain", (accounts) => {
  const creators = accounts;
  it("constructs the contract correctly", async () =>{
    var instance = await Sidechain.new(creators[0],[], 1000);
    var parents = await instance.getParents();
    var rev = await instance.getREV();
    var creator = await instance.getCreator();
    assert.equal(parents.length, 0,     "Constructor incorrectly sets parent addresses.");
    assert.equal(rev, 1000,             "Constructor incorrectly sets remix equity value.");
    assert.equal(creator, creators[0],  "Constructor incorrectly sets creator.");

    await truffleAssert.reverts(Sidechain.new(creators[0],[], 1001),
      "Maximum REV = 1000.");
  });

  /**
   * Constructs the contract asserting that:
   *    - Create a network of Sidechain contracts.
   * */
  it("constructs a remix tree correctly 1", async () =>{
    var parent = await Sidechain.new(creators[0],[], 200);
    var child = await Sidechain.new(creators[1],[parent.address], 300);
    const contractMap = {}
    for (node of [parent, child]){
      contractMap[node.address] = node;
    }
    const ancestorSet = (await getLineage(child, contractMap)).sort().join();
    const expectedSet = ([creators[0], creators[1]]).sort().join();
    assert.equal(ancestorSet, expectedSet, `Lineage incorrect for work created by ${creators[1]}`)
  });

  /**
   * Constructs the contract asserting that:
   *    - Create a network of Sidechain contracts but bigger.
   * */
  it("constructs a remix tree correctly 2", async () =>{
  });



});
