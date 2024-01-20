//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { FundMe } from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() public returns(FundMe){

        HelperConfig helperConfig = new HelperConfig();
        address configAddress = helperConfig.activeConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(configAddress);
        vm.stopBroadcast();
        return fundMe;
    }
}