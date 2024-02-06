//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../../src/FundMe.sol";
import { DeployFundMe } from "../../script/DeployFundMe.s.sol";

import { FundFundMe, WithdrawFundMe } from "../../script/Interactions.s.sol";

contract FundMeTestIntegration is Test {
       FundMe f;

    //mock an address in cases where we need to have a consistent address
    address USER = makeAddr("User");
    uint256 ETHER_AMOUNT = 0.1 ether;
    uint256 GAS_PRICE = 1;
    

    //give user default funds to ensure its never out of balalnce
    uint256 DEFAULT_BALANCE = 10 ether;

    function setUp() public {
        DeployFundMe deployFundMe = new DeployFundMe();
        f = deployFundMe.run();
        //this is how you give user fake balance in tests
        vm.deal(USER, DEFAULT_BALANCE);
    }

    // function testUserCanFund() public {
    //     FundFundMe fundFundMe = new FundFundMe();
    //     vm.prank(USER);
    //     vm.deal(USER, 1e18);
    //     fundFundMe.fundFundMe(address(f));

    //     address funder = f.getFunder(0);
    //     assertEq(funder, USER);
    // }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        // vm.prank(USER);
        // vm.deal(USER, 1e18);
        fundFundMe.fundFundMe(address(f));
        withdrawFundMe.withdrawFundMe(address(f));

        assert(address(f).balance == 0);
    }
}