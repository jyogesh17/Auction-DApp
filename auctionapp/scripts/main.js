const hre = require('hardhat')

async function main() {
  const auctionContract = await hre.ethers.getContractFactory('Auction')
  const auctioning = await auctionContract.deploy()

  await auctioning.deployed()

  console.log('Auction contract deployed to', auctioning.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error), process.exit(1)
  })
