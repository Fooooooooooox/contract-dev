// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// 定义了一个interface
interface Solidity101 {
    function hello() external pure;
    function world(int) external pure;
}

contract InterfaceCaculator {
    /* 计算interface identifier
    selector：函数签名的前四个字节

    接口ID(interface identifier)：接口中所有函数选择器的异或（XOR
    计算方式如下：
    */
    function calculateSelector() public pure returns (bytes4) {
        Solidity101 i;
        return i.hello.selector ^ i.world.selector;
    }
}

// ! 这个calculator只是为了展示interface indentifier是如何计算的 实际上有个方法来计算：type(ITest).interfaceId（在测试用例中有展示详细用法）

// interfaceId = xor of all selectors (methods) name and param type, don't care to return type