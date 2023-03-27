const { assert, expect } = require("chai")
const { network, deployments, ethers } = require("hardhat")
const { developmentChains } = require("../../helper-hardhat-config")
const chaiBN = require("chai-bignumber")
const BigNumber = require("ethers").BigNumber

// chai.use(chaiBN(BigNumber))

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

              describe("Icon", () => {
                  it("Updates icon", async () => {
                      let instance = await server.getServer(1)
                      expect(instance.icon).to.be.equal("")
                      server.updateServerIcon(1, "ETH Chat")
                      let instance2 = await server.getServer(1)
                      expect(instance2.icon).to.be.equal("ETH Chat")
                  })

                  it("requires the owner", async () => {
                      let instance = await server.connect(user2).getServer(1)
                      expect(instance.icon).to.be.equal("")

                      await expect(
                          server.connect(user2).updateServerIcon(1, "BTC Chat")
                      )
                          .to.be.revertedWithCustomError(
                              server,
                              "RRCServer_ServerNoPermission"
                          )
                          .withArgs(
                              1,
                              "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
                              "Update Icon"
                          )

                      let instance2 = await server.connect(user2).getServer(1)
                      expect(instance2.icon).to.be.equal("")
                  })

                  it("requires index to be greater than 0", async () => {
                      let instance = await server.connect(deployer).getServer(1)
                      expect(instance.icon).to.be.equal("")

                      await expect(
                          server
                              .connect(deployer)
                              .updateServerIcon(0, "BTC Chat")
                      )
                          .to.be.revertedWithCustomError(
                              server,
                              "RRCServer_Index"
                          )
                          .withArgs(0)

                      let instance2 = await server
                          .connect(deployer)
                          .getServer(1)
                      expect(instance2.icon).to.be.equal("")
                  })

                  it("requires index to be less than servercount", async () => {
                      let instance = await server.connect(deployer).getServer(1)
                      expect(instance.icon).to.be.equal("")

                      let serverCount = await server.getServerCount()

                      await expect(
                          server
                              .connect(deployer)
                              .updateServerIcon(serverCount + 1, "BTC Chat")
                      )
                          .to.be.revertedWithCustomError(
                              server,
                              "RRCServer_Index"
                          )
                          .withArgs(serverCount + 1)

                      let instance2 = await server
                          .connect(deployer)
                          .getServer(1)
                      expect(instance2.icon).to.be.equal("")
                  })

                  it("requires icon to not be empty", async () => {
                      let instance = await server.connect(deployer).getServer(1)
                      expect(instance.icon).to.be.equal("")

                      let serverCount = await server.getServerCount()

                      await expect(
                          server
                              .connect(deployer)
                              .updateServerIcon(serverCount, "")
                      )
                          .to.be.revertedWithCustomError(
                              server,
                              "RRCServer_InvalidStringParameter"
                          )
                          .withArgs("icon", "")

                      let instance2 = await server
                          .connect(deployer)
                          .getServer(1)
                      expect(instance2.icon).to.be.equal("")
                  })

                  it("requires emits an event", async () => {
                      let instance = await server.connect(deployer).getServer(1)
                      expect(instance.icon).to.be.equal("")

                      await expect(
                          server
                              .connect(deployer)
                              .updateServerIcon(1, "420 Chat")
                      )
                          .to.emit(server, "ServerIconChanged")
                          .withArgs(1, "420 Chat")

                      let instance2 = await server
                          .connect(deployer)
                          .getServer(1)
                      expect(instance2.icon).to.be.equal("420 Chat")
                  })
              })

              describe("Welcome Message", () => {
                  it("Updates Welcome Message", async () => {
                      let instance = await server.getServer(1)
                      expect(instance.message).to.be.equal("")
                      server.updateServerWelcomeMessage(1, "ETH Chat")
                      let instance2 = await server.getServer(1)
                      expect(instance2.message).to.be.equal("ETH Chat")
                  })

                  it("requires the owner", async () => {
                      let instance = await server.connect(user2).getServer(1)
                      expect(instance.message).to.be.equal("")

                      await expect(
                          server
                              .connect(user2)
                              .updateServerWelcomeMessage(1, "BTC Chat")
                      )
                          .to.be.revertedWithCustomError(
                              server,
                              "RRCServer_ServerNoPermission"
                          )
                          .withArgs(
                              1,
                              "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
                              "Update Welcome Message"
                          )

                      let instance2 = await server.connect(user2).getServer(1)
                      expect(instance2.message).to.be.equal("")
                  })

                  it("requires index to be greater than 0", async () => {
                      let instance = await server.connect(deployer).getServer(1)
                      expect(instance.message).to.be.equal("")

                      await expect(
                          server
                              .connect(deployer)
                              .updateServerWelcomeMessage(0, "BTC Chat")
                      )
                          .to.be.revertedWithCustomError(
                              server,
                              "RRCServer_Index"
                          )
                          .withArgs(0)

                      let instance2 = await server
                          .connect(deployer)
                          .getServer(1)
                      expect(instance2.message).to.be.equal("")
                  })

                  it("requires index to be less than servercount", async () => {
                      let instance = await server.connect(deployer).getServer(1)
                      expect(instance.message).to.be.equal("")

                      let serverCount = await server.getServerCount()

                      await expect(
                          server
                              .connect(deployer)
                              .updateServerWelcomeMessage(
                                  serverCount + 1,
                                  "BTC Chat"
                              )
                      )
                          .to.be.revertedWithCustomError(
                              server,
                              "RRCServer_Index"
                          )
                          .withArgs(serverCount + 1)

                      let instance2 = await server
                          .connect(deployer)
                          .getServer(1)
                      expect(instance2.message).to.be.equal("")
                  })

                  it("requires welcome message to not be empty", async () => {
                      let instance = await server.connect(deployer).getServer(1)
                      expect(instance.message).to.be.equal("")

                      let serverCount = await server.getServerCount()

                      await expect(
                          server
                              .connect(deployer)
                              .updateServerWelcomeMessage(serverCount, "")
                      )
                          .to.be.revertedWithCustomError(
                              server,
                              "RRCServer_InvalidStringParameter"
                          )
                          .withArgs("welcome message", "")

                      let instance2 = await server
                          .connect(deployer)
                          .getServer(1)
                      expect(instance2.message).to.be.equal("")
                  })

                  it("requires emits an event", async () => {
                      let instance = await server.connect(deployer).getServer(1)
                      expect(instance.message).to.be.equal("")

                      await expect(
                          server
                              .connect(deployer)
                              .updateServerWelcomeMessage(1, "420 Chat")
                      )
                          .to.emit(server, "ServermessageChanged")
                          .withArgs(1, "420 Chat")

                      let instance2 = await server
                          .connect(deployer)
                          .getServer(1)
                      expect(instance2.message).to.be.equal("420 Chat")
                  })
              })

              describe("User Array", () => {
                  describe("add to Array", () => {
                      it("Updates user Array", async () => {
                          let instance = await server.getServer(1)
                          expect(instance.users).to.be.an("array").that.is.empty
                          server.addUserToServer(1, user2.address)
                          let instance2 = await server.getServer(1)
                          expect(instance2.users).to.be.contains(user2.address)
                      })
                      it("requires the owner", async () => {
                          let instance = await server
                              .connect(user2)
                              .getServer(1)
                          expect(instance.users).to.be.an("array").that.is.empty

                          await expect(
                              server
                                  .connect(user2)
                                  .addUserToServer(1, user2.address)
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_ServerNoPermission"
                              )
                              .withArgs(
                                  1,
                                  "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
                                  "Add User"
                              )

                          let instance2 = await server
                              .connect(user2)
                              .getServer(1)
                          expect(instance2.users).to.be.an("array").that.is
                              .empty
                      })

                      it("requires index to be greater than 0", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.users).to.be.an("array").that.is.empty

                          await expect(
                              server
                                  .connect(deployer)
                                  .addUserToServer(0, user2.address)
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_Index"
                              )
                              .withArgs(0)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance2.users).to.be.an("array").that.is
                              .empty
                      })

                      it("requires index to be less than servercount", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.users).to.be.an("array").that.is.empty

                          let serverCount = await server.getServerCount()

                          await expect(
                              server
                                  .connect(deployer)
                                  .addUserToServer(
                                      serverCount + 1,
                                      user2.address
                                  )
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_Index"
                              )
                              .withArgs(serverCount + 1)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance2.users).to.be.an("array").that.is
                              .empty
                      })
                      it("requires address to not be empty", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.users).to.be.an("array").that.is.empty

                          let serverCount = await server.getServerCount()

                          await expect(
                              server
                                  .connect(deployer)
                                  .addUserToServer(
                                      serverCount,
                                      "0x0000000000000000000000000000000000000000"
                                  )
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_InvalidAddressParameter"
                              )
                              .withArgs("userAddress")

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(serverCount)
                          expect(instance2.users).to.be.an("array").that.is
                              .empty
                      })

                      it("requires user to not already be listed", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.users).to.be.an("array").that.is.empty

                          let serverCount = await server.getServerCount()
                          server.addUserToServer(serverCount, user2.address)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(serverCount)
                          expect(instance2.users).to.contains(user2.address)

                          await expect(
                              server.addUserToServer(serverCount, user2.address)
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_UserAlreadyExists"
                              )
                              .withArgs(serverCount, user2.address)

                          let instance3 = await server
                              .connect(deployer)
                              .getServer(serverCount)
                          expect(instance3.users).to.contains(user2.address)
                      })

                      it("requires emits an event", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.users).to.be.an("array").that.is.empty

                          await expect(
                              server
                                  .connect(deployer)
                                  .addUserToServer(1, user2.address)
                          )
                              .to.emit(server, "UserAddedToServer")
                              .withArgs(1, user2.address)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance2.users).to.contains(user2.address)
                      })
                  })
                  describe("delete from Array", () => {
                      beforeEach(async () => {
                          let instance = await server.getServer(1)
                          expect(instance.users).to.be.an("array").that.is.empty
                          server.addUserToServer(1, user2.address)
                          let instance2 = await server.getServer(1)
                          expect(instance2.users).to.be.contains(user2.address)
                      })
                      it("Removes from user Array", async () => {
                          let instance = await server.getServer(1)
                          expect(instance.users).to.contains(user2.address)

                          server.deleteUserFromServer(1, user2.address)

                          let instance2 = await server.getServer(1)
                          expect(instance2.users).to.be.an("array").that.is
                              .empty
                      })
                      it("requires the owner", async () => {
                          let instance = await server
                              .connect(user2)
                              .getServer(1)
                          expect(instance.users).to.contains(user2.address)

                          await expect(
                              server
                                  .connect(user2)
                                  .deleteUserFromServer(1, user2.address)
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_ServerNoPermission"
                              )
                              .withArgs(
                                  1,
                                  "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
                                  "Delete User"
                              )

                          let instance2 = await server
                              .connect(user2)
                              .getServer(1)
                          expect(instance2.users).to.contains(user2.address)
                      })

                      it("requires index to be greater than 0", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.users).to.contains(user2.address)

                          await expect(
                              server
                                  .connect(deployer)
                                  .deleteUserFromServer(0, user2.address)
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_Index"
                              )
                              .withArgs(0)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance2.users).to.contains(user2.address)
                      })
                      it("requires index to be less than servercount", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.users).to.contains(user2.address)

                          let serverCount = await server.getServerCount()

                          await expect(
                              server
                                  .connect(deployer)
                                  .deleteUserFromServer(
                                      serverCount + 1,
                                      user2.address
                                  )
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_Index"
                              )
                              .withArgs(serverCount + 1)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance2.users).to.contains(user2.address)
                      })

                      it("requires address to not be empty", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.users).to.contains(user2.address)

                          let serverCount = await server.getServerCount()

                          await expect(
                              server
                                  .connect(deployer)
                                  .deleteUserFromServer(
                                      serverCount,
                                      "0x0000000000000000000000000000000000000000"
                                  )
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_UserNotFound"
                              )
                              .withArgs(
                                  serverCount,
                                  "0x0000000000000000000000000000000000000000"
                              )

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(serverCount)
                          expect(instance2.users).to.contains(user2.address)
                      })
                      it("requires address to be listed, unrelated address", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.users).to.contains(user2.address)

                          let serverCount = await server.getServerCount()

                          await expect(
                              server
                                  .connect(deployer)
                                  .deleteUserFromServer(
                                      serverCount,
                                      "0x31d843b99c2c4088cD20D96EF2426673b958Ff70"
                                  )
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_UserNotFound"
                              )
                              .withArgs(
                                  serverCount,
                                  "0x31d843b99c2c4088cD20D96EF2426673b958Ff70"
                              )

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(serverCount)
                          expect(instance2.users).to.contains(user2.address)
                      })
                      it("requires user to be listed, failes if not listed", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.users).to.contains(user2.address)

                          let serverCount = await server.getServerCount()
                          server.deleteUserFromServer(
                              serverCount,
                              user2.address
                          )

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(serverCount)
                          expect(instance2.users).to.be.an("array").that.is
                              .empty

                          await expect(
                              server.deleteUserFromServer(
                                  serverCount,
                                  user2.address
                              )
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_UserNotFound"
                              )
                              .withArgs(serverCount, user2.address)

                          let instance3 = await server
                              .connect(deployer)
                              .getServer(serverCount)
                          expect(instance3.users).to.be.an("array").that.is
                              .empty
                      })

                      it("requires emits an event", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.users).to.contains(user2.address)

                          await expect(
                              server
                                  .connect(deployer)
                                  .deleteUserFromServer(1, user2.address)
                          )
                              .to.emit(server, "UserDeletedFromServer")
                              .withArgs(1, user2.address)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance2.users).to.be.an("array").that.is
                              .empty
                      })
                  })
              })

              describe("Channel Array", () => {
                  describe("add to Array", () => {
                      it("Updates Channel Array", async () => {
                          let instance = await server.getServer(1)
                          expect(instance.channels).to.be.an("array").that.is
                              .empty
                          server.addChannelToServer(1, 420)
                          let instance2 = await server.getServer(1)

                          expect(
                              instance2.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())
                      })
                      it("requires the owner", async () => {
                          let instance = await server
                              .connect(user2)
                              .getServer(1)
                          expect(instance.channels).to.be.an("array").that.is
                              .empty

                          await expect(
                              server.connect(user2).addChannelToServer(1, 420)
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_ServerNoPermission"
                              )
                              .withArgs(
                                  1,
                                  "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
                                  "add to channels"
                              )

                          let instance2 = await server
                              .connect(user2)
                              .getServer(1)
                          expect(instance2.channels).to.be.an("array").that.is
                              .empty
                      })

                      it("requires index to be greater than 0", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.channels).to.be.an("array").that.is
                              .empty

                          await expect(
                              server
                                  .connect(deployer)
                                  .addChannelToServer(0, 420)
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_Index"
                              )
                              .withArgs(0)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance2.channels).to.be.an("array").that.is
                              .empty
                      })

                      it("requires index to be less than servercount", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.channels).to.be.an("array").that.is
                              .empty

                          let serverCount = await server.getServerCount()

                          await expect(
                              server
                                  .connect(deployer)
                                  .addChannelToServer(serverCount + 1, 420)
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_Index"
                              )
                              .withArgs(serverCount + 1)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance2.channels).to.be.an("array").that.is
                              .empty
                      })
                      it("requires channel to not be 0", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.channels).to.be.an("array").that.is
                              .empty

                          let serverCount = await server.getServerCount()

                          await expect(
                              server
                                  .connect(deployer)
                                  .addChannelToServer(serverCount, 0)
                          ).to.be.revertedWithCustomError(
                              server,
                              "RRCServer_InvalidUint256Parameter"
                          )
                          // .withArgs("channel id", BigNumber.from(1))

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(serverCount)
                          expect(instance2.channels).to.be.an("array").that.is
                              .empty
                      })

                      it("requires channel to not already be listed", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.channels).to.be.an("array").that.is
                              .empty

                          let serverCount = await server.getServerCount()
                          server.addChannelToServer(serverCount, 420)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(serverCount)
                          expect(
                              instance2.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())

                          await expect(
                              server.addChannelToServer(serverCount, 420)
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_ChannelAlreadyExists"
                              )
                              .withArgs(420)

                          let instance3 = await server
                              .connect(deployer)
                              .getServer(serverCount)
                          expect(
                              instance3.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())
                      })

                      it("requires emits an event", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance.channels).to.be.an("array").that.is
                              .empty

                          await expect(
                              server
                                  .connect(deployer)
                                  .addChannelToServer(1, 420)
                          )
                              .to.emit(server, "ChannelAddedToServer")
                              .withArgs(1, 420)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(
                              instance2.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())
                      })
                  })
                  describe("delete from Array", () => {
                      beforeEach(async () => {
                          let instance = await server.getServer(1)
                          expect(instance.channels).to.be.an("array").that.is
                              .empty
                          server.addChannelToServer(1, 420)
                          let instance2 = await server.getServer(1)
                          expect(
                              instance2.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())
                      })
                      it("Removes from channel Array", async () => {
                          let instance = await server.getServer(1)
                          expect(
                              instance.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())

                          server.deleteChannelFromServer(1, 420)

                          let instance2 = await server.getServer(1)
                          expect(instance2.channels).to.be.an("array").that.is
                              .empty
                      })
                      it("requires the owner", async () => {
                          let instance = await server
                              .connect(user2)
                              .getServer(1)
                          expect(
                              instance.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())

                          await expect(
                              server
                                  .connect(user2)
                                  .deleteChannelFromServer(1, user2.address)
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_ServerNoPermission"
                              )
                              .withArgs(
                                  1,
                                  "0x70997970C51812dc3A010C7d01b50e0d17dc79C8",
                                  "delete channel"
                              )

                          let instance2 = await server
                              .connect(user2)
                              .getServer(1)
                          expect(
                              instance2.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())
                      })

                      it("requires index to be greater than 0", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(
                              instance.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())

                          await expect(
                              server
                                  .connect(deployer)
                                  .deleteChannelFromServer(0, 420)
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_Index"
                              )
                              .withArgs(0)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(
                              instance2.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())
                      })
                      it("requires index to be less than servercount", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(
                              instance.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())

                          let serverCount = await server.getServerCount()

                          await expect(
                              server
                                  .connect(deployer)
                                  .deleteChannelFromServer(serverCount + 1, 420)
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_Index"
                              )
                              .withArgs(serverCount + 1)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(
                              instance2.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())
                      })

                      it("requires channel to not be 0", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(
                              instance.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())

                          let serverCount = await server.getServerCount()

                          await expect(
                              server
                                  .connect(deployer)
                                  .deleteChannelFromServer(serverCount, 0)
                          ).to.be.revertedWithCustomError(
                              server,
                              "RRCServer_ChannelNotFound"
                          )
                          //   .withArgs(420)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(serverCount)
                          expect(
                              instance2.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())
                      })
                      it("requires address to be listed, unrelated address", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(
                              instance.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())

                          let serverCount = await server.getServerCount()

                          await expect(
                              server
                                  .connect(deployer)
                                  .deleteChannelFromServer(serverCount, 710)
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_ChannelNotFound"
                              )
                              .withArgs(710)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(serverCount)
                          expect(
                              instance2.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())
                      })
                      it("requires channel to be listed, failes if not listed", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(
                              instance.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())

                          let serverCount = await server.getServerCount()
                          server.deleteChannelFromServer(serverCount, 420)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(serverCount)
                          expect(instance2.channels).to.be.an("array").that.is
                              .empty

                          await expect(
                              server.deleteChannelFromServer(serverCount, 420)
                          )
                              .to.be.revertedWithCustomError(
                                  server,
                                  "RRCServer_ChannelNotFound"
                              )
                              .withArgs(420)

                          let instance3 = await server
                              .connect(deployer)
                              .getServer(serverCount)
                          expect(instance3.channels).to.be.an("array").that.is
                              .empty
                      })

                      it("requires emits an event", async () => {
                          let instance = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(
                              instance.channels.map((n) => n.toString())
                          ).to.include(BigNumber.from(420).toString())

                          await expect(
                              server
                                  .connect(deployer)
                                  .deleteChannelFromServer(1, 420)
                          )
                              .to.emit(server, "ChannelDeletedFromServer")
                              .withArgs(1, 420)

                          let instance2 = await server
                              .connect(deployer)
                              .getServer(1)
                          expect(instance2.channels).to.be.an("array").that.is
                              .empty
                      })
                  })
              })

              //======================================
              //   https://medium.com/@danielque/solidity-unit-testing-internal-functions-4e9a728298a0
              // function contains(
              //     uint256[] memory array,
              //     uint256 element
              // ) internal pure returns (bool) {
              //     for (uint256 i = 0; i < array.length; i++) {
              //         if (array[i] == element) {
              //             return true;
              //         }
              //     }
              //     return false;
              // }

              // function contains(
              //     address[] memory array,
              //     address element
              // ) internal pure returns (bool) {
              //     for (uint256 i = 0; i < array.length; i++) {
              //         if (array[i] == element) {
              //             return true;
              //         }
              //     }
              //     return false;
              // }

              // function getChannelIndex(
              //     Server storage server,
              //     uint256 channelId
              // ) internal view returns (uint256) {
              //     for (uint256 i = 0; i < server.channels.length; i++) {
              //         if (server.channels[i] == channelId) {
              //             return i;
              //         }
              //     }
              //     return server.channels.length;
              // }

              // function getUserIndex(
              //     Server storage server,
              //     address userAddress
              // ) internal view returns (uint256) {
              //     for (uint256 i = 0; i < server.users.length; i++) {
              //         if (server.users[i] == userAddress) {
              //             return i;
              //         }
              //     }
              //     return server.users.length;
              // }
          })
      })