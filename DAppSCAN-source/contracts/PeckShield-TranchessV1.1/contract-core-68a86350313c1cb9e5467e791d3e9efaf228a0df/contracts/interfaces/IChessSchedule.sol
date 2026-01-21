// SPDX-License-Identifier: MIT

interface IChessSchedule {
    function getRate(uint256 timestamp) external view returns (uint256);

    function mint(address account, uint256 amount) external;

    function addMinter(address account) external;
}
