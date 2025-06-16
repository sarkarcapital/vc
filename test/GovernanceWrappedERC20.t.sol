// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";

contract GovernanceWrappedERC20Test is Test {
    modifier givenTheContractIsAlreadyInitialized() {
        _;
    }

    function test_WhenCallingInitializeAgain() external givenTheContractIsAlreadyInitialized {
        // It reverts if trying to re-initialize
        vm.skip(true);
    }

    function test_WhenCheckingTheContractsNameAndSymbol() external givenTheContractIsAlreadyInitialized {
        // It sets the wrapped token name and symbol
        vm.skip(true);
    }

    function test_WhenCheckingTheContractsDecimalsWithoutModification() external givenTheContractIsAlreadyInitialized {
        // It should return default decimals if not modified
        vm.skip(true);
    }

    function test_WhenCheckingTheContractsDecimalsAfterModification() external givenTheContractIsAlreadyInitialized {
        // It should return modified decimals
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

    function test_WhenCallingSupportsInterfaceWithTheIGovernanceWrappedERC20Interface()
        external
        givenTheContractIsDeployed
    {
        // It supports the `IGovernanceWrappedERC20` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceWithTheIERC20UpgradeableInterface() external givenTheContractIsDeployed {
        // It supports the `IERC20Upgradeable` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceWithTheIERC20PermitUpgradeableInterface()
        external
        givenTheContractIsDeployed
    {
        // It supports the `IERC20PermitUpgradeable` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceWithTheIVotesUpgradeableInterface() external givenTheContractIsDeployed {
        // It supports the `IVotesUpgradeable` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceWithTheIERC20MetadataUpgradeableInterface()
        external
        givenTheContractIsDeployed
    {
        // It supports the `IERC20MetadataUpgradeable` interface
        vm.skip(true);
    }

    modifier givenTheContractIsDeployed2() {
        _;
    }

    modifier givenTheDepositAmountIsNotApproved() {
        _;
    }

    function test_WhenCallingDepositFor() external givenTheContractIsDeployed2 givenTheDepositAmountIsNotApproved {
        // It reverts if the amount is not approved
        vm.skip(true);
    }

    modifier givenTheDepositAmountIsApproved() {
        _;
    }

    function test_WhenCallingDepositFor2() external givenTheContractIsDeployed2 givenTheDepositAmountIsApproved {
        // It deposits an amount of tokens
        vm.skip(true);
    }

    modifier givenTheFullBalanceIsApprovedForDeposit() {
        _;
    }

    function test_WhenCallingDepositForWithTheFullBalance()
        external
        givenTheContractIsDeployed2
        givenTheFullBalanceIsApprovedForDeposit
    {
        // It updates the available votes
        vm.skip(true);
    }

    modifier givenTokensHaveBeenDeposited() {
        _;
    }

    function test_WhenCallingWithdrawTo() external givenTokensHaveBeenDeposited {
        // It withdraws an amount of tokens
        vm.skip(true);
    }

    function test_WhenCallingWithdrawToForTheFullBalance() external givenTokensHaveBeenDeposited {
        // It updates the available votes
        vm.skip(true);
    }

    modifier givenTokensHaveBeenDepositedAndApprovedForAllHolders() {
        _;
    }

    function test_WhenCallingDelegate() external givenTokensHaveBeenDepositedAndApprovedForAllHolders {
        // It delegates voting power to another account
        vm.skip(true);
    }

    function test_WhenCallingDelegateMultipleTimes() external givenTokensHaveBeenDepositedAndApprovedForAllHolders {
        // It is checkpointed
        vm.skip(true);
    }

    modifier givenAFreshTokenContractIsDeployedAndBalancesAreSet() {
        _;
    }

    function test_WhenMintingTokensForAUser() external givenAFreshTokenContractIsDeployedAndBalancesAreSet {
        // It turns on delegation after mint
        vm.skip(true);
    }

    function test_WhenTransferringTokensToAUserForTheFirstTime()
        external
        givenAFreshTokenContractIsDeployedAndBalancesAreSet
    {
        // It turns on delegation for the `to` address after transfer
        vm.skip(true);
    }

    function test_WhenTransferringTokensThroughAChainOfUsers()
        external
        givenAFreshTokenContractIsDeployedAndBalancesAreSet
    {
        // It turns on delegation for all users in the chain of transfer A => B => C
        vm.skip(true);
    }

    modifier givenTheRecipientHasManuallyTurnedDelegationOff() {
        _;
    }

    function test_WhenTransferringTokensToTheRecipient()
        external
        givenAFreshTokenContractIsDeployedAndBalancesAreSet
        givenTheRecipientHasManuallyTurnedDelegationOff
    {
        // It should not turn on delegation on `transfer` if `to` manually turned it off
        vm.skip(true);
    }

    function test_WhenMintingTokensForTheRecipient()
        external
        givenAFreshTokenContractIsDeployedAndBalancesAreSet
        givenTheRecipientHasManuallyTurnedDelegationOff
    {
        // It should not turn on delegation on `mint` if `to` manually turned it off
        vm.skip(true);
    }

    modifier givenTheUserHasSetADelegateBeforeReceivingTokens() {
        _;
    }

    function test_WhenTransferringTokensToTheUser()
        external
        givenAFreshTokenContractIsDeployedAndBalancesAreSet
        givenTheUserHasSetADelegateBeforeReceivingTokens
    {
        // It should not rewrite delegation setting for `transfer` if user set it on before receiving tokens
        vm.skip(true);
    }

    function test_WhenMintingTokensForTheUser()
        external
        givenAFreshTokenContractIsDeployedAndBalancesAreSet
        givenTheUserHasSetADelegateBeforeReceivingTokens
    {
        // It should not rewrite delegation setting for `mint` if user set it on before receiving tokens
        vm.skip(true);
    }

    modifier givenDelegationWasTurnedOnInThePast() {
        _;
    }

    function test_WhenMintingMoreTokens()
        external
        givenAFreshTokenContractIsDeployedAndBalancesAreSet
        givenDelegationWasTurnedOnInThePast
    {
        // It should not turn on delegation on `mint` if it was turned on at least once in the past
        vm.skip(true);
    }

    function test_WhenTransferringTokens()
        external
        givenAFreshTokenContractIsDeployedAndBalancesAreSet
        givenDelegationWasTurnedOnInThePast
    {
        // It should not turn on delegation on `transfer` if it was turned on at least once in the past
        vm.skip(true);
    }

    modifier givenDelegationIsTurnedOnForTheSender() {
        _;
    }

    function test_WhenTransferringTokens2()
        external
        givenAFreshTokenContractIsDeployedAndBalancesAreSet
        givenDelegationIsTurnedOnForTheSender
    {
        // It updates voting power after transfer for `from` if delegation turned on
        vm.skip(true);
    }

    modifier givenDelegationIsTurnedOnForTheRecipient() {
        _;
    }

    function test_WhenTransferringTokens3()
        external
        givenAFreshTokenContractIsDeployedAndBalancesAreSet
        givenDelegationIsTurnedOnForTheRecipient
    {
        // It updates voting power after transfer for `to` if delegation turned on
        vm.skip(true);
    }

    modifier givenAnExhaustiveTestSetupForTokenTransfers() {
        _;
    }

    modifier givenTheToAddressHasAZeroBalance() {
        _;
    }

    modifier givenTheToAddressHasDelegatedToOther() {
        _;
    }

    function test_WhenToReceivesTokensViaDepositFor()
        external
        givenAnExhaustiveTestSetupForTokenTransfers
        givenTheToAddressHasAZeroBalance
        givenTheToAddressHasDelegatedToOther
    {
        // It `to` has the correct voting power
        // It `to`s delegate has not changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    function test_WhenToReceivesTokensViaTransferFromFrom()
        external
        givenAnExhaustiveTestSetupForTokenTransfers
        givenTheToAddressHasAZeroBalance
        givenTheToAddressHasDelegatedToOther
    {
        // It `from` has the correct voting power
        // It `from`s delegate has not changed
        // It `from`s delegate has the correct voting power
        // It `to` has the correct voting power
        // It `to`s delegate has not changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    modifier givenTheToAddressHasNotDelegatedBefore() {
        _;
    }

    function test_WhenToReceivesTokensViaDepositFor2()
        external
        givenAnExhaustiveTestSetupForTokenTransfers
        givenTheToAddressHasAZeroBalance
        givenTheToAddressHasNotDelegatedBefore
    {
        // It `to` has the correct voting power
        // It `to`s delegate has not changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    function test_WhenToReceivesTokensViaTransferFromFrom2()
        external
        givenAnExhaustiveTestSetupForTokenTransfers
        givenTheToAddressHasAZeroBalance
        givenTheToAddressHasNotDelegatedBefore
    {
        // It `from` has the correct voting power
        // It `from`s delegate has not changed
        // It `from`s delegate has the correct voting power
        // It `to` has the correct voting power
        // It `to`s delegate has not changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    modifier givenTheToAddressHasANonzeroBalance() {
        _;
    }

    modifier givenTheToAddressHasDelegatedToOther2() {
        _;
    }

    modifier whenToReceivesMoreTokensViaDepositFor() {
        _;
    }

    function test_WhenToThenTransfersTokensToOther()
        external
        givenAnExhaustiveTestSetupForTokenTransfers
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasDelegatedToOther2
        whenToReceivesMoreTokensViaDepositFor
    {
        // It `to` has the correct voting power
        // It `to`s delegate has not changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    function test_WhenToThenRedelegatesToOther()
        external
        givenAnExhaustiveTestSetupForTokenTransfers
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasDelegatedToOther2
        whenToReceivesMoreTokensViaDepositFor
    {
        // It `to` has the correct voting power
        // It `to`s delegate is correctly changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    modifier whenToReceivesMoreTokensViaTransferFromFrom() {
        _;
    }

    function test_WhenToThenTransfersTokensToOther2()
        external
        givenAnExhaustiveTestSetupForTokenTransfers
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasDelegatedToOther2
        whenToReceivesMoreTokensViaTransferFromFrom
    {
        // It `to` has the correct voting power
        // It `to`s delegate has not changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    function test_WhenToThenRedelegatesToOther2()
        external
        givenAnExhaustiveTestSetupForTokenTransfers
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasDelegatedToOther2
        whenToReceivesMoreTokensViaTransferFromFrom
    {
        // It `to` has the correct voting power
        // It `to`s delegate is correctly changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    modifier givenTheToAddressHasNotDelegatedBeforeReceivingAnInitialBalance() {
        _;
    }

    modifier whenToReceivesMoreTokensViaDepositFor2() {
        _;
    }

    function test_WhenToThenTransfersTokensToOther3()
        external
        givenAnExhaustiveTestSetupForTokenTransfers
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasNotDelegatedBeforeReceivingAnInitialBalance
        whenToReceivesMoreTokensViaDepositFor2
    {
        // It `to` has the correct voting power
        // It `to`s delegate has not changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    function test_WhenToThenDelegatesToOther()
        external
        givenAnExhaustiveTestSetupForTokenTransfers
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasNotDelegatedBeforeReceivingAnInitialBalance
        whenToReceivesMoreTokensViaDepositFor2
    {
        // It `to` has the correct voting power
        // It `to`s delegate is correctly changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    modifier whenToReceivesMoreTokensViaTransferFromFrom2() {
        _;
    }

    function test_WhenToThenTransfersTokensToOther4()
        external
        givenAnExhaustiveTestSetupForTokenTransfers
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasNotDelegatedBeforeReceivingAnInitialBalance
        whenToReceivesMoreTokensViaTransferFromFrom2
    {
        // It `to` has the correct voting power
        // It `to`s delegate has not changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    function test_WhenToThenDelegatesToOther2()
        external
        givenAnExhaustiveTestSetupForTokenTransfers
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasNotDelegatedBeforeReceivingAnInitialBalance
        whenToReceivesMoreTokensViaTransferFromFrom2
    {
        // It `to` has the correct voting power
        // It `to`s delegate is correctly changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }
}
