// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;


import { MerkelAirdrop, IERC20 } from "../src/MerkleAirdrop.sol";
import { Script } from "forge-std/Script.sol";
import { BagelToken } from "../src/BagelToken.sol";
import { console } from "forge-std/console.sol";
//0: contract MerkelAirdrop 0xc870C170769aa6a95B050f49F466a3e0334Cf1AB
//1: contract BagelToken 0xfb00b41CDe52A58dACe25FA5D0991CfA37b669Db


contract DeployMerkleAirdrop is Script {
    bytes32 public ROOT = 0xfba4401795c371e44a8b8932031439edf0627655a1e69b8eeb1edc10048b9461;
    // 4 users, 25 Bagel tokens each
    uint256 public AMOUNT_TO_TRANSFER = 4 * (25 * 1e18);

    // Deploy the airdrop contract and bagel token contract
    function deployMerkleAirdrop() public returns (MerkelAirdrop, BagelToken) {
        vm.startBroadcast();
        BagelToken bagelToken = new BagelToken();
        MerkelAirdrop airdrop = new MerkelAirdrop(ROOT, IERC20(bagelToken));
        // Send Bagel tokens -> Merkle Air Drop contract
        bagelToken.mint(bagelToken.owner(), AMOUNT_TO_TRANSFER);
        IERC20(bagelToken).transfer(address(airdrop), AMOUNT_TO_TRANSFER);
        vm.stopBroadcast();
        return (airdrop, bagelToken);
    }

    function run() external returns (MerkelAirdrop, BagelToken) {
        return deployMerkleAirdrop();
    }
}
