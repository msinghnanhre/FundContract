//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Script } from "forge-std/Script.sol";
import { DevOpsTools } from "foundry-devops/src/DevOpsTools.sol";
import { FundMe } from "../src/FundMe.sol";

contract WithdrawFundMe is Script {
    
    function withdrawFundMe(address mostRecentDeployedFundMe) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployedFundMe)).withdraw();
        vm.stopBroadcast();
    }
    function run() external {
        address mostRecentDeployedFundMe = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentDeployedFundMe);
    }


}

contract FundFundMe is Script {
    uint256 constant FUND_ME_VALUE = 0.01 ether;
    
    function fundFundMe(address mostRecentDeployedFundMe) public payable {
        FundMe(payable(mostRecentDeployedFundMe)).fund{value: FUND_ME_VALUE}();
    }
    function run() external {
        address mostRecentDeployedFundMe = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
         vm.startBroadcast();
        fundFundMe(mostRecentDeployedFundMe);
        vm.stopBroadcast();
    }
}