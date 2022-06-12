// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Test {
   event Deposit(address indexed _from, uint64 indexed _id, uint _value);
   function deposit(uint64 _id) public payable {      
      emit Deposit(msg.sender, _id, msg.value);
   }
}