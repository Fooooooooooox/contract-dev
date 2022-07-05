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

// how to interact?

// first, call getMessageHash()
// input address to, amount, message and nonce
// and get your message hash 
// hash = ""0xc436a49c822567dc28b41c5c698e4d36965ee4ce1545dbcc33ec981ee955e643""


// then, you need to sign this massage with your private key, we use matemask to do this:
// onpen javascript console:
// ethereum.enable() ==> use metamask connect to remix 
// hash = ""0xc436a49c822567dc28b41c5c698e4d36965ee4ce1545dbcc33ec981ee955e643
// web3.personal.sign(hash, web3.eth.defaultAccount, console.log)
// get the signature
// input the signature into verify function

// https://www.youtube.com/watch?v=NP4db_UPVwc