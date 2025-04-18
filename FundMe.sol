// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {PriceConvertor} from "./PriceConvertor.sol"; // import library to use here

contract FundMe {
     //event FundReceived(address sender, uint256 amount); // for console.log
     //event EthReceived(uint256 amount); // for console.log
    using PriceConvertor for uint256; // attaching with uint256 hass access to all priceconvertor functions or getconversion rate function. msg.value is uint256 thats why it can call getConversionRate func.
     uint256 public myValue = 1;
     //uint256 public minimumUsd = 5;
     uint256 public minimumUsd = 5e18; // bcz value of getConversionRate(msg.value) is in EHT with 18 decimal
     address[] public funders; // store the addresses of fund senders
     mapping (address funder => uint256 amountRaised) public fundsRaisedByAddress; // search the fund sent by address and get the value of total amount raised from that
    // define function of fund
    function Fund() public payable {
        // allow user to send money
        // send a minimum amount
        myValue = myValue +2;
        // 1: how we will send ETH to this contract via payable keyword
        // require(msg.value > 1e18, "not enough ETH amount!"); //1e18 = 1ETH = 1000000000000000000 wei , require mean its complusoty
        //require(getConversionRate(msg.value) >= minimumUsd, "not enough ETH amount!"); //1e18 = 1ETH = 1000000000000000000 wei , require mean its complusoty
        require(msg.value.getConversionRate() >= minimumUsd, "not enough ETH amount!"); //getConversionRate is a function from PriceConvertor library that can convert ETH value to USD
        // getConversionRate take a parameter 'uint ethAmount' but we didn't pass coz by default its first param is msg.value and if we want to pass 2nd param than we need to mentioned it
        
        funders.push(msg.sender); // store address of sender to the funders array
        fundsRaisedByAddress[msg.sender] = fundsRaisedByAddress[msg.sender] + msg.value;
        //emit FundReceived(msg.sender, msg.value); // for console.log

        // what is revert ?
        // undo any task which have done. but gas will be paid or consimed due to execution
        // for example we used a state variable myValue
    }

    function Withdraw() public  {
        for (uint256 funderIndex; funderIndex < funders.length; funderIndex++) 
        {
            address funder = funders[funderIndex]; // get address from the funders Array
            fundsRaisedByAddress[funder] = 0;   // set it to zero as we want only one time withdrawal for every funder.
        }
        funders = new address[](0); // reset the array, "Wipe the funders list clean."Prevent double-withdrawal or double-counting: After withdrawing, you don’t want to consider the same funder again unless they fund again.
        /* there are three ways to send or tranfer balance to sender
        1: transfer, 2: send , 3: call
        */
        // payable keyword is used to give funds to the contract
        // msg.sender = address
        // payable(msg.sender) = payable address
        // this key word is the object of thise whole contract
        // transfer automatically revert the transection on failed
        payable(msg.sender).transfer(address(this).balance); // msg.value will be equal to ETH balance of this contract in our case
        // using send which return bool instead of throw any error, its very risky
       bool sendSuccess = payable(msg.sender).send(address(this).balance);
       // on send method we have to check manually if transection is failed so using require to revert it.
       require(sendSuccess,"send failed");
       // call , this is most powerfull function in eth infrasruction to call any external fucntion to call
       (bool callSuccess,)= payable(msg.sender).call{value: address(this).balance}(""); // it return two values , gas used and return reason but here we need just success or not
       require(callSuccess,"Call failed");
    }

   
} 