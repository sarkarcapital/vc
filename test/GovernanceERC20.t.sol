// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";

contract GovernanceERC20Test is Test {
    modifier givenTheContractIsDeployedWithDefaultMintSettings() {
        _;
    }

    function test_WhenCallingInitializeAgain() external givenTheContractIsDeployedWithDefaultMintSettings {
        // It reverts if trying to re-initialize
        vm.skip(true);
    }

    function test_WhenCheckingTheTokenNameAndSymbol() external givenTheContractIsDeployedWithDefaultMintSettings {
        // It sets the token name and symbol
        vm.skip(true);
    }

    function test_WhenCheckingTheManagingDAO() external givenTheContractIsDeployedWithDefaultMintSettings {
        // It sets the managing DAO
        vm.skip(true);
    }

    function test_WhenDeployingWithMismatchedReceiversAndAmountsArrays()
        external
        givenTheContractIsDeployedWithDefaultMintSettings
    {
        // It reverts if the `receivers` and `amounts` array lengths in the mint settings mismatch
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

    function test_WhenCallingSupportsInterfaceWithAllInheritedInterfaces() external givenTheContractIsDeployed {
        // It it supports all inherited interfaces
        vm.skip(true);
    }

    modifier givenTheContractIsDeployed2() {
        _;
    }

    modifier givenTheCallerIsMissingTheMINTPERMISSIONID() {
        _;
    }

    function test_WhenCallingMint() external givenTheContractIsDeployed2 givenTheCallerIsMissingTheMINTPERMISSIONID {
        // It reverts if the `MINT_PERMISSION_ID` permission is missing
        vm.skip(true);
    }

    modifier givenTheCallerHasTheMINTPERMISSIONID() {
        _;
    }

    function test_WhenCallingMint2() external givenTheContractIsDeployed2 givenTheCallerHasTheMINTPERMISSIONID {
        // It mints tokens if the caller has the `mintPermission`
        vm.skip(true);
    }

    modifier givenTheContractIsDeployedWithInitialBalances() {
        _;
    }

    function test_WhenDelegatingVotingPowerToAnotherAccount() external givenTheContractIsDeployedWithInitialBalances {
        // It delegates voting power to another account
        vm.skip(true);
    }

    function test_WhenDelegatingVotingPowerMultipleTimes() external givenTheContractIsDeployedWithInitialBalances {
        // It is checkpointed
        vm.skip(true);
    }

    modifier givenATokenIsDeployedAndTheMainSignerCanMint() {
        _;
    }

    function test_WhenMintingTokensToAnAddressForTheFirstTime() external givenATokenIsDeployedAndTheMainSignerCanMint {
        // It turns on delegation after mint
        vm.skip(true);
    }

    function test_WhenTransferringTokensToAnAddressForTheFirstTime()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint
    {
        // It turns on delegation for the `to` address after transfer
        vm.skip(true);
    }

    function test_WhenPerformingAChainOfTransfersABC() external givenATokenIsDeployedAndTheMainSignerCanMint {
        // It turns on delegation for all users in the chain of transfer A => B => C
        vm.skip(true);
    }

    modifier givenTheReceiverHasManuallyTurnedOffDelegation() {
        _;
    }

    function test_WhenTransferringTokensToTheReceiver()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint
        givenTheReceiverHasManuallyTurnedOffDelegation
    {
        // It should not turn on delegation on `transfer` if `to` manually turned it off
        vm.skip(true);
    }

    function test_WhenMintingTokensToTheReceiver()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint
        givenTheReceiverHasManuallyTurnedOffDelegation
    {
        // It should not turn on delegation on `mint` if `to` manually turned it off
        vm.skip(true);
    }

    modifier givenAUserHasPredelegatedBeforeReceivingTokens() {
        _;
    }

    function test_WhenTransferringTokensToTheUser()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint
        givenAUserHasPredelegatedBeforeReceivingTokens
    {
        // It should not rewrite delegation setting for `transfer` if user set it on before receiving tokens
        vm.skip(true);
    }

    function test_WhenMintingTokensToTheUser()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint
        givenAUserHasPredelegatedBeforeReceivingTokens
    {
        // It should not rewrite delegation setting for `mint` if user set it on before receiving tokens
        vm.skip(true);
    }

    modifier givenDelegationWasTurnedOnInThePast() {
        _;
    }

    function test_WhenMintingMoreTokens()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint
        givenDelegationWasTurnedOnInThePast
    {
        // It should not turn on delegation on `mint` if it was turned on at least once in the past
        vm.skip(true);
    }

    function test_WhenTransferringMoreTokens()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint
        givenDelegationWasTurnedOnInThePast
    {
        // It should not turn on delegation on `transfer` if it was turned on at least once in the past
        vm.skip(true);
    }

    function test_WhenTransferringTokensFromAnAddressWithDelegationTurnedOn()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint
    {
        // It updates voting power after transfer for `from` if delegation turned on
        vm.skip(true);
    }

    function test_WhenTransferringTokensToAnAddressWithDelegationTurnedOn()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint
    {
        // It updates voting power after transfer for `to` if delegation turned on
        vm.skip(true);
    }

    modifier givenATokenIsDeployedAndTheMainSignerCanMint2() {
        _;
    }

    modifier givenTheToAddressHasAZeroBalance() {
        _;
    }

    modifier givenTheToAddressHasDelegatedToOther() {
        _;
    }

    function test_WhenTheToAddressReceivesTokensViaMint()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint2
        givenTheToAddressHasAZeroBalance
        givenTheToAddressHasDelegatedToOther
    {
        // It `to` has the correct voting power
        // It `to`s delegate has not changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    function test_WhenTheToAddressReceivesTokensViaTransferFromFrom()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint2
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

    function test_WhenTheToAddressReceivesTokensViaMint2()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint2
        givenTheToAddressHasAZeroBalance
        givenTheToAddressHasNotDelegatedBefore
    {
        // It `to` has the correct voting power
        // It `to`s delegate has not changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    function test_WhenTheToAddressReceivesTokensViaTransferFromFrom2()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint2
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

    modifier whenTheToAddressReceivesTokensViaMint3() {
        _;
    }

    function test_WhenTheToAddressThenTransfersToOther()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint2
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasDelegatedToOther2
        whenTheToAddressReceivesTokensViaMint3
    {
        // It `to` has the correct voting power
        // It `to`s delegate has not changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    function test_WhenTheToAddressThenDelegatesToOtherAgain()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint2
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasDelegatedToOther2
        whenTheToAddressReceivesTokensViaMint3
    {
        // It `to` has the correct voting power
        // It `to`s delegate is correctly changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    modifier whenTheToAddressReceivesTokensViaTransferFromFrom3() {
        _;
    }

    function test_WhenTheToAddressThenTransfersToOther2()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint2
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasDelegatedToOther2
        whenTheToAddressReceivesTokensViaTransferFromFrom3
    {
        // It `to` has the correct voting power
        // It `to`s delegate has not changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    function test_WhenTheToAddressThenDelegatesToOtherAgain2()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint2
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasDelegatedToOther2
        whenTheToAddressReceivesTokensViaTransferFromFrom3
    {
        // It `to` has the correct voting power
        // It `to`s delegate is correctly changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    modifier givenTheToAddressHasNotDelegatedBefore2() {
        _;
    }

    modifier whenTheToAddressReceivesTokensViaMint4() {
        _;
    }

    function test_WhenTheToAddressThenTransfersToOther3()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint2
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasNotDelegatedBefore2
        whenTheToAddressReceivesTokensViaMint4
    {
        // It `to` has the correct voting power
        // It `to`s delegate has not changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    function test_WhenTheToAddressThenDelegatesToOther()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint2
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasNotDelegatedBefore2
        whenTheToAddressReceivesTokensViaMint4
    {
        // It `to` has the correct voting power
        // It `to`s delegate is correctly changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    modifier whenTheToAddressReceivesTokensViaTransferFromFrom4() {
        _;
    }

    function test_WhenTheToAddressThenTransfersToOther4()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint2
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasNotDelegatedBefore2
        whenTheToAddressReceivesTokensViaTransferFromFrom4
    {
        // It `to` has the correct voting power
        // It `to`s delegate has not changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }

    function test_WhenTheToAddressThenDelegatesToOther2()
        external
        givenATokenIsDeployedAndTheMainSignerCanMint2
        givenTheToAddressHasANonzeroBalance
        givenTheToAddressHasNotDelegatedBefore2
        whenTheToAddressReceivesTokensViaTransferFromFrom4
    {
        // It `to` has the correct voting power
        // It `to`s delegate is correctly changed
        // It `to`s delegate has the correct voting power
        vm.skip(true);
    }
}
