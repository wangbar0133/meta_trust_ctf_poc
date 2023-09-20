//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "./greeterGate.sol";

contract ContractTest is Test {
    Gate public gate = new Gate(
        bytes32(hex"7465737412340000000000000000000000000000000000000000000000000000"),
        bytes32(hex"7465737456780000000000000000000000000000000000000000000000000000"),
        bytes32(hex"7465737490ab0000000000000000000000000000000000000000000000000000")
    );

    function testExp() public {
        gate.resolve(
            abi.encodeWithSignature(
                "unlock(bytes)", 
                bytes(hex"7465737490ab0000000000000000000000000000000000000000000000000000"))
        );

        require(gate.isSolved());
    }
}

contract Cal {
    function go() public pure returns(uint256){
        return uint256(keccak256(abi.encode(3)));
    }
}