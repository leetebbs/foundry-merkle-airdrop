# Merkle Airdrop 🪂

A gas-efficient airdrop system using Merkle trees to distribute ERC20 tokens. Users can claim their allocated tokens by providing a valid Merkle proof.

## 📋 Overview

This project implements a smart contract-based airdrop system that uses Merkle trees for efficient token distribution. Instead of storing all eligible addresses on-chain, only the Merkle root is stored, allowing users to prove their eligibility with a cryptographic proof.

## 🚀 Features

- **Gas Efficient**: Only stores Merkle root on-chain, not individual addresses
- **Secure**: Uses cryptographic proofs to verify eligibility
- **Flexible**: Supports any ERC20 token
- **One-time Claims**: Prevents double claiming with tracking mechanism
- **Signature Verification**: Optional signature-based claiming for enhanced security

## 📦 Contracts

### TebboToken (ERC20)
- **Symbol**: TBT
- **Name**: TebboToken
- **Features**: Mintable by owner

### MerkleAirdrop
- Manages token distribution using Merkle proofs
- Tracks claimed addresses to prevent double spending
- Supports signature-based claiming

## 🌐 Deployment

### Sepolia Testnet

| Contract | Address |
|----------|---------|
| **TebboToken** | [`0xCcE6640706A3fE103bA690e494745c27a49C6da6`](https://sepolia.etherscan.io/address/0xCcE6640706A3fE103bA690e494745c27a49C6da6) |
| **MerkleAirdrop** | [`0x101F1c679e575ed3FBb3a0C54e0d7cA634Ed3783`](https://sepolia.etherscan.io/address/0x101F1c679e575ed3FBb3a0C54e0d7cA634Ed3783) |

## 🛠️ Getting Started

### Prerequisites

- [Foundry](https://getfoundry.sh/)
- Node.js (for generating Merkle trees)

### Installation

```bash
git clone <repository-url>
cd merkle-airdrop
forge install
```

### Build

```bash
forge build
```

### Test

```bash
forge test
```

## 📝 Usage

### Deploying Contracts

```bash
# Deploy using the deployment script
forge script script/DeployMerkleAirdrop.s.sol --rpc-url <RPC_URL> --private-key <PRIVATE_KEY> --broadcast
```

### Generating Merkle Tree

```bash
# Generate input file with eligible addresses and amounts
forge script script/GenerateInput.s.sol

# Create Merkle tree and proofs
forge script script/MakeMerkle.s.sol
```

### Claiming Tokens

Users can claim their tokens by providing:
- Their address
- Allocated amount
- Merkle proof
- Valid signature (if required)

## 🔧 Scripts

- `DeployMerkleAirdrop.s.sol` - Deploys both TebboToken and MerkleAirdrop contracts
- `GenerateInput.s.sol` - Generates list of eligible addresses and amounts
- `MakeMerkle.s.sol` - Creates Merkle tree and generates proofs
- `Interact.s.sol` - Interacts with deployed contracts for claiming

## 🧪 Testing

The project includes comprehensive tests covering:
- Token deployment and minting
- Merkle proof generation and verification
- Claiming mechanisms
- Edge cases and security scenarios

Run tests with:
```bash
forge test -vv
```

## 📊 Gas Optimization

- Uses Merkle trees to minimize on-chain storage
- Efficient proof verification algorithm
- Optimized contract structures

## 🔐 Security Features

- Prevents double claiming
- Signature verification for enhanced security
- Comprehensive input validation
- Reentrancy protection

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- [Sepolia Testnet Explorer](https://sepolia.etherscan.io/)
- [Foundry Documentation](https://book.getfoundry.sh/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)

---

Built with ❤️ using [Foundry](https://getfoundry.sh/)