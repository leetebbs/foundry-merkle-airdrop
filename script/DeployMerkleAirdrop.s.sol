// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { ZkSyncChainChecker } from "lib/foundry-devops/src/ZkSyncChainChecker.sol"; 
import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {TebboToken} from "../src/TebboToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployMerkleAirdrop is Script, ZkSyncChainChecker {
    bytes32 private s_merkleRoot = 0xe22d6a5546eacb2541428c99fd856c71e9f64aacacdcab8381b2b9791a4f7e3c;
    uint256 private s_amountToTransfer = 4 * 25 * 1e18; // 4 users, 25 tokens each

    function run() external returns (MerkleAirdrop, TebboToken) {
        return deployMerkleAirdrop();
    }

    function deployMerkleAirdrop() public returns (MerkleAirdrop, TebboToken) {
        vm.startBroadcast();

        TebboToken token = new TebboToken();
        MerkleAirdrop airdrop = new MerkleAirdrop(s_merkleRoot, IERC20(address(token)));

        // Mint tokens to the deployer (owner of the token contract by default)
        token.mint(token.owner(), s_amountToTransfer);
        // Transfer tokens from the deployer to the airdrop contract
        token.transfer(address(airdrop), s_amountToTransfer);

        vm.stopBroadcast();
        return (airdrop, token);
    }
}
