// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {TokenVoting} from "../src/TokenVoting.sol";

import {TokenVoting as TokenVotingR1B1} from "./old-versions/v1.1/TokenVoting.sol";
import {MajorityVotingBase as MajorityVotingBaseR1B1} from "./old-versions/v1.1/MajorityVotingBase.sol";
import {IDAO as IDAOR1B1} from "./old-versions/v1.1/IDAO.sol";
import {TokenVoting as TokenVotingR1B3} from "plugin-version-1.3/TokenVoting.sol";
import {MajorityVotingBase as MajorityVotingBaseR1B3} from "plugin-version-1.3/MajorityVotingBase.sol";
import {IPlugin} from "@aragon/osx-commons-contracts/src/plugin/IPlugin.sol";
import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {SimpleBuilder} from "./builders/SimpleBuilder.sol";
import {IVotesUpgradeable} from "@openzeppelin/contracts-upgradeable/governance/utils/IVotesUpgradeable.sol";
import {ProxyLib} from "@aragon/osx-commons-contracts/src/utils/deployment/ProxyLib.sol";

contract UpgradingTest is Test {
    error AlreadyInitialized();

    function test_WhenUpgradingToANewImplementation() external {
        // It upgrades to a new implementation
        (DAO dao, TokenVoting plugin,,) = new SimpleBuilder().build();

        dao.grant(address(plugin), address(this), keccak256("UPGRADE_PLUGIN_PERMISSION"));

        address originalImpl = address(plugin.implementation());
        address newImpl = address(new TokenVoting());
        plugin.upgradeTo(newImpl);
        address currentImpl = address(plugin.implementation());

        assertNotEq(originalImpl, currentImpl);
        assertEq(currentImpl, newImpl);
    }

    modifier givenTheContractIsAtR1B1() {
        _;
    }

    function test_WhenUpgradingWithInitializeFrom() external givenTheContractIsAtR1B1 {
        // It Upgrades from v1.0.0 with `initializeFrom`
        (DAO dao,, IVotesUpgradeable token,) = new SimpleBuilder().build();

        // Install as 1.1
        TokenVotingR1B1 plugin = TokenVotingR1B1(
            ProxyLib.deployUUPSProxy(
                address(new TokenVotingR1B1()),
                abi.encodeCall(
                    TokenVotingR1B1.initialize,
                    (
                        IDAOR1B1(address(dao)),
                        MajorityVotingBaseR1B1.VotingSettings({
                            votingMode: MajorityVotingBaseR1B1.VotingMode.EarlyExecution,
                            supportThreshold: 123_456,
                            minParticipation: 234_567,
                            minDuration: 60 * 60,
                            minProposerVotingPower: 11223344556677889900
                        }),
                        token
                    )
                )
            )
        );

        dao.grant(address(plugin), address(this), keccak256("UPGRADE_PLUGIN_PERMISSION"));

        address originalImpl = address(plugin.implementation());

        // It The old `initialize` function fails during the upgrade
        vm.expectRevert("Initializable: contract is already initialized");
        plugin.upgradeToAndCall(
            originalImpl,
            abi.encodeCall(
                TokenVotingR1B1.initialize,
                (
                    IDAOR1B1(address(dao)),
                    MajorityVotingBaseR1B1.VotingSettings({
                        votingMode: MajorityVotingBaseR1B1.VotingMode.EarlyExecution,
                        supportThreshold: 123_456,
                        minParticipation: 234_567,
                        minDuration: 60 * 60,
                        minProposerVotingPower: 11223344556677889900
                    }),
                    token
                )
            )
        );

        address newImpl = address(new TokenVoting());

        // It initializeFrom succeeds
        uint256 minApprovals = 1234;
        IPlugin.TargetConfig memory targetConfig =
            IPlugin.TargetConfig({target: address(dao), operation: IPlugin.Operation.Call});
        bytes memory pluginMetadata = "new-metadata";
        plugin.upgradeToAndCall(
            newImpl,
            abi.encodeCall(TokenVoting.initializeFrom, (1, abi.encode(minApprovals, targetConfig, pluginMetadata)))
        );

        address currentImpl = address(plugin.implementation());
        assertNotEq(originalImpl, currentImpl);
        assertEq(currentImpl, newImpl);

        // It protocol versions are updated correctly
        uint8[3] memory version = TokenVoting(address(plugin)).protocolVersion();
        assertEq(version[0], 1);
        assertEq(version[1], 4);
        assertEq(version[2], 0);

        // It new settings are applied
        assertEq(TokenVoting(address(plugin)).minApproval(), 1234);

        IPlugin.TargetConfig memory newTargetConfig = TokenVoting(address(plugin)).getTargetConfig();
        vm.assertEq(newTargetConfig.target, address(dao));
        vm.assertEq(uint8(newTargetConfig.operation), uint8(IPlugin.Operation.Call));
        vm.assertEq(TokenVoting(address(plugin)).getMetadata(), "new-metadata");

        // It the original `initialize` function is disabled post-upgrade
        vm.expectRevert();
        plugin.initialize(
            IDAOR1B1(address(dao)),
            MajorityVotingBaseR1B1.VotingSettings({
                votingMode: MajorityVotingBaseR1B1.VotingMode.EarlyExecution,
                supportThreshold: 123_456,
                minParticipation: 234_567,
                minDuration: 60 * 60,
                minProposerVotingPower: 11223344556677889900
            }),
            token
        );
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
}
