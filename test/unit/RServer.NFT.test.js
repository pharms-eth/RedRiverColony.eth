const { assert, expect } = require("chai")
const { network, deployments, ethers } = require("hardhat")
const { developmentChains } = require("../../helper-hardhat-config")

const tokens = (n) => {
    return ethers.utils.parseUnits(n.toString(), "ether")
}

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("RRCServer - NFT", function () {
          let server
          let deployer
          let user2
          let user3

          const NAME = "AI Generated NFT"
          const SYMBOL = "AINFT"
          const COST = tokens(1) // 1 ETH
          const URL =
              "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json"
          //   const sendValue = ethers.utils.parseEther("1")
          beforeEach(async () => {
              ;[deployer, user2, user3] = await ethers.getSigners()
              //   const [owner, addr1, addr2] = await ethers.getSigners();

              //   const FriendoX = await ethers.getContractFactory("FriendoX")
              //   server = await FriendoX.deploy()

              await deployments.fixture(["all"])
              server = await ethers.getContract("RServer", deployer)

              // // Deploy Real Estate
              //   const NFT = await ethers.getContractFactory("RServer")
              //   server = await NFT.deploy(NAME, SYMBOL, COST)

              // // Mint
              const transaction = await server
                  .connect(deployer)
                  .register("TESTServer")
              //   await transaction.wait()
          })

          describe("Deployment", () => {
              it("Returns owner", async () => {
                  const result = await server.owner()
                  expect(result).to.be.equal(deployer.address)
              })

              //   it("Returns cost", async () => {
              //       const result = await server.cost()
              //       expect(result).to.be.equal(COST)
              //   })
          })

          describe("Minting", () => {
              it("Returns owner", async () => {
                  const result = await server.ownerOf("1")
                  expect(result).to.be.equal(deployer.address)
              })

              it("Returns URI", async () => {
                  const result = await server.tokenURI("1")
                  expect(result).to.be.equal(URL)
              })

              it("Updates total supply", async () => {
                  const result = await server.getServerCount()
                  expect(result).to.be.equal("1")
              })
          })

          describe("Withdrawing", () => {
              let balanceBefore

              beforeEach(async () => {
                  balanceBefore = await ethers.provider.getBalance(
                      deployer.address
                  )

                  const transaction = await server.connect(deployer).withdraw()
                  await transaction.wait()
              })

              //   it("Updates the owner balance", async () => {
              //       const result = await ethers.provider.getBalance(
              //           deployer.address
              //       )
              //       expect(result).to.be.greaterThan(balanceBefore)
              //   })

              it("Updates the contract balance", async () => {
                  const result = await ethers.provider.getBalance(
                      server.address
                  )
                  expect(result).to.equal(0)
              })
          })
      })
