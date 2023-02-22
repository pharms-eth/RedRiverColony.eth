const { network, ethers } = require("hardhat")
const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")
require("dotenv").config()

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainID = network.config.chainId

    const name = networkConfig[chainID]["serverName"]
    log("----------------------------------------------------")
    log(`Deploying RRCServer ${name} and waiting for confirmations...`)

    const args = [name]
    const rRCServer = await deploy("RServer", {
        from: deployer,
        args: args,
        log: true,
        // we need to wait if on a live network so we can verify properly
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    log(`RRCServer deployed at ${rRCServer.address}`)
    const networkName = network.name == "hardhat" ? "localhost" : network.name
    log(`network ${networkName}`)

    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        log(`Verifying...`)
        await verify(rRCServer.address, args)
    }
    log("----------------------------------------------------")
}

module.exports.tags = ["all", "Server"]
