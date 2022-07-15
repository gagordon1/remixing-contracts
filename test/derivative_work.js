const DerivativeWork = artifacts.require("DerivativeWork");



contract("DerivativeWork", (accounts) => {
  const originalCreatorAccount = "0x627306090abaB3A6e1400e9345bC60c78a8BEf57"
  const derivativeCreatorAccount = "0x468452829705ace2579fef3fae59333ac33b1ca8"
  it("should give original creator account the first 3 tokens and derivative creator account 5 tokens"
      , async () =>{
    const instance = await DerivativeWork.deployed();
    const originalCreatorBalance = await instance.balanceOf(originalCreatorAccount);
    const derivativeCreatorBalance = await instance.balanceOf(derivativeCreatorAccount);
    assert.equal(originalCreatorBalance.words[0], 3, "3 tokens were not in the first account after construction.");
    assert.equal(derivativeCreatorBalance.words[0], 5, "5  tokens were not in the first account after construction.");
  });
});