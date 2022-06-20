const main = async () => {
  const DeNFTContractFactory = await hre.ethers.getContractFactory("DeNFT");
  const DeNFTContract = await DeNFTContractFactory.deploy();
  await DeNFTContract.deployed();

  console.log("Deployed address:", DeNFTContract.address);

  // mint NFT.
  let txn = await DeNFTContract.mintAnNFT();
  // Wait for it to be mined.
  await txn.wait();

  // mint NFT.
  txn = await DeNFTContract.mintAnNFT();
  // Wait for it to be mined.
  await txn.wait();

  // mint NFT.
  txn = await DeNFTContract.mintAnNFT();
  // Wait for it to be mined.
  await txn.wait();

  // mint NFT.
  txn = await DeNFTContract.mintAnNFT();
  // Wait for it to be mined.
  await txn.wait();
};

(async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
})();
