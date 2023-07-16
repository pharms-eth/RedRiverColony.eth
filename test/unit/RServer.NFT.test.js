const { assert, expect, use } = require("chai")
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
                  .register("TESTServer", "imageURL", user2.address)
              //   await transaction.wait()
          })

          describe("Deployment", () => {
              it("Returns owner", async () => {
                  const result = await server.contractOwner()
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
                  expect(result).to.be.equal("")
              })

              it("Updates total supply", async () => {
                  const result = await server.getServerCount()
                  expect(result).to.be.equal("1")
              })

              it("Updates balance", async () => {
                  expect(await server.balanceOf(deployer.address)).to.equal(1)
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

          describe("BURN", () => {
              it("Should fail if the token does not exist", async function () {
                  await expect(
                      server.connect(deployer).burn(9999)
                  ).to.be.revertedWith(
                      "ERC721: operator query for nonexistent token"
                  )
              })

              it("Should fail if the caller is not the owner", async function () {
                  // Assume that owner has tokenId 1
                  await expect(
                      server.connect(user2).burn(1)
                  ).to.be.revertedWithCustomError(
                      server,
                      "RRCServer_ServerNoPermission"
                  )
              })

              it("Should fail if the token is already burned", async function () {
                  // Assume that owner has tokenId 1
                  await server.connect(deployer).burn(1)
                  await expect(
                      server.connect(deployer).burn(1)
                  ).to.be.revertedWith(
                      "ERC721: operator query for nonexistent token"
                  )
              })

              it("Should delete token approvals", async function () {
                  // Assume that owner has tokenId 1 and approves addr1
                  await server.connect(deployer).approve(user2.address, 1)
                  await server.connect(deployer).burn(1)
                  await expect(server.getApproved(1)).to.be.revertedWith(
                      "ERC721: operator query for nonexistent token"
                  )
              })

              it("Should emit a Transfer event", async function () {
                  // Assume that owner has tokenId 1
                  await expect(server.connect(deployer).burn(1))
                      .to.emit(server, "Transfer")
                      .withArgs(
                          deployer.address,
                          ethers.constants.AddressZero,
                          1
                      )
              })

              it("Should decreases balance", async function () {
                  // Assume that owner has tokenId 1
                  await server.connect(deployer).burn(1)
                  expect(await server.balanceOf(deployer.address)).to.equal(0)
              })

              it("Deletes Server", async () => {
                  await server.connect(deployer).burn(1)
                  await expect(
                      server.connect(deployer).getServer(1)
                  ).to.be.revertedWith(
                      "ERC721: operator query for nonexistent token"
                  )
              })
          })

          describe("URI", () => {
              it("Creates URI", async () => {
                  //   const result = await server.owner()
                  //   expect(result).to.be.equal(deployer.address)
              })

              it("Updates URI", async () => {
                  //   const result = await server.owner()
                  //   expect(result).to.be.equal(deployer.address)
              })

              it("Reads URI", async () => {
                  //   const result = await server.owner()
                  //   expect(result).to.be.equal(deployer.address)
              })

              it("Delete URI", async () => {
                  //   const result = await server.owner()
                  //   expect(result).to.be.equal(deployer.address)
              })

              //   it("Returns cost", async () => {
              //       const result = await server.cost()
              //       expect(result).to.be.equal(COST)
              //   })
          })

          describe("NFT functions", () => {
              it("function balanceOf(address _owner) external view returns (uint256)", async () => {
                  expect(await server.balanceOf(deployer.address)).to.equal(1)
              })
              it("function ownerOf(uint256 _tokenId) external view returns (address)", async () => {
                  expect(await server.ownerOf("1")).to.be.equal(
                      deployer.address
                  )
              })
              it("function tokenByIndex(uint256 _index) external view returns (uint256))", async () => {
                  expect(await server.tokenByIndex("0")).to.equal(0)
              })
              it("function totalSupply() external view returns (uint256)", async () => {
                  expect(await server.totalSupply()).to.equal(1)
              })
              it("function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256)", async () => {
                  expect(
                      await server.tokenOfOwnerByIndex(deployer.address, "0")
                  ).to.equal(0)
              })

              describe("Approvals", () => {
                  describe("function approve(address _approved, uint256 _tokenId) external payable", () => {
                      it("Should Fail if to is owner", async () => {
                          await expect(
                              server.approve(deployer.address, "1")
                          ).to.be.revertedWith(
                              "ERC721: approval to current owner"
                          )
                      })
                      it("Should Fail if caller is not owner", async () => {
                          await expect(
                              server.connect(user2).approve(user2.address, "1")
                          ).to.be.revertedWith(
                              "ERC721: approve caller is not token owner or approved for all"
                          )
                      })

                      it("Should emit an Approval event", async () => {
                          // Assume that owner has tokenId 1
                          await expect(
                              server
                                  .connect(deployer)
                                  .approve(user2.address, "1")
                          )
                              .to.emit(server, "Approval")
                              .withArgs(deployer.address, user2.address, 1)
                      })
                      it("Should update state", async () => {
                          server.connect(deployer).approve(user2.address, 1)
                          expect(await server.getApproved(1)).to.equal(
                              user2.address
                          )
                      })
                  })
                  describe("setApprovalForAll and isApprovedForAll", function () {
                      it("Should set approval status and return it correctly", async function () {
                          await server
                              .connect(deployer)
                              .setApprovalForAll(user2.address, true)
                          expect(
                              await server
                                  .connect(deployer)
                                  .isApprovedForAll(
                                      deployer.address,
                                      user2.address
                                  )
                          ).to.equal(true)
                      })

                      it("Should emit an ApprovalForAll event", async function () {
                          await expect(
                              server
                                  .connect(deployer)
                                  .setApprovalForAll(user2.address, true)
                          )
                              .to.emit(server, "ApprovalForAll")
                              .withArgs(deployer.address, user2.address, true)
                      })

                      it("Should not allow an owner to approve themselves", async function () {
                          await expect(
                              server
                                  .connect(deployer)
                                  .setApprovalForAll(deployer.address, true)
                          ).to.be.revertedWith("ERC721: approve to caller")
                      })

                      it("Should allow revoking approval", async function () {
                          await server
                              .connect(deployer)
                              .setApprovalForAll(user2.address, true)
                          await server
                              .connect(deployer)
                              .setApprovalForAll(user2.address, false)
                          expect(
                              await server
                                  .connect(deployer)
                                  .isApprovedForAll(
                                      deployer.address,
                                      user2.address
                                  )
                          ).to.equal(false)
                      })

                      it("Should not affect other operators when setting approval", async function () {
                          await server
                              .connect(deployer)
                              .setApprovalForAll(user2.address, true)
                          expect(
                              await server
                                  .connect(deployer)
                                  .isApprovedForAll(
                                      deployer.address,
                                      user3.address
                                  )
                          ).to.equal(false)
                      })
                  })
              })

              describe("safeTransferFrom and transferFrom", function () {
                  it("Should transfer the token correctly", async function () {
                      await server["safeTransferFrom(address,address,uint256)"](
                          deployer.address,
                          user2.address,
                          1
                      )

                      expect(await server.ownerOf(1)).to.equal(user2.address)
                  })

                  it("Should fail if the caller is not the owner or approved", async function () {
                      await expect(
                          server
                              .connect(user2)
                              ["safeTransferFrom(address,address,uint256)"](
                                  deployer.address,
                                  user2.address,
                                  1
                              )
                      ).to.be.revertedWith(
                          "ERC721: caller is not token owner or approved"
                      )
                  })

                  it("Should fail if transferring from incorrect owner", async function () {
                      await expect(
                          server
                              .connect(deployer)
                              ["safeTransferFrom(address,address,uint256)"](
                                  user2.address,
                                  user3.address,
                                  1
                              )
                      ).to.be.revertedWith(
                          "ERC721: transfer from incorrect owner"
                      )
                  })

                  it("Should fail if transferring to the zero address", async function () {
                      await expect(
                          server
                              .connect(deployer)
                              ["safeTransferFrom(address,address,uint256)"](
                                  deployer.address,
                                  ethers.constants.AddressZero,
                                  1
                              )
                      ).to.be.revertedWith(
                          "ERC721: transfer to the zero address"
                      )
                  })

                  it("Should emit a Transfer event", async function () {
                      await expect(
                          server
                              .connect(deployer)
                              ["safeTransferFrom(address,address,uint256)"](
                                  deployer.address,
                                  user2.address,
                                  1
                              )
                      )
                          .to.emit(server, "Transfer")
                          .withArgs(deployer.address, user2.address, 1)
                  })

                  it("Should clear approvals", async function () {
                      // Assume that owner approves addr1 for tokenId 1
                      await server.connect(deployer).approve(user2.address, 1)
                      await server
                          .connect(deployer)
                          ["safeTransferFrom(address,address,uint256)"](
                              deployer.address,
                              user3.address,
                              1
                          )

                      expect(await server.getApproved(1)).to.equal(
                          ethers.constants.AddressZero
                      )
                  })

                  it("Should update the balances correctly", async function () {
                      await server
                          .connect(deployer)
                          ["safeTransferFrom(address,address,uint256)"](
                              deployer.address,
                              user2.address,
                              1
                          )
                      expect(await server.balanceOf(deployer.address)).to.equal(
                          0
                      )
                      expect(await server.balanceOf(user2.address)).to.equal(1)
                  })
              })
          })
      })
