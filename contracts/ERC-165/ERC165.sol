// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/*
bytes4(keccak256('supportsInterface(bytes4)')) 得到 ==》 0x01ffc9a7
*/

interface ERC165 {
    /// @notice 查询一个合约时候实现了一个接口
    /// @param interfaceID  参数：接口ID, 参考上面的定义
    /// @return true 如果函数实现了 interfaceID (interfaceID 不为 0xffffffff )返回true, 否则为 false
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

/*
true ：当接口ID interfaceID 是 0x01ffc9a7 (EIP165 标准接口)返回 true
false ：当 interfaceID 是 0xffffffff 返回 false
true ：任何合约实现了接口的 interfaceID 都返回 true
false ：其他的都返回 false
*/

// 所以 可以调用contract.supportsInterface(0x01ffc9a7)来判断一个合约是否支持erc165
// 如果支持的话，后续就可以自定义计算出一些Interface Identifier来判断合约是否实现了某些方法