// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LPToken is ERC20 {
    IERC20 public tokenA;
    IERC20 public tokenB;

    constructor(IERC20 _tokenA, IERC20 _tokenB) ERC20("LP Token", "LPT") {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    function mint(address to, uint256 amount) external {
        uint256 tokenAAmount = amount * tokenA.balanceOf(address(this)) / totalSupply();
        uint256 tokenBAmount = amount * tokenB.balanceOf(address(this)) / totalSupply();
        require(tokenA.transfer(to, tokenAAmount), "transfer tokenA failed");
        require(tokenB.transfer(to, tokenBAmount), "transfer tokenB failed");
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external {
        uint256 tokenAAmount = amount * tokenA.balanceOf(address(this)) / totalSupply();
        uint256 tokenBAmount = amount * tokenB.balanceOf(address(this)) / totalSupply();
        require(tokenA.transferFrom(from, address(this), tokenAAmount), "transfer tokenA failed");
        require(tokenB.transferFrom(from, address(this), tokenBAmount), "transfer tokenB failed");
        _burn(from, amount);
    }
}
