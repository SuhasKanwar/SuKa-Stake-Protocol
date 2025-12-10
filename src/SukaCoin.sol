// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { Ownable }  from "@openzeppelin/contracts/access/Ownable.sol";

contract SuKaCoinContract is ERC20, Ownable {
    address public stakingContract;

    constructor(address _stakingContract) ERC20("SuKaCoin", "SKC") Ownable(msg.sender) {
        stakingContract = _stakingContract;
    }

    modifier onlyStakingContract {
        require(msg.sender == stakingContract, "Only the staking contract can envoke this function");
        _;
    }

    function updateStakingContract(address _stakingContract) public onlyOwner {
        stakingContract = _stakingContract;
    }

    function mint(address _account, uint256 _amount) public onlyStakingContract {
        
        _mint(_account, _amount);
    }
}