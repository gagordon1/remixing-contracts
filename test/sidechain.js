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
      out = out.concat(await getLineage(contractFromAddress[parent],
        contractFromAddress));
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
    assert.deepEqual(ancestorSet, expectedSet, `Lineage incorrect for work created by ${creators[1]}`)
  });

  /**
   * Constructs the contract asserting that:
   *    - Create a network of Sidechain contracts but bigger.
   * */
  it("constructs a remix tree correctly 2", async () =>{
    const contractMap = {}
    var n0 = await Sidechain.new(creators[0],[], 200);
    var n1 = await Sidechain.new(creators[1],[], 200);
    var n2 = await Sidechain.new(creators[2],[n0.address,n1.address], 300);
    var n3 = await Sidechain.new(creators[3],[n1.address], 200);
    var n4 = await Sidechain.new(creators[4],[n1.address], 200);
    var n5 = await Sidechain.new(creators[5],[n2.address], 200);
    var n6 = await Sidechain.new(creators[6],[n2.address,n3.address], 200);
    var n7 = await Sidechain.new(creators[7],[n3.address], 200);
    var n8 = await Sidechain.new(creators[8],[n4.address], 400);
    var n9 = await Sidechain.new(creators[9],[n8.address], 200);
    for (node of [n0,n1,n2,n3,n4,n5,n6,n7,n8,n9]){
      contractMap[node.address] = node;
    }

    let ancestorSet = (await getLineage(n0, contractMap));
    let expectedSet = ([creators[0]]);
    assert.deepEqual(ancestorSet, expectedSet, `Lineage incorrect for work created by creator 0`)


    ancestorSet = (await getLineage(n6, contractMap)).sort().join().map(addr => creators.indexOf(addr));
    expectedSet = ([creators[6], creators[0], creators[1], creators[2], creators[3]].sort().join());
    assert.deepEqual(ancestorSet, expectedSet, `Lineage incorrect for work created by creator 6`)
  });



});
