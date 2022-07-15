const DerivativeWork = artifacts.require("DerivativeWork");
const truffleAssert = require('truffle-assertions');
const { toBN } = web3.utils;

contract("DerivativeWork", (accounts) => {
  const originalCreatorAccount = "0x627306090abaB3A6e1400e9345bC60c78a8BEf57".toLowerCase() //accounts[0]
  const derivativeCreatorAccount = '0xf17f52151EbEF6C7334FAD080c5704D77216b732'.toLowerCase() //accounts[1]
  const tokenPrice = "500000000000000000"

  /**
   * Constructs the contract asserting that:
   *    - initial mints allocate tokens to derivative and original creators accurately
   *    - ownership is transferred to the derivative creator
   *    - tokenPrice is set correctly
   *    - baseURI is set correctly
   * */
  it("constructs the contract correctly", async () =>{
    const instance = await DerivativeWork.deployed();
    const originalCreatorBalance = await instance.balanceOf(originalCreatorAccount);
    const derivativeCreatorBalance = await instance.balanceOf(derivativeCreatorAccount);
    assert.equal(originalCreatorBalance.words[0], 3, "3 tokens were not in the first account after construction.");
    assert.equal(derivativeCreatorBalance.words[0], 5, "5  tokens were not in the first account after construction.");
    assert.equal((await instance.owner()).toLowerCase(), derivativeCreatorAccount, "constructor incorrectly transfers ownership.");
    assert.equal((await instance.getPrice()).toString(),  tokenPrice, "constructor incorrectly sets price.");
    assert.equal(await instance.tokenURI(0), "http://www.side-chain.xyz/0" , "constructor incorrectly sets base uri.");
  });


  /**
   * Tries to buy too many and with not enough value and asserts both fail.
   * Tries to buy with the correct amount and asserts that totall supply and buyer balance update correctly.
   * */
  it("should handle buying correctly", async () =>{
    const instance = await DerivativeWork.deployed();
    await truffleAssert.reverts(instance.buy(30, 
      {from : originalCreatorAccount, value : tokenPrice}), "Requested more than the amount of tokens remaining");      
    let weiToSend =  tokenPrice // not enough
    await truffleAssert.reverts(instance.buy(3, 
      {from : originalCreatorAccount, value : weiToSend}), "Not enough ether sent");      
    assert.equal(await instance.totalSupply(), 8, "Contract does not prevent minting too many tokens.");
    await instance.buy(3, {from : originalCreatorAccount, value : "1" + weiToSend}); 
    assert.equal(await instance.balanceOf(originalCreatorAccount), 6, "Contract does not allocate the correct amount of tokens on mint")
    assert.equal(await instance.totalSupply(), 11, "Total supply is incorrect after mint")
  });


  /**
   * 
   * Let two people mint 2 tokens each then:
   *    asserts that the operation reverts when someone other than the owner tries to withdraw.
   *    asserts that when the correct owner withdraws they receive 4*token price wei.
   * */
  it("should handle withdrawals correctly", async () =>{
    const instance = await DerivativeWork.deployed();
    const price = "1000000000000000000"
    await instance.buy(2, {from : originalCreatorAccount, value : price}); 
    await instance.buy(2, {from : derivativeCreatorAccount, value : price}); 
    await truffleAssert.reverts(instance.withdrawAll({from : originalCreatorAccount}), "Ownable: caller is not the owner")
    
    const ownerBalanceBefore = toBN(await web3.eth.getBalance(derivativeCreatorAccount))
    const contractBalanceBefore = await web3.eth.getBalance(instance.address)
    const receipt = await instance.withdrawAll({from : derivativeCreatorAccount})
    const ownerBalanceAfter = toBN(await web3.eth.getBalance(derivativeCreatorAccount))
    const contractBalanceAfter = await web3.eth.getBalance(instance.address)

    const gasUsed = toBN(receipt.receipt.gasUsed);
    const gasPrice = toBN((await web3.eth.getTransaction(receipt.tx)).gasPrice);
    const actualWithdrawalAmount = ownerBalanceAfter.sub(ownerBalanceBefore).add(gasPrice.mul(gasUsed))

    //^^BIG NUMHERS ARE IMPORTANT
    assert.equal(contractBalanceAfter, "0", "Contract balance was not 0 after withdrawAll")
    assert.equal(actualWithdrawalAmount, "3500000000000000000", "Withdrawal amount did not equal the pre-op contract balance after withdrawAll")
    

  });


});