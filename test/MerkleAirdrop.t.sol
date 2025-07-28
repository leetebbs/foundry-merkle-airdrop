// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {TebboToken} from "../src/TebboToken.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MerkleAirdropTest is Test {
    MerkleAirdrop public airdrop;
    TebboToken public token;

    // This ROOT value is derived from your Merkle tree generation script
    // It will be updated later in the process
    bytes32 public ROOT = 0xe22d6a5546eacb2541428c99fd856c71e9f64aacacdcab8381b2b9791a4f7e3c;
    uint256 public AMOUNT_TO_CLAIM = 2500 * 1e18; // Example claim amount for the test user
    uint256 public AMOUNT_TO_SEND; // Total tokens to fund the airdrop contract

    // User-specific data
    address user;
    uint256 userPrivKey; // Private key for the test user

    address public gasPayer;

    // Merkle Proof for the test user
    // The structure (e.g., bytes32[2]) depends on your Merkle tree's depth
    // These specific values will be populated from your Merkle tree output

            // "0x728fe2293b7a05c823ef21a0365eb856d0de4b583bee3423bdd35805239ea994",
            // "0xff524e7a19b318850583c1224b713461bc2c0cef3b627c75c0d71c443de8716d"
    bytes32 proofOne = 0x728fe2293b7a05c823ef21a0365eb856d0de4b583bee3423bdd35805239ea994;
    bytes32 proofTwo = 0xff524e7a19b318850583c1224b713461bc2c0cef3b627c75c0d71c443de8716d;
    bytes32[2] public PROOF;

    function setUp() public {
        // 1. Deploy the ERC20 Token
        token = new TebboToken();

        PROOF = [proofOne, proofTwo];

        // 2. Generate a Deterministic Test User
        // `makeAddrAndKey` creates a predictable address and private key.
        // This is crucial because we need to know the user's address *before*
        // generating the Merkle tree that includes them.
        (user, userPrivKey) = makeAddrAndKey("testUser");
        gasPayer = makeAddr("gasPayer");

        console.log(user);
        // 3. Deploy the MerkleAirdrop Contract
        // Pass the Merkle ROOT and the address of the token contract.
        airdrop = new MerkleAirdrop(ROOT, IERC20(address(token)));

        // 4. Fund the Airdrop Contract (Critical Step!)
        // The airdrop contract needs tokens to distribute.
        // Let's assume our test airdrop is for 4 users, each claiming AMOUNT_TO_CLAIM.
        AMOUNT_TO_SEND = AMOUNT_TO_CLAIM * 4;

        // The test contract itself is the owner of the BagelToken by default upon deployment.
        address owner = address(this); // or token.owner() if explicitly set elsewhere

        // Mint tokens to the owner (the test contract).
        token.mint(owner, AMOUNT_TO_SEND);

        // Transfer the minted tokens to the airdrop contract.
        // Note the explicit cast of `airdrop` (contract instance) to `address`.
        token.transfer(address(airdrop), AMOUNT_TO_SEND);
    }

    function testUsersCanClaim() public {
    uint256 startingBalance = token.balanceOf(user);

    // 1. Get the message digest that the user needs to sign
    // This calls the getMessageHash function from the MerkleAirdrop contract
    bytes32 digest = airdrop.getMessageHash(user, AMOUNT_TO_CLAIM);

    // 2. User signs the digest using their private key
    // vm.sign is a Foundry cheatcode
    uint8 v;
    bytes32 r;
    bytes32 s;
    (v, r, s) = vm.sign(userPrivKey, digest);

    // 3. The gasPayer calls the claim function with the user's signature
    vm.prank(gasPayer); // Set the next msg.sender to be gasPayer
    bytes32[] memory proof = new bytes32[](2);
    proof[0] = PROOF[0];
    proof[1] = PROOF[1];
    airdrop.claim(user, AMOUNT_TO_CLAIM, proof, v, r, s);

    uint256 endingBalance = token.balanceOf(user);
    console.log("Ending Balance: ", endingBalance);
    assertEq(endingBalance, startingBalance + AMOUNT_TO_CLAIM);
}
}
