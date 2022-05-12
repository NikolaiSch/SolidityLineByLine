# Wrapped Ether Contract

## What this is
- This is used by smart contracts to easily use Ether as a ERC20 token
- This is a similar implementation to [Mainnet Ethereum WETH token](https://etherscan.io/address/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2#code)

## Line by Line explanation

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
```

- The SPDX License allows developers to license their solidity code without attaching a full license
- the pragma solidity directive allows developers to allow other developers to know what version of solidity it is built for
  - `^0.8.9` represents all versions above 0.8.9

```solidity
import "https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol";
```

- Importing a prebuilt contract for ERC20. These contracts must follow IERC20, which is a standard that they must adhere to.
- The reason for this is that all tokens should be interacted with in the same manor, with the same function names and types

```solidity
contract WETH is ERC20 {
  ...
}
```

- It is convention to name the contract, the name of the token, in this case WETH.
- we use `is` to represent inheritance, which is a key part of Object oriented systems
- in this case, `is` just means, all functions in ERC20 are implemented in the WETH contract

```solidity
  event Deposit(uint256 amountDeposited, address depositorAddress);
  event Withdraw(uint256 amountWithdrew, address withdrawalAddress);
```    

- We can define events with up to 3 parameters
- Developers use this to track when users call certain functions
- Events can be tracked in the UI to see if something has changed, and notify user

```solidity
    constructor() ERC20("Wrapped Ether", "WETH", 18) {}
```

- A constructor function is called when we create the contract
- We call the ERC20 constructor in our WETH constructor
- The arguments for ERC20 are
  - Name of token, this is the full name, so `Wrapped Ether`
  - Symbol of token, which is `WETH`, as that what we want users to see
  - decimals, since there are no floats in solidity, so we use 1 ether is 10 ** 18 wei, and then on the user side, such as website, we divide by decimals (10 ** 18)

```solidity
    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.value, msg.sender);
    }
 ```
 
 - This deposit function has attributes `public` which means anyone can access it, as getters are created
 - Another attribute is `payable`, which means this function recieves money
 - We then call the \_mint function from ERC20 implementation.
 - We then emit the event Deposit that we defined before, which creates an event in the frontend with the variables we gave it

```solidity
  function withdraw(uint256 amount) public {
        _burn(msg.sender, amount);
        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "WETH: Revert due to failed withdraw call");
        emit Withdraw(amount, msg.sender);
    }
```

- We add a public function to withdraw Ether from the WETH contract, when they have enough WETH
- First, we use \_burn to burn the token. This will fail and revert if they do not have enough WETH
- Then we use payable() to declare an address as payable, which we can then call with the value: amount (so we can interact with smart contracts too)
- We then check that the previous call was a successful transaction, and if it wasn't, we revert
- Then we emit a withdraw event

```solidity
  receive() external payable {
        deposit();
    }
```

- This receive function, is a catchall for those who send funds to the smart contract without calling it.



  
