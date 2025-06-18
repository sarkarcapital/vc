// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {TestBase} from "./lib/TestBase.sol";

import {SimpleBuilder} from "./builders/SimpleBuilder.sol";
import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {DaoUnauthorized} from "@aragon/osx-commons-contracts/src/permission/auth/auth.sol";
import {TokenVotingSetup} from "../src/TokenVotingSetup.sol";
import {TokenVoting} from "../src/TokenVoting.sol";

contract TokenVotingTest is TestBase {
    DAO dao;
    TokenVoting plugin;

    modifier givenInTheInitializeContext() {
        // Setup shared across initialize tests
        (dao,, token) = new SimpleBuilder().withDaoOwner(alice).build();
        _;
    }

    function test_WhenCallingInitializeOnAnAlreadyInitializedPlugin() external {
        // GIVEN an already initialized plugin
        (dao, plugin,) = new SimpleBuilder().withDaoOwner(alice).build();

        // WHEN calling initialize again
        // THEN it reverts
        vm.expectRevert(PluginUUPSUpgradeable.AlreadyInitialized.selector);
        plugin.initialize(
            dao,
            MajorityVotingBase.VotingSettings({
                votingMode: MajorityVotingBase.VotingMode.Standard,
                supportThreshold: 500_000,
                minParticipation: 100_000,
                minDuration: ONE_HOUR,
                minProposerVotingPower: 0
            }),
            plugin.getVotingToken(),
            IPlugin.TargetConfig(address(dao), IPlugin.Operation.Call),
            0,
            ""
        );
    }

    function test_WhenCallingInitializeOnAnUninitializedPlugin() external {
        // GIVEN an uninitialized plugin proxy
        address base = address(new TokenVoting());
        (dao,,) = new SimpleBuilder().withDaoOwner(alice).withNewToken(new address[](0), new uint256[](0)).build();
        token = plugin.getVotingToken();

        address proxy = ProxyLib.deployUUPSProxy(base, "");
        plugin = TokenVoting(proxy);

        // WHEN calling initialize
        MajorityVotingBase.VotingSettings memory settings = MajorityVotingBase.VotingSettings({
            votingMode: MajorityVotingBase.VotingMode.EarlyExecution,
            supportThreshold: 400_000, // 40%
            minParticipation: 200_000, // 20%
            minDuration: ONE_DAY,
            minProposerVotingPower: 1 ether
        });
        uint256 minApprovals = 100_000; // 10%
        bytes memory metadata = "ipfs://1234";

        vm.expectEmit(true, true, true, true, address(plugin));
        emit IMembership.MembershipContractAnnounced(address(token));

        plugin.initialize(
            dao, settings, token, IPlugin.TargetConfig(address(dao), IPlugin.Operation.Call), minApprovals, metadata
        );

        // THEN it sets the voting settings, token, minimal approval and metadata
        assertEq(uint8(plugin.votingMode()), uint8(settings.votingMode));
        assertEq(plugin.supportThreshold(), settings.supportThreshold);
        assertEq(plugin.minParticipation(), settings.minParticipation);
        assertEq(plugin.minDuration(), settings.minDuration);
        assertEq(plugin.minProposerVotingPower(), settings.minProposerVotingPower);
        assertEq(address(plugin.getVotingToken()), address(token));
        assertEq(plugin.minApproval(), minApprovals);
    }

    modifier givenInTheERC165Context() {
        (dao, plugin,) = new SimpleBuilder().withDaoOwner(alice).build();
        _;
    }

    function test_WhenCallingSupportsInterface0xffffffff() external givenInTheERC165Context {
        // It does not support the empty interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceForIERC165Upgradeable() external givenInTheERC165Context {
        // It supports the `IERC165Upgradeable` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceForIPlugin() external givenInTheERC165Context {
        // It supports the `IPlugin` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceForIProtocolVersion() external givenInTheERC165Context {
        // It supports the `IProtocolVersion` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceForIProposal() external givenInTheERC165Context {
        // It supports the `IProposal` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceForIMembership() external givenInTheERC165Context {
        // It supports the `IMembership` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceForIMajorityVoting() external givenInTheERC165Context {
        // It supports the `IMajorityVoting` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceForTheOldIMajorityVoting() external givenInTheERC165Context {
        // It supports the `IMajorityVoting` OLD interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceForMajorityVotingBase() external givenInTheERC165Context {
        // It supports the `MajorityVotingBase` interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceForTheOldMajorityVotingBase() external givenInTheERC165Context {
        // It supports the `MajorityVotingBase` OLD interface
        vm.skip(true);
    }

    function test_WhenCallingSupportsInterfaceForTokenVoting() external givenInTheERC165Context {
        // It supports the `TokenVoting` interface
        vm.skip(true);
    }

    modifier givenInTheIsMemberContext() {
        _;
    }

    function test_WhenAnAccountOwnsAtLeastOneToken() external givenInTheIsMemberContext {
        // It returns true if the account currently owns at least one token
        vm.skip(true);
    }

    function test_WhenAnAccountHasAtLeastOneTokenDelegatedToThem() external givenInTheIsMemberContext {
        // It returns true if the account currently has at least one token delegated to her/him
        vm.skip(true);
    }

    modifier givenInTheIProposalInterfaceFunctionContextForProposalCreation() {
        _;
    }

    function test_WhenCreatingAProposalWithCustomEncodedData()
        external
        givenInTheIProposalInterfaceFunctionContextForProposalCreation
    {
        // It creates proposal with default values if `data` param is encoded with custom values
        vm.skip(true);
    }

    function test_WhenCreatingAProposalWithEmptyData()
        external
        givenInTheIProposalInterfaceFunctionContextForProposalCreation
    {
        // It creates proposal with default values if `data` param is passed as empty
        vm.skip(true);
    }

    modifier givenInTheProposalCreationContext() {
        _;
    }

    modifier givenMinProposerVotingPower0() {
        _;
    }

    function test_WhenTheCreatorHasNoVotingPower()
        external
        givenInTheProposalCreationContext
        givenMinProposerVotingPower0
    {
        // It creates a proposal if `_msgSender` owns no tokens and has no tokens delegated to her/him in the current block
        vm.skip(true);
    }

    modifier givenMinProposerVotingPower02() {
        _;
    }

    function test_WhenTheCreatorHasNoVotingPower2()
        external
        givenInTheProposalCreationContext
        givenMinProposerVotingPower02
    {
        // It reverts if `_msgSender` owns no tokens and has no tokens delegated to her/him in the current block
        vm.skip(true);
    }

    function test_WhenTheCreatorTransfersTheirVotingPowerAwayInTheSameBlock()
        external
        givenInTheProposalCreationContext
        givenMinProposerVotingPower02
    {
        // It reverts if `_msgSender` owns no tokens and has no tokens delegated to her/him in the current block although having them in the last block
        vm.skip(true);
    }

    function test_WhenTheCreatorOwnsEnoughTokens()
        external
        givenInTheProposalCreationContext
        givenMinProposerVotingPower02
    {
        // It creates a proposal if `_msgSender` owns enough tokens in the current block
        vm.skip(true);
    }

    function test_WhenTheCreatorOwnsEnoughTokensAndHasDelegatedThem()
        external
        givenInTheProposalCreationContext
        givenMinProposerVotingPower02
    {
        // It creates a proposal if `_msgSender` owns enough tokens and has delegated them to someone else in the current block
        vm.skip(true);
    }

    function test_WhenTheCreatorHasEnoughDelegatedTokens()
        external
        givenInTheProposalCreationContext
        givenMinProposerVotingPower02
    {
        // It creates a proposal if `_msgSender` owns no tokens but has enough tokens delegated to her/him in the current block
        vm.skip(true);
    }

    function test_WhenTheCreatorDoesNotHaveEnoughTokensOwnedOrDelegated()
        external
        givenInTheProposalCreationContext
        givenMinProposerVotingPower02
    {
        // It reverts if `_msgSender` does not own enough tokens herself/himself and has not tokens delegated to her/him in the current block
        vm.skip(true);
    }

    function test_WhenTheTotalTokenSupplyIs0() external givenInTheProposalCreationContext {
        // It reverts if the total token supply is 0
        vm.skip(true);
    }

    function test_WhenTheStartDateIsSmallerThanTheCurrentDate() external givenInTheProposalCreationContext {
        // It reverts if the start date is set smaller than the current date
        vm.skip(true);
    }

    function test_WhenTheStartDateWouldCauseAnOverflowWhenCalculatingTheEndDate()
        external
        givenInTheProposalCreationContext
    {
        // It panics if the start date is after the latest start date
        vm.skip(true);
    }

    function test_WhenTheEndDateIsBeforeTheMinimumDuration() external givenInTheProposalCreationContext {
        // It reverts if the end date is before the earliest end date so that min duration cannot be met
        vm.skip(true);
    }

    function test_WhenTheStartAndEndDatesAreProvidedAsZero() external givenInTheProposalCreationContext {
        // It sets the startDate to now and endDate to startDate + minDuration, if zeros are provided as an inputs
        vm.skip(true);
    }

    function test_WhenMinParticipationCalculationResultsInARemainder() external givenInTheProposalCreationContext {
        // It ceils the `minVotingPower` value if it has a remainder
        vm.skip(true);
    }

    function test_WhenMinParticipationCalculationDoesNotResultInARemainder()
        external
        givenInTheProposalCreationContext
    {
        // It does not ceil the `minVotingPower` value if it has no remainder
        vm.skip(true);
    }

    function test_WhenCreatingAProposalWithVoteOptionNone() external givenInTheProposalCreationContext {
        // It should create a proposal successfully, but not vote
        vm.skip(true);
    }

    function test_WhenCreatingAProposalWithAVoteOptionEgYes() external givenInTheProposalCreationContext {
        // It should create a vote and cast a vote immediately
        vm.skip(true);
    }

    function test_WhenCreatingAProposalWithAVoteOptionBeforeItsStartDate() external givenInTheProposalCreationContext {
        // It reverts creation when voting before the start date
        vm.skip(true);
    }

    modifier givenInTheStandardVotingMode() {
        _;
    }

    function test_WhenInteractingWithANonexistentProposal() external givenInTheStandardVotingMode {
        // It reverts if proposal does not exist
        vm.skip(true);
    }

    function test_WhenVotingBeforeTheProposalHasStarted() external givenInTheStandardVotingMode {
        // It does not allow voting, when the vote has not started yet
        vm.skip(true);
    }

    function test_WhenAUserWith0TokensTriesToVote() external givenInTheStandardVotingMode {
        // It should not be able to vote if user has 0 token
        vm.skip(true);
    }

    function test_WhenMultipleUsersVoteYesNoAndAbstain() external givenInTheStandardVotingMode {
        // It increases the yes, no, and abstain count and emits correct events
        vm.skip(true);
    }

    function test_WhenAUserTriesToVoteWithVoteOptionNone() external givenInTheStandardVotingMode {
        // It reverts on voting None
        vm.skip(true);
    }

    function test_WhenAUserTriesToReplaceTheirExistingVote() external givenInTheStandardVotingMode {
        // It reverts on vote replacement
        vm.skip(true);
    }

    function test_WhenAProposalMeetsExecutionCriteriaBeforeTheEndDate() external givenInTheStandardVotingMode {
        // It cannot early execute
        vm.skip(true);
    }

    function test_WhenAProposalMeetsParticipationAndSupportThresholdsAfterTheEndDate()
        external
        givenInTheStandardVotingMode
    {
        // It can execute normally if participation and support are met
        vm.skip(true);
    }

    function test_WhenVotingWithTheTryEarlyExecutionOption() external givenInTheStandardVotingMode {
        // It does not execute early when voting with the `tryEarlyExecution` option
        vm.skip(true);
    }

    function test_WhenTryingToExecuteAProposalThatIsNotYetDecided() external givenInTheStandardVotingMode {
        // It reverts if vote is not decided yet
        vm.skip(true);
    }

    function test_WhenTheCallerDoesNotHaveEXECUTEPROPOSALPERMISSIONID() external givenInTheStandardVotingMode {
        // It can not execute even if participation and support are met when caller does not have permission
        vm.skip(true);
    }

    modifier givenInTheEarlyExecutionVotingMode() {
        _;
    }

    function test_WhenInteractingWithANonexistentProposal2() external givenInTheEarlyExecutionVotingMode {
        // It reverts if proposal does not exist
        vm.skip(true);
    }

    function test_WhenVotingBeforeTheProposalHasStarted2() external givenInTheEarlyExecutionVotingMode {
        // It does not allow voting, when the vote has not started yet
        vm.skip(true);
    }

    function test_WhenAUserWith0TokensTriesToVote2() external givenInTheEarlyExecutionVotingMode {
        // It should not be able to vote if user has 0 token
        vm.skip(true);
    }

    function test_WhenMultipleUsersVoteYesNoAndAbstain2() external givenInTheEarlyExecutionVotingMode {
        // It increases the yes, no, and abstain count and emits correct events
        vm.skip(true);
    }

    function test_WhenAUserTriesToVoteWithVoteOptionNone2() external givenInTheEarlyExecutionVotingMode {
        // It reverts on voting None
        vm.skip(true);
    }

    function test_WhenAUserTriesToReplaceTheirExistingVote2() external givenInTheEarlyExecutionVotingMode {
        // It reverts on vote replacement
        vm.skip(true);
    }

    function test_WhenParticipationIsLargeEnoughToMakeTheOutcomeUnchangeable()
        external
        givenInTheEarlyExecutionVotingMode
    {
        // It can execute early if participation is large enough
        vm.skip(true);
    }

    function test_WhenParticipationAndSupportAreMetAfterTheVotingPeriodEnds()
        external
        givenInTheEarlyExecutionVotingMode
    {
        // It can execute normally if participation is large enough
        vm.skip(true);
    }

    function test_WhenParticipationIsTooLowEvenIfSupportIsMet() external givenInTheEarlyExecutionVotingMode {
        // It cannot execute normally if participation is too low
        vm.skip(true);
    }

    function test_WhenTheTargetOperationIsADelegatecall() external givenInTheEarlyExecutionVotingMode {
        // It executes target with delegate call
        vm.skip(true);
    }

    function test_WhenTheVoteIsDecidedEarlyAndTheTryEarlyExecutionOptionIsUsed()
        external
        givenInTheEarlyExecutionVotingMode
    {
        // It executes the vote immediately when the vote is decided early and the tryEarlyExecution options is selected
        vm.skip(true);
    }

    function test_WhenTryingToExecuteAProposalThatIsNotYetDecided2() external givenInTheEarlyExecutionVotingMode {
        // It reverts if vote is not decided yet
        vm.skip(true);
    }

    function test_WhenTheCallerHasNoExecutionPermissionButTryEarlyExecutionIsSelected()
        external
        givenInTheEarlyExecutionVotingMode
    {
        // It record vote correctly without executing even when tryEarlyExecution options is selected
        vm.skip(true);
    }

    modifier givenInTheVoteReplacementVotingMode() {
        _;
    }

    function test_WhenInteractingWithANonexistentProposal3() external givenInTheVoteReplacementVotingMode {
        // It reverts if proposal does not exist
        vm.skip(true);
    }

    function test_WhenVotingBeforeTheProposalHasStarted3() external givenInTheVoteReplacementVotingMode {
        // It does not allow voting, when the vote has not started yet
        vm.skip(true);
    }

    function test_WhenAUserWith0TokensTriesToVote3() external givenInTheVoteReplacementVotingMode {
        // It should not be able to vote if user has 0 token
        vm.skip(true);
    }

    function test_WhenMultipleUsersVoteYesNoAndAbstain3() external givenInTheVoteReplacementVotingMode {
        // It increases the yes, no, and abstain count and emits correct events
        vm.skip(true);
    }

    function test_WhenAUserTriesToVoteWithVoteOptionNone3() external givenInTheVoteReplacementVotingMode {
        // It reverts on voting None
        vm.skip(true);
    }

    function test_WhenAVoterChangesTheirVoteMultipleTimes() external givenInTheVoteReplacementVotingMode {
        // It should allow vote replacement but not double-count votes by the same address
        vm.skip(true);
    }

    function test_WhenAProposalMeetsExecutionCriteriaBeforeTheEndDate2() external givenInTheVoteReplacementVotingMode {
        // It cannot early execute
        vm.skip(true);
    }

    function test_WhenAProposalMeetsParticipationAndSupportThresholdsAfterTheEndDate2()
        external
        givenInTheVoteReplacementVotingMode
    {
        // It can execute normally if participation and support are met
        vm.skip(true);
    }

    function test_WhenVotingWithTheTryEarlyExecutionOption2() external givenInTheVoteReplacementVotingMode {
        // It does not execute early when voting with the `tryEarlyExecution` option
        vm.skip(true);
    }

    function test_WhenTryingToExecuteAProposalThatIsNotYetDecided3() external givenInTheVoteReplacementVotingMode {
        // It reverts if vote is not decided yet
        vm.skip(true);
    }

    modifier givenASimpleMajorityVoteWith50Support25ParticipationRequiredAndMinimalApproval21() {
        _;
    }

    function test_WhenSupportIsHighButParticipationIsTooLow()
        external
        givenASimpleMajorityVoteWith50Support25ParticipationRequiredAndMinimalApproval21
    {
        // It does not execute if support is high enough but participation is too low
        vm.skip(true);
    }

    function test_WhenSupportAndParticipationAreHighButMinimalApprovalIsTooLow()
        external
        givenASimpleMajorityVoteWith50Support25ParticipationRequiredAndMinimalApproval21
    {
        // It does not execute if support and participation are high enough but minimal approval is too low
        vm.skip(true);
    }

    function test_WhenParticipationIsHighButSupportIsTooLow()
        external
        givenASimpleMajorityVoteWith50Support25ParticipationRequiredAndMinimalApproval21
    {
        // It does not execute if participation is high enough but support is too low
        vm.skip(true);
    }

    function test_WhenParticipationAndMinimalApprovalAreHighButSupportIsTooLow()
        external
        givenASimpleMajorityVoteWith50Support25ParticipationRequiredAndMinimalApproval21
    {
        // It does not execute if participation and minimal approval are high enough but support is too low
        vm.skip(true);
    }

    function test_WhenAllThresholdsParticipationSupportMinimalApprovalAreMetAfterTheDuration()
        external
        givenASimpleMajorityVoteWith50Support25ParticipationRequiredAndMinimalApproval21
    {
        // It executes after the duration if participation, support and minimal approval are met
        vm.skip(true);
    }

    function test_WhenAllThresholdsAreMetAndTheOutcomeCannotChange()
        external
        givenASimpleMajorityVoteWith50Support25ParticipationRequiredAndMinimalApproval21
    {
        // It executes early if participation, support and minimal approval are met and the vote outcome cannot change anymore
        vm.skip(true);
    }

    modifier givenAnEdgeCaseWithSupportThreshold0MinParticipation0MinApproval0InEarlyExecutionMode() {
        _;
    }

    function test_WhenThereAre0Votes()
        external
        givenAnEdgeCaseWithSupportThreshold0MinParticipation0MinApproval0InEarlyExecutionMode
    {
        // It does not execute with 0 votes
        vm.skip(true);
    }

    function test_WhenThereIsAtLeastOneYesVote()
        external
        givenAnEdgeCaseWithSupportThreshold0MinParticipation0MinApproval0InEarlyExecutionMode
    {
        // It executes if participation, support and min approval are met
        vm.skip(true);
    }

    modifier givenAnEdgeCaseWithSupportThreshold999999MinParticipation100AndMinApproval100InEarlyExecutionMode() {
        _;
    }

    modifier givenTokenBalancesAreInTheMagnitudeOf1018() {
        _;
    }

    function test_WhenTheNumberOfYesVotesIsOneShyOfEnsuringTheSupportThresholdCannotBeDefeated()
        external
        givenAnEdgeCaseWithSupportThreshold999999MinParticipation100AndMinApproval100InEarlyExecutionMode
        givenTokenBalancesAreInTheMagnitudeOf1018
    {
        // It early support criterion is sharp by 1 vote
        vm.skip(true);
    }

    function test_WhenTheNumberOfCastedVotesIsOneShyOf100Participation()
        external
        givenAnEdgeCaseWithSupportThreshold999999MinParticipation100AndMinApproval100InEarlyExecutionMode
        givenTokenBalancesAreInTheMagnitudeOf1018
    {
        // It participation criterion is sharp by 1 vote
        vm.skip(true);
    }

    modifier givenTokenBalancesAreInTheMagnitudeOf106() {
        _;
    }

    function test_WhenTheNumberOfYesVotesIsOneShyOfEnsuringTheSupportThresholdCannotBeDefeated2()
        external
        givenAnEdgeCaseWithSupportThreshold999999MinParticipation100AndMinApproval100InEarlyExecutionMode
        givenTokenBalancesAreInTheMagnitudeOf106
    {
        // It early support criterion is sharp by 1 vote
        vm.skip(true);
    }

    function test_WhenTheNumberOfCastedVotesIsOneShyOf100Participation2()
        external
        givenAnEdgeCaseWithSupportThreshold999999MinParticipation100AndMinApproval100InEarlyExecutionMode
        givenTokenBalancesAreInTheMagnitudeOf106
    {
        // It participation is not met with 1 vote missing
        vm.skip(true);
    }

    modifier givenExecutionCriteriaHandleTokenBalancesForMultipleOrdersOfMagnitude() {
        _;
    }

    function test_WhenTestingWithAMagnitudeOf100()
        external
        givenExecutionCriteriaHandleTokenBalancesForMultipleOrdersOfMagnitude
    {
        // It magnitudes of 10^0
        vm.skip(true);
    }

    function test_WhenTestingWithAMagnitudeOf101()
        external
        givenExecutionCriteriaHandleTokenBalancesForMultipleOrdersOfMagnitude
    {
        // It magnitudes of 10^1
        vm.skip(true);
    }

    function test_WhenTestingWithAMagnitudeOf102()
        external
        givenExecutionCriteriaHandleTokenBalancesForMultipleOrdersOfMagnitude
    {
        // It magnitudes of 10^2
        vm.skip(true);
    }

    function test_WhenTestingWithAMagnitudeOf103()
        external
        givenExecutionCriteriaHandleTokenBalancesForMultipleOrdersOfMagnitude
    {
        // It magnitudes of 10^3
        vm.skip(true);
    }

    function test_WhenTestingWithAMagnitudeOf106()
        external
        givenExecutionCriteriaHandleTokenBalancesForMultipleOrdersOfMagnitude
    {
        // It magnitudes of 10^6
        vm.skip(true);
    }

    function test_WhenTestingWithAMagnitudeOf1012()
        external
        givenExecutionCriteriaHandleTokenBalancesForMultipleOrdersOfMagnitude
    {
        // It magnitudes of 10^12
        vm.skip(true);
    }

    function test_WhenTestingWithAMagnitudeOf1018()
        external
        givenExecutionCriteriaHandleTokenBalancesForMultipleOrdersOfMagnitude
    {
        // It magnitudes of 10^18
        vm.skip(true);
    }

    function test_WhenTestingWithAMagnitudeOf1024()
        external
        givenExecutionCriteriaHandleTokenBalancesForMultipleOrdersOfMagnitude
    {
        // It magnitudes of 10^24
        vm.skip(true);
    }

    function test_WhenTestingWithAMagnitudeOf1036()
        external
        givenExecutionCriteriaHandleTokenBalancesForMultipleOrdersOfMagnitude
    {
        // It magnitudes of 10^36
        vm.skip(true);
    }

    function test_WhenTestingWithAMagnitudeOf1048()
        external
        givenExecutionCriteriaHandleTokenBalancesForMultipleOrdersOfMagnitude
    {
        // It magnitudes of 10^48
        vm.skip(true);
    }

    function test_WhenTestingWithAMagnitudeOf1060()
        external
        givenExecutionCriteriaHandleTokenBalancesForMultipleOrdersOfMagnitude
    {
        // It magnitudes of 10^60
        vm.skip(true);
    }

    function test_WhenTestingWithAMagnitudeOf1066()
        external
        givenExecutionCriteriaHandleTokenBalancesForMultipleOrdersOfMagnitude
    {
        // It magnitudes of 10^66
        vm.skip(true);
    }
}
