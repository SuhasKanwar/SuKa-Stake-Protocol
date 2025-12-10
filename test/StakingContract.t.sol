// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {StakingContract, ISuKaCoinContract} from "src/StakingContract.sol";
import {SuKaCoinContract} from "src/SuKaCoin.sol";

contract StakingContractTest is Test {
    StakingContract stakingContract;
    SuKaCoinContract sukaCoin;
    address prankAddress = 0xa3d05E72052a89b985542100BcB93b93FC1aA909;

    function setUp() public {
        sukaCoin = new SuKaCoinContract(address(this)); // Temporary staking contract address
        stakingContract = new StakingContract(ISuKaCoinContract(address(sukaCoin)));
        sukaCoin.updateStakingContract(address(stakingContract));
    }

    receive() external payable {}

    function testStake() public {
        uint256 value = 200;
        stakingContract.stake{value: value}(value);
        assert(stakingContract.totalStake() == value);
        assert(stakingContract.balanceOf(address(this)) == value);
    }

    function testStakeUser() public {
        vm.startPrank(prankAddress);
        vm.deal(prankAddress, 10 ether);
        stakingContract.stake{value: 1 ether}(1 ether);
        assert(stakingContract.balanceOf(address(prankAddress)) == 1 ether);
    }

    function testRevert_unstake() public {
        uint256 value = 200;
        stakingContract.stake{value: value}(value);
        vm.expectRevert();
        stakingContract.unstake(value + 1);
    }

    function testUnstake() public {
        uint256 value = 200;
        stakingContract.stake{value: value}(value);
        stakingContract.unstake(value / 2);
        assert(stakingContract.balanceOf(address(this)) == value / 2);
    }

    function testGetRewards() public {
        uint256 value = 1 ether;
        stakingContract.stake{value: value}(value);
        vm.warp(block.timestamp + 1);
        uint256 rewards = stakingContract.getRewards(address(this));
        assert(rewards == value * 1 * stakingContract.REWARD_PER_SEC_PER_ETH());
    }

    function testComplexGetRewards() public {
        uint256 value = 1 ether;
        stakingContract.stake{value: value}(value);
        vm.warp(block.timestamp + 1);
        stakingContract.stake{value: value}(value);
        vm.warp(block.timestamp + 1);
        uint256 rewards = stakingContract.getRewards(address(this));

        assert(
            rewards
                == (value * 1 * stakingContract.REWARD_PER_SEC_PER_ETH())
                    + (2 * value * 1 * stakingContract.REWARD_PER_SEC_PER_ETH())
        );
    }

    function testClaimRewards() public {
        uint256 value = 1 ether;
        stakingContract.stake{value: value}(value);
        vm.warp(block.timestamp + 1);
        stakingContract.claimRewards();
        assert(sukaCoin.balanceOf(address(this)) == value * 1 * stakingContract.REWARD_PER_SEC_PER_ETH());
    }
}
