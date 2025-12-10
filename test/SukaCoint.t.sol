// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/SukaCoin.sol";

contract SuKaCoinTest is Test {
    SuKaCoinContract sukaCoin;

    function setUp() public {
        sukaCoin = new SuKaCoinContract(address(this));
    }

    function testInitialSupply() public view {
        assert(sukaCoin.totalSupply() == 0);
    }

    function testRevert_Mint() public {
        vm.startPrank(0xa3d05E72052a89b985542100BcB93b93FC1aA909);
        vm.expectRevert();
        sukaCoin.mint(0xa3d05E72052a89b985542100BcB93b93FC1aA909, 10);
    }

    function testMint() public {
        sukaCoin.mint(0xa3d05E72052a89b985542100BcB93b93FC1aA909, 10);
        assert(sukaCoin.balanceOf(0xa3d05E72052a89b985542100BcB93b93FC1aA909) == 10);
    }

    function testChangeStakingContract() public {
        sukaCoin.updateStakingContract(0xa3d05E72052a89b985542100BcB93b93FC1aA909);
        vm.startPrank(0xa3d05E72052a89b985542100BcB93b93FC1aA909);
        sukaCoin.mint(0xa3d05E72052a89b985542100BcB93b93FC1aA909, 10);
        assert(sukaCoin.balanceOf(0xa3d05E72052a89b985542100BcB93b93FC1aA909) == 10);
    }
}