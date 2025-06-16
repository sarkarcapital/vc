// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";

contract MajorityVotingBaseTest is Test {
    modifier givenTheContractIsAlreadyInitialized() {
        _;
    }

    function test_WhenCallingInitialize() external givenTheContractIsAlreadyInitialized {
        // It reverts if trying to re-initialize
        vm.skip(true);
    }

    modifier givenTheContractIsDeployed() {
        _;
    }

    function test_WhenCallingSupportsInterfaceWithTheEmptyInterface() external givenTheContractIsDeployed {
        // It does not support the empty interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceWithTheIERC165UpgradeableInterface()
        external
        givenTheContractIsDeployed
    {
        // It supports the `IERC165Upgradeable` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceWithTheIPluginInterface() external givenTheContractIsDeployed {
        // It supports the `IPlugin` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceWithTheIProtocolVersionInterface() external givenTheContractIsDeployed {
        // It supports the `IProtocolVersion` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceWithTheIProposalInterface() external givenTheContractIsDeployed {
        // It supports the `IProposal` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceWithTheIMajorityVotingInterface() external givenTheContractIsDeployed {
        // It supports the `IMajorityVoting` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceWithTheIMajorityVotingOLDInterface()
        external
        givenTheContractIsDeployed
    {
        // It supports the `IMajorityVoting` OLD interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceWithTheMajorityVotingBaseInterface()
        external
        givenTheContractIsDeployed
    {
        // It supports the `MajorityVotingBase` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceWithTheMajorityVotingBaseOLDInterface()
        external
        givenTheContractIsDeployed
    {
        // It supports the `MajorityVotingBase` OLD interface
        vm.skip(true);
    }

    modifier givenThePluginIsInitialized() {
        _;
    }

    modifier givenTheCallerIsUnauthorized() {
        _;
    }

    function test_WhenCallingUpdateVotingSettings() external givenThePluginIsInitialized givenTheCallerIsUnauthorized {
        // It reverts if caller is unauthorized
        vm.skip(true);
    }

    function test_WhenCallingUpdateVotingSettingsWhereSupportThresholdEquals100()
        external
        givenThePluginIsInitialized
    {
        // It reverts if the support threshold specified equals 100%
        vm.skip(true);
    }

    function test_WhenCallingUpdateVotingSettingsWhereSupportThresholdExceeds100()
        external
        givenThePluginIsInitialized
    {
        // It reverts if the support threshold specified exceeds 100%
        vm.skip(true);
    }

    function test_WhenCallingUpdateVotingSettingsWhereSupportThresholdEquals1002()
        external
        givenThePluginIsInitialized
    {
        // It reverts if the support threshold specified equals 100%
        vm.skip(true);
    }

    function test_WhenCallingUpdateVotingSettingsWhereMinimumParticipationExceeds100()
        external
        givenThePluginIsInitialized
    {
        // It reverts if the minimum participation specified exceeds 100%
        vm.skip(true);
    }

    function test_WhenCallingUpdateVotingSettingsWhereMinimalDurationIsShorterThanOneHour()
        external
        givenThePluginIsInitialized
    {
        // It reverts if the minimal duration is shorter than one hour
        vm.skip(true);
    }

    function test_WhenCallingUpdateVotingSettingsWhereMinimalDurationIsLongerThanOneYear()
        external
        givenThePluginIsInitialized
    {
        // It reverts if the minimal duration is longer than one year
        vm.skip(true);
    }

    function test_WhenCallingUpdateVotingSettings2() external givenThePluginIsInitialized {
        // It should change the voting settings successfully
        vm.skip(true);
    }

    modifier givenThePluginIsInitialized2() {
        _;
    }

    modifier givenTheCallerIsUnauthorized2() {
        _;
    }

    function test_WhenCallingUpdateMinApprovals() external givenThePluginIsInitialized2 givenTheCallerIsUnauthorized2 {
        // It reverts if caller is unauthorized
        vm.skip(true);
    }

    function test_WhenCallingUpdateMinApprovalsWhereTheMinimumApprovalExceeds100()
        external
        givenThePluginIsInitialized2
    {
        // It reverts if the minimum approval specified exceeds 100%
        vm.skip(true);
    }

    function test_WhenCallingUpdateMinApprovals2() external givenThePluginIsInitialized2 {
        // It should change the minimum approval successfully
        vm.skip(true);
    }

    modifier givenThePluginIsInitializedAndTheCallerHasTheSETTARGETCONFIGPERMISSIONID() {
        _;
    }

    function test_WhenCallingSetTargetConfig()
        external
        givenThePluginIsInitializedAndTheCallerHasTheSETTARGETCONFIGPERMISSIONID
    {
        // It should change the target config successfully
        vm.skip(true);
    }
}
