// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor(uint256 _initialSupply) ERC20("Elpabl0", "PBL0") {
        _mint(msg.sender, _initialSupply);
    }
}
