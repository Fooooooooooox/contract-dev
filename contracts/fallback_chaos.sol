pragma solidity ^0.5.0;

// 这是一个charity合约 如果用这个合约地址来和CharitySplitter来交互接受捐款 是不会出现任何问题的。
// 因为这个合约中正确定义了processDonation 方法（这个方法会在CharitySplitter中被调用）
contract Charity {
    mapping (address => uint256) public donations;
    function processDonation(address user) external payable {
        donations[user] += msg.value;
    }
}

// 这是一个receiver合约，如果用这个合约地址来和CharitySplitter来交互接受捐款是会出现问题的
contract Receiver {
    event ValueReceived(address user, uint amount);
    function() external payable {
        emit ValueReceived(msg.sender, msg.value);
    }
}

// 这是一个发放捐款的合约。donate函数会接受一个charity地址，调用charity合约中的processDonation方法
// 并传入value 进行转账
contract CharitySplitter {
    function donate(Charity charity) external payable {
        charity.processDonation.value(msg.value)(msg.sender);
    }
}

// notes:
// 如果调用CharitySplitter的donate方法的时候传入的是charity的地址，那么捐款会正确执行：

// 调用Charity 中定义的processDonation方法，charity合约就接受了转账传入的eth，并且给CharitySplitter记录下了捐款的金额。

// 如果调用的时候传入的是receiver合约的地址，那么就会出现混乱：

// 调用Charity 中定义的processDonation方法，但是问题是processDonation方法在receiver中并没有被定义，所以receiver的fallback函数就会被调用，虽然钱被转了，但是捐款的金额并没有得到处理。