// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract LedgerBalance {
    // balances is the name of the mapping.
    // address is the key type
    // uint is the value type
   mapping(address => uint) public balances;

   function updateBalance(uint newBalance) public {
      balances[msg.sender] = newBalance;
   }
}
contract Updater {
   function updateBalance() public returns (uint) {
      LedgerBalance ledgerBalance = new LedgerBalance();
      ledgerBalance.updateBalance(10);
      return ledgerBalance.balances(address(this));
   }
}