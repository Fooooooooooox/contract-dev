pragma solidity ^0.6.6;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "./IFlashLoanReceiver.sol";
import "./ILendingPoolAddressesProvider.sol";
import "../utils/Withdrawable.sol";

abstract contract FlashLoanReceiverBase is IFlashLoanReceiver, Withdrawable {

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    // 定义ethAddress地址
    address constant ethAddress = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    ILendingPoolAddressesProvider public addressesProvider;

    // constructor 函数中接受_addressProvider地址，这个应该是借出钱的合约地址（属于ILendingPoolAddressesProvider 可以看一下这个合约是干嘛的）
    // 这个合约是一个interface合约，有两个方法：getLendingPoolCore()、getLendingPool()
    // getLendingPoolCore() 是返回一个payable的地址，getLendingPool()是返回一个普通的地址
    constructor(address _addressProvider) public {
        addressesProvider = ILendingPoolAddressesProvider(_addressProvider);
    }

    // receive函数 这个应该是最重要的 让flashloan合约具有接受eth转账的功能。
    receive() payable external {}

    // 这个也非常重要 是把你借到的钱还回去
    // 传入两个参数：reserve地址 amount数量
    function transferFundsBackToPoolInternal(address _reserve, uint256 _amount) internal {
        // 从addressesProvider.getLendingPoolCore 中获取地址payable的地址 记为core
        address payable core = addressesProvider.getLendingPoolCore();
        // 调用transferInternal 完成转账
        transferInternal(core, _reserve, _amount);
    }

    // transferInternal函数会接受_destination地址、reserve地址、数量
    // 检查_reserve 地址是否等于前面定义好的eth地址
    function transferInternal(address payable _destination, address _reserve, uint256 _amount) internal {
        if(_reserve == ethAddress) {
            // 调用call函数，从reserve函数给destination函数转账
            (bool success, ) = _destination.call{value: _amount}("");
            require(success == true, "Couldn't transfer ETH");
            return;
        }
        // 如果不是eth地址 就调用IERC20来转账
        IERC20(_reserve).safeTransfer(_destination, _amount);
    }

    function getBalanceInternal(address _target, address _reserve) internal view returns(uint256) {
        if(_reserve == ethAddress) {
            return _target.balance;
        }
        return IERC20(_reserve).balanceOf(_target);
    }
}
