// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";

contract UpgradingTest is Test {
    function test_WhenUpgradingToANewImplementation() external {
        // It upgrades to a new implementation
        vm.skip(true);
    }

    modifier givenTheContractIsAtR1B1() {
        _;
    }

    function test_WhenUpgradingWithInitializeFrom() external givenTheContractIsAtR1B1 {
        // It Upgrades from v1.0.0 with `initializeFrom`
        // It The old `initialize` function fails during the upgrade
        // It initializeFrom succeeds
        // It protocol versions are updated correctly
        // It new settings are applied
        // It the original `initialize` function is disabled post-upgrade
        vm.skip(true);
    }

    modifier givenTheContractIsAtR1B2() {
        _;
    }

    function test_WhenUpgradingWithInitializeFrom2() external givenTheContractIsAtR1B2 {
        // It upgrades from v1.3.0 with `initializeFrom`
        // It The old `initialize` function fails during the upgrade
        // It initializeFrom succeeds
        // It protocol versions are updated correctly
        // It new settings are applied
        // It the original `initialize` function is disabled post-upgrade
        vm.skip(true);
    }

    modifier givenTheContractIsAtR1B3() {
        _;
    }

    function test_WhenUpgradingWithInitializeFrom3() external givenTheContractIsAtR1B3 {
        // It upgrades from R1 B3 with `initializeFrom`
        // It The old `initialize` function fails during the upgrade
        // It initializeFrom succeeds
        // It protocol versions are updated correctly
        // It new settings are applied
        // It the original `initialize` function is disabled post-upgrade
        vm.skip(true);
    }
}
