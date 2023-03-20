// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract LiquidityMining {
    using SafeERC20 for IERC20;

    IERC20 public lpToken;
    IERC20 public rewardToken;
    uint256 public rewardPerBlock;
    uint256 public lastUpdateBlock;
    mapping(address => uint256) public rewards;

    constructor(IERC20 _lpToken, IERC20 _rewardToken, uint256 _rewardPerBlock) {
        lpToken = _lpToken;
        rewardToken = _rewardToken;
        rewardPerBlock = _rewardPerBlock;
        lastUpdateBlock = block.number;
    }

    function updateReward() internal {
        uint256 reward = (block.number - lastUpdateBlock) * rewardPerBlock;
        rewardToken.safeTransferFrom(msg.sender, address(this), reward);
        lastUpdateBlock = block.number;
    }

    function stake(uint256 amount) external {
        updateReward();
        lpToken.safeTransferFrom(msg.sender, address(this), amount);
        rewards[msg.sender] += amount;
    }

    function unstake(uint256 amount) external {
        updateReward();
        lpToken.safeTransfer(msg.sender, amount);
        rewards[msg.sender] -= amount;
    }

    function claim() external {
        updateReward();
        uint256 reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        rewardToken.safeTransfer(msg.sender, reward);
    }
}
