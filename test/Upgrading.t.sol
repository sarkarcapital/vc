// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";

contract UpgradingTest is Test {
    function test_WhenUpgradingToANewImplementation() external {
        // It upgrades to a new implementation
        vm.skip(true);
    }

    modifier givenTheContractIsAtV100() {
        _;
    }

    function test_WhenUpgradingWithInitializeFrom() external givenTheContractIsAtV100 {
        // It Upgrades from v1.0.0 with `initializeFrom`
        // It The old `initialize` function fails during the upgrade
        // It initializeFrom succeeds
        // It protocol versions are updated correctly
        // It new settings are applied
        // It the original `initialize` function is disabled post-upgrade
        vm.skip(true);
    }

    modifier givenTheContractIsAtV130() {
        _;
    }

    function test_WhenUpgradingWithInitializeFrom2() external givenTheContractIsAtV130 {
        // It upgrades from v1.3.0 with `initializeFrom`
        // It The old `initialize` function fails during the upgrade
        // It initializeFrom succeeds
        // It protocol versions are updated correctly
        // It new settings are applied
        // It the original `initialize` function is disabled post-upgrade
        vm.skip(true);
    }
}
