// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {ForkTestBase} from "../lib/ForkTestBase.sol";

import {ForkBuilder} from "../builders/ForkBuilder.sol";
import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {DaoUnauthorized} from "@aragon/osx-commons-contracts/src/permission/auth/auth.sol";
import {PluginRepo} from "@aragon/osx/framework/plugin/repo/PluginRepo.sol";

import {TokenVotingSetup} from "../../src/TokenVotingSetup.sol";
import {TokenVoting} from "../../src/TokenVoting.sol";
import {NON_EMPTY_BYTES} from "../constants.sol";

import {ForkTestBase} from "../lib/ForkTestBase.sol";
import {ForkBuilder} from "../builders/ForkBuilder.sol";

// Aragon OSx Contracts
import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {PluginRepo} from "@aragon/osx/framework/plugin/repo/PluginRepo.sol";
import {
    PluginSetupRef,
    hashHelpers,
    hashPermissions
} from "@aragon/osx/framework/plugin/setup/PluginSetupProcessorHelpers.sol";
import {PluginSetupProcessor} from "@aragon/osx/framework/plugin/setup/PluginSetupProcessor.sol";
import {IPluginSetup} from "@aragon/osx-commons-contracts/src/plugin/setup/IPluginSetup.sol";
import {IPlugin} from "@aragon/osx-commons-contracts/src/plugin/IPlugin.sol";
import {PermissionLib} from "@aragon/osx-commons-contracts/src/permission/PermissionLib.sol";

// Plugin Contracts
import {MajorityVotingBase} from "../../src/base/MajorityVotingBase.sol";
import {GovernanceERC20} from "../../src/erc20/GovernanceERC20.sol";

// OZ Contracts
import {IVotesUpgradeable} from "@openzeppelin/contracts-upgradeable/governance/utils/IVotesUpgradeable.sol";

contract PluginSetupForkTest is ForkTestBase {
    // An address of the official TokenVoting plugin repository on Sepolia
    // This allows testing updates from previously published builds
    // https://sepolia.etherscan.io/address/0x481633515A23374251a84497e335222f5a435A91
    address private constant TOKEN_VOTING_REPO_ADDRESS = 0x481633515a23374251A84497e335222F5A435a91;

    // Actors
    address private deployer = address(this);

    modifier givenTheDeployerHasAllNecessaryPermissionsForInstallationAndUninstallation() {
        _;
    }

    function test_WhenInstallingAndThenUninstallingTheCurrentBuildUsingAnExistingToken()
        external
        givenTheDeployerHasAllNecessaryPermissionsForInstallationAndUninstallation
    {
        // It installs & uninstalls the current build with a token

        // SETUP: Create a DAO and an "existing" token for it to use
        (DAO dao, PluginRepo repo,,) = new ForkBuilder().build();
        GovernanceERC20 existingToken;
        {
            address[] memory receivers = new address[](1);
            receivers[0] = alice;
            uint256[] memory amounts = new uint256[](1);
            amounts[0] = 100 ether;
            GovernanceERC20.MintSettings memory initialMint = GovernanceERC20.MintSettings(receivers, amounts);
            existingToken = new GovernanceERC20(dao, "Existing Token", "EXIST", initialMint);
        }

        // PERMISSIONS: Grant the necessary permissions to the PluginSetupProcessor

        dao.grant(address(pluginSetupProcessor), deployer, pluginSetupProcessor.APPLY_INSTALLATION_PERMISSION_ID());
        dao.grant(address(pluginSetupProcessor), deployer, pluginSetupProcessor.APPLY_UNINSTALLATION_PERMISSION_ID());
        dao.grant(address(dao), address(pluginSetupProcessor), dao.ROOT_PERMISSION_ID());

        PluginSetupRef memory setupRef = PluginSetupRef({versionTag: getLatestTag(repo), pluginSetupRepo: repo});

        // INSTALLATION
        // Prepare installation data using the existing token
        bytes memory installData;
        {
            MajorityVotingBase.VotingSettings memory votingSettings = MajorityVotingBase.VotingSettings(
                MajorityVotingBase.VotingMode.EarlyExecution, 500_000, 200_000, 1 hours, 0
            );
            TokenVotingSetup.TokenSettings memory tokenSettings =
                TokenVotingSetup.TokenSettings({addr: address(existingToken), name: "Test Token", symbol: "TTK"});
            GovernanceERC20.MintSettings memory emptyMintSettings =
                GovernanceERC20.MintSettings(new address[](0), new uint256[](0));
            IPlugin.TargetConfig memory targetConfig = IPlugin.TargetConfig(address(dao), IPlugin.Operation.Call);

            installData = abi.encode(votingSettings, tokenSettings, emptyMintSettings, targetConfig, 0, "some-metadata");
        }

        // Prepare and apply the installation
        address plugin;
        IPluginSetup.PreparedSetupData memory preparedSetupData;
        {
            PluginSetupProcessor.PrepareInstallationParams memory prepareInstallParams =
                PluginSetupProcessor.PrepareInstallationParams({pluginSetupRef: setupRef, data: installData});

            (plugin, preparedSetupData) = pluginSetupProcessor.prepareInstallation(address(dao), prepareInstallParams);

            PluginSetupProcessor.ApplyInstallationParams memory applyInstallParams = PluginSetupProcessor
                .ApplyInstallationParams({
                pluginSetupRef: setupRef,
                plugin: plugin,
                permissions: preparedSetupData.permissions,
                helpersHash: hashHelpers(preparedSetupData.helpers)
            });
            pluginSetupProcessor.applyInstallation(plugin, applyInstallParams);

            vm.assertTrue(
                dao.isGranted(address(dao), address(plugin), dao.EXECUTE_PERMISSION_ID(), ""),
                "Plugin should be installed"
            );
        }

        // Assert that the installation was successful and configured correctly
        {
            TokenVoting tokenVotingPlugin = TokenVoting(plugin);
            assertEq(address(tokenVotingPlugin.getVotingToken()), address(existingToken), "Token address mismatch");
            assertTrue(tokenVotingPlugin.isMember(alice), "Alice should be a member");
            assertFalse(tokenVotingPlugin.isMember(bob), "Bob should not be a member");
        }

        // UNINSTALLATION
        // Prepare and apply the uninstallation
        {
            PluginSetupProcessor.PrepareUninstallationParams memory uninstallParams = PluginSetupProcessor
                .PrepareUninstallationParams({
                pluginSetupRef: setupRef,
                setupPayload: IPluginSetup.SetupPayload({
                    plugin: plugin,
                    currentHelpers: preparedSetupData.helpers,
                    data: ""
                })
            });
            PermissionLib.MultiTargetPermission[] memory uninstallPermissions =
                pluginSetupProcessor.prepareUninstallation(address(dao), uninstallParams);

            PluginSetupProcessor.ApplyUninstallationParams memory applyUninstallParams = PluginSetupProcessor
                .ApplyUninstallationParams({plugin: plugin, pluginSetupRef: setupRef, permissions: uninstallPermissions});
            pluginSetupProcessor.applyUninstallation(plugin, applyUninstallParams);
        }

        // Assert that the plugin was successfully uninstalled
        vm.assertFalse(
            dao.isGranted(address(dao), address(plugin), dao.EXECUTE_PERMISSION_ID(), ""),
            "Plugin should be uninstalled"
        );
    }

    modifier givenTheDeployerHasAllNecessaryPermissionsForInstallationAndUninstallation2() {
        _;
    }

    function test_WhenInstallingAndThenUninstallingTheCurrentBuildCreatingANewToken()
        external
        givenTheDeployerHasAllNecessaryPermissionsForInstallationAndUninstallation2
    {
        // It installs & uninstalls the current build without a token

        // SETUP: Create a DAO
        (DAO dao, PluginRepo repo,,) = new ForkBuilder().build();

        // PERMISSIONS: Grant the necessary permissions

        dao.grant(address(pluginSetupProcessor), deployer, pluginSetupProcessor.APPLY_INSTALLATION_PERMISSION_ID());
        dao.grant(address(pluginSetupProcessor), deployer, pluginSetupProcessor.APPLY_UNINSTALLATION_PERMISSION_ID());
        dao.grant(address(dao), address(pluginSetupProcessor), dao.ROOT_PERMISSION_ID());

        PluginSetupRef memory setupRef = PluginSetupRef({versionTag: getLatestTag(repo), pluginSetupRepo: repo});

        // INSTALLATION
        // Prepare installation data to create a new token
        bytes memory installData;

        {
            MajorityVotingBase.VotingSettings memory votingSettings = MajorityVotingBase.VotingSettings(
                MajorityVotingBase.VotingMode.EarlyExecution, 500_000, 200_000, 1 hours, 0
            );
            TokenVotingSetup.TokenSettings memory tokenSettings =
                TokenVotingSetup.TokenSettings({addr: address(0), name: "New Token", symbol: "NEW"});
            address[] memory receivers = new address[](1);
            receivers[0] = alice;
            uint256[] memory amounts = new uint256[](1);
            amounts[0] = 1000 ether;
            GovernanceERC20.MintSettings memory mintSettings = GovernanceERC20.MintSettings(receivers, amounts);
            IPlugin.TargetConfig memory targetConfig = IPlugin.TargetConfig(address(dao), IPlugin.Operation.Call);

            installData = abi.encode(votingSettings, tokenSettings, mintSettings, targetConfig, 0, "some-metadata");
        }

        // Prepare and apply the installation
        address plugin;
        IPluginSetup.PreparedSetupData memory preparedSetupData;

        {
            PluginSetupProcessor.PrepareInstallationParams memory prepareInstallParams =
                PluginSetupProcessor.PrepareInstallationParams({pluginSetupRef: setupRef, data: installData});

            (plugin, preparedSetupData) = pluginSetupProcessor.prepareInstallation(address(dao), prepareInstallParams);

            PluginSetupProcessor.ApplyInstallationParams memory applyInstallParams = PluginSetupProcessor
                .ApplyInstallationParams({
                pluginSetupRef: setupRef,
                plugin: plugin,
                permissions: preparedSetupData.permissions,
                helpersHash: hashHelpers(preparedSetupData.helpers)
            });
            pluginSetupProcessor.applyInstallation(plugin, applyInstallParams);

            vm.assertTrue(
                dao.isGranted(address(dao), address(plugin), dao.EXECUTE_PERMISSION_ID(), ""),
                "Plugin should be installed"
            );
        }

        // Assert that the installation created and configured the new token correctly
        {
            TokenVoting tokenVotingPlugin = TokenVoting(plugin);
            IVotesUpgradeable newToken = tokenVotingPlugin.getVotingToken();
            assertNotEq(address(newToken), address(0), "New token should have been created");
            assertTrue(tokenVotingPlugin.isMember(alice), "Alice should be a member");
            assertFalse(tokenVotingPlugin.isMember(bob), "Bob should not be a member");
        }

        // UNINSTALLATION
        // Prepare and apply the uninstallation
        {
            PluginSetupProcessor.PrepareUninstallationParams memory uninstallParams = PluginSetupProcessor
                .PrepareUninstallationParams({
                pluginSetupRef: setupRef,
                setupPayload: IPluginSetup.SetupPayload({
                    plugin: plugin,
                    currentHelpers: preparedSetupData.helpers,
                    data: ""
                })
            });
            PermissionLib.MultiTargetPermission[] memory uninstallPermissions =
                pluginSetupProcessor.prepareUninstallation(address(dao), uninstallParams);

            PluginSetupProcessor.ApplyUninstallationParams memory applyUninstallParams = PluginSetupProcessor
                .ApplyUninstallationParams({plugin: plugin, pluginSetupRef: setupRef, permissions: uninstallPermissions});
            pluginSetupProcessor.applyUninstallation(plugin, applyUninstallParams);
        }

        // Assert that the plugin was successfully uninstalled
        vm.assertFalse(
            dao.isGranted(address(dao), address(plugin), dao.EXECUTE_PERMISSION_ID(), ""),
            "Plugin should be uninstalled"
        );
    }
}
