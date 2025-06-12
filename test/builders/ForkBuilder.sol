// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.17;

import {ForkTestBase} from "../lib/ForkTestBase.sol";

import {DAO, IDAO} from "@aragon/osx/core/dao/DAO.sol";
import {DAOFactory} from "@aragon/osx/framework/dao/DAOFactory.sol";
import {PluginRepoFactory} from "@aragon/osx/framework/plugin/repo/PluginRepoFactory.sol";
import {PluginRepo} from "@aragon/osx/framework/plugin/repo/PluginRepo.sol";
import {PluginSetupRef} from "@aragon/osx/framework/plugin/setup/PluginSetupProcessorHelpers.sol";
import {TokenVotingSetup} from "../../src/TokenVotingSetup.sol";
import {TokenVoting} from "../../src/TokenVoting.sol";
import {NON_EMPTY_BYTES} from "../constants.sol";

import {GovernanceERC20} from "../../src/erc20/GovernanceERC20.sol";
import {GovernanceWrappedERC20} from "../../src/erc20/GovernanceWrappedERC20.sol";
import {IERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import {MajorityVotingBase} from "../../src/base/MajorityVotingBase.sol";
import {IPlugin} from "@aragon/osx-commons-contracts/src/plugin/IPlugin.sol";
import {IVotesUpgradeable} from "@openzeppelin/contracts-upgradeable/governance/utils/IVotesUpgradeable.sol";

contract ForkBuilder is ForkTestBase {
    address immutable DAO_BASE = address(new DAO());
    address immutable UPGRADEABLE_PLUGIN_BASE = address(new TokenVoting());

    // Add your own parameters here
    MajorityVotingBase.VotingMode votingMode =
        MajorityVotingBase.VotingMode.Standard;
    uint32 supportThreshold = 500_000; // 50%
    uint32 minParticipation = 100_000; // 10%
    uint64 minDuration = 60 * 60; // 1h
    uint256 minProposerVotingPower;

    IVotesUpgradeable token;
    address[] newTokenHolders;
    uint256[] newTokenBalances;
    address targetAddress;
    IPlugin.Operation targetOperation;
    uint256 minApprovals;
    bytes pluginMetadata;

    // Override methods
    function withEarlyExecution() public returns (ForkBuilder) {
        votingMode = MajorityVotingBase.VotingMode.EarlyExecution;
        return this;
    }

    function withVoteReplacement() public returns (ForkBuilder) {
        votingMode = MajorityVotingBase.VotingMode.VoteReplacement;
        return this;
    }

    function withSupportThreshold(
        uint32 _newThreshold
    ) public returns (ForkBuilder) {
        supportThreshold = _newThreshold;
        return this;
    }

    function withMinParticipation(
        uint32 _newValue
    ) public returns (ForkBuilder) {
        minParticipation = _newValue;
        return this;
    }

    function withMinDuration(uint64 _newValue) public returns (ForkBuilder) {
        minDuration = _newValue;
        return this;
    }

    function withMinApprovals(uint64 _newValue) public returns (ForkBuilder) {
        minApprovals = _newValue;
        return this;
    }

    function withMinProposerVotingPower(
        uint256 _newValue
    ) public returns (ForkBuilder) {
        minProposerVotingPower = _newValue;
        return this;
    }

    // Use the given token
    function withToken(
        IVotesUpgradeable _newToken
    ) public returns (ForkBuilder) {
        token = _newToken;
        return this;
    }

    // A list of token holders, all with the same balance
    function withNewToken(
        address[] memory _holders,
        uint256 _balance
    ) public returns (ForkBuilder) {
        for (uint256 i = 0; i < _holders.length; i++) {
            newTokenHolders.push(_holders[i]);
            newTokenBalances.push(_balance);
        }
        return this;
    }

    // A list of token holders, each with their own balance
    function withNewToken(
        address[] memory _holders,
        uint256[] memory _balances
    ) public returns (ForkBuilder) {
        for (uint256 i = 0; i < _holders.length; i++) {
            newTokenHolders.push(_holders[i]);
            newTokenBalances.push(_balances[i]);
        }
        return this;
    }

    function withTargetConfig(
        address _target,
        IPlugin.Operation _operation
    ) public returns (ForkBuilder) {
        targetAddress = _target;
        targetOperation = _operation;
        return this;
    }

    function withPluginMetadata(
        bytes memory _newValue
    ) public returns (ForkBuilder) {
        pluginMetadata = _newValue;
        return this;
    }

    /// @dev Creates a DAO with the given orchestration settings.
    /// @dev The setup is done on block/timestamp 0 and tests should be made on block/timestamp 1 or later.
    function build()
        public
        returns (
            DAO dao,
            PluginRepo pluginRepo,
            TokenVotingSetup pluginSetup,
            TokenVoting plugin
        )
    {
        // Dependency implementations
        GovernanceERC20 governanceERC20 = new GovernanceERC20(
            IDAO(address(0)),
            "",
            "",
            GovernanceERC20.MintSettings(new address[](0), new uint256[](0))
        );
        GovernanceWrappedERC20 governanceWrappedERC20 = new GovernanceWrappedERC20(
                IERC20Upgradeable(address(0)),
                "",
                ""
            );

        // Prepare a plugin repo with an initial version and subdomain
        string memory pluginRepoSubdomain = string.concat(
            "my-token-voting-plugin-",
            vm.toString(block.timestamp)
        );
        pluginSetup = new TokenVotingSetup(
            governanceERC20,
            governanceWrappedERC20
        );
        pluginRepo = pluginRepoFactory.createPluginRepoWithFirstVersion({
            _subdomain: string(pluginRepoSubdomain),
            _pluginSetup: address(pluginSetup),
            _maintainer: address(this),
            _releaseMetadata: NON_EMPTY_BYTES,
            _buildMetadata: NON_EMPTY_BYTES
        });

        // DAO settings
        DAOFactory.DAOSettings memory daoSettings = DAOFactory.DAOSettings({
            trustedForwarder: address(0),
            daoURI: "http://host/",
            subdomain: "",
            metadata: ""
        });

        // Define what plugin(s) to install and give the corresponding parameters
        DAOFactory.PluginSettings[]
            memory installSettings = new DAOFactory.PluginSettings[](1);

        // Token voting params
        if (address(token) == address(0)) {
            if (newTokenHolders.length != newTokenBalances.length) {
                revert("Mismatch between token holders and balances count");
            } else if (newTokenHolders.length == 0) {
                // Fallback: Mint a token with `msg.sender`
                newTokenHolders.push(msg.sender);
                newTokenBalances.push(1000 ether);
            }
            token = new GovernanceERC20(
                dao,
                "MyToken",
                "SYM",
                GovernanceERC20.MintSettings(newTokenHolders, newTokenBalances)
            );
        }

        // Target the DAO by default
        if (targetAddress == address(0)) {
            targetAddress = address(dao);
        }
        IPlugin.TargetConfig memory targetConfig = IPlugin.TargetConfig(
            targetAddress,
            targetOperation
        );
        MajorityVotingBase.VotingSettings
            memory votingSettings = MajorityVotingBase.VotingSettings({
                votingMode: votingMode,
                supportThreshold: supportThreshold,
                minParticipation: minParticipation,
                minDuration: minDuration,
                minProposerVotingPower: minProposerVotingPower
            });

        bytes memory pluginInstallData = abi.encode(
            votingSettings,
            TokenVotingSetup.TokenSettings({
                addr: address(token),
                name: "TokenName",
                symbol: "SYM"
            }),
            // only used for GovernanceERC20(token is not passed)
            GovernanceERC20.MintSettings(new address[](0), new uint256[](0)),
            targetConfig,
            minApprovals,
            pluginMetadata
        );
        installSettings[0] = DAOFactory.PluginSettings({
            pluginSetupRef: PluginSetupRef({
                versionTag: getLatestTag(pluginRepo),
                pluginSetupRepo: pluginRepo
            }),
            data: pluginInstallData
        });

        // Create DAO with the plugin
        DAOFactory.InstalledPlugin[] memory installedPlugins;
        (dao, installedPlugins) = daoFactory.createDao(
            daoSettings,
            installSettings
        );
        plugin = TokenVoting(installedPlugins[0].plugin);

        // Labels
        vm.label(address(dao), "DAO");
        vm.label(address(plugin), "TokenVoting");

        // Moving forward to avoid collisions
        vm.roll(block.number + 1);
        vm.warp(block.timestamp + 1);
    }
}
