// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {TestBase} from "./lib/TestBase.sol";

import {SimpleBuilder} from "./builders/SimpleBuilder.sol";
import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {DaoUnauthorized} from "@aragon/osx-commons-contracts/src/permission/auth/auth.sol";
import {TokenVotingSetup} from "../src/TokenVotingSetup.sol";
import {TokenVoting} from "../src/TokenVoting.sol";

contract TokenVotingSetupTest is TestBase {
    function test_WhenCallingSupportsInterface0xffffffff() external {
        // It does not support the empty interface
        vm.skip(true);
    }

    function test_WhenCallingGovernanceERC20BaseAndGovernanceWrappedERC20BaseAfterInitialization() external {
        // It stores the bases provided through the constructor
        vm.skip(true);
    }

    modifier givenTheContextIsPrepareInstallation() {
        _;
    }

    function test_WhenCallingPrepareInstallationWithDataThatIsEmptyOrNotOfMinimumLength()
        external
        givenTheContextIsPrepareInstallation
    {
        // It fails if data is empty, or not of minimum length
        vm.skip(true);
    }

    function test_WhenCallingPrepareInstallationIfMintSettingsArraysDoNotHaveTheSameLength()
        external
        givenTheContextIsPrepareInstallation
    {
        // It fails if `MintSettings` arrays do not have the same length
        vm.skip(true);
    }

    function test_WhenCallingPrepareInstallationIfPassedTokenAddressIsNotAContract()
        external
        givenTheContextIsPrepareInstallation
    {
        // It fails if passed token address is not a contract
        vm.skip(true);
    }

    function test_WhenCallingPrepareInstallationIfPassedTokenAddressIsNotERC20()
        external
        givenTheContextIsPrepareInstallation
    {
        // It fails if passed token address is not ERC20
        vm.skip(true);
    }

    function test_WhenCallingPrepareInstallationAndAnERC20TokenAddressIsSupplied()
        external
        givenTheContextIsPrepareInstallation
    {
        // It correctly returns plugin, helpers and permissions, when an ERC20 token address is supplied
        vm.skip(true);
    }

    function test_WhenCallingPrepareInstallationAndAnERC20TokenAddressIsSupplied2()
        external
        givenTheContextIsPrepareInstallation
    {
        // It correctly sets up `GovernanceWrappedERC20` helper, when an ERC20 token address is supplied
        vm.skip(true);
    }

    function test_WhenCallingPrepareInstallationAndAGovernanceTokenAddressIsSupplied()
        external
        givenTheContextIsPrepareInstallation
    {
        // It correctly returns plugin, helpers and permissions, when a governance token address is supplied
        vm.skip(true);
    }

    function test_WhenCallingPrepareInstallationAndATokenAddressIsNotSupplied()
        external
        givenTheContextIsPrepareInstallation
    {
        // It correctly returns plugin, helpers and permissions, when a token address is not supplied
        vm.skip(true);
    }

    function test_WhenCallingPrepareInstallationAndATokenAddressIsNotPassed()
        external
        givenTheContextIsPrepareInstallation
    {
        // It correctly sets up the plugin and helpers, when a token address is not passed
        vm.skip(true);
    }

    modifier givenTheContextIsPrepareUpdate() {
        _;
    }

    function test_WhenCallingPrepareUpdateForAnUpdateFromBuild1() external givenTheContextIsPrepareUpdate {
        // It returns the permissions expected for the update from build 1
        vm.skip(true);
    }

    function test_WhenCallingPrepareUpdateForAnUpdateFromBuild2() external givenTheContextIsPrepareUpdate {
        // It returns the permissions expected for the update from build 2
        vm.skip(true);
    }

    function test_WhenCallingPrepareUpdateForAnUpdateFromBuild3() external givenTheContextIsPrepareUpdate {
        // It returns the permissions expected for the update from build 3 (empty list)
        vm.skip(true);
    }

    modifier givenTheContextIsPrepareUninstallation() {
        _;
    }

    function test_WhenCallingPrepareUninstallationAndHelpersContainAGovernanceWrappedERC20Token()
        external
        givenTheContextIsPrepareUninstallation
    {
        // It correctly returns permissions, when the required number of helpers is supplied
        vm.skip(true);
    }

    function test_WhenCallingPrepareUninstallationAndHelpersContainAGovernanceERC20Token()
        external
        givenTheContextIsPrepareUninstallation
    {
        // It correctly returns permissions, when the required number of helpers is supplied
        vm.skip(true);
    }
}
