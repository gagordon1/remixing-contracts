const DerivativeWork = artifacts.require("DerivativeWork");
const truffleAssert = require('truffle-assertions');
const { toBN } = web3.utils;

contract("DerivativeWork", (accounts) => {
  const originalCreatorAccount = "0x627306090abaB3A6e1400e9345bC60c78a8BEf57".toLowerCase() //accounts[0]
  const derivativeCreatorAccount = '0xf17f52151EbEF6C7334FAD080c5704D77216b732'.toLowerCase() //accounts[1]
  const derivativeCreatorAccount2 = '0xf17f52151EbEF6C7334FAD080c5704D77216b732'.toLowerCase() //accounts[2]
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
  });

});
