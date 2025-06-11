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
}
