// SPDX-License-Identifier: MIT

contract AddressWhitelist {
    mapping(address => bool) public whitelist;

    constructor(address[] memory whitelistAccounts) public {
        for (uint256 i = 0; i < whitelistAccounts.length; i++) {
            whitelist[whitelistAccounts[i]] = true;
        }
    }

    function check(address account) external view returns (bool) {
        return whitelist[account];
    }
}
