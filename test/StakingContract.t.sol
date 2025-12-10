// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/StakingContract.sol";

contract StakingContractTest is Test {
    StakingContract stakingContract;
    address prankAddress = 0xa3d05E72052a89b985542100BcB93b93FC1aA909;

    function setUp() public {
        // stakingContract = new StakingContract();
    }

    receive() external payable {}

    // function testStake() public {
    //     stakingContract.stake{value: 200}();
    //     assert(stakingContract.balanceOf(address(this)) == 200);
    // }

    // function testStakeUser() public {
    //     vm.startPrank(prankAddress);
    //     vm.deal(prankAddress, 10 ether);
    //     stakingContract.stake{value: 1 ether}();
    //     assert(stakingContract.balanceOf(address(prankAddress)) == 1 ether);
    // }

    // function testUnstake() public {
    //     stakingContract.stake{value: 200}();
    //     stakingContract.unstake(100);
    //     assert(stakingContract.balanceOf(address(this)) == 100);
    // }

    // function testRevert_unstake() public {
    //     stakingContract.stake{value: 200}();
    //     vm.expectRevert();
    //     stakingContract.unstake(300);
    // }
}
