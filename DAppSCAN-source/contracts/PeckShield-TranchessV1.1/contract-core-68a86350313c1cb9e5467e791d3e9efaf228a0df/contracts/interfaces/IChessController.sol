// SPDX-License-Identifier: MIT

interface IChessController {
    function getFundRelativeWeight(address account, uint256 timestamp)
        external
        view
        returns (uint256);
}
