// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FallbackExample {
    uint256 public result;
    
    // when call a function without data this function call automatically
    receive() external payable {
        result = 1;
     }

     // when our contract do not know which function a user want to call with data 
     fallback() external payable { 
        result = 2;
     }
}