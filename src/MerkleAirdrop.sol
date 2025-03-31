// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20, SafeERC20 } from "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "../lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";
import {EIP712} from "../lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol";
import {ECDSA} from "../lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract MerkelAirdrop is EIP712{
    
    using SafeERC20 for IERC20;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdroptoken;
    address[] claimers;

    struct AirdropClaim{
        address account;
        uint256 amount;
    }
   
    bytes32 public constant MESSAGE_TYPEHASH = keccak256("AirdropClaim(address account,uint256 amount)");
    mapping(address claimer => bool hasclaimed) private s_claimed;

    event claimamount(address indexed account, uint256 amount);

    error MerkleAirdrop_InvalidProof();
    error MerkleAirdrop_AlreadyClaimed();
    error MerkleAirdrop_InvalidSignature();

    constructor (bytes32 merkleRoot, IERC20 airdroptoken) EIP712("MerkelAirdrop", "1") {
        i_merkleRoot = merkleRoot;
        i_airdroptoken = airdroptoken;
      i_merkleRoot = merkleRoot;
        i_airdroptoken = airdroptoken;
    }

    function claim(address account, uint256 amount , bytes32[] calldata merkleProof,bytes memory signature) external {
        if(s_claimed[account]){
            revert MerkleAirdrop_AlreadyClaimed();
        }
        if(!_isValidSignature(account, getMessage(account,amount), signature)){
            revert MerkleAirdrop_InvalidSignature();
        }
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));
        if(!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)){
            revert MerkleAirdrop_InvalidProof();
        }
         s_claimed[account] = true;
       emit  claimamount(account, amount);
       i_airdroptoken.safeTransfer(account, amount);
       s_claimed[account] = true;
    }

    function  getMessage(address account, uint256 amount) public view returns (bytes32){
        return _hashTypedDataV4(keccak256(abi.encode(MESSAGE_TYPEHASH, AirdropClaim({account: account,amount: amount }))));
    }

    function getMerkleRoot() external view returns (bytes32){
        return i_merkleRoot;
    }

    function getAirdropToken() external view returns (IERC20){
        return i_airdroptoken;
    }

    function _isValidSignature(address account, bytes32 digest, bytes memory signature) internal pure returns (bool) {
        (address actualSigner, ,)= ECDSA.tryRecover(digest, signature);
        return actualSigner == account;

    }
}

