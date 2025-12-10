// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract StakingContract {
    mapping(address => uint256) stakes;
    mapping(address => uint256) unclaimedRewards;
    mapping(address => uint256) lastUpdateTime;

    constructor() {}

    function stake() public payable {
        require(msg.value > 0);
        if (!lastUpdateTime[msg.sender]) {
            lastUpdateTime[msg.sender] = block.timestamp;
        } else {
            unclaimedRewards[msg.sender] += (block.timestamp - lastUpdateTime[msg.sender]) * stakes[msg.sender];
            lastUpdateTime[msg.sender] = block.timestamp;
        }
        stakes[msg.sender] += msg.value;
    }

    function unstake(uint256 _amount) public {
        require(_amount <= stakes[msg.sender]);

        unclaimedRewards[msg.sender] += (block.timestamp - lastUpdateTime[msg.sender]) * stakes[msg.sender];
        lastUpdateTime[msg.sender] = block.timestamp;

        payable(msg.sender).transfer(_amount);
        stakes[msg.sender] -= _amount;
    }

    function balanceOf(address _staker) public view returns (uint256) {
        return stakes[_staker];
    }

    function getRewards(address _address) public view {
        uint256 currentReward = unclaimedRewards[_address];
        uint256 lastUpdatedTime = lastUpdateTime[_address];
        uint256 newReward = (block.timestamp - lastUpdatedTime) * stakes[_address];
        return currentReward + newReward;
    }

    function claimRewards() public {
        uint256 currentReward = unclaimedRewards[msg.sender];
        uint256 lastUpdatedTime = lastUpdateTime[msg.sender];
        uint256 newReward = (block.timestamp - lastUpdatedTime) * stakes[msg.sender];

        // Transfer currentReward + newReward amount of SuKaCoin

        unclaimedRewards[msg.sender] = 0;
        lastUpdateTime[msg.sender] = block.timestamp;
    }
}
