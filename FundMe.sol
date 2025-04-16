// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
     //event FundReceived(address sender, uint256 amount); // for console.log
     //event EthReceived(uint256 amount); // for console.log
     uint256 public myValue = 1;
     //uint256 public minimumUsd = 5;
     uint256 public minimumUsd = 5e18; // bcz value of getConversionRate(msg.value) is in EHT with 18 decimal
    // define function of fund
    function Fund() public payable {
        // allow user to send money
        // send a minimum amount
        myValue = myValue +2;
        // 1: how we will send ETH to this contract via payable keyword
        // require(msg.value > 1e18, "not enough ETH amount!"); //1e18 = 1ETH = 1000000000000000000 wei , require mean its complusoty
        require(getConversionRate(msg.value) >= minimumUsd, "not enough ETH amount!"); //1e18 = 1ETH = 1000000000000000000 wei , require mean its complusoty

        //emit FundReceived(msg.sender, msg.value); // for console.log

        // what is revert ?
        // undo any task which have done. but gas will be paid or consimed due to execution
        // for example we used a state variable myValue
    }

    function getPrice() public view returns (uint256){
        //address get from caainlink price feed for ETH '0x694AA1769357215DE4FAC081bf1f309aDC325306'
        //ABI (get function from chainlink github repo )
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        //get latest price data from chainlink
        //priceFeed.latestRoundData() --> 194718520 = 36,117 ETH (Ethereum) / roundID = 1 for now
        (
            /* uint80 roundId */,
            int256 price,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        )= priceFeed.latestRoundData(); // becuase latestRoundData return different value so we just need price at this time
        //*1 e18 means we want to get the usd value with unit in kilo
        // need casting price to uint256 bcz of decimal
        return uint256(price * 1e10); // this value is in ETH
    }

    function getConversionRate(uint ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        // eth price 2000_000000000000000000
        // we need to get eth value * usd price / usd value = ethPrice
        // (1000000000000000000 * 2000_000000000000000000) / 1e18 = $2000 to get the value eth to usd whole number
        // $2000 = 1 Eth
        uint256 ethAmountInUsd = (ethAmount * ethPrice)/1e18; 
         //emit EthReceived(ethAmountInUsd); // for console.log
        return ethAmountInUsd;
    }
} 