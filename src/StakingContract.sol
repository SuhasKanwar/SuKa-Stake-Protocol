// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract StakingContract {
    mapping(address => uint256) stakes;
    uint256 totalStakes;

    constructor() {}

    function stake() public payable {
        require(msg.value > 0);
        stakes[msg.sender] += msg.value;
    }

    function unstake(uint256 _amount) public {
        require(_amount <= stakes[msg.sender]);
        payable(msg.sender).transfer(_amount);
        stakes[msg.sender] -= _amount;
    }

    function balanceOf(address _staker) public view returns (uint256) {
        return stakes[_staker];
    }

    function getRewards() public view {}

    function claimRewards() public {}
}
