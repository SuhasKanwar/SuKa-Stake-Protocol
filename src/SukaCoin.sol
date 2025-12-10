// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { Ownable }  from "@openzeppelin/contracts/access/Ownable.sol";

contract SukaCoin is ERC20, Ownable {
    constructor() ERC20("SuKaCoin", "SKC") Ownable(msg.sender) {
        _mint(msg.sender, 1000000);
    }

    function mint(address _account, uint256 _amount) public onlyOwner {
        _mint(_account, _amount);
    }
}