关于receive和fallback：
https://www.notion.so/fallback-receive-898cbf976f124f1487ca1db05efaccc4

知识补充1：

直接转账是不会涉及到evm的opcode执行的，eoa账户给eoa账户转账，他只会收取一笔最小的gas（2100）

直接转账的方法：

`eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[1], value: web3.toWei(1, "ether")})`

知识补充2:

solidity里，transfer函数和call的时候传value是不一样的，可以说transfer是solidity为了安全加上的一个补丁。

transfer和send都是有gas limit限制的，2300的gas，如果你的gas超过了2300，交易会被revert

最开始引入`transfer()` 和 `send()` 是为了防止重入攻击

```
重入攻击，希望是你看到上述代码后的第一反应。 引入 transfer() 和 send() 的全部原因是为了解决The DAO上臭名昭著的黑客事件的原因。 当时的想法是，2300Gas足够触发一个日志条目，但不足以进行再重入的调用来修改存储状态。

不过请记住，Gas成本是会变化的，这意味着无论如何这都不是解决再重入攻击的好办法。 19 年初，君士坦丁堡分叉被推迟，就是因为gas成本的降低，导致以前重入攻击安全的代码不再安全。

如果我们不打算再使用transfer()和send()，我们就必须用更强大的方式来防止重入。 幸运的是，这个问题有很好的解决办法。
```

call.value send transfer

There are currently 3 ways to transfer eth in solidity contracts: trasnfer, send and call.value. By the way, there is another kind of transfer called `raw transaction` which move eth from one Externally Owned Account (EOA) to another EOA and does not involve the running of the EVM.