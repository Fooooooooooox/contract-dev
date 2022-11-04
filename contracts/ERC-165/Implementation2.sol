// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import './ERC165.sol';
import './ERC165MappingImplementation.sol';

// 或者不用ERC165MappingImplementation 只用erc165

contract Implementation2 is ERC165, Simpson {
    function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
        return
            interfaceID == this.supportsInterface.selector || // ERC165
            interfaceID == this.is2D.selector ^ this.skinColor.selector; // Simpson
    }

    function is2D() external returns (bool) {}

    function skinColor() external returns (string memory) {}
}
