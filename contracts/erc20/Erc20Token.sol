// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Freedom is ERC20 {
    constructor() ERC20("Freedom", "FDM") {
        _mint(msg.sender, 100000 * (10 ** decimals()));
    }
}

contract Liberty is ERC20 {
    constructor() ERC20("Liberty", "LIBER") {
        _mint(msg.sender, 100000 * (10 ** decimals()));
    }
}
