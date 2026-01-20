
// --- START: FeeCollector.sol ---
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


// --- START: Ownable.sol ---
// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)



// --- START: Context.sol ---
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)


/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// --- END: Context.sol ---

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// --- END: Ownable.sol ---

// --- START: Math.sol ---
// OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)


/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a / b + (a % b == 0 ? 0 : 1);
    }
}

// --- END: Math.sol ---

// --- START: SafeERC20.sol ---
// OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)



// --- START: IERC20.sol ---
// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// --- END: IERC20.sol ---

// --- START: Address.sol ---
// OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)


/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// --- END: Address.sol ---

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// --- END: SafeERC20.sol ---

// --- START: IERC20Metadata.sol ---
// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)



/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// --- END: IERC20Metadata.sol ---

// --- START: BalanceAccounting.sol ---



contract BalanceAccounting {
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function _mint(address account, uint256 amount) internal virtual {
        _totalSupply += amount;
        unchecked {
            _balances[account] += amount;
        }
    }

    function _burn(address account, uint256 amount) internal virtual {
        _balances[account] -= amount;
        unchecked {
            _totalSupply -= amount;
        }
    }
}

// --- END: BalanceAccounting.sol ---


contract FeeCollector is Ownable, BalanceAccounting {
    using SafeERC20 for IERC20;

    struct EpochBalance {
        mapping(address => uint256) balances;
        uint256 totalSupply;
        uint256 tokenSpent;
        uint256 inchBalance;
    }

    struct TokenInfo {
        uint40 lastTime;
        uint216 lastValue;
        mapping(uint256 => EpochBalance) epochBalance;
        uint256 firstUnprocessedEpoch;
        uint256 currentEpoch;
        mapping(address => uint256) firstUserUnprocessedEpoch;
    }

    uint256 private immutable _k00;
    uint256 private immutable _k01;
    uint256 private immutable _k02;
    uint256 private immutable _k03;
    uint256 private immutable _k04;
    uint256 private immutable _k05;
    uint256 private immutable _k06;
    uint256 private immutable _k07;
    uint256 private immutable _k08;
    uint256 private immutable _k09;
    uint256 private immutable _k10;
    uint256 private immutable _k11;
    uint256 private immutable _k12;
    uint256 private immutable _k13;
    uint256 private immutable _k14;
    uint256 private immutable _k15;
    uint256 private immutable _k16;
    uint256 private immutable _k17;
    uint256 private immutable _k18;
    uint256 private immutable _k19;

    uint256 private constant _MAX_TIME = 0xfffff;

    mapping(IERC20 => TokenInfo) public tokenInfo;
    IERC20 public immutable token;
    uint256 public immutable minValue;
    uint8 public immutable decimals;

    constructor(
        IERC20 _token,
        uint256 _minValue,
        uint256 _deceleration
    ) {
        require(_deceleration > 0 && _deceleration < 1e36, "Invalid deceleration");

        token = _token;
        minValue = _minValue;
        decimals = IERC20Metadata(address(_token)).decimals();

        uint256 z;
        _k00 = z = _deceleration;
        _k01 = z = z * z / 1e36;
        _k02 = z = z * z / 1e36;
        _k03 = z = z * z / 1e36;
        _k04 = z = z * z / 1e36;
        _k05 = z = z * z / 1e36;
        _k06 = z = z * z / 1e36;
        _k07 = z = z * z / 1e36;
        _k08 = z = z * z / 1e36;
        _k09 = z = z * z / 1e36;
        _k10 = z = z * z / 1e36;
        _k11 = z = z * z / 1e36;
        _k12 = z = z * z / 1e36;
        _k13 = z = z * z / 1e36;
        _k14 = z = z * z / 1e36;
        _k15 = z = z * z / 1e36;
        _k16 = z = z * z / 1e36;
        _k17 = z = z * z / 1e36;
        _k18 = z = z * z / 1e36;
        _k19 = z = z * z / 1e36;
        require(z * z < 1e36, "Deceleration is too slow");
    }

    function name() external view returns(string memory) {
        return string(abi.encodePacked("FeeCollector: ", IERC20Metadata(address(token)).name()));
    }

    function symbol() external view returns(string memory) {
        return string(abi.encodePacked("fee-", IERC20Metadata(address(token)).symbol()));
    }

    function getEpochBalance(IERC20 _token, uint256 epoch) external view returns(uint256 totalSupply, uint256 tokenSpent, uint256 inchBalance) {
        EpochBalance storage epochBalance = tokenInfo[_token].epochBalance[epoch];
        (totalSupply, tokenSpent, inchBalance) = (epochBalance.totalSupply, epochBalance.tokenSpent, epochBalance.inchBalance);
    }

    function getUserEpochBalance(IERC20 _token, uint256 epoch, address user) external view returns(uint256 balance) {
        balance = tokenInfo[_token].epochBalance[epoch].balances[user];
    }

    function getFirstUserUnprocessedEpoch(IERC20 _token, address user) external view returns(uint256 firstUserUnprocessedEpoch) {
        firstUserUnprocessedEpoch = tokenInfo[_token].firstUserUnprocessedEpoch[user];
    }

    function decelerationTable() public view returns(uint256[20] memory) {
        return [
            _k00, _k01, _k02, _k03, _k04,
            _k05, _k06, _k07, _k08, _k09,
            _k10, _k11, _k12, _k13, _k14,
            _k15, _k16, _k17, _k18, _k19
        ];
    }

    function value(IERC20 _token) public view returns(uint256 result) {
        return valueForTime(block.timestamp, _token);
    }

    function valueForTimeSimple(uint256 time, IERC20 _token) public view returns(uint256 result) {
        uint256[20] memory table = decelerationTable();
        uint256 lastTime = tokenInfo[_token].lastTime;
        uint256 lastValue = tokenInfo[_token].lastValue;
        uint256 secs = Math.min(time - lastTime, _MAX_TIME);
        result = Math.max(lastValue, minValue);
        for (uint i = 0; secs > 0 && i < table.length; i++) {
            if (secs & 1 != 0) {
                result = result * table[i] / 1e36;
            }
            if (result < minValue) return minValue;
            secs >>= 1;
        }
    }

    function valueForTime(uint256 time, IERC20 _token) public view returns(uint256 result) {
        uint256 secs = tokenInfo[_token].lastTime;
        result = tokenInfo[_token].lastValue;

        secs = time - secs;
        if (secs > _MAX_TIME) {
            secs = _MAX_TIME;
        }
        if (result < minValue) {
            result = minValue;
        }

        uint256 minValue_ = minValue;
        assembly { // solhint-disable-line no-inline-assembly
            if and(secs, 0x00000F) {
                if and(secs, 0x000001) {
                    result := div(mul(result, 999900000000000000000000000000000000), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x000002) {
                    result := div(mul(result, 999800010000000000000000000000000000), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x000004) {
                    result := div(mul(result, 999600059996000100000000000000000000), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x000008) {
                    result := div(mul(result, 999200279944006999440027999200010000), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }
            }

            if and(secs, 0x0000F0) {
                if and(secs, 0x000010) {
                    result := div(mul(result, 998401199440181956328006856128688560), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x000020) {
                    result := div(mul(result, 996804955043593987145855519554957648), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x000040) {
                    result := div(mul(result, 993620118399461429792290614928235372), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x000080) {
                    result := div(mul(result, 987280939688159750172898466482272707), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }
            }

            if and(secs, 0x000F00) {
                if and(secs, 0x000100) {
                    result := div(mul(result, 974723653871535730138973062438582481), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x000200) {
                    result := div(mul(result, 950086201416677390961738571086337286), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x000400) {
                    result := div(mul(result, 902663790122371280016479918855854806), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x000800) {
                    result := div(mul(result, 814801917998084346828628782199508463), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }
            }

            if and(secs, 0x00F000) {
                if and(secs, 0x001000) {
                    result := div(mul(result, 663902165573356968243491567819400493), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x002000) {
                    result := div(mul(result, 440766085452993090398118811102456830), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x004000) {
                    result := div(mul(result, 194274742085555207178862579417407102), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x008000) {
                    result := div(mul(result, 37742675412408995610179844414960649), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }
            }

            if and(secs, 0x0F0000) {
                if and(secs, 0x010000) {
                    result := div(mul(result, 1424509547286462546864068778806188), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x020000) {
                    result := div(mul(result, 2029227450310282474813662564103), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x040000) {
                    result := div(mul(result, 4117764045092769930387910), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }

                if and(secs, 0x080000) {
                    result := div(mul(result, 16955980731058), 1000000000000000000000000000000000000)
                    if lt(result, minValue_) {
                        result := minValue_
                        secs := 0
                    }
                }
            }
        }
    }

    function updateRewards(address[] calldata receivers, uint256[] calldata amounts) external {
        for (uint i = 0; i < receivers.length; i++) {
            _updateReward(IERC20(msg.sender), receivers[i], amounts[i]);
        }
    }

    function updateReward(address referral, uint256 amount) external {
        _updateReward(IERC20(msg.sender), referral, amount);
    }

    // SWC-107-Reentrancy: L340 - L343
    function updateRewardNonLP(IERC20 erc20, address referral, uint256 amount) external {
        erc20.safeTransferFrom(msg.sender, address(this), amount);
        _updateReward(erc20, referral, amount);
    }

    function trade(IERC20 erc20, uint256 amount) external {
        TokenInfo storage _token = tokenInfo[erc20];
        uint256 currentEpoch = _token.currentEpoch;
        uint256 firstUnprocessedEpoch = _token.firstUnprocessedEpoch;
        EpochBalance storage epochBalance = _token.epochBalance[firstUnprocessedEpoch];
        EpochBalance storage currentEpochBalance = _token.epochBalance[currentEpoch];

        uint256 currentEpochStored = currentEpoch;

        uint256 unprocessedTotalSupply = epochBalance.totalSupply;
        uint256 unprocessedTokenBalance = unprocessedTotalSupply - epochBalance.tokenSpent;
        uint256 tokenBalance = unprocessedTokenBalance;
        if (firstUnprocessedEpoch != currentEpoch) {
            tokenBalance += currentEpochBalance.totalSupply - currentEpochBalance.tokenSpent;
        }

        // SWC-114-Transaction Order Dependence: L361
        uint256 returnAmount = amount * tokenBalance / value(erc20);
        require(tokenBalance >= returnAmount, "not enough tokens");

        if (firstUnprocessedEpoch == currentEpoch) {
            currentEpoch += 1;
        }

        _updateTokenState(erc20, -int256(returnAmount), currentEpochStored, firstUnprocessedEpoch);

        if (returnAmount <= unprocessedTokenBalance) {
            if (returnAmount == unprocessedTokenBalance) {
                _token.firstUnprocessedEpoch += 1;
            }

            epochBalance.tokenSpent += returnAmount;
            epochBalance.inchBalance += amount;
        } else {
            uint256 amountPart = unprocessedTokenBalance * amount / returnAmount;

            epochBalance.tokenSpent = unprocessedTotalSupply;
            epochBalance.inchBalance += amountPart;

            currentEpochBalance.tokenSpent += returnAmount - unprocessedTokenBalance;
            currentEpochBalance.inchBalance += amount - amountPart;

            _token.firstUnprocessedEpoch += 1;
            currentEpoch += 1;
        }

        if (currentEpoch != currentEpochStored) {
            _token.currentEpoch = currentEpoch;
        }

        token.safeTransferFrom(msg.sender, address(this), amount);
        erc20.safeTransfer(msg.sender, returnAmount);
    }

    function claim(IERC20[] memory pools) external {
        for (uint256 i = 0; i < pools.length; ++i) {
            TokenInfo storage _token = tokenInfo[pools[i]];
            _collectProcessedEpochs(msg.sender, _token, _token.currentEpoch, _token.firstUnprocessedEpoch);
        }

        uint256 userBalance = balanceOf(msg.sender);
        if (userBalance > 1) {
            // Avoid erasing storage to decrease gas footprint for referral payments
            unchecked {
                uint256 withdrawn = userBalance - 1;
                _burn(msg.sender, withdrawn);
                token.safeTransfer(msg.sender, withdrawn);
            }
        }
    }

    function claimCurrentEpoch(IERC20 erc20) external {
        TokenInfo storage _token = tokenInfo[erc20];
        uint256 currentEpoch = _token.currentEpoch;
        uint256 userBalance = _token.epochBalance[currentEpoch].balances[msg.sender];
        if (userBalance > 0) {
            _token.epochBalance[currentEpoch].balances[msg.sender] = 0;
            _token.epochBalance[currentEpoch].totalSupply -= userBalance;
            erc20.safeTransfer(msg.sender, userBalance);
        }
    }

    function claimFrozenEpoch(IERC20 erc20) external {
        TokenInfo storage _token = tokenInfo[erc20];
        uint256 firstUnprocessedEpoch = _token.firstUnprocessedEpoch;
        uint256 currentEpoch = _token.currentEpoch;

        require(firstUnprocessedEpoch + 1 == currentEpoch, "Epoch already finalized");
        require(_token.firstUserUnprocessedEpoch[msg.sender] == firstUnprocessedEpoch, "Epoch funds already claimed");

        _token.firstUserUnprocessedEpoch[msg.sender] = currentEpoch;
        EpochBalance storage epochBalance = _token.epochBalance[firstUnprocessedEpoch];
        uint256 share = epochBalance.balances[msg.sender];

        if (share > 0) {
            uint256 totalSupply = epochBalance.totalSupply;
            epochBalance.balances[msg.sender] = 0;
            epochBalance.totalSupply = totalSupply - share;
            epochBalance.inchBalance -= _transferTokenShare(token, epochBalance.inchBalance, share, totalSupply);
            _transferTokenShare(erc20, epochBalance.tokenSpent, share, totalSupply);
        }
    }

    function _updateReward(IERC20 erc20, address referral, uint256 amount) private {
        TokenInfo storage _token = tokenInfo[erc20];
        uint256 currentEpoch = _token.currentEpoch;
        uint256 firstUnprocessedEpoch = _token.firstUnprocessedEpoch;

        _updateTokenState(erc20, int256(amount), currentEpoch, firstUnprocessedEpoch);

        // Add new reward to current epoch
        _token.epochBalance[currentEpoch].balances[referral] += amount;
        _token.epochBalance[currentEpoch].totalSupply += amount;

        // Collect all processed epochs and advance user token epoch
        _collectProcessedEpochs(referral, _token, currentEpoch, firstUnprocessedEpoch);
    }

    function _updateTokenState(IERC20 erc20, int256 amount, uint256 currentEpoch, uint256 firstUnprocessedEpoch) private {
        TokenInfo storage _token = tokenInfo[erc20];

        uint256 fee = _token.epochBalance[firstUnprocessedEpoch].totalSupply - _token.epochBalance[firstUnprocessedEpoch].tokenSpent;
        if (firstUnprocessedEpoch != currentEpoch) {
            fee += (_token.epochBalance[currentEpoch].totalSupply - _token.epochBalance[currentEpoch].tokenSpent);
        }

        uint256 feeWithAmount = (amount >= 0 ? fee + uint256(amount) : fee - uint256(-amount));
        (
            tokenInfo[erc20].lastTime,
            tokenInfo[erc20].lastValue
        ) = (
            uint40(block.timestamp),
            uint216(valueForTime(block.timestamp, erc20) * feeWithAmount / (fee == 0 ? 1 : fee))
        );
    }

    function _transferTokenShare(IERC20 _token, uint256 balance, uint256 share, uint256 totalSupply) private returns(uint256 amount) {
        amount = balance * share / totalSupply;
        if (amount > 0) {
            _token.safeTransfer(msg.sender, amount);
        }
    }

    function _collectProcessedEpochs(address user, TokenInfo storage _token, uint256 currentEpoch, uint256 tokenEpoch) private {
        uint256 userEpoch = _token.firstUserUnprocessedEpoch[user];

        if (tokenEpoch <= userEpoch) {
            return;
        }

        // Early return for the new users
        if (_token.epochBalance[userEpoch].balances[user] == 0) {
            _token.firstUserUnprocessedEpoch[user] = currentEpoch;
            return;
        }

        uint256 epochCount = Math.min(2, tokenEpoch - userEpoch); // 0, 1 or 2 epochs

        // Claim 1 or 2 processed epochs for the user
        uint256 collected = _collectEpoch(user, _token, userEpoch);
        if (epochCount > 1) {
            collected += _collectEpoch(user, _token, userEpoch + 1);
        }
        _mint(user, collected);

        // Update user token epoch counter
        bool emptySecondEpoch = _token.epochBalance[userEpoch + 1].balances[user] == 0;
        _token.firstUserUnprocessedEpoch[user] = (epochCount == 2 || emptySecondEpoch) ? currentEpoch : userEpoch + 1;
    }

    function _collectEpoch(address user, TokenInfo storage _token, uint256 epoch) private returns(uint256 collected) {
        uint256 share = _token.epochBalance[epoch].balances[user];
        if (share > 0) {
            uint256 inchBalance = _token.epochBalance[epoch].inchBalance;
            uint256 totalSupply = _token.epochBalance[epoch].totalSupply;

            collected = inchBalance * share / totalSupply;

            _token.epochBalance[epoch].balances[user] = 0;
            _token.epochBalance[epoch].totalSupply = totalSupply - share;
            _token.epochBalance[epoch].inchBalance = inchBalance - collected;
        }
    }
}

// --- END: FeeCollector.sol ---
