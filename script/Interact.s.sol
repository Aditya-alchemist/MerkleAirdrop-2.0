// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {MerkelAirdrop} from "../src/MerkleAirdrop.sol";
import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";

//0: contract MerkelAirdrop 0xc870C170769aa6a95B050f49F466a3e0334Cf1AB
//1: contract BagelToken 0xfb00b41CDe52A58dACe25FA5D0991CfA37b669Db


contract ClaimAirdrop is Script {

    address constant CLAIMING_ADDRESS = 0x7f21D6Db0B059496EE1C0810898e35c125A714ab;
    uint256 constant CLAIMING_AMOUNT = 25 * 1e18;
    bytes32 private constant proof1= 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 private constant proof2 = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] private PROOF = [proof1, proof2];
    bytes private SIGNATURE = hex"d6afb96ec128e93a715041745dbae51733e7d8f0a0e7e4f10d71bd778fa089de404bcba4eae56f8180da30e92b7a71939f40187cd95ebecd54e0e7a52691d1f21c";

   function run() external{
    address mostrecent = DevOpsTools.get_most_recent_deployment("MerkelAirdrop", block.chainid);
    claimAirdrop(mostrecent);
   }

   function claimAirdrop(address airdrop) public {
    vm.startBroadcast();
    
    MerkelAirdrop(airdrop).claim(CLAIMING_ADDRESS,CLAIMING_AMOUNT,PROOF, SIGNATURE);
    vm.stopBroadcast();
   }

   
}