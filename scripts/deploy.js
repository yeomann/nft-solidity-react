async function main() {
  const [owner] = await hre.ethers.getSigners()
  const DeNFTContractFactory = await hre.ethers.getContractFactory("DeNFT");
  
  const nftContract = await DeNFTContractFactory.deploy();
  await nftContract.deployed();

  console.log("nftContract deployed to:", nftContract.address);
  console.log("Deployed owner:", owner.address);

  // mint NFT.
  let txn = await nftContract.makeAnEpicNFT();
  // Wait for it to be mined.
  await txn.wait();
  console.log("Minted NFT #1")


  // mint NFT.
  txn = await nftContract.makeAnEpicNFT();
  // Wait for it to be mined.
  await txn.wait();
  console.log("Minted NFT #2");
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  })