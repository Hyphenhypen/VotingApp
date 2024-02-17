/**
* @type import('hardhat/config').HardhatUserConfig
*/

require('dotenv').config();
require("@nomicfoundation/hardhat-toolbox");

module.exports = {
   solidity: "0.8.11",
   networks: {
      mumbai: {
         url: process.env.RPC_URL,
         accounts: [process.env.PRIVATE_KEY],
      },
   },
   etherscan: {
      apiKey: process.env.API_KEY
   }
}
