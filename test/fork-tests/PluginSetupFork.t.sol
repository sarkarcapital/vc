// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";

contract PluginSetupForkTest is Test {
    modifier givenTheDeployerHasAllNecessaryPermissionsForInstallationAndUninstallation() {
        _;
    }

    function test_WhenInstallingAndThenUninstallingTheCurrentBuildUsingAnExistingToken()
        external
        givenTheDeployerHasAllNecessaryPermissionsForInstallationAndUninstallation
    {
        // It installs & uninstalls the current build with a token
        vm.skip(true);
    }

    modifier givenTheDeployerHasAllNecessaryPermissionsForInstallationAndUninstallation2() {
        _;
    }

    function test_WhenInstallingAndThenUninstallingTheCurrentBuildCreatingANewToken()
        external
        givenTheDeployerHasAllNecessaryPermissionsForInstallationAndUninstallation2
    {
        // It installs & uninstalls the current build without a token
        vm.skip(true);
    }

    modifier givenAPreviousPluginBuild1IsInstalledAndTheDeployerHasUpdatePermissions() {
        _;
    }

    function test_WhenUpdatingFromBuild1ToTheCurrentBuild()
        external
        givenAPreviousPluginBuild1IsInstalledAndTheDeployerHasUpdatePermissions
    {
        // It updates from build 1 to the current build
        vm.skip(true);
    }

    modifier givenAPreviousPluginBuild2IsInstalledAndTheDeployerHasUpdatePermissions() {
        _;
    }

    function test_WhenUpdatingFromBuild2ToTheCurrentBuild()
        external
        givenAPreviousPluginBuild2IsInstalledAndTheDeployerHasUpdatePermissions
    {
        // It updates from build 2 to the current build
        vm.skip(true);
    }
}
