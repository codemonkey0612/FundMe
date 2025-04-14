// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
// Introdue Inheritance in solidity
import {SimpleStorage} from "./simpleStorage.sol";
contract AddFiveStore is SimpleStorage {
    // +5
    // overrides
    // virtual , override
    function store(uint256 _fvrNumber) override public {
        myFavNumber = _fvrNumber +5;
    }
    
}