const { assert, expect } = require("chai")
const { network, deployments, ethers } = require("hardhat")
const { developmentChains } = require("../../helper-hardhat-config")

const tokens = (n) => {
    return ethers.utils.parseUnits(n.toString(), "ether")
}

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("RRCServer - Server", function () {
          let server
          let deployer
          let user2
          let user3

          //   const NAME = "AI Generated NFT"
          //   const SYMBOL = "AINFT"
          //   const COST = tokens(1) // 1 ETH

          beforeEach(async () => {
              ;[deployer, user2, user3] = await ethers.getSigners()

              await deployments.fixture(["all"])
              server = await ethers.getContract("RServer", deployer)

              const transaction = await server
                  .connect(deployer)
                  .register("TESTServer")
          })

          describe("Deployment", () => {
              it("Returns owner", async () => {
                  const result = await server.owner()
                  expect(result).to.be.equal(deployer.address)
              })
              it("registered/minted with an id", async () => {
                  let instance = await server.getServer(1)
                  expect(instance.id).to.be.equal("1")
              })
          })

          describe("Updating", () => {
              describe("Name", () => {
                  it("Updates name", async () => {
                      let instance = await server.getServer(1)
                      expect(instance.name).to.be.equal("TESTServer")
                      server.updateServerName(1, "ETH Chat")
                      let instance2 = await server.getServer(1)
                      expect(instance2.name).to.be.equal("ETH Chat")
                  })

                  it("requires the owner", async () => {
                      let instance = await server.connect(user2).getServer(1)
                      expect(instance.name).to.be.equal("TESTServer")

                      await expect(
                          server.connect(user2).updateServerName(1, "BTC Chat")
                      )
                          .to.be.revertedWithCustomError(
                              server,
                              "RRCServer_ServerNoPermission"
                          )
                          .withArgs(
                              1,
                              "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
                              "Update Name"
                          )

                      let instance2 = await server.connect(user2).getServer(1)
                      expect(instance2.name).to.be.equal("TESTServer")
                  })

                  it("requires index to be greater than 0", async () => {
                      let instance = await server.connect(deployer).getServer(1)
                      expect(instance.name).to.be.equal("TESTServer")

                      await expect(
                          server
                              .connect(deployer)
                              .updateServerName(0, "BTC Chat")
                      )
                          .to.be.revertedWithCustomError(
                              server,
                              "RRCServer_Index"
                          )
                          .withArgs(0)

                      let instance2 = await server
                          .connect(deployer)
                          .getServer(1)
                      expect(instance2.name).to.be.equal("TESTServer")
                  })

                  it("requires index to be less than servercount", async () => {
                      let instance = await server.connect(deployer).getServer(1)
                      expect(instance.name).to.be.equal("TESTServer")

                      let serverCount = await server.getServerCount()

                      await expect(
                          server
                              .connect(deployer)
                              .updateServerName(serverCount + 1, "BTC Chat")
                      )
                          .to.be.revertedWithCustomError(
                              server,
                              "RRCServer_Index"
                          )
                          .withArgs(serverCount + 1)

                      let instance2 = await server
                          .connect(deployer)
                          .getServer(1)
                      expect(instance2.name).to.be.equal("TESTServer")
                  })

                  it("requires name to not be empty", async () => {
                      let instance = await server.connect(deployer).getServer(1)
                      expect(instance.name).to.be.equal("TESTServer")

                      let serverCount = await server.getServerCount()

                      await expect(
                          server
                              .connect(deployer)
                              .updateServerName(serverCount, "")
                      )
                          .to.be.revertedWithCustomError(
                              server,
                              "RRCServer_InvalidStringParameter"
                          )
                          .withArgs("name", "")

                      let instance2 = await server
                          .connect(deployer)
                          .getServer(1)
                      expect(instance2.name).to.be.equal("TESTServer")
                  })

                  it("requires name to less than 256 characters", async () => {
                      let instance = await server.connect(deployer).getServer(1)
                      expect(instance.name).to.be.equal("TESTServer")

                      let serverCount = await server.getServerCount()
                      let massiveString =
                          "Why did the Ethereum developer cross the road? To get to the DApp side! Speaking of DApps, did you hear about the one that let you trade virtual tulips for Ether? It was called CryptoTulips, and it bloomed briefly before withering away. But don't worry, there are plenty of other DApps out there to explore. Some of them are even useful! Like the one that lets you rent out your spare computing power to earn Ether. Now that's what I call putting your hardware to work. And if all else fails, you can always just HODL your Ether and hope for the best. After all, you never know when the moon might be within reach!"
                      await expect(
                          server
                              .connect(deployer)
                              .updateServerName(serverCount, massiveString)
                      )
                          .to.be.revertedWithCustomError(
                              server,
                              "RRCServer_InvalidStringParameter"
                          )
                          .withArgs("name", massiveString)

                      let instance2 = await server
                          .connect(deployer)
                          .getServer(1)
                      expect(instance2.name).to.be.equal("TESTServer")
                  })

                  it("requires emits an event", async () => {
                      let instance = await server.connect(deployer).getServer(1)
                      expect(instance.name).to.be.equal("TESTServer")

                      await expect(
                          server
                              .connect(deployer)
                              .updateServerName(1, "420 Chat")
                      )
                          .to.emit(server, "ServerNameChanged")
                          .withArgs(1, "420 Chat")

                      let instance2 = await server
                          .connect(deployer)
                          .getServer(1)
                      expect(instance2.name).to.be.equal("420 Chat")
                  })
              })
          })
      })
