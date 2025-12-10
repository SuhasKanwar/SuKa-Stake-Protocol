// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {SuKaCoinContract} from "src/SuKaCoin.sol";

contract SuKaCoinTest is Test {
    SuKaCoinContract sukaCoin;
    address prankAddress = 0xa3d05E72052a89b985542100BcB93b93FC1aA909;

    function setUp() public {
        sukaCoin = new SuKaCoinContract(address(this));
    }

    function testInitialSupply() public view {
        assert(sukaCoin.totalSupply() == 0);
    }

    function testRevert_Mint() public {
        uint256 value = 10;
        vm.startPrank(prankAddress);
        vm.expectRevert();
        sukaCoin.mint(address(this), value);
    }

    function testMint() public {
        uint256 value = 10;
        sukaCoin.mint(address(this), value);
        assert(sukaCoin.balanceOf(address(this)) == value);
    }

    function testChangeStakingContract() public {
        uint256 value = 10;
        sukaCoin.updateStakingContract(prankAddress);
        vm.startPrank(prankAddress);
        sukaCoin.mint(prankAddress, value);
        assert(sukaCoin.balanceOf(prankAddress) == value);
    }
}
