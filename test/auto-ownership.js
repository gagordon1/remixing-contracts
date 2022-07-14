const AutoOwnership = artifacts.require("AutoOwnership");



contract("AutoOwnership", (accounts) => {
  const creatorAccount = accounts[0]
  const testAccount = accounts[1]
  it("should give creator account the first 20 tokens", async () =>{
    const instance = await AutoOwnership.deployed();
    const creatorBalance = await instance.balanceOf(creatorAccount);
    const testBalance = await instance.balanceOf(testAccount);
    assert.equal(creatorBalance.words[0], 1, "1 skier was not in the first account after construction.");
  });
});