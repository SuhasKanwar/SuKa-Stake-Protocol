// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/SukaCoin.sol";

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
        vm.startPrank(prankAddress);
        vm.expectRevert();
        sukaCoin.mint(prankAddress, 10);
    }

    function testMint() public {
        sukaCoin.mint(prankAddress, 10);
        assert(sukaCoin.balanceOf(prankAddress) == 10);
    }

    function testChangeStakingContract() public {
        sukaCoin.updateStakingContract(prankAddress);
        vm.startPrank(prankAddress);
        sukaCoin.mint(prankAddress, 10);
        assert(sukaCoin.balanceOf(prankAddress) == 10);
    }
}
