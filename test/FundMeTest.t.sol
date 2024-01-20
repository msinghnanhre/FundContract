//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../src/FundMe.sol";
import { DeployFundMe } from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe f;

    //mock an address in cases where we need to have a consistent address
    address USER = makeAddr("User");
    uint256 ETHER_AMOUNT = 5e18;

    //give user default funds to ensure its never out of balalnce
    uint256 constant DEFAULT_BALANCE = 10 ether;

    function setUp() public {
        DeployFundMe deployFundMe = new DeployFundMe();
        f = deployFundMe.run();
        //this is how you give user fake balance in tests
        vm.deal(USER, DEFAULT_BALANCE);
    }
    function testMinimumUsdIsFive() public {
        assertEq(f.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(f.i_owner(), msg.sender);
    }

    function testVersionIsCorrect() public {
        uint256 version = f.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        f.fund();
    }

    function testFundUpdatesFundersDataStructure() public {
        vm.prank(USER);
        f.fund{ value: ETHER_AMOUNT }();

        uint256 amountFunded = f.getAddressToAmountFunderd(USER);

        assertEq(amountFunded, ETHER_AMOUNT);
    }
}