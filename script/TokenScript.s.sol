// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {Token} from "../src/Elpabl0Token.sol";

contract TokenScript is Script {
    uint256 initialSupply = 1000e18;

    function run() public returns (Token, uint256) {
        vm.startBroadcast();
        Token token = new Token(initialSupply);
        vm.stopBroadcast();
        return (token, initialSupply);
    }
}
