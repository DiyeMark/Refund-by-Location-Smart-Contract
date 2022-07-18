const RefundByLocationContract = artifacts.require("RefundByLocation");

module.exports = function (deployer) {
  deployer.deploy(RefundByLocationContract, "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266", "38", "9", "50", "1");
};