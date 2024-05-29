require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.26",
  networks: {
    hardhat: {
      gas: 30000000,
      gasLimit: 30000000,
      maxFeePerGas: 55000000000,
      maxPriorityFeePerGas: 55000000000,
      forking: {
        url: `https://optimism-mainnet.infura.io/v3/${process.env.INFURA_KEY}`,
        blockNumber: Number(process.env.BLOCK_NUMBER),
        enabled: true,
        // enabled: false,
      },
      chains: {
        42161: {
          hardforkHistory: {
            london: 23850000
          }
        }
      }
    },
    op_sepolia: {
      url: `https://optimism-sepolia.infura.io/v3/${process.env.INFURA_KEY}`,
      accounts: {
        mnemonic: process.env.MNEMONIC,
      }
    },
  }
};
