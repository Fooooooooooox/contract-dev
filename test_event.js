let web3 = new Web3(Web3.givenProvider || "ws://localhost:8545");

var abi = [
    {
        "anonymous": false,
        "inputs": [
            {
                "indexed": true,
                "internalType": "address",
                "name": "_from",
                "type": "address"
            },
            {
                "indexed": true,
                "internalType": "uint64",
                "name": "_id",
                "type": "uint64"
            },
            {
                "indexed": false,
                "internalType": "uint256",
                "name": "_value",
                "type": "uint256"
            }
        ],
        "name": "Deposit",
        "type": "event"
    },
    {
        "inputs": [
            {
                "internalType": "uint64",
                "name": "_id",
                "type": "uint64"
            }
        ],
        "name": "deposit",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function"
    }
]
var ClientReceipt = web3.eth.contract(abi);
var clientReceiptContract = ClientReceipt.at("0x5B38Da6a701c568545dCfcB03FcB875f56beddC4" /* address */);

// get deposite event
var event = clientReceiptContract.Deposit(function(error, result) {
    console.log("hhhhh",event)
   if (!error)console.log(result);
});
