// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.7.6;


import "../liquidity/LPool.sol";

contract UpgradeLPoolV2 is LPool {
    int public version;

    function getName() external pure returns (string memory)  {
        return "LPoolUpgradeV2";
    }

    function setVersion() external {
        version = version + 1;
    }
}
