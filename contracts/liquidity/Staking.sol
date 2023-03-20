pragma solidity ^0.8.0;
// SPDX-License-Identifier: UNLICENSED
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./LPToken.sol";
import "./LiquidityMining.sol";
contract Staking {
    using SafeERC20 for IERC20;

    IERC20 public tokenA;
    IERC20 public tokenB;
    LPToken public lpToken;
    LiquidityMining public liquidityMining;

    constructor(IERC20 _tokenA, IERC20 _tokenB, LPToken _lpToken, LiquidityMining _liquidityMining) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        lpToken = _lpToken;
        liquidityMining = _liquidityMining;
    }

    function stake(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "amounts must be greater than zero");
        tokenA.safeTransferFrom(msg.sender, address(this), amountA);
        tokenB.safeTransferFrom(msg.sender, address(this), amountB);
        lpToken.mint(msg.sender, amountA + amountB);
        lpToken.approve(address(liquidityMining), amountA + amountB);
        liquidityMining.stake(amountA + amountB);
    }

    function unstake() external {
        uint256 lpTokenAmount = lpToken.balanceOf(msg.sender);
        require(lpTokenAmount > 0, "lpToken balance must be greater than zero");
        lpToken.approve(address(liquidityMining), 0);
        lpToken.approve(address(liquidityMining), lpTokenAmount);
        liquidityMining.unstake(lpTokenAmount);
        lpToken.burn(msg.sender, lpTokenAmount);
        tokenA.safeTransfer(msg.sender, tokenA.balanceOf(address(this)));
        tokenB.safeTransfer(msg.sender, tokenB.balanceOf(address(this)));
    }
}
