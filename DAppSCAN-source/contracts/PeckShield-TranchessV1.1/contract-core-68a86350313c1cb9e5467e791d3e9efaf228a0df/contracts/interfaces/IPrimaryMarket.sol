// SPDX-License-Identifier: MIT

interface IPrimaryMarket {
    function claim(address account)
        external
        returns (uint256 createdShares, uint256 redeemedUnderlying);

    function settle(
        uint256 day,
        uint256 fundTotalShares,
        uint256 fundUnderlying,
        uint256 underlyingPrice,
        uint256 previousNav
    )
        external
        returns (
            uint256 sharesToMint,
            uint256 sharesToBurn,
            uint256 creationUnderlying,
            uint256 redemptionUnderlying,
            uint256 fee
        );
}
