//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_VALUE = 2000e8;

    struct Config {
        address priceFeedAddress;
    }

    Config public activeConfig;

    constructor() {
        if(block.chainid == 11155111) {
            activeConfig = getSepoliaEthConfig();
            } else {
                activeConfig = getOrCreateAnvilEthConfig();
            }
    }

    function getSepoliaEthConfig() public pure returns (Config memory) {
        Config memory sepoliaConfig = Config({
            priceFeedAddress: 0x694AA1769357215DE4FAC081bf1f309aDC325306
                });
                return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (Config memory) {
        // return Config({
        //     priceFeedAddress: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        //         });
        if(activeConfig.priceFeedAddress != address(0)) {
            return activeConfig;
        }

        vm.startBroadcast();

        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_VALUE);
        vm.stopBroadcast();

        Config memory anvilConfig = Config({
            priceFeedAddress: address(mockPriceFeed)
                });
                return anvilConfig;

    }
}