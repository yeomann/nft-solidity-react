async function main() {
  const [owner] = await hre.ethers.getSigners()
  const GreeterContract = await hre.ethers.getContractFactory("Greeter");
  
  const greeter = await GreeterContract.deploy("Hello deployed contract");
  await greeter.deployed();

  console.log("Greeter deployed to:", greeter.address);
  console.log("Deployed owner:", owner);
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  })