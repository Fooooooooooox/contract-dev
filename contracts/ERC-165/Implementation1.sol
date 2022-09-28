// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./ERC165.sol";
import "./ERC165MappingImplementation.sol";

// lisa继承了simpson里的方法
contract Implementation1 is ERC165MappingImplementation, Simpson {
    function Implementation1func() public {
        // 用Implementation1内支持的函数的选择器做异或 ==》 得到lisa的interface indentifier
        // 在map中把Implementation1的interface indentifier设置为true
        supportedInterfaces[this.is2D.selector ^ this.skinColor.selector] = true;
    }

    function is2D() external returns (bool){}
    function skinColor() external returns (string memory){}
}