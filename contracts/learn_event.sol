// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Test {
   event Deposit(address indexed _from, uint64 indexed _id, uint _value);
   function deposit(uint64 _id) public payable {      
      // emit Deposit(msg.sender, _id, msg.value);
   }
}

// see the difference with and without "emit Deposit(msg.sender, _id, msg.value);"

// with emit
// log is generated: 
// https://rinkeby.etherscan.io/tx/0xb42639d65f2317ea388f12238bf8700abc0685150500b0ca5f5f0ff1eb35c137

// without emit
// https://rinkeby.etherscan.io/tx/0xb1ae8574f91b65949f5d133559c39426dd9299ec01b701bc8aa13fb06ff7c0e2

