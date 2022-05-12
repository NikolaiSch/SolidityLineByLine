// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol";

contract WETH is ERC20 {

    event Deposit(uint256 amountDeposited, address depositorAddress);
    event Withdraw(uint256 amountWithdrew, address withdrawalAddress);

    constructor() ERC20("Wrapped Ether", "WETH", 18) {}

    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.value, msg.sender);
    }

    function withdraw(uint256 amount) public {
        _burn(msg.sender, amount);
        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "WETH: Revert due to failed withdraw call");
        emit Withdraw(amount, msg.sender);
    }

    receive() external payable {
        deposit();
    }
}
