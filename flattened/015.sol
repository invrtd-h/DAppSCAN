
// --- START: woonklyPOS.sol ---
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

// original: imp-ort "https://github.com/Woonkly/OpenZeppelinBaseContracts/contracts/math/SafeMath.sol";
// original: imp-ort "https://github.com/Woonkly/OpenZeppelinBaseContracts/contracts/token/ERC20/ERC20.sol"
// original: imp-ort "https://github.com/Woonkly/OpenZeppelinBaseContracts/contracts/utils/ReentrancyGuard.sol";
// original: imp-ort "https://github.com/Woonkly/MartinHSolUtils/Utils.sol";
// original: imp-ort "https://github.com/Woonkly/STAKESmartContractPreRelease/Pausabled.sol";
// original: imp-ort "https://github.com/Woonkly/STAKESmartContractPreRelease/Erc20Manager.sol";
// original: imp-ort "https://github.com/Woonkly/STAKESmartContractPreRelease/StakeManager.sol";
// original: imp-ort "https://github.com/Woonkly/STAKESmartContractPreRelease/IWStaked.sol";
// original: imp-ort "https://github.com/Woonkly/STAKESmartContractPreRelease/IInvestiable.sol";


// --- START: SafeMath.sol ---


/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// --- END: SafeMath.sol ---

// --- START: ERC20.sol ---



// --- START: Context.sol ---


/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// --- END: Context.sol ---

// --- START: IERC20.sol ---


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
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name_, string memory symbol_) public {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

// --- END: ERC20.sol ---

// --- START: ReentrancyGuard.sol ---


/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// --- END: ReentrancyGuard.sol ---

// --- START: Utils.sol ---



library Utils {


function getStringLen(string memory str)  internal pure returns (uint){
    bytes memory tempEmptyStringTest = bytes(str); // Uses memory
    return tempEmptyStringTest.length;
}


 function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
    if (_i == 0) {
        return "0";
    }
    uint j = _i;
    uint len;
    while (j != 0) {
        len++;
        j /= 10;
    }
    bytes memory bstr = new bytes(len);
    uint k = len - 1;
    while (_i != 0) {
        bstr[k--] = byte(uint8(48 + _i % 10));
        _i /= 10;
    }
    return string(bstr);
}


function append(string memory a, string memory b, string memory c, string memory d, string memory e) internal pure returns (string memory) {

    return string(abi.encodePacked(a, b, c, d, e));

}


function checkEven(uint testNo) internal  pure returns(bool){
        uint remainder = testNo%2;
        if(remainder==0)
            return true;
        else
            return false;
    }
    
}







// --- END: Utils.sol ---

// --- START: Pausabled.sol ---

// original: imp-ort "./../contracts/access/Ownable.sol";

// --- START: Ownable.sol ---


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
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
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
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// --- END: Ownable.sol ---

contract Pausabled is Ownable{

    bool internal _paused;
    
    
    modifier Active() {
         require( !isPaused() ," Error is paused!");
        _;
    }

  
    function isPaused() public view returns(bool){
        return _paused;
    }
    
    
    event Paused(bool paused);
    function setPause(bool paused) public onlyOwner returns(bool){
        _paused=paused;
        emit Paused(_paused);
        return true;
    }
    
    
    
}





// --- END: Pausabled.sol ---

// --- START: Erc20Manager.sol ---

// original: imp-ort "https://github.com/Woonkly/OpenZeppelinBaseContracts/contracts/math/SafeMath.sol";
// original: imp-ort "https://github.com/Woonkly/MartinHSolUtils/Utils.sol";
// original: imp-ort "https://github.com/Woonkly/OpenZeppelinBaseContracts/contracts/GSN/Context.sol";


// --- START: Context.sol ---



// --- END: Context.sol ---

/**
MIT License

Copyright (c) 2021 Woonkly OU

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED BY WOONKLY OU "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

contract Erc20Manager is Context {
    using SafeMath for uint256;

    //Section Type declarations

    struct E20 {
        address sc;
        uint8 flag; //0 no exist  1 exist 2 deleted
    }

    //Section State variables

    uint256 internal _lastIndexE20s;
    mapping(uint256 => E20) internal _E20s;
    mapping(address => uint256) internal _IDE20sIndex;
    uint256 internal _E20Count;

    //Section Modifier

    modifier onlyNewERC20(address sc) {
        require(!this.ERC20Exist(sc), "E2 Exist");
        _;
    }

    modifier onlyERC20Exist(address sc) {
        require(this.ERC20Exist(sc), "E2 !Exist");
        _;
    }

    modifier onlyERC20IndexExist(uint256 index) {
        require(this.ERC20IndexExist(index), "E2I !Exist");
        _;
    }

    //Section Events

    event NewERC20(address sc);
    event ERC20Removed(address sc);

    //Section functions

    constructor() internal {
        _lastIndexE20s = 0;
        _E20Count = 0;
    }

    function hasContracts() external view returns (bool) {
        return (_E20Count > 0);
    }

    function getERC20Count() external view returns (uint256) {
        return _E20Count;
    }

    function getLastIndexERC20s() external view returns (uint256) {
        return _lastIndexE20s;
    }

    function ERC20Exist(address sc) public view returns (bool) {
        return _E20Exist(_IDE20sIndex[sc]);
    }

    function ERC20IndexExist(uint256 index) public view returns (bool) {
        return (index < (_lastIndexE20s + 1));
    }

    function _E20Exist(uint256 E20ID) internal view returns (bool) {
        return (_E20s[E20ID].flag == 1);
    }

    function newERC20(address sc) internal onlyNewERC20(sc) returns (uint256) {
        _lastIndexE20s = _lastIndexE20s.add(1);
        _E20Count = _E20Count.add(1);

        _E20s[_lastIndexE20s].sc = sc;
        _E20s[_lastIndexE20s].flag = 1;

        _IDE20sIndex[sc] = _lastIndexE20s;

        emit NewERC20(sc);
        return _lastIndexE20s;
    }

    function removeERC20(address sc) internal onlyERC20Exist(sc) {
        _E20s[_IDE20sIndex[sc]].flag = 2;
        _E20s[_IDE20sIndex[sc]].sc = address(0);
        _E20Count = _E20Count.sub(1);
        emit ERC20Removed(sc);
    }

    function getERC20ByIndex(uint256 index) external view returns (address) {
        return _E20s[index].sc;
    }

    function getAllERC20()
        external
        view
        returns (uint256[] memory, address[] memory)
    {
        uint256[] memory indexs = new uint256[](_E20Count);
        address[] memory pACCs = new address[](_E20Count);
        uint256 ind = 0;

        for (uint32 i = 0; i < (_lastIndexE20s + 1); i++) {
            E20 memory p = _E20s[i];
            if (p.flag == 1) {
                indexs[ind] = i;
                pACCs[ind] = p.sc;
                ind++;
            }
        }

        return (indexs, pACCs);
    }
}

// --- END: Erc20Manager.sol ---

// --- START: StakeManager.sol ---

// original: imp-ort "https://github.com/Woonkly/OpenZeppelinBaseContracts/contracts/math/SafeMath.sol";
// original: imp-ort "https://github.com/Woonkly/OpenZeppelinBaseContracts/contracts/token/ERC20/ERC20.sol";
// original: imp-ort "https://github.com/Woonkly/MartinHSolUtils/Utils.sol";
// original: imp-ort "https://github.com/Woonkly/MartinHSolUtils/Owners.sol";


// --- START: Owners.sol ---

// original: imp-ort "./../contracts/math/SafeMath.sol";
// original: imp-ort "./../contracts/GSN/Context.sol";



contract Owners is Context{

 using SafeMath for uint256;

    struct Sowners {
    address account;
    uint8 flag; //0 no exist  1 exist 2 deleted
    
  }


  uint256 internal _lastIndexSowners;
  mapping(uint256 => Sowners) internal _Sowners;    
  mapping(address => uint256) internal _IDSownersIndex;    
  uint256 internal _SownersCount;

 

constructor () internal {
      _lastIndexSowners = 0;
       _SownersCount = 0;
       
       address msgSender = _msgSender();
       addOwner( msgSender);
    }    



    function getOwnersCount() public view returns (uint256) {
        return _SownersCount;
    }


    function OwnerExist(address account) public view returns (bool) {
        return _SownersExist( _IDSownersIndex[account]);
    }

    function SownersIndexExist(uint256 index) internal view returns (bool) {
        
        if(_SownersCount==0) return false;
        
        if(index <  (_lastIndexSowners + 1) ) return true;
        
        return false;
    }


    function _SownersExist(uint256 SownersID)internal view returns (bool) {
        
        //0 no exist  1 exist 2 deleted
        if(_Sowners[SownersID].flag == 1 ){ 
            return true;
        }
        return false;         
    }


      modifier onlyNewOwners(address account) {
        require(!this.OwnerExist(account), "Ow:!exist");
        _;
      }
      
      
      modifier onlyOwnersExist(address account) {
        require(this.OwnerExist(account), "Ow:!exist");
        _;
      }
      
      modifier onlySownersIndexExist(uint256 index) {
        require(SownersIndexExist(index), "Ow:!iexist");
        _;
      }
  
  
      modifier onlyIsInOwners() {
        require(OwnerExist( _msgSender()) , "Own:!owners");
        _;
    }

  
  
  event addNewInOwners(address account);

function addOwner(address account) private returns(uint256){
    _lastIndexSowners=_lastIndexSowners.add(1);
    _SownersCount=  _SownersCount.add(1);
    
    _Sowners[_lastIndexSowners].account = account;
      _Sowners[_lastIndexSowners].flag = 1;
    
    _IDSownersIndex[account] = _lastIndexSowners;
    
    emit addNewInOwners(account);
    return _lastIndexSowners;
}   
     
 function newInOwners(address account ) public onlyIsInOwners onlyNewOwners(account)  returns (uint256){
     return addOwner( account);
}    




event RemovedFromOwners(address account);

function removeFromOwners(address account) public onlyIsInOwners onlyOwnersExist(account) {
    _Sowners[ _IDSownersIndex[account] ].flag = 2;
    _Sowners[ _IDSownersIndex[account] ].account=address(0);
    _SownersCount=  _SownersCount.sub(1);
    emit RemovedFromOwners( account);
}






function getOwnerByIndex(uint256 index) public view  returns( address) {
    
        if(!SownersIndexExist( index)) return address(0);
     
        Sowners memory p= _Sowners[ index ];
         
        return ( p.account);
    }



function getAllOwners() public view returns(uint256[] memory, address[] memory ) {
  
    uint256[] memory indexs=new uint256[](_SownersCount);
    address[] memory pACCs=new address[](_SownersCount);
    

    uint256 ind=0;
    
    for (uint32 i = 0; i < (_lastIndexSowners +1) ; i++) {
        Sowners memory p= _Sowners[ i ];
        if(p.flag == 1 ){
            indexs[ind]=i;
            pACCs[ind]=p.account;
            ind++;
        }
    }

    return (indexs, pACCs);

}



    
}
// --- END: Owners.sol ---

/**
MIT License

Copyright (c) 2021 Woonkly OU

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED BY WOONKLY OU "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

contract StakeManager is Owners, ERC20 {
    using SafeMath for uint256;

    //Section Type declarations

    struct Stake {
        address account;
        bool autoCompound;
        uint8 flag; //0 no exist  1 exist 2 deleted
    }

    //Section State variables

    uint256 internal _lastIndexStakes;
    mapping(uint256 => Stake) internal _Stakes;
    mapping(address => uint256) internal _IDStakesIndex;
    uint256 internal _StakeCount;

    //Section Modifier

    modifier onlyNewStake(address account) {
        require(!this.StakeExist(account), "This Stake account exist");
        _;
    }

    modifier onlyStakeExist(address account) {
        require(StakeExist(account), "This Stake account not exist");
        _;
    }

    modifier onlyStakeIndexExist(uint256 index) {
        require(StakeIndexExist(index), "This Stake index not exist");
        _;
    }

    //Section Events

    event addNewStake(address account, uint256 amount);
    event StakeAdded(address account, uint256 oldAmount, uint256 newAmount);
    event StakeReNewed(address account, uint256 oldAmount, uint256 newAmount);
    event AutoCompoundChanged(address account, bool active);
    event StakeRemoved(address account);
    event AllStakeRemoved();

    //Section functions

    constructor(string memory name, string memory symbol)
        public
        ERC20(name, symbol)
    {
        _lastIndexStakes = 0;
        _StakeCount = 0;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual override {
        require(false);
        // super._transfer(sender,recipient,amount);
    }

    function getStakeCount() public view returns (uint256) {
        return _StakeCount;
    }

    function getLastIndexStakes() public view returns (uint256) {
        return _lastIndexStakes;
    }

    function StakeExist(address account) public view returns (bool) {
        return _StakeExist(_IDStakesIndex[account]);
    }

    function StakeIndexExist(uint256 index) public view returns (bool) {
        return (index < (_lastIndexStakes + 1));
    }

    function _StakeExist(uint256 StakeID) internal view returns (bool) {
        return (_Stakes[StakeID].flag == 1);
    }

    function newStake(address account, uint256 amount)
        external
        onlyIsInOwners
        onlyNewStake(account)
        returns (uint256)
    {
        _lastIndexStakes = _lastIndexStakes.add(1);
        _StakeCount = _StakeCount.add(1);

        _Stakes[_lastIndexStakes].account = account;
        _Stakes[_lastIndexStakes].autoCompound = false;
        _Stakes[_lastIndexStakes].flag = 1;

        _IDStakesIndex[account] = _lastIndexStakes;

        if (amount > 0) {
            _mint(account, amount);
        }

        emit addNewStake(account, amount);
        return _lastIndexStakes;
    }

    function addToStake(address account, uint256 addAmount)
        public
        onlyIsInOwners
        onlyStakeExist(account)
        returns (uint256)
    {
        uint256 oldAmount = balanceOf(account);
        if (addAmount > 0) {
            _mint(account, addAmount);
        }

        emit StakeAdded(account, oldAmount, addAmount);

        return _IDStakesIndex[account];
    }

    function renewStake(address account, uint256 newAmount)
        external
        onlyIsInOwners
        onlyStakeExist(account)
        returns (uint256)
    {
        uint256 oldAmount = balanceOf(account);
        if (oldAmount > 0) {
            _burn(account, oldAmount);
        }

        if (newAmount > 0) {
            _mint(account, newAmount);
        }

        emit StakeReNewed(account, oldAmount, newAmount);

        return _IDStakesIndex[account];
    }

    function setAutoCompound(address account, bool active)
        public
        onlyIsInOwners
        onlyStakeExist(account)
        returns (uint256)
    {
        _Stakes[_IDStakesIndex[account]].autoCompound = active;
        emit AutoCompoundChanged(
            account,
            _Stakes[_IDStakesIndex[account]].autoCompound
        );
        return _IDStakesIndex[account];
    }

    function removeStake(address account)
        external
        onlyIsInOwners
        onlyStakeExist(account)
    {
        _Stakes[_IDStakesIndex[account]].flag = 2;
        _Stakes[_IDStakesIndex[account]].account = address(0);
        _Stakes[_IDStakesIndex[account]].autoCompound = false;
        uint256 bl = balanceOf(account);
        if (bl > 0) {
            _burn(account, bl);
        }

        _StakeCount = _StakeCount.sub(1);
        emit StakeRemoved(account);
    }

    function getAutoCompoundStatus(address account) public view returns (bool) {
        if (!StakeExist(account)) return false;

        Stake memory p = _Stakes[_IDStakesIndex[account]];

        return p.autoCompound;
    }

    function getStake(address account) public view returns (uint256, bool) {
        if (!StakeExist(account)) return (0, false);

        Stake memory p = _Stakes[_IDStakesIndex[account]];

        return (balanceOf(account), p.autoCompound);
    }

    function getStakeByIndex(uint256 index)
        public
        view
        returns (
            address,
            uint256,
            bool,
            uint8
        )
    {
        if (!StakeIndexExist(index)) return (address(0), 0, false, 0);

        Stake memory p = _Stakes[index];

        return (p.account, balanceOf(p.account), p.autoCompound, p.flag);
    }

    function getAllStake()
        public
        view
        returns (
            uint256[] memory,
            address[] memory,
            uint256[] memory,
            bool[] memory
        )
    {
        uint256[] memory indexs = new uint256[](_StakeCount);
        address[] memory pACCs = new address[](_StakeCount);
        uint256[] memory pAmounts = new uint256[](_StakeCount);
        bool[] memory pAuto = new bool[](_StakeCount);

        uint256 ind = 0;

        for (uint32 i = 0; i < (_lastIndexStakes + 1); i++) {
            Stake memory p = _Stakes[i];
            if (p.flag == 1) {
                indexs[ind] = i;
                pACCs[ind] = p.account;
                pAmounts[ind] = balanceOf(p.account);
                pAuto[ind] = p.autoCompound;
                ind++;
            }
        }

        return (indexs, pACCs, pAmounts, pAuto);
    }

    function removeAllStake() external onlyIsInOwners returns (bool) {
        for (uint32 i = 0; i < (_lastIndexStakes + 1); i++) {
            _IDStakesIndex[_Stakes[i].account] = 0;

            address acc = _Stakes[i].account;
            _Stakes[i].flag = 0;
            _Stakes[i].account = address(0);
            _Stakes[i].autoCompound = false;
            uint256 bl = balanceOf(acc);
            if (bl > 0) {
                _burn(acc, bl);
            }
        }
        _lastIndexStakes = 0;
        _StakeCount = 0;
        emit AllStakeRemoved();
        return true;
    }
}

// --- END: StakeManager.sol ---

// --- START: IWStaked.sol ---

/**
MIT License

Copyright (c) 2021 Woonkly OU

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED BY WOONKLY OU "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/



interface IWStaked{
    function NotifyAddStake(address account, uint256 amount) external returns(bool);
    function NotifyWithdrawFunds(address account, uint256 amount) external returns(uint256);
    function NotifyActiveChanged(bool activeStatus)  external returns(bool);
    
    function StakeExist(address account) external  view  returns (bool) ;
    function setAutoCompound(address account, bool active)  external returns(uint256);
    function addToStake(address account, uint256 addAmount) external returns(uint256);
    function newStake(address account,uint256 amount ) external returns (uint256);
    function getStake(address account) external  view  returns( uint256 ,bool);
    function removeStake(address account) external;
    function renewStake(address account, uint256 newAmount) external returns(uint256);
    function getStakeCount() external  view  returns(uint256) ;
    function getLastIndexStakes() external view returns (uint256) ;
    function getStakeByIndex(uint256 index) external  view   returns(address, uint256,bool,uint8) ;
    function getAutoCompoundStatus(address account) external  view  returns(bool);
    function removeAllStake() external returns(bool);
    function balanceOf(address account)  external  view  returns(uint256) ;
    
}
// --- END: IWStaked.sol ---

// --- START: IInvestiable.sol ---


/**
MIT License

Copyright (c) 2021 Woonkly OU

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED BY WOONKLY OU "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/




interface IInvestable{
    function getFreezeCount() external view returns(uint256) ;
    function getLastIndexFreezes() external view  returns(uint256);     
    function FreezeExist(address account) external  view  returns(bool);
    function FreezeIndexExist(uint256 index) external  view  returns(bool);
    function newFreeze(address account,uint256 amount,uint256 date ) external returns(uint256);
    function removeFreeze(address account) external;
    function getFreeze(address account) external  view  returns( uint256 , uint256 , uint256 );
    function getFreezeByIndex(uint256 index) external  view  returns( uint256 , uint256 , uint256 );
    function getAllFreeze() external  view  returns(uint256[] memory, address[] memory ,uint256[] memory , uint256[] memory , uint256[] memory );
    function updateFund(address account,uint256 withdraw) external  returns(bool);
    function canWithdrawFunds(address account,uint256 withdraw,uint256 currentFund) external  view  returns(bool);
    function howMuchCanWithdraw(address account,uint256 currentFund) external  view  returns(uint256);
        
}
// --- END: IInvestiable.sol ---

/**
MIT License

Copyright (c) 2021 Woonkly OU

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED BY WOONKLY OU "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

contract WOOPStake is Owners, Pausabled, Erc20Manager, ReentrancyGuard {
    using SafeMath for uint256;

    //Section Type declarations
    struct Stake {
        address account;
        uint256 bal;
        bool autoCompound;
        uint8 flag; //0 no exist  1 exist 2 deleted
    }

    struct processRewardInfo {
        uint256 remainder;
        uint256 woopsRewards;
        uint256 dealed;
        address me;
        bool resp;
    }

    struct Stadistic {
        uint256 ind;
        uint256 funds;
        uint256 rews;
        uint256 rewsCOIN;
        uint256 autocs;
    }

    //Section State variables

    address internal _remainder;
    address internal _woopERC20;
    uint256 internal _distributedCOIN;
    IInvestable internal _inv;
    IWStaked internal _stakes;
    address internal _investable;
    address internal _stakeable;
    uint256 _factor;
    mapping(address => mapping(address => uint256)) private _rewards;
    mapping(address => uint256) private _rewardsCOIN;
    mapping(address => uint256) private _distributeds;

    //Section Modifier

    modifier IhaveEnoughTokens(address sc, uint256 token_amount) {
        uint256 amount = getMyTokensBalance(sc);
        require(token_amount <= amount, "-tk");
        _;
    }

    modifier IhaveEnoughCoins(uint256 coins) {
        uint256 amount = getMyCoinBalance();
        require(coins <= amount, "-coin");
        _;
    }

    modifier hasApprovedTokens(
        address sc,
        address sender,
        uint256 token_amount
    ) {
        IERC20 _token = IERC20(sc);
        require(
            _token.allowance(sender, address(this)) >= token_amount,
            "!aptk"
        ); //sender != address(0) &&
        _;
    }

    modifier ProviderHasToken(address sc, uint256 amount) {
        uint256 total = calcTotalRewards(amount);
        require(total <= getTokensBalanceOf(sc, _msgSender()), "WOO:tk-");
        _;
    }

    modifier IhaveAprovedRewardTokens(address sc, uint256 amount) {
        uint256 total = calcTotalRewards(amount);
        IERC20 _token = IERC20(sc);
        require(
            _token.allowance(_msgSender(), address(this)) >= total,
            "WOO:-apt"
        );

        _;
    }

    modifier Solvency(address sc) {
        bool isSolvency;
        uint256 solvent;

        (isSolvency, solvent) = getSolvency(sc);

        require(isSolvency, "WO:sol!");
        _;
    }

    modifier SolvencyCOIN() {
        bool isSolvency;
        uint256 solvent;

        (isSolvency, solvent) = getSolvencyCOIN();

        require(isSolvency, "WO:sol!");
        _;
    }

    //Section Events

    event RewardedCOIN(address account, uint256 reward);
    event Rewarded(address sc, address account, uint256 reward);
    event CoinReceived(uint256 coins);
    event FactorChanged(uint256 oldf, uint256 newf);
    event DistributedReseted(address sc, uint256 old);
    event DistributedCOINReseted(uint256 old);
    event RemaninderAccChanged(address old, address newr);
    event ERC20WOOPChanged(address old, address newr);
    event VestingChanged(address old, address newi);
    event StakeAddrChanged(address old, address news);
    event WithdrawFunds(address account, uint256 amount, uint256 remainder);
    event RewardWithdrawed(
        address sc,
        address account,
        uint256 amount,
        uint256 remainder
    );
    event RewardToCompound(address account, uint256 amount);

    event RewardCOINWithdrawed(
        address account,
        uint256 amount,
        uint256 remainder
    );

    event InsuficientRewardFund(address sc, address account);
    event NewLeftover(address sc, address account, uint256 leftover);
    event InsuficientRewardFundCOIN(address account);
    event NewLeftoverCOIN(address account, uint256 leftover);

    event StakeClosed(
        uint256 csc,
        uint256 stakes,
        uint256 totFunds,
        uint256 totRew
    );

    //Section functions

    constructor(
        address remAcc,
        address woopERC20,
        address inv,
        address stake
    ) public {
        _paused = false;
        _remainder = remAcc;
        //_factor=10**8;
        //factor = 1000000000000000000;

        _factor = 100000000;
        _distributedCOIN = 0;
        _woopERC20 = woopERC20;
        _investable = inv;
        _inv = IInvestable(inv);
        _stakeable = stake;
        _stakes = IWStaked(stake);
    }

    function _dorewardCOIN(address account, uint256 reward) internal {
        require(account != address(0), "WO:0addr");

        _rewardsCOIN[account] = reward;
        emit RewardedCOIN(account, reward);
    }

    function rewardedCOIN(address account) public view returns (uint256) {
        return _rewardsCOIN[account];
    }

    function _rewardCOIN(address account, uint256 amount)
        internal
        returns (bool)
    {
        _dorewardCOIN(account, amount);
        return true;
    }

    function _increaseRewardsCOIN(address account, uint256 addedValue)
        internal
        returns (bool)
    {
        _dorewardCOIN(account, _rewardsCOIN[account].add(addedValue));
        return true;
    }

    function _decreaseRewardsCOIN(address account, uint256 subtractedValue)
        internal
        returns (bool)
    {
        _dorewardCOIN(
            account,
            _rewardsCOIN[account].sub(subtractedValue, "WO:-0")
        );
        return true;
    }

    function _doreward(
        address sc,
        address account,
        uint256 reward
    ) internal {
        require(sc != address(0), "WO:0addr");
        require(account != address(0), "WO:0addr");

        _rewards[sc][account] = reward;
        emit Rewarded(sc, account, reward);
    }

    function rewarded(address sc, address account)
        public
        view
        returns (uint256)
    {
        return _rewards[sc][account];
    }

    function _reward(
        address sc,
        address account,
        uint256 amount
    ) internal returns (bool) {
        _doreward(sc, account, amount);
        return true;
    }

    function _increaseRewards(
        address sc,
        address account,
        uint256 addedValue
    ) internal returns (bool) {
        _doreward(sc, account, _rewards[sc][account].add(addedValue));
        return true;
    }

    function _decreaseRewards(
        address sc,
        address account,
        uint256 subtractedValue
    ) internal returns (bool) {
        _doreward(
            sc,
            account,
            _rewards[sc][account].sub(subtractedValue, "WO:-0")
        );
        return true;
    }

    receive() external payable {
        // React to receiving ether
        _processRewardCOIN(msg.value);

        emit CoinReceived(msg.value);
    }

    fallback() external payable {
        //emit CoinReceived(msg.value);
    }

    function getMyCoinBalance() public view returns (uint256) {
        address payable self = address(this);
        uint256 bal = self.balance;
        return bal;
    }

    function getMyTokensBalance(address sc) public view returns (uint256) {
        IERC20 _token = IERC20(sc);
        return _token.balanceOf(address(this));
    }

    function getTokensBalanceOf(address sc, address account)
        public
        view
        returns (uint256)
    {
        IERC20 _token = IERC20(sc);
        return _token.balanceOf(account);
    }

    function addErc20STK(address sc) public onlyIsInOwners returns (bool) {
        newERC20(sc);
        return true;
    }

    function removeErc20STK(address sc) public onlyIsInOwners returns (bool) {
        removeERC20(sc);
        return true;
    }

    function setFactor(uint256 newf) public onlyIsInOwners {
        require(newf <= 1000000000, ">lim");
        emit FactorChanged(_factor, newf);
        _factor = newf;
    }

    function getFactor() public view returns (uint256) {
        return _factor;
    }

    function getfractionUnit() public view returns (uint256) {
        return uint256(1000000000000000000000000000).div(_factor);
    }

    function getDistributed(address sc) public view returns (uint256) {
        return _distributeds[sc];
    }

    function resetDistributed(address sc) public onlyIsInOwners returns (bool) {
        uint256 old = _distributeds[sc];
        _distributeds[sc] = 0;
        emit DistributedReseted(sc, old);
        return true;
    }

    function getDistributedCOIN() public view returns (uint256) {
        return _distributedCOIN;
    }

    function resetDistributedCOIN() public onlyIsInOwners returns (bool) {
        uint256 old = _distributedCOIN;
        _distributedCOIN = 0;
        emit DistributedCOINReseted(old);
        return true;
    }

    function getRemaninderAcc() public view returns (address) {
        return _remainder;
    }

    function setRemaniderAcc(address newr)
        public
        onlyIsInOwners
        returns (bool)
    {
        require(newr != address(0), "!0ad");
        address old = _remainder;
        _remainder = newr;
        emit RemaninderAccChanged(old, newr);
        return true;
    }

    function getERC20WOOP() public view returns (address) {
        return _woopERC20;
    }

    function setERC20WOOP(address newr) public onlyIsInOwners returns (bool) {
        require(newr != address(0), "!0ad");
        address old = _woopERC20;
        _woopERC20 = newr;
        emit ERC20WOOPChanged(old, newr);
        return true;
    }

    function getVesting() public view returns (address) {
        return _investable;
    }

    function setVesting(address newi) public onlyIsInOwners returns (bool) {
        require(newi != address(0), "!0ad");
        address old = _investable;
        _investable = newi;
        _inv = IInvestable(newi);
        emit VestingChanged(old, newi);
        return true;
    }

    function getStakeAddr() public view returns (address) {
        return _stakeable;
    }

    function setStakeAddr(address news) public onlyIsInOwners returns (bool) {
        require(news != address(0), "!0ad");
        address old = _stakeable;
        _stakeable = news;
        _stakes = IWStaked(news);
        emit StakeAddrChanged(old, news);
        return true;
    }

    function setMyCompoundStatus(bool status)
        public
        nonReentrant
        returns (bool)
    {
        require(_stakes.StakeExist(_msgSender()), "WO:!");
        _stakes.setAutoCompound(_msgSender(), status);
        if (status == true)
            _compoundReward(_msgSender(), rewarded(_woopERC20, _msgSender()));
        return true;
    }

    function addStake(uint256 amount)
        public
        Active
        hasApprovedTokens(_woopERC20, _msgSender(), amount)
        returns (bool)
    {
        require(amount >= getfractionUnit(), "WO:-am");

        IERC20 _token = IERC20(_woopERC20);

        require(
            _token.transferFrom(_msgSender(), address(this), amount),
            "WO:-etf"
        );

        require(_addStake(_msgSender(), amount), "WO:eas");

        return true;
    }

    function _addStake(address account, uint256 amount)
        internal
        Active
        returns (bool)
    {
        if (!_stakes.StakeExist(account)) {
            _stakes.newStake(account, amount);
        } else {
            _stakes.addToStake(account, amount);
        }

        return true;
    }

    function _withdrawFunds(address account, uint256 amount)
        internal
        Active
        returns (uint256)
    {
        require(_stakes.StakeExist(account), "WO:!");
        uint256 fund;
        bool autoC;

        (fund, autoC) = _stakes.getStake(account);

        require(amount <= fund, "WO:eef");

        uint256 remainder = fund.sub(amount);

        if (remainder == 0) {
            _stakes.removeStake(account);
        } else {
            _stakes.renewStake(account, remainder);
        }

        emit WithdrawFunds(account, amount, remainder);

        return amount;
    }

    function withdrawFunds(uint256 amount)
        public
        Active
        nonReentrant
        returns (bool)
    {
        require(_stakes.StakeExist(_msgSender()), "WO:!");
        require(
            _inv.canWithdrawFunds(
                _msgSender(),
                amount,
                _stakes.balanceOf(_msgSender())
            ),
            "WO:!i"
        );

        IERC20 _token = IERC20(_woopERC20);

        require(_token.transfer(_msgSender(), amount), "WO:ewf");
        _withdrawFunds(_msgSender(), amount);

        _inv.updateFund(_msgSender(), amount);
        return true;
    }

    function _withdrawReward(
        address sc,
        address account,
        uint256 amount
    ) internal Active nonReentrant returns (uint256) {
        IERC20 _token = IERC20(sc);

        uint256 rew = rewarded(sc, account);

        require(amount <= rew, "WO:amew");

        require(amount <= getMyTokensBalance(sc), "WO:-tk");

        require(_token.transfer(account, amount));

        uint256 remainder = rew.sub(amount);


        //fix critical issue by coin Fabrik
        _doreward(sc, account, remainder);


       emit RewardWithdrawed(sc, account, amount, remainder);

        return amount;
    }

    function _compoundReward(address account, uint256 amount)
        internal
        Active
        returns (uint256)
    {
        uint256 rew = rewarded(_woopERC20, account);

        require(amount <= rew, "WO: am>w");

        require(amount <= getMyTokensBalance(_woopERC20), "WO:-tk");

        uint256 remainder = rew.sub(amount);


        //fix critical issue by coin Fabrik
        _doreward(_woopERC20, account, remainder);


        _stakes.addToStake(account, amount);

        emit RewardToCompound(account, amount);

        return amount;
    }

    function WithdrawReward(address sc, uint256 amount)
        public
        Active
        returns (bool)
    {
        _withdrawReward(sc, _msgSender(), amount);

        return true;
    }

    function CompoundReward(uint256 amount)
        public
        Active
        nonReentrant
        returns (bool)
    {
        _compoundReward(_msgSender(), amount);

        return true;
    }

    function _withdrawRewardCOIN(address account, uint256 amount)
        internal
        Active
        nonReentrant
        returns (uint256)
    {
        uint256 rew = rewardedCOIN(account);

        require(amount <= rew, "WO:am++");

        require(amount <= getMyCoinBalance(), "WO:tk-");

        address payable acc = address(uint160(address(account)));

        acc.transfer(amount);

        uint256 remainder = rew.sub(amount);


        //fix critical issue by coin Fabrik
        _dorewardCOIN(account,remainder);

        emit RewardCOINWithdrawed(account, amount, remainder);

        return amount;
    }

    function WithdrawRewardCOIN(uint256 amount) public Active returns (bool) {
        _withdrawRewardCOIN(_msgSender(), amount);

        return true;
    }

    function getCalcRewardAmount(address account, uint256 amount)
        public
        view
        returns (uint256, uint256)
    {
        if (!_stakes.StakeExist(account)) return (0, 0);

        uint256 fund = 0;
        bool autoC;

        (fund, autoC) = _stakes.getStake(account);

        if (fund < getfractionUnit()) return (0, 0);

        uint256 factor = fund.div(getfractionUnit());

        if (factor < 1) return (0, 0);

        uint256 remainder = fund.sub(factor.mul(getfractionUnit()));

        uint256 woopsRewards = calcReward(amount, factor);

        if (woopsRewards < 1) return (0, 0);

        return (woopsRewards, remainder);
    }

    function calcReward(uint256 amount, uint256 factor)
        public
        view
        returns (uint256)
    {
        return amount.mul(factor).div(_factor);
    }

    function calcTotalRewards(uint256 amount) public view returns (uint256) {
        uint256 remainder;
        uint256 woopsRewards;
        uint256 ind = 0;
        uint256 total = 0;

        Stake memory p;

        uint256 last = _stakes.getLastIndexStakes();

        for (uint256 i = 0; i < (last + 1); i++) {
            (p.account, p.bal, p.autoCompound, p.flag) = _stakes
                .getStakeByIndex(i);

            if (p.flag == 1) {
                (woopsRewards, remainder) = getCalcRewardAmount(
                    p.account,
                    amount
                );
                if (woopsRewards > 0) {
                    total = total.add(woopsRewards);
                }
                ind++;
            }
        }

        return total;
    }

    function _processReward_1(
        IERC20 _token,
        address account,
        uint256 amount
    ) internal returns (bool) {
        require(_token.transferFrom(account, address(this), amount), "WO:etr");
        return true;
    }

    function _processReward_2(address sc, uint256 amount)
        internal
        returns (uint256)
    {
        processRewardInfo memory slot;

        Stake memory p;

        uint256 last = _stakes.getLastIndexStakes();

        for (uint256 i = 0; i < (last + 1); i++) {
            (p.account, p.bal, p.autoCompound, p.flag) = _stakes
                .getStakeByIndex(i);

            if (p.flag == 1) {
                (slot.woopsRewards, slot.remainder) = getCalcRewardAmount(
                    p.account,
                    amount
                );
                if (slot.woopsRewards > 0) {
                    if (
                        _stakes.getAutoCompoundStatus(p.account) &&
                        sc == _woopERC20
                    ) {
                        _stakes.addToStake(p.account, slot.woopsRewards);
                    } else {
                        _increaseRewards(sc, p.account, slot.woopsRewards);
                    }

                    slot.dealed = slot.dealed.add(slot.woopsRewards);
                } else {
                    emit InsuficientRewardFund(sc, p.account);
                }
            }
        } //for

        _distributeds[sc] = _distributeds[sc].add(slot.dealed);

        return slot.dealed;
    }

// SWC-107-Reentrancy: L743 - L769
    function processReward(address sc, uint256 amount)
        public
        nonReentrant
        Active
        hasApprovedTokens(sc, _msgSender(), amount)
        ProviderHasToken(sc, amount)
        returns (bool)
    {
        if (!ERC20Exist(sc)) {
            newERC20(sc);
        }

        processRewardInfo memory slot;

        IERC20 _token = IERC20(sc);
        _processReward_1(_token, _msgSender(), amount);

        slot.dealed = _processReward_2(sc, amount);

        uint256 leftover = amount.sub(slot.dealed);
        if (leftover > 0) {
            require(_token.transfer(_remainder, leftover), "WO:trf");
            emit NewLeftover(sc, _remainder, leftover);
        }

        return true;
    }

    function _processReward_2COIN(uint256 amount) internal returns (uint256) {
        processRewardInfo memory slot;
        Stake memory p;

        uint256 last = _stakes.getLastIndexStakes();

        for (uint256 i = 0; i < (last + 1); i++) {
            (p.account, p.bal, p.autoCompound, p.flag) = _stakes
                .getStakeByIndex(i);

            if (p.flag == 1) {
                (slot.woopsRewards, slot.remainder) = getCalcRewardAmount(
                    p.account,
                    amount
                );

                if (slot.woopsRewards > 0) {
                    _increaseRewardsCOIN(p.account, slot.woopsRewards);

                    slot.dealed = slot.dealed.add(slot.woopsRewards);
                } else {
                    emit InsuficientRewardFundCOIN(p.account);
                }
            }
        } //for

        return slot.dealed;
    }

    function _processRewardCOIN(uint256 amount)
        internal
        nonReentrant
        Active
        returns (bool)
    {
        processRewardInfo memory slot;

        address payable nrem = address(uint160(_remainder));

        slot.dealed = _processReward_2COIN(amount);

        _distributedCOIN = _distributedCOIN.add(slot.dealed);

        uint256 leftover = amount.sub(slot.dealed);
        if (leftover > 0) {
            nrem.transfer(leftover);
            emit NewLeftoverCOIN(_remainder, leftover);
        }

        return true;
    }

    function closeStakes() public onlyIsInOwners nonReentrant returns (bool) {
        uint256 totRew = 0;

        uint256 toSC = _lastIndexE20s + 1;

        for (uint32 i = 0; i < (_lastIndexE20s + 1); i++) {
            E20 memory p = _E20s[i];
            if (p.flag == 1) {
                totRew = totRew.add(_withdrawAllrewards(p.sc));
            }
        }

        totRew = totRew.add(_withdrawAllrewardsCOIN());

        uint256 fund;
        bool autoC;
        uint256 funds = 0;

        Stake memory p;

        uint256 last = _stakes.getLastIndexStakes();

        for (uint256 i = 0; i < (last + 1); i++) {
            (p.account, p.bal, p.autoCompound, p.flag) = _stakes
                .getStakeByIndex(i);
            if (p.flag == 1) {
                (fund, autoC) = _stakes.getStake(p.account);
                _withdrawFunds(p.account, fund);
                funds = funds.add(fund);
            }
        }

        setPause(true);
        _stakes.removeAllStake();

        emit StakeClosed(toSC, (last + 1), funds, totRew);
        return true;
    }

    function _withdrawAllrewardsCOIN()
        internal
        SolvencyCOIN()
        nonReentrant
        returns (uint256)
    {
        uint256 total = 0;
        uint256 rew = 0;
        Stake memory p;

        uint256 last = _stakes.getLastIndexStakes();
        // SWC-113-DoS with Failed Call: L874 - L886
        for (uint256 i = 0; i < (last + 1); i++) {
            (p.account, p.bal, p.autoCompound, p.flag) = _stakes
                .getStakeByIndex(i);

            if (p.flag == 1) {
                rew = rewardedCOIN(p.account);

                if (rew > 0) {
                    _withdrawRewardCOIN(p.account, rew);
                    total = total.add(rew);
                }
            }
        }

        uint256 eth_reserve = address(this).balance;

        if (eth_reserve > 0) {
            address payable ow = address(uint160(_remainder));
            ow.transfer(eth_reserve);
        }

        return total;
    }

    function _withdrawAllrewards(address sc)
        internal
        Solvency(sc)
        returns (uint256)
    {
        uint256 total = 0;
        uint256 rew = 0;

        Stake memory p;

        uint256 last = _stakes.getLastIndexStakes();

        for (uint256 i = 0; i < (last + 1); i++) {
            (p.account, p.bal, p.autoCompound, p.flag) = _stakes
                .getStakeByIndex(i);

            if (p.flag == 1) {
                rew = rewarded(sc, p.account);

                if (rew > 0) {
                    _withdrawReward(sc, p.account, rew);
                    total = total.add(rew);
                }
            }
        }

        IERC20 _token = IERC20(sc);

        uint256 token_reserve = _token.balanceOf(address(this));

        if (token_reserve > 0) {
            require(_token.transfer(_remainder, token_reserve), "WO:trf");
        }

        return total;
    }

    function getSolvencyCOIN() public view returns (bool, uint256) {
        uint256 ind = 0;
        uint256 funds = 0;
        uint256 rews = 0;
        uint256 rewsc = 0;
        uint256 autos = 0;

        (ind, funds, rews, rewsc, autos) = getStatistics(_woopERC20);

        uint256 coins = getMyCoinBalance();

        if (coins < rewsc) {
            return (false, rewsc - coins);
        } else {
            return (true, coins - rewsc);
        }
    }

    function getSolvency(address sc) public view returns (bool, uint256) {
        Stadistic memory s;

        (s.ind, s.funds, s.rews, , ) = getStatistics(sc);

        uint256 tokens = getMyTokensBalance(sc);

        uint256 tot = s.funds + s.rews;

        if (tokens < tot) {
            return (false, tot - tokens);
        } else {
            return (true, tokens - tot);
        }
    }

    function getStatistics(address sc)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        uint256 fund;
        bool autoC;

        Stadistic memory s;

        Stake memory p;

        uint256 last = _stakes.getLastIndexStakes();

        for (uint256 i = 0; i < (last + 1); i++) {
            (p.account, p.bal, p.autoCompound, p.flag) = _stakes
                .getStakeByIndex(i);

            if (p.flag == 1) {
                (fund, autoC) = _stakes.getStake(p.account);

                if (sc == _woopERC20) {
                    s.funds = s.funds.add(fund);
                }

                fund = rewarded(sc, p.account);

                s.rews = s.rews.add(fund);

                fund = rewardedCOIN(p.account);

                s.rewsCOIN = s.rewsCOIN.add(fund);

                if (autoC) {
                    s.autocs++;
                }
                s.ind++;
            }
        }

        return (s.ind, s.funds, s.rews, s.rewsCOIN, s.autocs);
    }
}

// --- END: woonklyPOS.sol ---
