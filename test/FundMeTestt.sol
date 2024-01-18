//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe f;
    function setUp() public {
        f = new FundMe();
    }
    function testMinimumUsdIsFive() public {
        assertEq(f.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(f.i_owner(), address(this));
    }
}