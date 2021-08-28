const AgromartContract = artifacts.require("../contract/AgromartContract.sol");
// Then deploy
module.exports = (deployer, network, accounts) => {
  deployer.deploy(
    AgromartContract, // initialize the constructor
    "Agromart Order Details from Blockchain",
    accounts[0]
  );
};
