// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./ERC165.sol";

// 继承ERC165
contract ERC165MappingImplementation is ERC165 {
    /// @dev 不能设置 0xffffffff 为 true
    // 0xffffffff 应该是和erc165之前的判断方法有关的
    mapping(bytes4 => bool) internal supportedInterfaces;

    // 将supportsInterface函数签名设置为true
    function ERC165MappingImplementationfunc() internal {
        supportedInterfaces[this.supportsInterface.selector] = true;
    }

    // 输入一个interfaceID 查询在supportedInterfaces maps里这个interface对应的是不是true
    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return supportedInterfaces[interfaceID];
    }
}

interface Simpson {
    function is2D() external returns (bool);
    function skinColor() external returns (string memory);
}
