// SPDX-License-Identifier: MIT

interface IAprOracle {
    function capture() external returns (uint256 dailyRate);
}
