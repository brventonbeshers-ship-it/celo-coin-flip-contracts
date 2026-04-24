const { ethers } = require("hardhat");

async function main() {
  console.log("Deploying CoinFlipV2...");
  const Contract = await ethers.getContractFactory("CoinFlipV2");
  const contract = await Contract.deploy();
  await contract.waitForDeployment();
  console.log("CoinFlipV2 deployed to:", await contract.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
