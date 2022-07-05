// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract VerifySignature {

    // you send a message with your signature to a bank telling it 
    // "i want to send xx amount to someone with a message"
    function getMessageHash(
        address _to, uint _amount, string memory _message, uint _nonce
    ) 
        public pure returns (bytes32)
    {
        return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
    }

    // signature is produced by signing a keccak256 hash with the following format:
    // "\x19Ethereum Signed Message:\n" + len(msg) + msg
    function getEthSignedMessageHash(bytes32 _messageHash) 
    public pure returns (bytes32)
    {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));   
    }

    function verify(
        address _signer,
        address _to, uint _amount, string memory _message, uint _nonce,
        bytes memory _signature
    ) 
        public pure returns (bool)
    {
        bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, _signature) == _signer;
    }

    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) 
        public pure returns (address)
    {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);    
    }

    function splitSignature(bytes memory _sig)
        public pure returns (bytes32 r, bytes32 s, uint8 v)
    {
        require(_sig.length == 65, "invalid signature length");
        assembly {
            // add here means you add 32 to the pointer
            // so mload(add(_sig, 32)) skips the first 32 bytes of data and read from 32 byte
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }
    }
}