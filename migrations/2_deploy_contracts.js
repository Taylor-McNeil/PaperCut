var project = artifacts.require("Factory");
//var Factory = artifacts.require("./Papercut.sol");

module.exports = function(deployer) {
 // deployer.deploy(Papercut);
  deployer.deploy(project);
};
