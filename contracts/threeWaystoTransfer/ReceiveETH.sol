// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ReceiveETH {
    // 收到eth事件，记录amount和gas
    event Log(uint amount, uint gas);

    // receive方法，接收eth时被触发
    receive() external payable {
        emit Log(msg.value, gasleft());
    }

    // 返回合约ETH余额
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

// receive函数会在1.收到eth（call{value: xxx) 2.call data为空的时候被调用
/*
    Which function is called, fallback() or receive()?
    
               send Ether
                   |
             msg.data is empty?
                  / \
                yes  no
                /     \
    receive() exists?  fallback()
             /   \
            yes   no
            /      \
        receive()   fallback()
*/
