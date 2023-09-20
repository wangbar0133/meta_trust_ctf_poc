//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "./byteDance.sol";

contract ContractTest is Test {
    ByteDance public byteDance = new ByteDance();

    function testExp() public {
        Deployer dev = new Deployer();
        address exp = dev.deploy();
        byteDance.checkCode(exp);
        require(byteDance.isSolved());
    }
}

contract Deployer{
    function deploy() public returns(address){
        bytes memory code = hex"6101016111011B156101016111011B55610101611181F3";
        return address(new Exp(code));
    }
}
contract Exp{
    constructor(bytes memory code){assembly{return (add(code, 0x20), mload(code))}}
}