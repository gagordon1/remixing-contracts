require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    hardhat: {
        accounts: {
            count: 10
        },
        blockGasLimit: 100000000429720 
    }
    
  }
};
