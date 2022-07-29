const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-network-helpers");

const { expect } = require("chai");
const w3 = require("web3")
const { toBN } = w3.utils;
var assert = require('assert');

/**
* Gets the lineage for a Sidechain leaf (walks up until roots)
*
* returns Set(string)
*/
const getLineage = async (node, contractFromAddress) =>{
  let out = new Set([await node.getCreator()])
  const parents = await node.getParents();
  if (parents.length == 0){
    return out
  }
  else{

    for (const parent of parents){
      (await getLineage(contractFromAddress[parent], contractFromAddress))
        .forEach((ancestor) => out.add(ancestor)) //ensure parents arent double counted
    }
    return out;
  }
}

describe.only("Sidechain", async (accounts) => {

    async function deployTokenFixture() {
        // Get the ContractFactory and Signers here.
        const Sidechain = await ethers.getContractFactory("Sidechain");
        const creators = (await ethers.getSigners()).map(signer => signer.address);;
    
        // Fixtures can return anything you consider useful for your tests
        return { Sidechain, creators };
      }
 

  console.log("here")
  it("constructs the contract correctly", async () =>{
    const { Sidechain, creators } = await loadFixture(deployTokenFixture)
    var instance = await Sidechain.deploy(creators[0],[], 1000);
    await instance.deployed()
    var parents = await instance.getParents();
    var rev = await instance.getREV();
    var creator = await instance.getCreator();
    assert.equal(parents.length, 0,     "Constructor incorrectly sets parent addresses.");
    assert.equal(rev, 1000,             "Constructor incorrectly sets remix equity value.");
    assert.equal(creator, creators[0],  "Constructor incorrectly sets creator.");

    await expect (
        Sidechain.deploy(creators[0],[], 1001)
      ).to.be.revertedWith("Maximum REV = 1000.");
  });

  /**
   * Constructs the contract asserting that:
   *    - Create a network of Sidechain contracts.
   * */
  it("constructs a remix tree correctly 1", async () =>{
    const { Sidechain, creators } = await loadFixture(deployTokenFixture)
    var parent = await Sidechain.deploy(creators[0],[], 200);
    var child = await Sidechain.deploy(creators[1],[parent.address], 300);
    const contractMap = {}
    for (node of [parent, child]){
      contractMap[node.address] = node;
    }
    const ancestorSet = new Set(await getLineage(child, contractMap))
    const expectedSet = new Set([creators[0], creators[1]])
    assert.deepEqual(ancestorSet, expectedSet, `Lineage incorrect for work created by ${creators[1]}`)
  });

  /**
   * Constructs the contract asserting that:
   *    - Create a network of Sidechain contracts but bigger.
   * */
  it("constructs a remix tree correctly 2", async () =>{
    const { Sidechain, creators } = await loadFixture(deployTokenFixture)
    const contractMap = {}
    var n0 = await Sidechain.deploy(creators[0],[], 200);
    var n1 = await Sidechain.deploy(creators[1],[], 100);
    var n2 = await Sidechain.deploy(creators[2],[n0.address,n1.address], 300);
    var n3 = await Sidechain.deploy(creators[3],[n1.address], 100);
    var n4 = await Sidechain.deploy(creators[4],[n1.address], 200);
    var n5 = await Sidechain.deploy(creators[5],[n2.address], 200);
    var n6 = await Sidechain.deploy(creators[6],[n2.address,n3.address], 200);
    var n7 = await Sidechain.deploy(creators[7],[n3.address], 200);
    var n8 = await Sidechain.deploy(creators[8],[n4.address], 400);
    var n9 = await Sidechain.deploy(creators[9],[n8.address], 200);

    for (node of [n0,n1,n2,n3,n4,n5,n6,n7,n8,n9]){
      contractMap[node.address] = node;
    }

    let ancestorSet = (await getLineage(n0, contractMap));
    let expectedSet = new Set([creators[0]]);
    assert.deepEqual(ancestorSet, expectedSet, `Lineage incorrect for work created by creator 0`)


    ancestorSet = (await getLineage(n6, contractMap))
    expectedSet = new Set([creators[0], creators[1], creators[2], creators[3], creators[6]]);
    assert.deepEqual(ancestorSet, expectedSet, `Lineage incorrect for work created by creator 6`)

    ancestorSet = (await getLineage(n9, contractMap))
    expectedSet = new Set([creators[1], creators[4], creators[9], creators[8]]);
    assert.deepEqual(ancestorSet, expectedSet, `Lineage incorrect for work created by creator 9`)

    ancestorSet = (await getLineage(n5, contractMap))
    expectedSet = new Set([creators[5], creators[2], creators[0], creators[1]]);
    assert.deepEqual(ancestorSet, expectedSet, `Lineage incorrect for work created by creator 5`)
  }).timeout(100000);

  /**
   * Constructs the contract asserting that:
   *    - Allocation of ownership is done correctly upon construction.
   * */
   it("allocates ownership properly", async () =>{
    const { Sidechain, creators } = await loadFixture(deployTokenFixture)
    const contractMap = {}
    var n0 = await Sidechain.deploy(creators[0],[], 200);
    var n1 = await Sidechain.deploy(creators[1],[], 100);
    var n2 = await Sidechain.deploy(creators[2],[n0.address,n1.address], 300);
    var n3 = await Sidechain.deploy(creators[3],[n1.address], 100);
    var n4 = await Sidechain.deploy(creators[4],[n1.address], 200);
    var n5 = await Sidechain.deploy(creators[5],[n2.address], 200);
    var n6 = await Sidechain.deploy(creators[6],[n2.address,n3.address], 200);
    var n7 = await Sidechain.deploy(creators[7],[n3.address], 200);
    var n8 = await Sidechain.deploy(creators[8],[n4.address], 400);
    var n9 = await Sidechain.deploy(creators[9],[n8.address], 200);

    for (node of [n0,n1,n2,n3,n4,n5,n6,n7,n8,n9]){
      contractMap[node.address] = node;
    }

    assert.equal(await n2.balanceOf(creators[0]), 200, "Incorrect ownership.")
    assert.equal(await n2.balanceOf(creators[1]), 100, "Incorrect ownership.")

    assert.equal(await n7.balanceOf(creators[1]), 100, "Incorrect ownership.")
    assert.equal(await n7.balanceOf(creators[3]), 100, "Incorrect ownership.")

    assert.equal(await n9.balanceOf(creators[1]), 100, "Incorrect ownership.")
    assert.equal(await n9.balanceOf(creators[4]), 200, "Incorrect ownership.")
    assert.equal(await n9.balanceOf(creators[8]), 400, "Incorrect ownership.")

    assert.equal(await n6.balanceOf(creators[1]), 200, "Incorrect ownership.")
    assert.equal(await n6.balanceOf(creators[3]), 100, "Incorrect ownership.")
    assert.equal(await n6.balanceOf(creators[2]), 300, "Incorrect ownership.")
    assert.equal(await n6.balanceOf(creators[0]), 200, "Incorrect ownership.")

  }).timeout(100000);

});
