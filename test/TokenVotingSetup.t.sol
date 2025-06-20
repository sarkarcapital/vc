// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.28;

import {TestBase} from "./lib/TestBase.sol";

import {SimpleBuilder} from "./builders/SimpleBuilder.sol";
import {TokenVotingSetup as PluginSetupContract} from "../src/TokenVotingSetup.sol";
import {TokenVoting} from "../src/TokenVoting.sol";
import {MajorityVotingBase} from "../src/base/MajorityVotingBase.sol";
import {GovernanceERC20} from "../src/erc20/GovernanceERC20.sol";
import {GovernanceWrappedERC20} from "../src/erc20/GovernanceWrappedERC20.sol";
import {ERC20Mock} from "./mocks/ERC20Mock.sol";
import {DAO} from "@aragon/osx/core/dao/DAO.sol";
import {IPluginSetup} from "@aragon/osx-commons-contracts/src/plugin/setup/IPluginSetup.sol";
import {PermissionLib} from "@aragon/osx-commons-contracts/src/permission/PermissionLib.sol";
import {IPlugin} from "@aragon/osx-commons-contracts/src/plugin/IPlugin.sol";
import {IDAO} from "@aragon/osx-commons-contracts/src/dao/IDAO.sol";
import {IVotesUpgradeable} from "@openzeppelin/contracts-upgradeable/governance/utils/IVotesUpgradeable.sol";
import {IERC20Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

contract TokenVotingSetupTest is TestBase {
    // Permission IDs
    bytes32 constant UPDATE_VOTING_SETTINGS_PERMISSION_ID = keccak256("UPDATE_VOTING_SETTINGS_PERMISSION");
    bytes32 constant CREATE_PROPOSAL_PERMISSION_ID = keccak256("CREATE_PROPOSAL_PERMISSION");
    bytes32 constant MINT_PERMISSION_ID = keccak256("MINT_PERMISSION");
    bytes32 constant SET_METADATA_PERMISSION_ID = keccak256("SET_METADATA_PERMISSION");
    bytes32 constant SET_TARGET_CONFIG_PERMISSION_ID = keccak256("SET_TARGET_CONFIG_PERMISSION");

    address private constant ANY_ADDR = address(type(uint160).max);

    PluginSetupContract internal pluginSetup;
    GovernanceERC20 internal governanceERC20Base;
    GovernanceWrappedERC20 internal governanceWrappedERC20Base;
    DAO internal dao;

    // Default settings
    MajorityVotingBase.VotingSettings internal defaultVotingSettings;
    PluginSetupContract.TokenSettings internal defaultTokenSettings;
    GovernanceERC20.MintSettings internal defaultMintSettings;
    IPlugin.TargetConfig internal defaultTargetConfig;
    uint256 internal defaultMinApproval;
    bytes internal defaultMetadata;

    function setUp() public {
        // Deploy DAO
        (dao,,,) = new SimpleBuilder().withDaoOwner(address(this)).build();

        // Deploy base contracts
        governanceERC20Base = new GovernanceERC20(
            IDAO(address(0)), "G", "G", GovernanceERC20.MintSettings(new address[](0), new uint256[](0))
        );
        governanceWrappedERC20Base = new GovernanceWrappedERC20(IERC20Upgradeable(address(0x1)), "WG", "WG");

        // Deploy PluginSetup
        pluginSetup = new PluginSetupContract(governanceERC20Base, governanceWrappedERC20Base);

        // Default settings
        defaultVotingSettings = MajorityVotingBase.VotingSettings({
            votingMode: MajorityVotingBase.VotingMode.EarlyExecution,
            supportThreshold: 500_000,
            minParticipation: 200_000,
            minDuration: 1 hours,
            minProposerVotingPower: 0
        });
        defaultTokenSettings = PluginSetupContract.TokenSettings({addr: address(0), name: "MyToken", symbol: "TKN"});
        defaultMintSettings = GovernanceERC20.MintSettings({receivers: new address[](0), amounts: new uint256[](0)});
        defaultTargetConfig = IPlugin.TargetConfig({target: address(dao), operation: IPlugin.Operation.Call});
        defaultMinApproval = 300_000;
        defaultMetadata = "0x11";
    }

    function _getInstallationData() internal view returns (bytes memory) {
        return abi.encode(
            defaultVotingSettings,
            defaultTokenSettings,
            defaultMintSettings,
            defaultTargetConfig,
            defaultMinApproval,
            defaultMetadata
        );
    }

    function _assertPermission(
        PermissionLib.MultiTargetPermission memory p,
        PermissionLib.Operation op,
        address where,
        address who,
        address condition,
        bytes32 permissionId
    ) internal pure {
        assertEq(uint8(p.operation), uint8(op), "permission op mismatch");
        assertEq(p.where, where, "permission where mismatch");
        assertEq(p.who, who, "permission who mismatch");
        assertEq(p.condition, condition, "permission condition mismatch");
        assertEq(p.permissionId, permissionId, "permissionId mismatch");
    }

    function test_WhenCallingSupportsInterface0xffffffff() external view {
        // It does not support the empty interface
        assertFalse(pluginSetup.supportsInterface(0xffffffff));
    }

    function test_WhenCallingGovernanceERC20BaseAndGovernanceWrappedERC20BaseAfterInitialization() external view {
        // It stores the bases provided through the constructor
        assertEq(pluginSetup.governanceERC20Base(), address(governanceERC20Base));
        assertEq(pluginSetup.governanceWrappedERC20Base(), address(governanceWrappedERC20Base));
    }

    modifier givenTheContextIsPrepareInstallation() {
        _;
    }

    function test_WhenCallingPrepareInstallationWithDataThatIsEmptyOrNotOfMinimumLength()
        external
        givenTheContextIsPrepareInstallation
    {
        // It fails if data is empty, or not of minimum length
        vm.expectRevert();
        pluginSetup.prepareInstallation(address(dao), "");

        vm.expectRevert();
        pluginSetup.prepareInstallation(address(dao), "0x1234");

        // And it should not revert with correct data
        pluginSetup.prepareInstallation(address(dao), _getInstallationData());
    }

    function test_WhenCallingPrepareInstallationIfMintSettingsArraysDoNotHaveTheSameLength()
        external
        givenTheContextIsPrepareInstallation
    {
        // It fails if `MintSettings` arrays do not have the same length
        defaultMintSettings.receivers = new address[](1);
        defaultMintSettings.amounts = new uint256[](0);

        vm.expectRevert(abi.encodeWithSelector(GovernanceERC20.MintSettingsArrayLengthMismatch.selector, 1, 0));
        pluginSetup.prepareInstallation(address(dao), _getInstallationData());
    }

    function test_WhenCallingPrepareInstallationIfPassedTokenAddressIsNotAContract()
        external
        givenTheContextIsPrepareInstallation
    {
        // It fails if passed token address is not a contract
        defaultTokenSettings.addr = alice; // EOA is not a contract

        vm.expectRevert(abi.encodeWithSelector(PluginSetupContract.TokenNotContract.selector, alice));
        pluginSetup.prepareInstallation(address(dao), _getInstallationData());
    }

    function test_WhenCallingPrepareInstallationIfPassedTokenAddressIsNotERC20()
        external
        givenTheContextIsPrepareInstallation
    {
        // It fails if passed token address is not ERC20
        defaultTokenSettings.addr = address(dao); // DAO is a contract but not ERC20

        vm.expectRevert(abi.encodeWithSelector(PluginSetupContract.TokenNotERC20.selector, address(dao)));
        pluginSetup.prepareInstallation(address(dao), _getInstallationData());
    }

    function test_WhenCallingPrepareInstallationAndAnERC20TokenAddressIsSupplied()
        external
        givenTheContextIsPrepareInstallation
    {
        // It correctly returns plugin, helpers and permissions, when an ERC20 token address is supplied
        ERC20Mock erc20 = new ERC20Mock("Mock Token", "MTK");
        defaultTokenSettings.addr = address(erc20);
        bytes memory data = _getInstallationData();

        uint256 nonce = vm.getNonce(address(pluginSetup));
        address anticipatedWrappedTokenAddress = computeCreateAddress(address(pluginSetup), nonce);
        address anticipatedPluginAddress = computeCreateAddress(address(pluginSetup), nonce + 1);
        address anticipatedCondition = computeCreateAddress(address(pluginSetup), nonce + 2);

        (address plugin, IPluginSetup.PreparedSetupData memory prepared) =
            pluginSetup.prepareInstallation(address(dao), data);

        assertEq(plugin, anticipatedPluginAddress);
        assertEq(prepared.helpers.length, 2);
        assertEq(prepared.helpers[0], anticipatedCondition);
        assertEq(prepared.helpers[1], anticipatedWrappedTokenAddress);

        assertEq(prepared.permissions.length, 6);
        _assertPermission(
            prepared.permissions[0],
            PermissionLib.Operation.Grant,
            plugin,
            address(dao),
            address(0),
            TokenVoting(plugin).UPDATE_VOTING_SETTINGS_PERMISSION_ID()
        );
        _assertPermission(
            prepared.permissions[1],
            PermissionLib.Operation.Grant,
            address(dao),
            plugin,
            address(0),
            dao.EXECUTE_PERMISSION_ID()
        );
        _assertPermission(
            prepared.permissions[2],
            PermissionLib.Operation.GrantWithCondition,
            plugin,
            ANY_ADDR,
            anticipatedCondition,
            TokenVoting(plugin).CREATE_PROPOSAL_PERMISSION_ID()
        );
        _assertPermission(
            prepared.permissions[3],
            PermissionLib.Operation.Grant,
            plugin,
            address(dao),
            address(0),
            TokenVoting(plugin).SET_TARGET_CONFIG_PERMISSION_ID()
        );
        _assertPermission(
            prepared.permissions[4],
            PermissionLib.Operation.Grant,
            plugin,
            address(dao),
            address(0),
            TokenVoting(plugin).SET_METADATA_PERMISSION_ID()
        );
        _assertPermission(
            prepared.permissions[5],
            PermissionLib.Operation.Grant,
            plugin,
            ANY_ADDR,
            address(0),
            TokenVoting(plugin).EXECUTE_PROPOSAL_PERMISSION_ID()
        );
    }

    function test_WhenCallingPrepareInstallationAndAnERC20TokenAddressIsSupplied2()
        external
        givenTheContextIsPrepareInstallation
    {
        // It correctly sets up `GovernanceWrappedERC20` helper, when an ERC20 token address is supplied
        ERC20Mock erc20 = new ERC20Mock("Mock Token", "MTK");
        defaultTokenSettings.addr = address(erc20);
        defaultTokenSettings.name = "My Wrapped Token";
        defaultTokenSettings.symbol = "wTKN";

        (, IPluginSetup.PreparedSetupData memory prepared) =
            pluginSetup.prepareInstallation(address(dao), _getInstallationData());

        GovernanceWrappedERC20 wrappedToken = GovernanceWrappedERC20(prepared.helpers[1]);

        assertEq(wrappedToken.name(), "My Wrapped Token");
        assertEq(wrappedToken.symbol(), "wTKN");
        assertEq(address(wrappedToken.underlying()), address(erc20));
        assertTrue(wrappedToken.supportsInterface(type(IVotesUpgradeable).interfaceId));
    }

    function test_WhenCallingPrepareInstallationAndAGovernanceTokenAddressIsSupplied()
        external
        givenTheContextIsPrepareInstallation
    {
        // It correctly returns plugin, helpers and permissions, when a governance token address is supplied
        GovernanceERC20 govToken = new GovernanceERC20(IDAO(address(dao)), "Test", "TST", defaultMintSettings);
        defaultTokenSettings.addr = address(govToken);
        bytes memory data = _getInstallationData();

        uint256 nonce = vm.getNonce(address(pluginSetup));
        address anticipatedPluginAddress = computeCreateAddress(address(pluginSetup), nonce);
        address anticipatedCondition = computeCreateAddress(address(pluginSetup), nonce + 1);

        (address plugin, IPluginSetup.PreparedSetupData memory prepared) =
            pluginSetup.prepareInstallation(address(dao), data);

        assertEq(plugin, anticipatedPluginAddress);
        assertEq(prepared.helpers.length, 2);
        assertEq(prepared.helpers[0], anticipatedCondition);
        assertEq(prepared.helpers[1], address(govToken));
        assertEq(prepared.permissions.length, 6);
    }

    function test_WhenCallingPrepareInstallationAndATokenAddressIsNotSupplied()
        external
        givenTheContextIsPrepareInstallation
    {
        // It correctly returns plugin, helpers and permissions, when a token address is not supplied
        defaultTokenSettings.addr = address(0);
        bytes memory data = _getInstallationData();

        uint256 nonce = vm.getNonce(address(pluginSetup));
        address anticipatedTokenAddress = computeCreateAddress(address(pluginSetup), nonce);
        address anticipatedPluginAddress = computeCreateAddress(address(pluginSetup), nonce + 1);
        address anticipatedCondition = computeCreateAddress(address(pluginSetup), nonce + 2);

        (address plugin, IPluginSetup.PreparedSetupData memory prepared) =
            pluginSetup.prepareInstallation(address(dao), data);

        assertEq(plugin, anticipatedPluginAddress);
        assertEq(prepared.helpers.length, 2);
        assertEq(prepared.helpers[0], anticipatedCondition);
        assertEq(prepared.helpers[1], anticipatedTokenAddress);

        assertEq(prepared.permissions.length, 7);
        _assertPermission(
            prepared.permissions[6],
            PermissionLib.Operation.Grant,
            anticipatedTokenAddress,
            address(dao),
            address(0),
            MINT_PERMISSION_ID
        );
    }

    function test_WhenCallingPrepareInstallationAndATokenAddressIsNotPassed()
        external
        givenTheContextIsPrepareInstallation
    {
        // It correctly sets up the plugin and helpers, when a token address is not passed
        defaultTokenSettings.addr = address(0);
        (address pluginAddr, IPluginSetup.PreparedSetupData memory prepared) =
            pluginSetup.prepareInstallation(address(dao), _getInstallationData());

        TokenVoting plugin = TokenVoting(pluginAddr);
        GovernanceERC20 token = GovernanceERC20(prepared.helpers[1]);

        assertEq(address(plugin.dao()), address(dao));
        assertEq(uint8(plugin.votingMode()), uint8(defaultVotingSettings.votingMode));
        assertEq(address(plugin.getVotingToken()), address(token));
        address target = plugin.getTargetConfig().target;
        assertEq(target, defaultTargetConfig.target);
        assertEq(address(token.dao()), address(dao));
        assertEq(token.name(), defaultTokenSettings.name);
        assertEq(token.symbol(), defaultTokenSettings.symbol);
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
