// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract ERC165Query {
    // 传入0xffffffff的时候会返回false 不知道这是个什么奇怪的函数签名
    // 查了一下4byte.directory：
    // https://www.4byte.directory/signatures/?bytes4_signature=0xffffffff
    // 	LOCK8605463013()或者是test266151307()
    bytes4 constant InvalidID = 0xffffffff;
    bytes4 constant ERC165ID = 0x01ffc9a7; //这个是bytes4(keccak256('supportsInterface(bytes4)')) 是为了检查合约是否支持erc165

    // 这个例子是用来查询一个合约实现了哪些接口的：
    // 传入地址 和计算好的_interfaceId返回一个bool值，如果实现了就返回1，未实现的返回0
    function doesContractImplementInterface(address _contract, bytes4 _interfaceId) external view returns (bool) {
        uint256 success;
        uint256 result;

        // 先判断合约是否支持erc165
        // 只有支持才可以用后续的方法判断合约是否实现某一函数
        (success, result) = noThrowCall(_contract, ERC165ID);
        if ((success==0)||(result==0)) {
            return false;
        }

        // 如果实现了0xffffffff 就返回false
        (success, result) = noThrowCall(_contract, InvalidID);
        if ((success==0)||(result!=0)) {
            return false;
        }

        // 查询特定的interfaceId
        (success, result) = noThrowCall(_contract, _interfaceId);
        if ((success==1)&&(result==1)) {
            return true;
        }
        return false;
    }

    function noThrowCall(address _contract, bytes4 _interfaceId) public view returns (uint256 success, uint256 result) {
        bytes4 erc165ID = ERC165ID;

        assembly {
                let x := mload(0x40)               // Find empty storage location using "free memory pointer"
                mstore(x, erc165ID)                // Place signature at beginning of empty storage 把ERC165ID supportsInterface(bytes4)的函数签名存储到memory中 x是存储的位置，erc165ID是存储的值
                mstore(add(x, 0x04), _interfaceId) // Place first argument directly next to signature 把要查询的interfaceid存入内存，位置是前面ERC165ID的位置（x）加上ERC165ID的长度（签名是四个字节）

                success := staticcall(
                                    30000,         // 30k gas
                                    _contract,     // To addr
                                    x,             // Inputs are stored at location x 输入从x位置开始
                                    0x24,          // Inputs are 36 bytes long 长度是0x24
                                    x,             // Store output over input (saves space) 输出存储到输入的位置
                                    0x20)          // Outputs are 32 bytes long
                result := mload(x)                 // Load the result
        }
        // 上面相当于构造了0x01ffc9a7interfaceID00000000000000000000000000000000000000000000000000000000
    }
}