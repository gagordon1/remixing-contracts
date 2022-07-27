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

// const Sidechain = artifacts.require("Sidechain.sol");
//
// creators = [
//   '0x468452829705ACE2579Fef3FAE59333Ac33b1CA8',
//   '0x557c65E243092E4142d30331732B89F9f69B1074',
//   '0x3825DF80A86114730C2F46FFD9DcBCf5D013a76a',
//   '0x6Fc72B42ee2e3DDcdf61b15C357a7DD92a5c53F3',
//   '0x7c7B263f15C3f87081B7a0588A87559cBc6bd0CB',
//   '0x54676b75b0435993Bd88d2B5051F64998C9968f1',
//   '0xA68D06a6e0562A09B525549381132Ab6099B9Af2',
//   '0x851D2896f15B67e3a5D548e413727531d0b34904',
//   '0x3540F684C324A644FB3788EAfFCd4219F375b039',
//   '0x4937A29020871bE426887ab49C96Af0e1b91F534'
// ]
//
// addresses = {}
//
// //Deploy chain of derivative works
// module.exports = async function (deployer) {
//   var n0 = [creators[0],[], 200]
//   var n1 = [creators[1],[], 200]
//   var n2 = [creators[2],[0,1], 300]
//   var n3 = [creators[3],[1], 200]
//   var n4 = [creators[4],[1], 200]
//   var n5 = [creators[5],[2], 200]
//   var n6 = [creators[6],[2,3], 200]
//   var n7 = [creators[7],[3], 200]
//   var n8 = [creators[8],[4], 400]
//   var n9 = [creators[9],[8], 200]
//
//   i = 0
//   for (node of [n0,n1,n2,n3,n4,n5,n6,n7,n8,n9]){
//     let result = await deployer.deploy(Sidechain, node[0],
//       node[1].map((j) => {return addresses[j]}), node[2])
//     console.log(result)
//     addresses[i] = result.address
//     i++
//   }
// };
