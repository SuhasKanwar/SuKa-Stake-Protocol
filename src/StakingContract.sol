// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

interface ISuKaCoinContract {
    function mint(address _account, uint256 _amount) external;
}

contract StakingContract {
    uint256 public totalStake;
    uint256 public constant REWARD_PER_SEC_PER_ETH = 1;

    struct UserInfo {
        uint256 stakedAmount;
        uint256 rewardDebt;
        uint256 lastUpdateTime;
    }

    mapping(address => UserInfo) public userInfo;
    ISuKaCoinContract public suKaCoin;

    constructor(ISuKaCoinContract _suKaCoin) {
        suKaCoin = _suKaCoin;
    }

    function _updateRewards(address _staker) internal {
        UserInfo storage user = userInfo[_staker];

        if (user.lastUpdateTime == 0) {
            user.lastUpdateTime = block.timestamp;
            return;
        }

        uint256 timeDiff = block.timestamp - user.lastUpdateTime;

        if (timeDiff == 0) {
            return;
        }

        uint256 additionalReward = (user.stakedAmount * timeDiff * REWARD_PER_SEC_PER_ETH);

        user.rewardDebt += additionalReward;
        user.lastUpdateTime = block.timestamp;
    }

    function stake(uint256 _amount) external payable {
        require(msg.value == _amount, "Sent value must match the stake amount");
        require(msg.value > 0, "Stake amount must be greater than zero");

        _updateRewards(msg.sender);

        userInfo[msg.sender].stakedAmount += _amount;
        totalStake += _amount;
    }

    function unstake(uint256 _amount) public {
        require(_amount > 0, "Unstake amount must be greater than zero");
        UserInfo storage user = userInfo[msg.sender];
        require(user.stakedAmount >= _amount, "Insufficient staked amount to unstake");

        _updateRewards(msg.sender);

        user.stakedAmount -= _amount;
        totalStake -= _amount;

        payable(msg.sender).transfer(_amount);
    }

    function balanceOf(address _staker) public view returns (uint256) {
        return userInfo[_staker].stakedAmount;
    }

    function claimRewards() public {
        _updateRewards(msg.sender);
        UserInfo storage user = userInfo[msg.sender];
        suKaCoin.mint(msg.sender, user.rewardDebt);
        user.rewardDebt = 0;
    }

    function getRewards(address _address) public view {
        uint256 timeDiff = block.timestamp - userInfo[_address].lastUpdateTime;

        if (timeDiff == 0) {
            return userInfo[_address].rewardDebt;
        }

        return (userInfo[_address].stakedAmount * timeDiff * REWARD_PER_SEC_PER_ETH) + userInfo[_address].rewardDebt;
    }
}
