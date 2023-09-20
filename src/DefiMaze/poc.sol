//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "./SetUp.sol";

contract ContractTest is Test {
    SetUp public setup = new SetUp();
    DeFiPlatform public df = DeFiPlatform(setup.platfrom());
    Vault public vault = Vault(setup.vault());

    function testExp() public {
        deal(address(this), 7 ether);
        df.depositFunds{value:7 ether}(7 ether);
        df.calculateYield(0,1,1);
        df.requestWithdrawal(7 ether);
        vault.isSolved();
        require(vault.solved());
    }
}