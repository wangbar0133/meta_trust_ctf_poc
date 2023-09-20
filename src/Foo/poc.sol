pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "./foo.sol";

contract ContractTest is Test {

    uint256[] challenge = new uint256[](8);
    Foo public foo = new Foo();

    function testExp() public {
        prepare();
        foo.setup();
        foo.stage1{gas:60000}();
        foo.stage2{gas:42110}();
        foo.stage3();
        foo.stage4();
        require(foo.isSolved());
    }

    function check() public view returns(bytes32) {
        if(gasleft()>31000) {
            for(int i=0;i<32;i++){keccak256(abi.encodePacked("1"));}
            return keccak256(abi.encodePacked("1337")); 
        }
        else { return keccak256(abi.encodePacked("13337")); }
    }

    function prepare() internal {
        
        challenge[0] = (block.timestamp & 0xf0000000) >> 28;
        challenge[1] = (block.timestamp & 0xf000000) >> 24;
        challenge[2] = (block.timestamp & 0xf00000) >> 20;
        challenge[3] = (block.timestamp & 0xf0000) >> 16;
        challenge[4] = (block.timestamp & 0xf000) >> 12;
        challenge[5] = (block.timestamp & 0xf00) >> 8;
        challenge[6] = (block.timestamp & 0xf0) >> 4;
        challenge[7] = (block.timestamp & 0xf) >> 0;
        for(uint i=0 ; i<8 ; i++) {
            for(uint j=i+1 ; j<8 ; j++) {
                if (challenge[i] > challenge[j]) {
                    uint tmp = challenge[i];
                    challenge[i] = challenge[j];
                    challenge[j] = tmp;
                }
            }
        }
    }

    function pos() external view returns (bytes32) {
        return keccak256(abi.encode(address(this),keccak256(abi.encode(uint256(4),uint256(1)))));
    }

    function sort(uint256[] memory) public view returns (uint[] memory) {
        return challenge;
    }

}