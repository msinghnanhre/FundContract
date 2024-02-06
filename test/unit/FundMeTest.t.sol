//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../../src/FundMe.sol";
import { DeployFundMe } from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
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
    function testMinimumUsdIsFive() public {
        assertGt(ETHER_AMOUNT, f.MINIMUM_USD());
    }

    function testOwnerIsMsgSender() public {
        assertEq(f.getOwner(), msg.sender);
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

    function testAddFunderToArrayOfFunders() public {
        vm.prank(USER);
        f.fund{ value: ETHER_AMOUNT }();

        address funder = f.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        f.fund{ value: ETHER_AMOUNT }();
        _;
    }

    function testOnlyOwnerCanWithdrawFunds() public funded {
        vm.expectRevert();
        vm.prank(USER);
        f.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        uint256 startingOwnerBalance = f.getOwner().balance;
        uint256 startingFundMeBalance = address(f).balance;

        vm.prank(f.getOwner());
        f.withdraw();

        uint256 endingOwnerBalance = f.getOwner().balance;
        uint256 endingFundMeBalance = address(f).balance;

        assertEq(endingFundMeBalance, 0);
        assertGt(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
    }

    function testWithdrawWithMultipleFunders() public funded {

        uint160 numberOfAddress = 10;
        uint160 funderIndex = 1;

        for (uint160 i = funderIndex; i < numberOfAddress; i++) {
            hoax(address(i), ETHER_AMOUNT);
            f.fund{value: ETHER_AMOUNT}();
        }

        uint256 startingOwnerBalance = f.getOwner().balance;
        uint256 startingFundMeBalance = address(f).balance;

        // uint256 gasLeft = gasleft();
        // vm.txGasPrice(GAS_PRICE);
        vm.prank(f.getOwner());
        f.withdraw();
        // uint256 gasEnd = gasleft();

        //gasleft() is built in solity tells you how much gas is left in the current function

        // uint256 gasUsed = gasEnd - gasLeft * tx.gasprice;
        //tx.gasprice is built in solity tells you current gas price
        uint256 endingOwnerBalance = f.getOwner().balance;

        assert(address(f).balance == 0);
        assert(startingOwnerBalance + startingFundMeBalance == endingOwnerBalance);
 
    }

}