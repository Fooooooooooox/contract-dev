pragma solidity ^0.6.6;

import './aave/FlashLoanReceiverBase.sol';
import './aave/ILendingPoolAddressesProvider.sol';
import './aave/ILendingPool.sol';

// 一些定义：
// reserve函数是你借到flash loan的地址
// pool是给你提供贷款的地址
//

// flashloan合约继承了FlashLoanReceiverBase，先看一下FlashLoanReceiverBase里有什么
// 最重要的是：里面定义了receive方法
contract Flashloan is FlashLoanReceiverBase {
    constructor(address _addressProvider) public FlashLoanReceiverBase(_addressProvider) {}

    /**
        This function is called after your contract has received the flash loaned amount
     */
    //  executeOperation里应该是可以由你自定义的逻辑
    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    ) external override {
        require(
            _amount <= getBalanceInternal(address(this), _reserve),
            'Invalid balance, was the flashLoan successful?'
        );

        // Your logic goes here.
        // !! Ensure that *this contract* has enough of `_reserve` funds to payback the `_fee` !!

        // 总的债务 = amount + fee
        uint totalDebt = _amount.add(_fee);
        // 把借到的flash loan还回去（
        // reserve是你借到flashloan的地址
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }

    /**
        Flash loan 1000000000000000000 wei (1 ether) worth of `_asset`
     */
    function flashloan(address _asset) public onlyOwner {
        bytes memory data = '';
        uint amount = 1 ether;

        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
        lendingPool.flashLoan(address(this), _asset, amount, data);
    }
}
