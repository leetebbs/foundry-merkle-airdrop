// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {MerkleAirdrop} from "../../src/MerkleAirdrop.sol";

contract ClaimAirdrop is Script {

    error __cliamAirdropScript__splitSignature_invalidLength();



        function claimAirdrop(address airdropContractAddress) public {
        address CLAIMING_ADDRESS = 0xF7DFAA7B4230fdc795e8C6430834Cf309aF893bA; // Example address
        uint256 CLAIMING_AMOUNT = 25 * 1e18; // Example: 25 tokens with 18 decimals 2500 * 1e18

        bytes32 PROOF_ONE = 0x728fe2293b7a05c823ef21a0365eb856d0de4b583bee3423bdd35805239ea994; // Example proof element
        bytes32 PROOF_TWO = 0xff524e7a19b318850583c1224b713461bc2c0cef3b627c75c0d71c443de8716d; // Example proof element
        bytes32[] memory proof = new bytes32[](2); // Assuming a proof length of 2 for this example
        proof[0] = PROOF_ONE;
        proof[1] = PROOF_TWO;

        bytes memory SIGNATURE = hex"d5ff7d0550407e8a800b14e9342b1258ffea321b7a2e747e45ab04a73f5265c41f717cae01fb1fa2ebc8aacaa31d56fd78228c8418e6585dd2946aa2e112b8871b"; // Example signature
        console.log("Sig length ", SIGNATURE.length);
        // v, r, s signature components are still needed
        
        vm.startBroadcast();
        (uint8 v,bytes32 r, bytes32 s) = splitSignature(SIGNATURE);
        // MerkleAirdrop(airdropContractAddress).claim(CLAIMING_ADDRESS, CLAIMING_AMOUNT, proof, v, r, s);
        vm.stopBroadcast();
    }

    function splitSignature(bytes memory _sig) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
        require(_sig.length == 65, "Invalid signature length");
        if(_sig.length != 65) {
            revert __cliamAirdropScript__splitSignature_invalidLength();
        }
        assembly {
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }
    }

        function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid);
        claimAirdrop(mostRecentlyDeployed);
    }
}
