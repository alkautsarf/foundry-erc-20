// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Token} from "../src/Elpabl0Token.sol";
import {TokenScript} from "../script/TokenScript.s.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";


contract TokenTest is Test {
    Token token;
    TokenScript tokenScript;

    uint256 initialSupply;
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");
    uint256 constant INITIAL_BALANCE = 10 ether;

    function setUp() public {
        tokenScript = new TokenScript();
        (token, initialSupply) = tokenScript.run();
    }

    modifier initiateTxWithBob() {
        vm.prank(msg.sender);
        token.transfer(bob, initialSupply / 2);
        hoax(bob, INITIAL_BALANCE);
        _;
    }

    modifier initiateTxWithAlice() {
        vm.prank(msg.sender);
        token.transfer(alice, initialSupply / 2);
        hoax(alice, INITIAL_BALANCE);
        _;
    }

    function testOwnerBalance() public {
        uint256 balance = token.balanceOf(msg.sender);
        assertEq(balance, initialSupply);
    }

    function testBobBalance() public initiateTxWithBob {
        assert(token.balanceOf(bob) == initialSupply / 2);
    }

    function testAliceBalance() public initiateTxWithAlice {
        assert(token.balanceOf(alice) == initialSupply / 2);
    }

    function testTransferFromSucceed() public initiateTxWithBob {
        token.approve(alice, initialSupply / 2);
        uint256 balance = token.balanceOf(bob);
        vm.prank(alice);
        token.transferFrom(bob, alice, initialSupply / 2);
        assertEq(balance, token.balanceOf(alice));
    }

    function testTransferFromFailed(address _from) public {
        vm.assume(_from != address(0));
        vm.prank(_from);
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientAllowance.selector,
                _from,
                0,
                initialSupply
            )
        );
        token.transferFrom(bob, _from, initialSupply);
    }
}
