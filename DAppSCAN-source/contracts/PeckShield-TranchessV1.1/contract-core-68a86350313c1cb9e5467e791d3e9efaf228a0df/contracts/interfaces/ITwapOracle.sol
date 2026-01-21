// SPDX-License-Identifier: MIT

interface ITwapOracle {
    function getTwap(uint256 timestamp) external view returns (uint256);
}
