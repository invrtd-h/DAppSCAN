
// --- START: SkaleBalances.sol ---
/*
    SkaleBalances.sol - SKALE Manager
    Copyright (C) 2018-Present SKALE Labs
    @author Vadim Yavorsky
    @author Dmytro Stebaiev

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity ^0.5.3;
pragma experimental ABIEncoderV2;


// --- START: IERC1820Registry.sol ---

/**
 * @dev Interface of the global ERC1820 Registry, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
 * implementers for interfaces in this registry, as well as query support.
 *
 * Implementers may be shared by multiple accounts, and can also implement more
 * than a single interface for each account. Contracts can implement interfaces
 * for themselves, but externally-owned accounts (EOA) must delegate this to a
 * contract.
 *
 * {IERC165} interfaces can also be queried via the registry.
 *
 * For an in-depth explanation and source code analysis, see the EIP text.
 */
interface IERC1820Registry {
    /**
     * @dev Sets `newManager` as the manager for `account`. A manager of an
     * account is able to set interface implementers for it.
     *
     * By default, each account is its own manager. Passing a value of `0x0` in
     * `newManager` will reset the manager to this initial state.
     *
     * Emits a {ManagerChanged} event.
     *
     * Requirements:
     *
     * - the caller must be the current manager for `account`.
     */
    function setManager(address account, address newManager) external;

    /**
     * @dev Returns the manager for `account`.
     *
     * See {setManager}.
     */
    function getManager(address account) external view returns (address);

    /**
     * @dev Sets the `implementer` contract as `account`'s implementer for
     * `interfaceHash`.
     *
     * `account` being the zero address is an alias for the caller's address.
     * The zero address can also be used in `implementer` to remove an old one.
     *
     * See {interfaceHash} to learn how these are created.
     *
     * Emits an {InterfaceImplementerSet} event.
     *
     * Requirements:
     *
     * - the caller must be the current manager for `account`.
     * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
     * end in 28 zeroes).
     * - `implementer` must implement {IERC1820Implementer} and return true when
     * queried for support, unless `implementer` is the caller. See
     * {IERC1820Implementer-canImplementInterfaceForAddress}.
     */
    function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;

    /**
     * @dev Returns the implementer of `interfaceHash` for `account`. If no such
     * implementer is registered, returns the zero address.
     *
     * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
     * zeroes), `account` will be queried for support of it.
     *
     * `account` being the zero address is an alias for the caller's address.
     */
    function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);

    /**
     * @dev Returns the interface hash for an `interfaceName`, as defined in the
     * corresponding
     * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
     */
    function interfaceHash(string calldata interfaceName) external pure returns (bytes32);

    /**
     *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
     *  @param account Address of the contract for which to update the cache.
     *  @param interfaceId ERC165 interface for which to update the cache.
     */
    function updateERC165Cache(address account, bytes4 interfaceId) external;

    /**
     *  @notice Checks whether a contract implements an ERC165 interface or not.
     *  If the result is not cached a direct lookup on the contract address is performed.
     *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
     *  {updateERC165Cache} with the contract address.
     *  @param account Address of the contract to check.
     *  @param interfaceId ERC165 interface to check.
     *  @return True if `account` implements `interfaceId`, false otherwise.
     */
    function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);

    /**
     *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
     *  @param account Address of the contract to check.
     *  @param interfaceId ERC165 interface to check.
     *  @return True if `account` implements `interfaceId`, false otherwise.
     */
    function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);

    event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);

    event ManagerChanged(address indexed account, address indexed newManager);
}

// --- END: IERC1820Registry.sol ---

// --- START: IERC777Recipient.sol ---

/**
 * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
 *
 * Accounts can be notified of {IERC777} tokens being sent to them by having a
 * contract implement this interface (contract holders can be their own
 * implementer) and registering it on the
 * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
 *
 * See {IERC1820Registry} and {ERC1820Implementer}.
 */
interface IERC777Recipient {
    /**
     * @dev Called by an {IERC777} token contract whenever tokens are being
     * moved or created into a registered account (`to`). The type of operation
     * is conveyed by `from` being the zero address or not.
     *
     * This call occurs _after_ the token contract's state is updated, so
     * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
     *
     * This function may revert to prevent the operation from being executed.
     */
    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
}

// --- END: IERC777Recipient.sol ---


// --- START: Permissions.sol ---
/*
    Permissions.sol - SKALE Manager
    Copyright (C) 2018-Present SKALE Labs
    @author Artem Payvin

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/



// --- START: ContractManager.sol ---
/*
    ContractManager.sol - SKALE Manager
    Copyright (C) 2018-Present SKALE Labs
    @author Artem Payvin

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/



// --- START: Ownable.sol ---


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
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// --- END: Context.sol ---
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
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
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// --- END: Ownable.sol ---


/**
 * @title Main contract in upgradeable approach. This contract contain actual
 * contracts for this moment in skale manager system by human name.
 * @author Artem Payvin
 */
contract ContractManager is Ownable {

    // mapping of actual smart contracts addresses
    mapping (bytes32 => address) public contracts;

    event ContractUpgraded(string contractsName, address contractsAddress);

    /**
     * Adds actual contract to mapping of actual contract addresses
     * @param contractsName - contracts name in skale manager system
     * @param newContractsAddress - contracts address in skale manager system
     */
    function setContractsAddress(string calldata contractsName, address newContractsAddress) external onlyOwner {
        // check newContractsAddress is not equal zero
        require(newContractsAddress != address(0), "New address is equal zero");
        // create hash of contractsName
        bytes32 contractId = keccak256(abi.encodePacked(contractsName));
        // check newContractsAddress is not equal the previous contract's address
        require(contracts[contractId] != newContractsAddress, "Contract is already added");
        uint length;
        assembly {
            length := extcodesize(newContractsAddress)
        }
        // check newContractsAddress contains code
        require(length > 0, "Given contracts address is not contain code");
        // add newContractsAddress to mapping of actual contract addresses
        contracts[contractId] = newContractsAddress;
        emit ContractUpgraded(contractsName, newContractsAddress);
    }

    function getContract(string calldata name) external view returns (address contractAddress) {
        contractAddress = contracts[keccak256(abi.encodePacked(name))];
        require(contractAddress != address(0), "Contract has not been found");
    }
}

// --- END: ContractManager.sol ---


/**
 * @title Permissions - connected module for Upgradeable approach, knows ContractManager
 * @author Artem Payvin
 */
contract Permissions is Ownable {

    ContractManager contractManager;

    /**
     * @dev allow - throws if called by any account and contract other than the owner
     * or `contractName` contract
     * @param contractName - human readable name of contract
     */
    modifier allow(string memory contractName) {
        require(
            contractManager.contracts(keccak256(abi.encodePacked(contractName))) == msg.sender || isOwner(),
            "Message sender is invalid");
        _;
    }

    modifier allowTwo(string memory contractName1, string memory contractName2) {
        require(
            contractManager.contracts(keccak256(abi.encodePacked(contractName1))) == msg.sender ||
            contractManager.contracts(keccak256(abi.encodePacked(contractName2))) == msg.sender ||
            isOwner(),
            "Message sender is invalid");
        _;
    }

    modifier allowThree(string memory contractName1, string memory contractName2, string memory contractName3) {
        require(
            contractManager.contracts(keccak256(abi.encodePacked(contractName1))) == msg.sender ||
            contractManager.contracts(keccak256(abi.encodePacked(contractName2))) == msg.sender ||
            contractManager.contracts(keccak256(abi.encodePacked(contractName3))) == msg.sender ||
            isOwner(),
            "Message sender is invalid");
        _;
    }

    /**
     * @dev constructor - sets current address of ContractManager
     * @param newContractsAddress - current address of ContractManager
     */
    constructor(address newContractsAddress) public {
        contractManager = ContractManager(newContractsAddress);
    }
}

// --- END: Permissions.sol ---

// --- START: SkaleToken.sol ---
/*
    SkaleToken.sol - SKALE Manager
    Copyright (C) 2018-Present SKALE Labs
    @author Artem Payvin

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/




// --- START: LockableERC777.sol ---


// --- START: IERC777.sol ---

/**
 * @dev Interface of the ERC777Token standard as defined in the EIP.
 *
 * This contract uses the
 * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 registry standard] to let
 * token holders and recipients react to token movements by using setting implementers
 * for the associated interfaces in said registry. See {IERC1820Registry} and
 * {ERC1820Implementer}.
 */
interface IERC777 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the smallest part of the token that is not divisible. This
     * means all token operations (creation, movement and destruction) must have
     * amounts that are a multiple of this number.
     *
     * For most token contracts, this value will equal 1.
     */
    function granularity() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by an account (`owner`).
     */
    function balanceOf(address owner) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * If send or receive hooks are registered for the caller and `recipient`,
     * the corresponding functions will be called with `data` and empty
     * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
     *
     * Emits a {Sent} event.
     *
     * Requirements
     *
     * - the caller must have at least `amount` tokens.
     * - `recipient` cannot be the zero address.
     * - if `recipient` is a contract, it must implement the {IERC777Recipient}
     * interface.
     */
    function send(address recipient, uint256 amount, bytes calldata data) external;

    /**
     * @dev Destroys `amount` tokens from the caller's account, reducing the
     * total supply.
     *
     * If a send hook is registered for the caller, the corresponding function
     * will be called with `data` and empty `operatorData`. See {IERC777Sender}.
     *
     * Emits a {Burned} event.
     *
     * Requirements
     *
     * - the caller must have at least `amount` tokens.
     */
    function burn(uint256 amount, bytes calldata data) external;

    /**
     * @dev Returns true if an account is an operator of `tokenHolder`.
     * Operators can send and burn tokens on behalf of their owners. All
     * accounts are their own operator.
     *
     * See {operatorSend} and {operatorBurn}.
     */
    function isOperatorFor(address operator, address tokenHolder) external view returns (bool);

    /**
     * @dev Make an account an operator of the caller.
     *
     * See {isOperatorFor}.
     *
     * Emits an {AuthorizedOperator} event.
     *
     * Requirements
     *
     * - `operator` cannot be calling address.
     */
    function authorizeOperator(address operator) external;

    /**
     * @dev Make an account an operator of the caller.
     *
     * See {isOperatorFor} and {defaultOperators}.
     *
     * Emits a {RevokedOperator} event.
     *
     * Requirements
     *
     * - `operator` cannot be calling address.
     */
    function revokeOperator(address operator) external;

    /**
     * @dev Returns the list of default operators. These accounts are operators
     * for all token holders, even if {authorizeOperator} was never called on
     * them.
     *
     * This list is immutable, but individual holders may revoke these via
     * {revokeOperator}, in which case {isOperatorFor} will return false.
     */
    function defaultOperators() external view returns (address[] memory);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
     * be an operator of `sender`.
     *
     * If send or receive hooks are registered for `sender` and `recipient`,
     * the corresponding functions will be called with `data` and
     * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
     *
     * Emits a {Sent} event.
     *
     * Requirements
     *
     * - `sender` cannot be the zero address.
     * - `sender` must have at least `amount` tokens.
     * - the caller must be an operator for `sender`.
     * - `recipient` cannot be the zero address.
     * - if `recipient` is a contract, it must implement the {IERC777Recipient}
     * interface.
     */
    function operatorSend(
        address sender,
        address recipient,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    ) external;

    /**
     * @dev Destoys `amount` tokens from `account`, reducing the total supply.
     * The caller must be an operator of `account`.
     *
     * If a send hook is registered for `account`, the corresponding function
     * will be called with `data` and `operatorData`. See {IERC777Sender}.
     *
     * Emits a {Burned} event.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     * - the caller must be an operator for `account`.
     */
    function operatorBurn(
        address account,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    ) external;

    event Sent(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 amount,
        bytes data,
        bytes operatorData
    );

    event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);

    event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);

    event AuthorizedOperator(address indexed operator, address indexed tokenHolder);

    event RevokedOperator(address indexed operator, address indexed tokenHolder);
}

// --- END: IERC777.sol ---

// --- START: IERC777Sender.sol ---

/**
 * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
 *
 * {IERC777} Token holders can be notified of operations performed on their
 * tokens by having a contract implement this interface (contract holders can be
 *  their own implementer) and registering it on the
 * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
 *
 * See {IERC1820Registry} and {ERC1820Implementer}.
 */
interface IERC777Sender {
    /**
     * @dev Called by an {IERC777} token contract whenever a registered holder's
     * (`from`) tokens are about to be moved or destroyed. The type of operation
     * is conveyed by `to` being the zero address or not.
     *
     * This call occurs _before_ the token contract's state is updated, so
     * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
     *
     * This function may revert to prevent the operation from being executed.
     */
    function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
}

// --- END: IERC777Sender.sol ---

// --- START: IERC20.sol ---

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
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
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
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
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// --- END: SafeMath.sol ---

// --- START: Address.sol ---

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
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
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
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// --- END: Address.sol ---


/**
 * @dev Implementation of the `IERC777` interface.
 * Modified version to support delegation
 */
contract LockableERC777 is IERC777, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    IERC1820Registry private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    mapping(address => uint256) private _balances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    // We inline the result of the following hashes because Solidity doesn't resolve them at compile time.
    // See https://github.com/ethereum/solidity/issues/4024.

    // keccak256("ERC777TokensSender")
    bytes32 constant private TOKENS_SENDER_INTERFACE_HASH = 0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;

    // keccak256("ERC777TokensRecipient")
    bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH = 0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;

    // This isn't ever read from - it's only used to respond to the defaultOperators query.
    address[] private _defaultOperatorsArray;

    // Immutable, but accounts may revoke them (tracked in __revokedDefaultOperators).
    mapping(address => bool) private _defaultOperators;

    // For each account, a mapping of its operators and revoked default operators.
    mapping(address => mapping(address => bool)) private _operators;
    mapping(address => mapping(address => bool)) private _revokedDefaultOperators;

    // ERC20-allowances
    mapping (address => mapping (address => uint256)) private _allowances;

    /**
     * @dev `defaultOperators` may be an empty array.
     */
    constructor(
        string memory name,
        string memory symbol,
        address[] memory defaultOperators
    ) public {
        _name = name;
        _symbol = symbol;

        _defaultOperatorsArray = defaultOperators;
        for (uint256 i = 0; i < _defaultOperatorsArray.length; i++) {
            _defaultOperators[_defaultOperatorsArray[i]] = true;
        }

        // register interfaces
        _erc1820.setInterfaceImplementer(address(this), keccak256("ERC777Token"), address(this));
        _erc1820.setInterfaceImplementer(address(this), keccak256("ERC20Token"), address(this));
    }

    /**
     * @dev See `IERC777.send`.
     *
     * Also emits a `Transfer` event for ERC20 compatibility.
     */
    function send(address recipient, uint256 amount, bytes calldata data) external {
        _send(
            msg.sender, msg.sender, recipient, amount, data, "", true
        );
    }

    /**
     * @dev See `IERC20.transfer`.
     *
     * Unlike `send`, `recipient` is _not_ required to implement the `tokensReceived`
     * interface if it is a contract.
     *
     * Also emits a `Sent` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool) {
        require(recipient != address(0), "ERC777: transfer to the zero address");

        address from = msg.sender;

        _callTokensToSend(
            from, from, recipient, amount, "", ""
        );

        _move(
            from, from, recipient, amount, "", ""
        );

        _callTokensReceived(
            from, from, recipient, amount, "", "", false
        );

        return true;
    }

    /**
     * @dev See `IERC777.burn`.
     *
     * Also emits a `Transfer` event for ERC20 compatibility.
     */
    function burn(uint256 amount, bytes calldata data) external {
        _burn(
            msg.sender, msg.sender, amount, data, ""
        );
    }

    /**
     * @dev See `IERC777.authorizeOperator`.
     */
    function authorizeOperator(address operator) external {
        require(msg.sender != operator, "ERC777: authorizing self as operator");

        if (_defaultOperators[operator]) {
            delete _revokedDefaultOperators[msg.sender][operator];
        } else {
            _operators[msg.sender][operator] = true;
        }

        emit AuthorizedOperator(operator, msg.sender);
    }

    /**
     * @dev See `IERC777.revokeOperator`.
     */
    function revokeOperator(address operator) external {
        require(operator != msg.sender, "ERC777: revoking self as operator");

        if (_defaultOperators[operator]) {
            _revokedDefaultOperators[msg.sender][operator] = true;
        } else {
            delete _operators[msg.sender][operator];
        }

        emit RevokedOperator(operator, msg.sender);
    }

    /**
     * @dev See `IERC777.operatorSend`.
     *
     * Emits `Sent` and `Transfer` events.
     */
    function operatorSend(
        address sender,
        address recipient,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    )
    external
    {
        require(isOperatorFor(msg.sender, sender), "ERC777: caller is not an operator for holder");
        _send(
            msg.sender, sender, recipient, amount, data, operatorData, true
        );
    }

    /**
     * @dev See `IERC777.operatorBurn`.
     *
     * Emits `Sent` and `Transfer` events.
     */
    function operatorBurn(
        address account, uint256 amount, bytes calldata data, bytes calldata operatorData
    ) external
    {
        require(isOperatorFor(msg.sender, account), "ERC777: caller is not an operator for holder");
        _burn(
            msg.sender, account, amount, data, operatorData
        );
    }

    /**
     * @dev See `IERC20.approve`.
     *
     * Note that accounts cannot have allowance issued by their operators.
     */
    function approve(address spender, uint256 value) external returns (bool) {
        address holder = msg.sender;
        _approve(holder, spender, value);
        return true;
    }

   /**
    * @dev See `IERC20.transferFrom`.
    *
    * Note that operator and allowance concepts are orthogonal: operators cannot
    * call `transferFrom` (unless they have allowance), and accounts with
    * allowance cannot call `operatorSend` (unless they are operators).
    *
    * Emits `Sent` and `Transfer` events.
    */
    function transferFrom(address holder, address recipient, uint256 amount) external returns (bool) {
        require(recipient != address(0), "ERC777: transfer to the zero address");
        require(holder != address(0), "ERC777: transfer from the zero address");

        address spender = msg.sender;

        _callTokensToSend(
            spender, holder, recipient, amount, "", ""
        );

        _move(
            spender, holder, recipient, amount, "", ""
        );
        _approve(holder, spender, _allowances[holder][spender].sub(amount));

        _callTokensReceived(
            spender, holder, recipient, amount, "", "", false
        );

        return true;
    }

    /**
     * @dev See `IERC777.name`.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev See `IERC777.symbol`.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See `ERC20Detailed.decimals`.
     *
     * Always returns 18, as per the
     * [ERC777 EIP](https://eips.ethereum.org/EIPS/eip-777#backward-compatibility).
     */
    function decimals() public pure returns (uint8) {
        return 18;
    }

    /**
     * @dev See `IERC777.granularity`.
     *
     * This implementation always returns `1`.
     */
    function granularity() public view returns (uint256) {
        return 1;
    }

    /**
     * @dev See `IERC777.totalSupply`.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Returns the amount of tokens owned by an account (`tokenHolder`).
     */
    function balanceOf(address tokenHolder) public view returns (uint256) {
        return _balances[tokenHolder];
    }

    /**
     * @dev See `IERC777.isOperatorFor`.
     */
    function isOperatorFor(
        address operator,
        address tokenHolder
    ) public view returns (bool)
    {
        return operator == tokenHolder ||
            (_defaultOperators[operator] && !_revokedDefaultOperators[tokenHolder][operator]) ||
            _operators[tokenHolder][operator];
    }

    /**
     * @dev See `IERC777.defaultOperators`.
     */
    function defaultOperators() public view returns (address[] memory) {
        return _defaultOperatorsArray;
    }

    /**
     * @dev See `IERC20.allowance`.
     *
     * Note that operator and allowance concepts are orthogonal: operators may
     * not have allowance, and accounts with allowance may not be operators
     * themselves.
     */
    function allowance(address holder, address spender) public view returns (uint256) {
        return _allowances[holder][spender];
    }

    /**
     * @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * If a send hook is registered for `raccount`, the corresponding function
     * will be called with `operator`, `data` and `operatorData`.
     *
     * See `IERC777Sender` and `IERC777Recipient`.
     *
     * Emits `Sent` and `Transfer` events.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - if `account` is a contract, it must implement the `tokensReceived`
     * interface.
     */
    function _mint(
        address operator,
        address account,
        uint256 amount,
        bytes memory userData,
        bytes memory operatorData
    )
    internal
    {
        require(account != address(0), "ERC777: mint to the zero address");

        // Update state variables
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);

        _callTokensReceived(
            operator, address(0), account, amount, userData, operatorData, true
        );

        emit Minted(
            operator, account, amount, userData, operatorData
        );
        emit Transfer(address(0), account, amount);
    }

    // Added by SKALE
    function _getLockedOf(address wallet) internal returns (uint);
    // --------------

    /**
     * @dev Send tokens
     * @param operator address operator requesting the transfer
     * @param from address token holder address
     * @param to address recipient address
     * @param amount uint256 amount of tokens to transfer
     * @param userData bytes extra information provided by the token holder (if any)
     * @param operatorData bytes extra information provided by the operator (if any)
     * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
     */
    function _send(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes memory userData,
        bytes memory operatorData,
        bool requireReceptionAck
    )
        private
    {
        require(from != address(0), "ERC777: send from the zero address");
        require(to != address(0), "ERC777: send to the zero address");

        _callTokensToSend(
            operator, from, to, amount, userData, operatorData
        );

        _move(
            operator, from, to, amount, userData, operatorData
        );

        _callTokensReceived(
            operator, from, to, amount, userData, operatorData, requireReceptionAck
        );
    }

    /**
     * @dev Burn tokens
     * @param operator address operator requesting the operation
     * @param from address token holder address
     * @param amount uint256 amount of tokens to burn
     * @param data bytes extra information provided by the token holder
     * @param operatorData bytes extra information provided by the operator (if any)
     */
    // SWC-107-Reentrancy: L399-422
    function _burn(
        address operator,
        address from,
        uint256 amount,
        bytes memory data,
        bytes memory operatorData
    )
        private
    {
        require(from != address(0), "ERC777: burn from the zero address");

        _callTokensToSend(
            operator, from, address(0), amount, data, operatorData
        );

        // Update state variables
        _totalSupply = _totalSupply.sub(amount);
        _balances[from] = _balances[from].sub(amount);

        emit Burned(
            operator, from, amount, data, operatorData
        );
        emit Transfer(from, address(0), amount);
    }

    function _move(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes memory userData,
        bytes memory operatorData
    )
        private
    {
// Property of the company SKALE Labs inc.---------------------------------
        uint locked = _getLockedOf(from);
        if (locked > 0) {
            require(_balances[from] >= locked + amount, "Token should be unlocked for transferring");
        }
//-------------------------------------------------------------------------
        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount);

        emit Sent(
            operator, from, to, amount, userData, operatorData
        );
        emit Transfer(from, to, amount);
    }

    function _approve(address holder, address spender, uint256 value) private {
        // TODO: restore this require statement if this function becomes internal, or is called at a new callsite. It is
        // currently unnecessary.
        //require(holder != address(0), "ERC777: approve from the zero address");
        require(spender != address(0), "ERC777: approve to the zero address");

        _allowances[holder][spender] = value;
        emit Approval(holder, spender, value);
    }

    /**
     * @dev Call from.tokensToSend() if the interface is registered
     * @param operator address operator requesting the transfer
     * @param from address token holder address
     * @param to address recipient address
     * @param amount uint256 amount of tokens to transfer
     * @param userData bytes extra information provided by the token holder (if any)
     * @param operatorData bytes extra information provided by the operator (if any)
     */
    function _callTokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes memory userData,
        bytes memory operatorData
    )
        private
    {
        address implementer = _erc1820.getInterfaceImplementer(from, TOKENS_SENDER_INTERFACE_HASH);
        if (implementer != address(0)) {
            IERC777Sender(implementer).tokensToSend(
                operator, from, to, amount, userData, operatorData
            );
        }
    }

    /**
     * @dev Call to.tokensReceived() if the interface is registered. Reverts if the recipient is a contract but
     * tokensReceived() was not registered for the recipient
     * @param operator address operator requesting the transfer
     * @param from address token holder address
     * @param to address recipient address
     * @param amount uint256 amount of tokens to transfer
     * @param userData bytes extra information provided by the token holder (if any)
     * @param operatorData bytes extra information provided by the operator (if any)
     * @param requireReceptionAck if true, contract recipients are required to implement ERC777TokensRecipient
     */
    function _callTokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes memory userData,
        bytes memory operatorData,
        bool requireReceptionAck
    )
        private
    {
        address implementer = _erc1820.getInterfaceImplementer(to, TOKENS_RECIPIENT_INTERFACE_HASH);
        if (implementer != address(0)) {
            IERC777Recipient(implementer).tokensReceived(
                operator, from, to, amount, userData, operatorData
            );
        } else if (requireReceptionAck) {
            require(!to.isContract(), "Token recipient contract has no implementer for ERC777TokensRecipient");
        }
    }
}

// --- END: LockableERC777.sol ---

// --- START: IDelegatableToken.sol ---
/*
    IDelegatableToken.sol - SKALE Manager
    Copyright (C) 2019-Present SKALE Labs
    @author Dmytro Stebaiev

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/


interface IDelegatableToken {

    function getLockedOf(address wallet) external returns (uint);

    function getDelegatedOf(address wallet) external returns (uint);

    function getSlashedOf(address wallet) external returns (uint);
}
// --- END: IDelegatableToken.sol ---

// --- START: DelegationService.sol ---
/*
    DelegationService.sol - SKALE Manager
    Copyright (C) 2019-Present SKALE Labs
    @author Dmytro Stebaiev

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/



// --- START: IHolderDelegation.sol ---
/*
    IHolderDelegation.sol - SKALE Manager
    Copyright (C) 2019-Present SKALE Labs
    @author Dmytro Stebaiev

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/


interface IHolderDelegation {
    event DelegationRequestIsSent(uint id);

    /// @notice Creates request to delegate `amount` of tokens to `validatorId`
    /// from the begining of the next month
    function delegate(
        uint validatorId,
        uint amount,
        uint delegationPeriod,
        string calldata info
    ) external;

    /// @notice Allows tokens holder to request return of it's token from validator
    function requestUndelegation(uint delegationId) external;

    function cancelPendingDelegation(uint delegationId) external;

    function getDelegationRequestsForValidator(uint validatorId) external returns (uint[] memory);

    function getValidators() external view returns (uint[] memory validatorIds);

    function withdrawBounty(address bountyCollectionAddress, uint amount) external;

    function getEarnedBountyAmount() external returns (uint);

}
// --- END: IHolderDelegation.sol ---

// --- START: IValidatorDelegation.sol ---
/*
    IValidatorDelegation.sol - SKALE Manager
    Copyright (C) 2019-Present SKALE Labs
    @author Dmytro Stebaiev

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/

interface IValidatorDelegation {

    /// @notice Allows validator to accept tokens delegated at `delegationId`
    function acceptPendingDelegation(uint delegationId) external;

    /// @notice removes node from system
    function deleteNode(uint nodeIndex) external;

    /// @notice Register new as validator
    function registerValidator(
        string calldata name,
        string calldata description,
        uint feeRatePromille,
        uint minimumDelegationAmount
    ) external returns (uint validatorId);

    function unregisterValidator(uint validatorId) external;

    /// @notice return how many of validator funds are locked in SkaleManager
    function getBondAmount(uint validatorId) external returns (uint amount);

    function setValidatorName(string calldata newName) external;

    function setValidatorDescription(string calldata descripton) external;

    function requestForNewAddress(address newAddress) external;

    function confirmNewAddress(uint validatorId) external;

    function setMinimumDelegationAmount(uint amount) external;

    // TODO: replace with getters
    // function getValidatorInfo(uint validatorId) external returns (Validator memory validator);
}

// --- END: IValidatorDelegation.sol ---

// --- START: DelegationRequestManager.sol ---
/*
    DelegationRequestManager.sol - SKALE Manager
    Copyright (C) 2018-Present SKALE Labs
    @author Vadim Yavorsky

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/


// --- START: DelegationPeriodManager.sol ---
/*
    DelegationPeriodManager.sol - SKALE Manager
    Copyright (C) 2018-Present SKALE Labs
    @author Vadim Yavorsky

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/




contract DelegationPeriodManager is Permissions {
    mapping (uint => uint) public stakeMultipliers;

    constructor(address newContractsAddress) Permissions(newContractsAddress) public {
        stakeMultipliers[3] = 100;
        stakeMultipliers[6] = 150;
        stakeMultipliers[12] = 200;
    }

    function isDelegationPeriodAllowed(uint monthsCount) external view returns (bool) {
        return stakeMultipliers[monthsCount] != 0 ? true : false;
    }

    function setDelegationPeriod(uint monthsCount, uint stakeMultiplier) external onlyOwner {
        stakeMultipliers[monthsCount] = stakeMultiplier;
    }

    function removeDelegationPeriod(uint monthsCount) external onlyOwner {
        // remove only if there is no guys that stacked tokens for this period
        stakeMultipliers[monthsCount] = 0;
    }
}
// --- END: DelegationPeriodManager.sol ---

// --- START: ValidatorService.sol ---
/*
    ValidatorService.sol - SKALE Manager
    Copyright (C) 2019-Present SKALE Labs
    @author Dmytro Stebaiev

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/


// --- START: DelegationController.sol ---
/*
    DelegationController.sol - SKALE Manager
    Copyright (C) 2018-Present SKALE Labs
    @author Vadim Yavorsky

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/


// --- START: TokenState.sol ---
/*
    TokenState.sol - SKALE Manager
    Copyright (C) 2019-Present SKALE Labs
    @author Dmytro Stebaiev

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/


// --- START: TimeHelpers.sol ---
/*
    TimeHellper.sol - SKALE Manager
    Copyright (C) 2019-Present SKALE Labs
    @author Dmytro Stebaiev

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/


// --- START: BokkyPooBahsDateTimeLibrary.sol ---

// ----------------------------------------------------------------------------
// BokkyPooBah's DateTime Library v1.01
//
// A gas-efficient Solidity date and time library
//
// https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary
//
// Tested date range 1970/01/01 to 2345/12/31
//
// Conventions:
// Unit      | Range         | Notes
// :-------- |:-------------:|:-----
// timestamp | >= 0          | Unix timestamp, number of seconds since 1970/01/01 00:00:00 UTC
// year      | 1970 ... 2345 |
// month     | 1 ... 12      |
// day       | 1 ... 31      |
// hour      | 0 ... 23      |
// minute    | 0 ... 59      |
// second    | 0 ... 59      |
// dayOfWeek | 1 ... 7       | 1 = Monday, ..., 7 = Sunday
//
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018-2019. The MIT Licence.
// ----------------------------------------------------------------------------

library BokkyPooBahsDateTimeLibrary {

    uint constant SECONDS_PER_DAY = 24 * 60 * 60;
    uint constant SECONDS_PER_HOUR = 60 * 60;
    uint constant SECONDS_PER_MINUTE = 60;
    int constant OFFSET19700101 = 2440588;

    uint constant DOW_MON = 1;
    uint constant DOW_TUE = 2;
    uint constant DOW_WED = 3;
    uint constant DOW_THU = 4;
    uint constant DOW_FRI = 5;
    uint constant DOW_SAT = 6;
    uint constant DOW_SUN = 7;

    // ------------------------------------------------------------------------
    // Calculate the number of days from 1970/01/01 to year/month/day using
    // the date conversion algorithm from
    //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
    // and subtracting the offset 2440588 so that 1970/01/01 is day 0
    //
    // days = day
    //      - 32075
    //      + 1461 * (year + 4800 + (month - 14) / 12) / 4
    //      + 367 * (month - 2 - (month - 14) / 12 * 12) / 12
    //      - 3 * ((year + 4900 + (month - 14) / 12) / 100) / 4
    //      - offset
    // ------------------------------------------------------------------------
    function _daysFromDate(uint year, uint month, uint day) internal pure returns (uint _days) {
        require(year >= 1970);
        int _year = int(year);
        int _month = int(month);
        int _day = int(day);

        int __days = _day
          - 32075
          + 1461 * (_year + 4800 + (_month - 14) / 12) / 4
          + 367 * (_month - 2 - (_month - 14) / 12 * 12) / 12
          - 3 * ((_year + 4900 + (_month - 14) / 12) / 100) / 4
          - OFFSET19700101;

        _days = uint(__days);
    }

    // ------------------------------------------------------------------------
    // Calculate year/month/day from the number of days since 1970/01/01 using
    // the date conversion algorithm from
    //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
    // and adding the offset 2440588 so that 1970/01/01 is day 0
    //
    // int L = days + 68569 + offset
    // int N = 4 * L / 146097
    // L = L - (146097 * N + 3) / 4
    // year = 4000 * (L + 1) / 1461001
    // L = L - 1461 * year / 4 + 31
    // month = 80 * L / 2447
    // dd = L - 2447 * month / 80
    // L = month / 11
    // month = month + 2 - 12 * L
    // year = 100 * (N - 49) + year + L
    // ------------------------------------------------------------------------
    function _daysToDate(uint _days) internal pure returns (uint year, uint month, uint day) {
        int __days = int(_days);

        int L = __days + 68569 + OFFSET19700101;
        int N = 4 * L / 146097;
        L = L - (146097 * N + 3) / 4;
        int _year = 4000 * (L + 1) / 1461001;
        L = L - 1461 * _year / 4 + 31;
        int _month = 80 * L / 2447;
        int _day = L - 2447 * _month / 80;
        L = _month / 11;
        _month = _month + 2 - 12 * L;
        _year = 100 * (N - 49) + _year + L;

        year = uint(_year);
        month = uint(_month);
        day = uint(_day);
    }

    function timestampFromDate(uint year, uint month, uint day) internal pure returns (uint timestamp) {
        timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY;
    }
    function timestampFromDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) internal pure returns (uint timestamp) {
        timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + hour * SECONDS_PER_HOUR + minute * SECONDS_PER_MINUTE + second;
    }
    function timestampToDate(uint timestamp) internal pure returns (uint year, uint month, uint day) {
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function timestampToDateTime(uint timestamp) internal pure returns (uint year, uint month, uint day, uint hour, uint minute, uint second) {
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        uint secs = timestamp % SECONDS_PER_DAY;
        hour = secs / SECONDS_PER_HOUR;
        secs = secs % SECONDS_PER_HOUR;
        minute = secs / SECONDS_PER_MINUTE;
        second = secs % SECONDS_PER_MINUTE;
    }

    function isValidDate(uint year, uint month, uint day) internal pure returns (bool valid) {
        if (year >= 1970 && month > 0 && month <= 12) {
            uint daysInMonth = _getDaysInMonth(year, month);
            if (day > 0 && day <= daysInMonth) {
                valid = true;
            }
        }
    }
    function isValidDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) internal pure returns (bool valid) {
        if (isValidDate(year, month, day)) {
            if (hour < 24 && minute < 60 && second < 60) {
                valid = true;
            }
        }
    }
    function isLeapYear(uint timestamp) internal pure returns (bool leapYear) {
        uint year;
        uint month;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        leapYear = _isLeapYear(year);
    }
    function _isLeapYear(uint year) internal pure returns (bool leapYear) {
        leapYear = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
    }
    function isWeekDay(uint timestamp) internal pure returns (bool weekDay) {
        weekDay = getDayOfWeek(timestamp) <= DOW_FRI;
    }
    function isWeekEnd(uint timestamp) internal pure returns (bool weekEnd) {
        weekEnd = getDayOfWeek(timestamp) >= DOW_SAT;
    }
    function getDaysInMonth(uint timestamp) internal pure returns (uint daysInMonth) {
        uint year;
        uint month;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        daysInMonth = _getDaysInMonth(year, month);
    }
    function _getDaysInMonth(uint year, uint month) internal pure returns (uint daysInMonth) {
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
            daysInMonth = 31;
        } else if (month != 2) {
            daysInMonth = 30;
        } else {
            daysInMonth = _isLeapYear(year) ? 29 : 28;
        }
    }
    // 1 = Monday, 7 = Sunday
    function getDayOfWeek(uint timestamp) internal pure returns (uint dayOfWeek) {
        uint _days = timestamp / SECONDS_PER_DAY;
        dayOfWeek = (_days + 3) % 7 + 1;
    }

    function getYear(uint timestamp) internal pure returns (uint year) {
        uint month;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function getMonth(uint timestamp) internal pure returns (uint month) {
        uint year;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function getDay(uint timestamp) internal pure returns (uint day) {
        uint year;
        uint month;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
    }
    function getHour(uint timestamp) internal pure returns (uint hour) {
        uint secs = timestamp % SECONDS_PER_DAY;
        hour = secs / SECONDS_PER_HOUR;
    }
    function getMinute(uint timestamp) internal pure returns (uint minute) {
        uint secs = timestamp % SECONDS_PER_HOUR;
        minute = secs / SECONDS_PER_MINUTE;
    }
    function getSecond(uint timestamp) internal pure returns (uint second) {
        second = timestamp % SECONDS_PER_MINUTE;
    }

    function addYears(uint timestamp, uint _years) internal pure returns (uint newTimestamp) {
        uint year;
        uint month;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        year += _years;
        uint daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        require(newTimestamp >= timestamp);
    }
    function addMonths(uint timestamp, uint _months) internal pure returns (uint newTimestamp) {
        uint year;
        uint month;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        month += _months;
        year += (month - 1) / 12;
        month = (month - 1) % 12 + 1;
        uint daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        require(newTimestamp >= timestamp);
    }
    function addDays(uint timestamp, uint _days) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp + _days * SECONDS_PER_DAY;
        require(newTimestamp >= timestamp);
    }
    function addHours(uint timestamp, uint _hours) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp + _hours * SECONDS_PER_HOUR;
        require(newTimestamp >= timestamp);
    }
    function addMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp + _minutes * SECONDS_PER_MINUTE;
        require(newTimestamp >= timestamp);
    }
    function addSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp + _seconds;
        require(newTimestamp >= timestamp);
    }

    function subYears(uint timestamp, uint _years) internal pure returns (uint newTimestamp) {
        uint year;
        uint month;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        year -= _years;
        uint daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        require(newTimestamp <= timestamp);
    }
    function subMonths(uint timestamp, uint _months) internal pure returns (uint newTimestamp) {
        uint year;
        uint month;
        uint day;
        (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
        uint yearMonth = year * 12 + (month - 1) - _months;
        year = yearMonth / 12;
        month = yearMonth % 12 + 1;
        uint daysInMonth = _getDaysInMonth(year, month);
        if (day > daysInMonth) {
            day = daysInMonth;
        }
        newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
        require(newTimestamp <= timestamp);
    }
    function subDays(uint timestamp, uint _days) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp - _days * SECONDS_PER_DAY;
        require(newTimestamp <= timestamp);
    }
    function subHours(uint timestamp, uint _hours) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp - _hours * SECONDS_PER_HOUR;
        require(newTimestamp <= timestamp);
    }
    function subMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp - _minutes * SECONDS_PER_MINUTE;
        require(newTimestamp <= timestamp);
    }
    function subSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
        newTimestamp = timestamp - _seconds;
        require(newTimestamp <= timestamp);
    }

    function diffYears(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _years) {
        require(fromTimestamp <= toTimestamp);
        uint fromYear;
        uint fromMonth;
        uint fromDay;
        uint toYear;
        uint toMonth;
        uint toDay;
        (fromYear, fromMonth, fromDay) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
        (toYear, toMonth, toDay) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
        _years = toYear - fromYear;
    }
    function diffMonths(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _months) {
        require(fromTimestamp <= toTimestamp);
        uint fromYear;
        uint fromMonth;
        uint fromDay;
        uint toYear;
        uint toMonth;
        uint toDay;
        (fromYear, fromMonth, fromDay) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
        (toYear, toMonth, toDay) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
        _months = toYear * 12 + toMonth - fromYear * 12 - fromMonth;
    }
    function diffDays(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _days) {
        require(fromTimestamp <= toTimestamp);
        _days = (toTimestamp - fromTimestamp) / SECONDS_PER_DAY;
    }
    function diffHours(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _hours) {
        require(fromTimestamp <= toTimestamp);
        _hours = (toTimestamp - fromTimestamp) / SECONDS_PER_HOUR;
    }
    function diffMinutes(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _minutes) {
        require(fromTimestamp <= toTimestamp);
        _minutes = (toTimestamp - fromTimestamp) / SECONDS_PER_MINUTE;
    }
    function diffSeconds(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _seconds) {
        require(fromTimestamp <= toTimestamp);
        _seconds = toTimestamp - fromTimestamp;
    }
}

// --- END: BokkyPooBahsDateTimeLibrary.sol ---


contract TimeHelpers {
    function getNextMonthStart() external view returns (uint timestamp) {
        return getNextMonthStartFromDate(now);
    }

    function calculateDelegationEndTime(
        uint requestTime,
        uint delegationPeriod,
        uint redelegationPeriod
    )
        external
        view
        returns (uint timestamp)
    {
        uint year;
        uint month;
        (year, month, ) = BokkyPooBahsDateTimeLibrary.timestampToDate(requestTime);

        month += delegationPeriod + 1;
        if (month > 12) {
            year += (month - 1) / 12;
            month = (month - 1) % 12 + 1;
        }
        timestamp = BokkyPooBahsDateTimeLibrary.timestampFromDate(year, month, 1);

        if (now > timestamp) {
            uint currentYear;
            uint currentMonth;
            (currentYear, currentMonth, ) = BokkyPooBahsDateTimeLibrary.timestampToDate(now);
            currentMonth += (currentYear - year) * 12;

            month += ((currentMonth - month) / redelegationPeriod + 1) * redelegationPeriod;
            if (month > 12) {
                year += (month - 1) / 12;
                month = (month - 1) % 12 + 1;
            }
            timestamp = BokkyPooBahsDateTimeLibrary.timestampFromDate(year, month, 1);
        }
    }

    function addMonths(uint fromTimestamp, uint n) external pure returns (uint) {
        uint year;
        uint month;
        uint day;
        uint hour;
        uint minute;
        uint second;
        (year, month, day, hour, minute, second) = BokkyPooBahsDateTimeLibrary.timestampToDateTime(fromTimestamp);
        month += n;
        if (month > 12) {
            year += (month - 1) / 12;
            month = (month - 1) % 12 + 1;
        }
        return BokkyPooBahsDateTimeLibrary.timestampFromDateTime(
            year,
            month,
            day,
            hour,
            minute,
            second);
    }

    function getNextMonthStartFromDate(uint dateTimestamp) public pure returns (uint timestamp) {
        uint year;
        uint month;
        (year, month, ) = BokkyPooBahsDateTimeLibrary.timestampToDate(dateTimestamp);
        month++;
        if (month > 12) {
            year++;
            month = 1;
        }
        timestamp = BokkyPooBahsDateTimeLibrary.timestampFromDate(year, month, 1);
    }
}
// --- END: TimeHelpers.sol ---


/// @notice Store and manage tokens states
contract TokenState is Permissions {

    enum State {
        PROPOSED,
        ACCEPTED,
        DELEGATED,
        ENDING_DELEGATED,
        COMPLETED
    }

    ///delegationId => State
    mapping (uint => State) private _state;

    /// delegationId => timestamp
    mapping (uint => uint) private _timelimit;

    ///       holder => amount
    mapping (address => uint) private _purchased;
    ///       holder => amount
    mapping (address => uint) private _slashed;
    ///       holder => amount
    mapping (address => uint) private _totalDelegated;
    /// delegationId => purchased
    mapping (uint => bool) private _isPurchased;

    ///       holder => delegationId[]
    mapping (address => uint[]) private _endingDelegations;

    constructor(address _contractManager) Permissions(_contractManager) public {
    }

    function getLockedCount(address holder) external returns (uint amount) {
        amount = 0;
        DelegationController delegationController = DelegationController(contractManager.getContract("DelegationController"));
        uint[] memory delegationIds = delegationController.getDelegationsByHolder(holder);
        // SWC-128-DoS With Block Gas Limit: L65
        for (uint i = 0; i < delegationIds.length; ++i) {
            uint id = delegationIds[i];
            if (isLocked(getState(id))) {
                amount += delegationController.getDelegation(id).amount;
            }
        }
        return amount + getPurchasedAmount(holder) + this.getSlashedAmount(holder);
    }

    function getDelegatedCount(address holder) external returns (uint amount) {
        amount = 0;
        DelegationController delegationController = DelegationController(contractManager.getContract("DelegationController"));
        uint[] memory delegationIds = delegationController.getDelegationsByHolder(holder);
        for (uint i = 0; i < delegationIds.length; ++i) {
            uint id = delegationIds[i];
            if (isDelegated(getState(id))) {
                amount += delegationController.getDelegation(id).amount;
            }
        }
        return amount;
    }

    function sold(address holder, uint amount) external allow("DelegationService") {
        _purchased[holder] += amount;
    }

    function accept(uint delegationId) external allow("DelegationRequestManager") {
        require(getState(delegationId) == State.PROPOSED, "Can't set state to accepted");
        setState(delegationId, State.ACCEPTED);
    }

    function requestUndelegation(uint delegationId) external allow("DelegationService") {
        require(getState(delegationId) == State.DELEGATED, "Can't request undelegation");
        setState(delegationId, State.ENDING_DELEGATED);
    }

    function cancel(uint delegationId) external allow("DelegationRequestManager") returns (State state) {
        require(getState(delegationId) == State.PROPOSED, "Can't cancel delegation request");
        DelegationController delegationController = DelegationController(contractManager.getContract("DelegationController"));
        return _cancel(delegationId, delegationController.getDelegation(delegationId));
    }

    function slash(uint delegationId, uint amount) external allow("DelegationService") {
        DelegationController delegationController = DelegationController(contractManager.getContract("DelegationController"));
        DelegationController.Delegation memory delegation = delegationController.getDelegation(delegationId);
        uint slashingAmount = amount;
        if (delegation.amount < amount) {
            // Can't slash more than delegated;
            slashingAmount = delegation.amount;
        }
        _slashed[delegation.holder] += slashingAmount;
        delegationController.setDelegationAmount(delegationId, delegation.amount - slashingAmount);
    }

    function forgive(address wallet, uint amount) external allow("DelegationService") {
        uint forgiveAmount = amount;
        if (amount > _slashed[wallet]) {
            forgiveAmount = _slashed[wallet];
        }
        _slashed[wallet] -= forgiveAmount;
    }

    function getSlashedAmount(address holder) external returns (uint amount) {
        return _slashed[holder];
    }

    function getState(uint delegationId) public returns (State state) {
        DelegationController delegationController = DelegationController(contractManager.getContract("DelegationController"));
        // TODO: Modify existance check
        require(delegationController.getDelegation(delegationId).holder != address(0), "Delegation does not exists");
        state = _state[delegationId];
        if (state == State.PROPOSED) {
            if (_timelimit[delegationId] == 0) {
                initProposed(delegationId);
            }
            if (now >= _timelimit[delegationId]) {
                state = _cancel(delegationId, delegationController.getDelegation(delegationId));
            }
        } else if (state == State.ACCEPTED) {
            if (now >= _timelimit[delegationId]) {
                state = acceptedToDelegated(delegationId);
                uint validatorId = delegationController.getDelegation(delegationId).validatorId;
                uint amount = delegationController.getDelegation(delegationId).amount;
                delegationController.addDelegationsTotal(validatorId, amount);
            }
        } else if (state == State.ENDING_DELEGATED) {
            if (now >= _timelimit[delegationId]) {
                state = endingDelegatedToUnlocked(delegationId, delegationController.getDelegation(delegationId));
                uint validatorId = delegationController.getDelegation(delegationId).validatorId;
                uint amount = delegationController.getDelegation(delegationId).amount;
                delegationController.subDelegationsTotal(validatorId, amount);
            }
        }
    }

    function getPurchasedAmount(address holder) public returns (uint amount) {
        // check if any delegation was ended
        for (uint i = 0; i < _endingDelegations[holder].length; ++i) {
            getState(_endingDelegations[holder][i]);
        }
        return _purchased[holder];
    }

    function isDelegated(State state) public returns (bool) {
        return state == State.DELEGATED || state == State.ENDING_DELEGATED;
    }

    // private

    function setState(uint delegationId, State newState) internal {
        TimeHelpers timeHelpers = TimeHelpers(contractManager.getContract("TimeHelpers"));
        DelegationController delegationController = DelegationController(contractManager.getContract("DelegationController"));

        require(newState != State.PROPOSED, "Can't set state to proposed");

        if (newState == State.ACCEPTED) {
            State currentState = getState(delegationId);
            require(currentState == State.PROPOSED, "Can't set state to accepted");

            _state[delegationId] = State.ACCEPTED;
            _timelimit[delegationId] = timeHelpers.getNextMonthStart();
        } else if (newState == State.DELEGATED) {
            revert("Can't set state to delegated");
        } else if (newState == State.ENDING_DELEGATED) {
            require(getState(delegationId) == State.DELEGATED, "Can't set state to ending delegated");
            DelegationController.Delegation memory delegation = delegationController.getDelegation(delegationId);

            _state[delegationId] = State.ENDING_DELEGATED;
            _timelimit[delegationId] = timeHelpers.calculateDelegationEndTime(delegation.created, delegation.delegationPeriod, 3);
            _endingDelegations[delegation.holder].push(delegationId);
        } else {
            revert("Unknown state");
        }
    }

    function initProposed(uint delegationId) internal {
        TimeHelpers timeHelpers = TimeHelpers(contractManager.getContract("TimeHelpers"));
        DelegationController delegationController = DelegationController(contractManager.getContract("DelegationController"));
        DelegationController.Delegation memory delegation = delegationController.getDelegation(delegationId);

        _timelimit[delegationId] = timeHelpers.getNextMonthStartFromDate(delegation.created);
        if (_purchased[delegation.holder] > 0) {
            _isPurchased[delegationId] = true;
            if (_purchased[delegation.holder] > delegation.amount) {
                _purchased[delegation.holder] -= delegation.amount;
            } else {
                _purchased[delegation.holder] = 0;
            }
        } else {
            _isPurchased[delegationId] = false;
        }
    }

    function isLocked(State state) internal returns (bool) {
        return state != State.COMPLETED;
    }

    function proposedToUnlocked(uint delegationId) internal returns (State state) {
        state = State.COMPLETED;
        _state[delegationId] = state;
        _timelimit[delegationId] = 0;
    }

    function acceptedToDelegated(uint delegationId) internal returns (State state) {
        state = State.DELEGATED;
        _state[delegationId] = state;
        _timelimit[delegationId] = 0;
    }

    function purchasedProposedToPurchased(uint delegationId, DelegationController.Delegation memory delegation) internal returns (State state) {
        state = State.COMPLETED;
        _state[delegationId] = state;
        _timelimit[delegationId] = 0;
        _purchased[delegation.holder] += delegation.amount;
    }

    function endingDelegatedToUnlocked(uint delegationId, DelegationController.Delegation memory delegation) internal returns (State state) {
        state = State.COMPLETED;
        _state[delegationId] = state;
        _timelimit[delegationId] = 0;

        // remove delegationId from _ending array
        uint endingLength = _endingDelegations[delegation.holder].length;
        for (uint i = 0; i < endingLength; ++i) {
            if (_endingDelegations[delegation.holder][i] == delegationId) {
                for (uint j = i; j + 1 < endingLength; ++j) {
                    _endingDelegations[delegation.holder][j] = _endingDelegations[delegation.holder][j+1];
                }
                _endingDelegations[delegation.holder][endingLength - 1] = 0;
                --_endingDelegations[delegation.holder].length;
                break;
            }
        }
        // SWC-105-Unprotected Ether Withdrawal: L259-265
        if (_isPurchased[delegationId]) {
            address holder = delegation.holder;
            _totalDelegated[holder] += delegation.amount;
            if (_totalDelegated[holder] >= _purchased[holder]) {
                purchasedToUnlocked(holder);
            }
        }
    }

    function purchasedToUnlocked(address holder) internal {
        _purchased[holder] = 0;
        _totalDelegated[holder] = 0;
    }

    function _cancel(uint delegationId, DelegationController.Delegation memory delegation) internal returns (State state) {
        if (_isPurchased[delegationId]) {
            state = purchasedProposedToPurchased(delegationId, delegation);
        } else {
            state = proposedToUnlocked(delegationId);
        }
    }

}

// --- END: TokenState.sol ---


contract DelegationController is Permissions {

    struct Delegation {
        address holder; // address of tokens owner
        uint validatorId;
        uint amount;
        uint delegationPeriod;
        uint created; // time of creation
        string info;
    }

    /// @notice delegations will never be deleted to index in this array may be used like delegation id
    Delegation[] public delegations;

    ///       holder => delegationId[]
    mapping (address => uint[]) private _delegationsByHolder;

    /// validatorId => delegationId[]
    mapping (uint => uint[]) private _activeByValidator;

    //validatorId => sum of tokens each holder
    mapping (uint => uint) private _delegationsTotal;

    modifier checkDelegationExists(uint delegationId) {
        require(delegationId < delegations.length, "Delegation does not exist");
        _;
    }

    constructor(address newContractsAddress) Permissions(newContractsAddress) public {

    }

    function getDelegation(uint delegationId) external view checkDelegationExists(delegationId) returns (Delegation memory) {
        return delegations[delegationId];
    }

    function addDelegationsTotal(uint validatorId, uint amount) external allow("TokenState") {
        _delegationsTotal[validatorId] += amount;
    }

    function subDelegationsTotal(uint validatorId, uint amount) external allow("TokenState") {
        _delegationsTotal[validatorId] -= amount;
    }

    function getDelegationsTotal(uint validatorId) external allow("ValidatorService") returns (uint) {
        TokenState tokenState = TokenState(contractManager.getContract("TokenState"));
        for (uint i = 0; i < _activeByValidator[validatorId].length; i++) {
            uint delegationId = _activeByValidator[validatorId][i];
            TokenState.State state = tokenState.getState(delegationId);
        }
        return _delegationsTotal[validatorId];
    }

    function addDelegation(
        address holder,
        uint validatorId,
        uint amount,
        uint delegationPeriod,
        uint created,
        string calldata info
    )
        external
        allow("DelegationRequestManager")
        returns (uint delegationId)
    {
        delegationId = delegations.length;
        delegations.push(Delegation(
            holder,
            validatorId,
            amount,
            delegationPeriod,
            created,
            info
        ));
        _delegationsByHolder[holder].push(delegationId);
        _activeByValidator[validatorId].push(delegationId);
    }

    function getDelegationsByHolder(address holder) external view allow("TokenState") returns (uint[] memory) {
        return _delegationsByHolder[holder];
    }

    function getActiveDelegationsByValidator(uint validatorId) external allow("Distributor") returns (uint[] memory) {
        TokenState tokenState = TokenState(contractManager.getContract("TokenState"));
        uint activeAmount = 0;
        for (uint i = 0; i < _activeByValidator[validatorId].length;) {
            TokenState.State state = tokenState.getState(_activeByValidator[validatorId][i]);
            if (state == TokenState.State.COMPLETED) {
                // remove from list
                _activeByValidator[validatorId][i] = _activeByValidator[validatorId][_activeByValidator[validatorId].length - 1];
                _activeByValidator[validatorId][_activeByValidator[validatorId].length - 1] = 0;
                --_activeByValidator[validatorId].length;
            } else {
                if (tokenState.isDelegated(state)) {
                    ++activeAmount;
                }
                ++i;
            }
        }

        uint[] memory active = new uint[](activeAmount);
        uint cursor = 0;
        for (uint i = 0; i < _activeByValidator[validatorId].length; ++i) {
            if (tokenState.isDelegated(tokenState.getState(_activeByValidator[validatorId][i]))) {
                require(cursor < active.length, "Out of index");
                active[cursor] = _activeByValidator[validatorId][i];
                ++cursor;
            }
        }

        return active;
    }

    function setDelegationAmount(uint delegationId, uint amount) external checkDelegationExists(delegationId) allow("TokenState") {
        delegations[delegationId].amount = amount;
    }

    function getDelegationsByHolder(address holderAddress, TokenState.State _state)
        external
        allow("DelegationService")
        returns (uint[] memory)
    {
        TokenState tokenState = TokenState(contractManager.getContract("TokenState"));
        uint delegationsAmount = 0;
        for (uint i = 0; i < _delegationsByHolder[holderAddress].length; i++) {
            TokenState.State state = tokenState.getState(_delegationsByHolder[holderAddress][i]);
            if (state == _state) {
                ++delegationsAmount;
            }
        }

        uint[] memory delegationsHolder = new uint[](delegationsAmount);
        uint cursor = 0;
        for (uint i = 0; i < _delegationsByHolder[holderAddress].length; i++) {
            if (_state == tokenState.getState(_delegationsByHolder[holderAddress][i])) {
                require(cursor < delegationsHolder.length, "Out of index");
                delegationsHolder[cursor] = _delegationsByHolder[holderAddress][i];
                ++cursor;
            }
        }
        return delegationsHolder;
    }

    function getDelegationsForValidator(address validatorAddress, TokenState.State _state)
        external
        allow("DelegationService")
        returns (uint[] memory)
    {
        TokenState tokenState = TokenState(contractManager.getContract("TokenState"));
        ValidatorService validatorService = ValidatorService(contractManager.getContract("ValidatorService"));
        uint validatorId = validatorService.getValidatorId(validatorAddress);
        uint delegationsAmount = 0;
        for (uint i = 0; i < _activeByValidator[validatorId].length; i++) {
            TokenState.State state = tokenState.getState(_activeByValidator[validatorId][i]);
            if (state == _state) {
                ++delegationsAmount;
            }
        }

        uint[] memory delegationsValidator = new uint[](delegationsAmount);
        uint cursor = 0;
        for (uint i = 0; i < _activeByValidator[validatorId].length; i++) {
            if (_state == tokenState.getState(_activeByValidator[validatorId][i])) {
                require(cursor < delegationsValidator.length, "Out of index");
                delegationsValidator[cursor] = _activeByValidator[validatorId][i];
                ++cursor;
            }
        }
        return delegationsValidator;
    }



}

// --- END: DelegationController.sol ---

// --- START: IConstants.sol ---

/**
 * @title Constants - interface of Constants contract
 * Contains only needed functions for current contract
 */
interface IConstants {
    function NODE_DEPOSIT() external view returns (uint);
    function FRACTIONAL_FACTOR() external view returns (uint);
    function FULL_FACTOR() external view returns (uint);
    function SECONDS_TO_DAY() external view returns (uint32);
    function SECONDS_TO_YEAR() external view returns (uint32);
    function MEDIUM_DIVISOR() external view returns (uint8);
    function TINY_DIVISOR() external view returns (uint8);
    function SMALL_DIVISOR() external view returns (uint8);
    function MEDIUM_TEST_DIVISOR() external view returns (uint8);
    function NUMBER_OF_NODES_FOR_SCHAIN() external view returns (uint);
    function NUMBER_OF_NODES_FOR_TEST_SCHAIN() external view returns (uint);
    function NUMBER_OF_NODES_FOR_MEDIUM_TEST_SCHAIN() external view returns (uint);
    function lastTimeUnderloaded() external view returns (uint);
    function lastTimeOverloaded() external view returns (uint);
    function setLastTimeOverloaded() external;
    function checkTime() external view returns (uint8);
    function rewardPeriod() external view returns (uint32);
    function allowableLatency() external view returns (uint32);
    function deltaPeriod() external view returns (uint);
    function SIX_YEARS() external view returns (uint32);
    function NUMBER_OF_MONITORS() external view returns (uint);
    function msr() external view returns (uint);
}
// --- END: IConstants.sol ---


contract ValidatorService is Permissions {

    struct Validator {
        string name;
        address validatorAddress;
        address requestedAddress;
        string description;
        uint feeRate;
        uint registrationTime;
        uint minimumDelegationAmount;
        uint lastBountyCollectionMonth;
        uint[] nodeIndexes;
    }

    mapping (uint => Validator) public validators;
    mapping (uint => bool) public trustedValidators;
    mapping (address => uint) private _validatorAddressToId;
    uint public numberOfValidators;

    modifier checkValidatorExists(uint validatorId) {
        require(validatorExists(validatorId), "Validator with such id doesn't exist");
        _;
    }

    constructor(address newContractsAddress) Permissions(newContractsAddress) public {

    }

    function registerValidator(
        string calldata name,
        address validatorAddress,
        string calldata description,
        uint feeRate,
        uint minimumDelegationAmount
    )
        external
        allow("DelegationService")
        returns (uint validatorId)
    {
        require(_validatorAddressToId[validatorAddress] == 0, "Validator with such address already exists");
        uint[] memory epmtyArray = new uint[](0);
        validatorId = ++numberOfValidators;
        validators[validatorId] = Validator(
            name,
            validatorAddress,
            address(0),
            description,
            feeRate,
            now,
            minimumDelegationAmount,
            0,
            epmtyArray
        );
        _validatorAddressToId[validatorAddress] = validatorId;
    }

    function enableValidator(uint validatorId) external checkValidatorExists(validatorId) onlyOwner {
        trustedValidators[validatorId] = true;
    }

    function disableValidator(uint validatorId) external checkValidatorExists(validatorId) onlyOwner {
        trustedValidators[validatorId] = false;
    }

    function requestForNewAddress(address oldValidatorAddress, address newValidatorAddress) external allow("DelegationService") {
        require(newValidatorAddress != address(0), "New address cannot be null");
        uint validatorId = getValidatorId(oldValidatorAddress);
        validators[validatorId].requestedAddress = newValidatorAddress;
    }

    function confirmNewAddress(address newValidatorAddress, uint validatorId)
        external
        checkValidatorExists(validatorId)
        allow("DelegationService")
    {
        _validatorAddressToId[validators[validatorId].validatorAddress] = 0;
        validators[validatorId].validatorAddress = newValidatorAddress;
        validators[validatorId].requestedAddress = address(0);
        _validatorAddressToId[newValidatorAddress] = validatorId;
    }

    function linkNodeAddress(address validatorAddress, address nodeAddress) external allow("DelegationService") {
        uint validatorId = getValidatorId(validatorAddress);
        require(_validatorAddressToId[nodeAddress] == 0, "Validator cannot override node address");
        _validatorAddressToId[nodeAddress] = validatorId;
    }

    function unlinkNodeAddress(address validatorAddress, address nodeAddress) external allow("DelegationService") {
        uint validatorId = getValidatorId(validatorAddress);
        require(_validatorAddressToId[nodeAddress] == validatorId, "Validator hasn't permissions to unlink node");
        _validatorAddressToId[nodeAddress] = 0;
    }

    function checkMinimumDelegation(uint validatorId, uint amount)
        external
        checkValidatorExists(validatorId)
        allow("DelegationRequestManager")
        returns (bool)
    {
        return validators[validatorId].minimumDelegationAmount <= amount ? true : false;
    }

    function checkValidatorAddressToId(address validatorAddress, uint validatorId)
        external
        view
        allow("DelegationRequestManager")
        returns (bool)
    {
        return getValidatorId(validatorAddress) == validatorId ? true : false;
    }

    function getValidatorNodeIndexes(uint validatorId) external view returns (uint[] memory) {
        return getValidator(validatorId).nodeIndexes;
    }

    function pushNode(address validatorAddress, uint nodeIndex) external allow("SkaleManager") {
        uint validatorId = getValidatorId(validatorAddress);
        validators[validatorId].nodeIndexes.push(nodeIndex);
    }

    function deleteNode(uint validatorId, uint nodeIndex) external allow("SkaleManager") {
        uint[] memory validatorNodes = validators[validatorId].nodeIndexes;
        uint position = findNode(validatorNodes, nodeIndex);
        if (position < validatorNodes.length) {
            validators[validatorId].nodeIndexes[position] = validators[validatorId].nodeIndexes[validatorNodes.length - 1];
        }
        delete validators[validatorId].nodeIndexes[validatorNodes.length - 1];
    }

    function checkPossibilityCreatingNode(address validatorAddress) external allow("SkaleManager") {
        DelegationController delegationController = DelegationController(
            contractManager.getContract("DelegationController")
        );
        uint validatorId = getValidatorId(validatorAddress);
        require(trustedValidators[validatorId], "Validator is not authorized to create a node");
        uint[] memory validatorNodes = validators[validatorId].nodeIndexes;
        uint delegationsTotal = delegationController.getDelegationsTotal(validatorId);
        uint msr = IConstants(contractManager.getContract("Constants")).msr();
        require((validatorNodes.length + 1) * msr <= delegationsTotal, "Validator has to meet Minimum Staking Requirement");
    }

    function checkPossibilityToMaintainNode(uint validatorId, uint nodeIndex) external allow("SkaleManager") returns (bool) {
        DelegationController delegationController = DelegationController(
            contractManager.getContract("DelegationController")
        );
        uint[] memory validatorNodes = validators[validatorId].nodeIndexes;
        uint position = findNode(validatorNodes, nodeIndex);
        require(position < validatorNodes.length, "Node does not exist for this Validator");
        uint delegationsTotal = delegationController.getDelegationsTotal(validatorId);
        uint MSR = IConstants(contractManager.getContract("Constants")).msr();
        return (position + 1) * MSR <= delegationsTotal;
    }

    function validatorExists(uint validatorId) public view returns (bool) {
        return validatorId <= numberOfValidators;
    }

    function validatorAddressExists(address validatorAddress) public view returns (bool) {
        return _validatorAddressToId[validatorAddress] != 0;
    }

    function checkIfValidatorAddressExists(address validatorAddress) public view {
        require(validatorAddressExists(validatorAddress), "Validator with such address doesn't exist");
    }

    function getValidator(uint validatorId) public view checkValidatorExists(validatorId) returns (Validator memory) {
        return validators[validatorId];
    }

    function getValidatorId(address validatorAddress) public view returns (uint) {
        checkIfValidatorAddressExists(validatorAddress);
        return _validatorAddressToId[validatorAddress];
    }

    function findNode(uint[] memory nodeIndexes, uint nodeIndex) internal pure returns (uint) {
        uint i;
        for (i = 0; i < nodeIndexes.length; i++) {
            if (nodeIndexes[i] == nodeIndex) {
                return i;
            }
        }
        return i;
    }

}

// --- END: ValidatorService.sol ---


contract DelegationRequestManager is Permissions {


    constructor(address newContractsAddress) Permissions(newContractsAddress) public {

    }

    function createRequest(
        address holder,
        uint validatorId,
        uint amount,
        uint delegationPeriod,
        string calldata info
    )
        external
        allow("DelegationService")
        returns (uint delegationId)
    {
        ValidatorService validatorService = ValidatorService(
            contractManager.getContract("ValidatorService")
        );
        TokenState tokenState = TokenState(
            contractManager.getContract("TokenState")
        );
        DelegationController delegationController = DelegationController(
            contractManager.getContract("DelegationController")
        );
        require(
            validatorService.checkMinimumDelegation(validatorId, amount),
            "Amount doesn't meet minimum delegation amount"
        );
        require(validatorService.trustedValidators(validatorId), "Validator is not authorized to accept request");
        require(
            DelegationPeriodManager(
                contractManager.getContract("DelegationPeriodManager")
            ).isDelegationPeriodAllowed(delegationPeriod),
            "This delegation period is not allowed"
        );
        // check that there is enough money
        // SWC-101-Integer Overflow and Underflow: L74-76
        uint holderBalance = SkaleToken(contractManager.getContract("SkaleToken")).balanceOf(holder);
        uint lockedToDelegate = tokenState.getLockedCount(holder) - tokenState.getPurchasedAmount(holder);
        require(holderBalance >= amount + lockedToDelegate, "Delegator hasn't enough tokens to delegate");

        delegationId = delegationController.addDelegation(
            holder,
            validatorId,
            amount,
            delegationPeriod,
            now,
            info
        );
    }

    function cancelRequest(uint delegationId, address holderAddress) external allow("DelegationService") {
        TokenState tokenState = TokenState(
            contractManager.getContract("TokenState")
        );
        DelegationController delegationController = DelegationController(
            contractManager.getContract("DelegationController")
        );
        ValidatorService validatorService = ValidatorService(
            contractManager.getContract("ValidatorService")
        );
        DelegationController.Delegation memory delegation = delegationController.getDelegation(delegationId);
        require(holderAddress == delegation.holder,"Only token holders can cancel delegation request");
        require(
            tokenState.getState(delegationId) == TokenState.State.PROPOSED,
            "Token holders able to cancel only PROPOSED delegations"
        );
        require(
            tokenState.cancel(delegationId) == TokenState.State.COMPLETED,
            "After cancellation token should be COMPLETED"
        );
    }

    function acceptRequest(uint delegationId, address validatorAddress) external allow("DelegationService") {
        TokenState tokenState = TokenState(
            contractManager.getContract("TokenState")
        );
        DelegationController delegationController = DelegationController(
            contractManager.getContract("DelegationController")
        );
        ValidatorService validatorService = ValidatorService(
            contractManager.getContract("ValidatorService")
        );
        DelegationController.Delegation memory delegation = delegationController.getDelegation(delegationId);
        require(
            validatorService.checkValidatorAddressToId(validatorAddress, delegation.validatorId),
            "No permissions to accept request"
        );
        tokenState.accept(delegationId);
    }

}

// --- END: DelegationRequestManager.sol ---

// --- START: Distributor.sol ---
/*
    Distributor.sol - SKALE Manager
    Copyright (C) 2019-Present SKALE Labs
    @author Dmytro Stebaiev

    SKALE Manager is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SKALE Manager is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with SKALE Manager.  If not, see <https://www.gnu.org/licenses/>.
*/



contract Distributor is Permissions {

    struct Share {
        address holder;
        uint amount;
        uint delegationId;
    }

    constructor (address _contractManager) public
    Permissions(_contractManager) {

    }

    function distributeBounty(uint validatorId, uint amount) external allow("DelegationService") returns (Share[] memory shares, uint fee) {
        return distributeWithFee(
            validatorId,
            amount,
            true,
            true);
    }

    function distributePenalties(uint validatorId, uint amount) external allow("DelegationService") returns (Share[] memory shares) {
        return distribute(
            validatorId,
            amount,
            false,
            false);
    }

    // private

    function distributeWithFee(
        uint validatorId,
        uint amount,
        bool roundFloor,
        bool applyMultipliers)
    internal returns (Share[] memory shares, uint fee)
    {
        ValidatorService validatorService = ValidatorService(contractManager.getContract("ValidatorService"));
        uint feeRate = validatorService.getValidator(validatorId).feeRate;

        shares = distribute(
            validatorId,
            amount - amount * feeRate / 1000,
            roundFloor,
            applyMultipliers);
        fee = amount;
        for (uint i = 0; i < shares.length; ++i) {
            fee -= shares[i].amount;
        }
    }

    function distribute(
        uint validatorId,
        uint amount,
        bool roundFloor,
        bool applyMultipliers)
    internal returns (Share[] memory shares)
    {
        DelegationController delegationController = DelegationController(contractManager.getContract("DelegationController"));

        uint totalDelegated = 0;
        uint[] memory activeDelegations = delegationController.getActiveDelegationsByValidator(validatorId);
        shares = new Share[](activeDelegations.length);

        DelegationPeriodManager delegationPeriodManager = DelegationPeriodManager(contractManager.getContract("DelegationPeriodManager"));
        for (uint i = 0; i < activeDelegations.length; ++i) {
            DelegationController.Delegation memory delegation = delegationController.getDelegation(activeDelegations[i]);
            shares[i].delegationId = activeDelegations[i];
            shares[i].holder = delegation.holder;
            if (applyMultipliers) {
                uint multiplier = delegationPeriodManager.stakeMultipliers(delegation.delegationPeriod);
                shares[i].amount = amount * delegation.amount * multiplier;
                totalDelegated += delegation.amount * multiplier;
            } else {
                shares[i].amount = amount * delegation.amount;
                totalDelegated += delegation.amount;
            }
        }

        for (uint i = 0; i < activeDelegations.length; ++i) {
            uint value = shares[i].amount;
            shares[i].amount /= totalDelegated;
            if (!roundFloor) {
                if (shares[i].amount * totalDelegated < value) {
                    ++shares[i].amount;
                }
            }
        }
    }
}
// --- END: Distributor.sol ---


contract DelegationService is Permissions, IHolderDelegation, IValidatorDelegation, IERC777Recipient {

    event DelegationRequestIsSent(
        uint delegationId
    );

    event ValidatorRegistered(
        uint validatorId
    );

    IERC1820Registry private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
    uint private _launchTimestamp;

    constructor(address newContractsAddress) Permissions(newContractsAddress) public {
        _launchTimestamp = now;
        _erc1820.setInterfaceImplementer(address(this), keccak256("ERC777TokensRecipient"), address(this));
    }

    function requestUndelegation(uint delegationId) external {
        TokenState tokenState = TokenState(contractManager.getContract("TokenState"));
        DelegationController delegationController = DelegationController(contractManager.getContract("DelegationController"));

        require(
            delegationController.getDelegation(delegationId).holder == msg.sender,
            "Can't request undelegation because sender is not a holder");

        tokenState.requestUndelegation(delegationId);
    }

    /// @notice Allows validator to accept tokens delegated at `delegationId`
    function acceptPendingDelegation(uint delegationId) external {
        DelegationRequestManager delegationRequestManager = DelegationRequestManager(
            contractManager.getContract("DelegationRequestManager")
        );
        delegationRequestManager.acceptRequest(delegationId, msg.sender);
    }

    function getDelegationsByHolder(TokenState.State state) external returns (uint[] memory) {
        DelegationController delegationController = DelegationController(contractManager.getContract("DelegationController"));
        return delegationController.getDelegationsByHolder(msg.sender, state);
    }

    function getDelegationsForValidator(TokenState.State state) external returns (uint[] memory) {
        DelegationController delegationController = DelegationController(contractManager.getContract("DelegationController"));
        return delegationController.getDelegationsForValidator(msg.sender, state);
    }

    function setMinimumDelegationAmount(uint amount) external {
        revert("Not implemented");
    }

    /// @notice Returns array of delegation requests id
    function listDelegationRequests() external returns (uint[] memory) {
        revert("Not implemented");
    }

    /// @notice Allows service to slash `validator` by `amount` of tokens
    function slash(uint validatorId, uint amount) external allow("SkaleDKG") {
        ValidatorService validatorService = ValidatorService(contractManager.getContract("ValidatorService"));
        require(validatorService.validatorExists(validatorId), "Validator does not exist");

        Distributor distributor = Distributor(contractManager.getContract("Distributor"));
        TokenState tokenState = TokenState(contractManager.getContract("TokenState"));

        Distributor.Share[] memory shares = distributor.distributePenalties(validatorId, amount);
        for (uint i = 0; i < shares.length; ++i) {
            tokenState.slash(shares[i].delegationId, shares[i].amount);
        }
    }

    function forgive(address wallet, uint amount) external onlyOwner() {
        TokenState tokenState = TokenState(contractManager.getContract("TokenState"));
        tokenState.forgive(wallet, amount);
    }

    /// @notice Returns amount of delegated token of the validator
    function getDelegatedAmount(uint validatorId) external returns (uint) {
        DelegationController delegationController = DelegationController(contractManager.getContract("DelegationController"));
        return delegationController.getDelegationsTotal(validatorId);
    }

    function setMinimumStakingRequirement(uint amount) external onlyOwner() {
        revert("Not implemented");
    }

    /// @notice Creates request to delegate `amount` of tokens to `validator` from the begining of the next month
    function delegate(
        uint validatorId,
        uint amount,
        uint delegationPeriod,
        string calldata info
    )
        external
    {
        DelegationRequestManager delegationRequestManager = DelegationRequestManager(
            contractManager.getContract("DelegationRequestManager")
        );
        uint delegationId = delegationRequestManager.createRequest(
            msg.sender,
            validatorId,
            amount,
            delegationPeriod,
            info
        );
        emit DelegationRequestIsSent(delegationId);
    }

    function cancelPendingDelegation(uint delegationId) external {
        DelegationRequestManager delegationRequestManager = DelegationRequestManager(
            contractManager.getContract("DelegationRequestManager")
        );
        delegationRequestManager.cancelRequest(delegationId, msg.sender);
    }
    // SWC-135-Code With No Effects: L152-158
    function getAllDelegationRequests() external returns(uint[] memory) {
        revert("Not implemented");
    }

    function getDelegationRequestsForValidator(uint validatorId) external returns (uint[] memory) {
        revert("Not implemented");
    }

    /// @notice Register new as validator
    function registerValidator(
        string calldata name,
        string calldata description,
        uint feeRate,
        uint minimumDelegationAmount
    )
        external returns (uint validatorId)
    {
        ValidatorService validatorService = ValidatorService(contractManager.getContract("ValidatorService"));
        validatorId = validatorService.registerValidator(
            name,
            msg.sender,
            description,
            feeRate,
            minimumDelegationAmount
        );
        emit ValidatorRegistered(validatorId);
    }

    function linkNodeAddress(address nodeAddress) external {
        ValidatorService validatorService = ValidatorService(contractManager.getContract("ValidatorService"));
        validatorService.linkNodeAddress(msg.sender, nodeAddress);
    }

    function unlinkNodeAddress(address nodeAddress) external {
        ValidatorService validatorService = ValidatorService(contractManager.getContract("ValidatorService"));
        validatorService.unlinkNodeAddress(msg.sender, nodeAddress);
    }

    function unregisterValidator(uint validatorId) external {
        revert("Not implemented");
    }

    /// @notice return how many of validator funds are locked in SkaleManager
    function getBondAmount(uint validatorId) external returns (uint amount) {
        revert("Not implemented");
    }

    function setValidatorName(string calldata newName) external {
        revert("Not implemented");
    }

    function setValidatorDescription(string calldata description) external {
        revert("Not implemented");
    }

    function requestForNewAddress(address newAddress) external {
        ValidatorService(contractManager.getContract("ValidatorService")).requestForNewAddress(msg.sender, newAddress);
    }

    function confirmNewAddress(uint validatorId) external {
        ValidatorService validatorService = ValidatorService(contractManager.getContract("ValidatorService"));
        ValidatorService.Validator memory validator = validatorService.getValidator(validatorId);

        require(
            validator.requestedAddress == msg.sender,
            "The validator cannot be changed because it isn't the actual owner"
        );

        validatorService.confirmNewAddress(msg.sender, validatorId);
    }

    function getValidators() external view returns (uint[] memory validatorIds) {
        ValidatorService validatorService = ValidatorService(contractManager.getContract("ValidatorService"));
        validatorIds = new uint[](validatorService.numberOfValidators());
        for (uint i = 0; i < validatorIds.length; ++i) {
            validatorIds[i] = i + 1;
        }
    }

    function withdrawBounty(address bountyCollectionAddress, uint amount) external {
        SkaleBalances skaleBalances = SkaleBalances(contractManager.getContract("SkaleBalances"));
        skaleBalances.withdrawBalance(msg.sender, bountyCollectionAddress, amount);
    }

    function getEarnedBountyAmount() external returns (uint) {
        SkaleBalances skaleBalances = SkaleBalances(contractManager.getContract("SkaleBalances"));
        return skaleBalances.getBalance(msg.sender);
    }

    /// @notice removes node from system
    function deleteNode(uint nodeIndex) external {
        revert("Not implemented");
    }

    /// @notice Makes all tokens of target account unavailable to move
    function lock(address wallet, uint amount) external allow("TokenSaleManager") {
        SkaleToken skaleToken = SkaleToken(contractManager.getContract("SkaleToken"));
        TokenState tokenState = TokenState(contractManager.getContract("TokenState"));

        require(skaleToken.balanceOf(wallet) >= tokenState.getPurchasedAmount(wallet) + amount, "Not enough founds");

        tokenState.sold(wallet, amount);
    }

    function getLockedOf(address wallet) external returns (uint) {
        TokenState tokenState = TokenState(contractManager.getContract("TokenState"));
        return tokenState.getLockedCount(wallet);
    }

    function getDelegatedOf(address wallet) external returns (uint) {
        TokenState tokenState = TokenState(contractManager.getContract("TokenState"));
        return tokenState.getDelegatedCount(wallet);
    }

    function getSlashedOf(address wallet) external returns (uint) {
        TokenState tokenState = TokenState(contractManager.getContract("TokenState"));
        return tokenState.getSlashedAmount(wallet);
    }

    function setLaunchTimestamp(uint timestamp) external onlyOwner {
        _launchTimestamp = timestamp;
    }

    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    )
        external
        allow("SkaleToken")
    {
        require(userData.length == 32, "Data length is incorrect");
        uint validatorId = abi.decode(userData, (uint));
        distributeBounty(amount, validatorId);
    }

    // private

    function distributeBounty(uint amount, uint validatorId) internal {
        ValidatorService validatorService = ValidatorService(contractManager.getContract("ValidatorService"));

        SkaleToken skaleToken = SkaleToken(contractManager.getContract("SkaleToken"));
        Distributor distributor = Distributor(contractManager.getContract("Distributor"));
        SkaleBalances skaleBalances = SkaleBalances(contractManager.getContract("SkaleBalances"));
        TimeHelpers timeHelpers = TimeHelpers(contractManager.getContract("TimeHelpers"));
        DelegationController delegationController = DelegationController(contractManager.getContract("DelegationController"));

        Distributor.Share[] memory shares;
        uint fee;
        (shares, fee) = distributor.distributeBounty(validatorId, amount);

        address validatorAddress = validatorService.getValidator(validatorId).validatorAddress;
        skaleToken.send(address(skaleBalances), fee, abi.encode(validatorAddress));
        skaleBalances.lockBounty(validatorAddress, timeHelpers.addMonths(_launchTimestamp, 3));
        // SWC-128-DoS With Block Gas Limit: L310-316
        for (uint i = 0; i < shares.length; ++i) {
            skaleToken.send(address(skaleBalances), shares[i].amount, abi.encode(shares[i].holder));

            uint created = delegationController.getDelegation(shares[i].delegationId).created;
            uint delegationStarted = timeHelpers.getNextMonthStartFromDate(created);
            skaleBalances.lockBounty(shares[i].holder, timeHelpers.addMonths(delegationStarted, 3));
        }
    }
}

// --- END: DelegationService.sol ---


/**
 * @title SkaleToken is ERC777 Token implementation, also this contract in skale
 * manager system
 */
contract SkaleToken is LockableERC777, Permissions, IDelegatableToken {

    string public constant NAME = "SKALE";

    string public constant SYMBOL = "SKL";

    uint public constant DECIMALS = 18;

    uint public constant CAP = 7 * 1e9 * (10 ** DECIMALS); // the maximum amount of tokens that can ever be created

    constructor(address contractsAddress, address[] memory defOps)
    Permissions(contractsAddress)
    LockableERC777("SKALE", "SKL", defOps) public
    {
        // TODO remove after testing
        uint money = 1e7 * 10 ** DECIMALS;
        _mint(
            address(0),
            address(msg.sender),
            money, bytes(""),
            bytes("")
        );
    }

    /**
     * @dev mint - create some amount of token and transfer it to specify address
     * @param operator address operator requesting the transfer
     * @param account - address where some amount of token would be created
     * @param amount - amount of tokens to mine
     * @param userData bytes extra information provided by the token holder (if any)
     * @param operatorData bytes extra information provided by the operator (if any)
     * @return returns success of function call.
     */
    function mint(
        address operator,
        address account,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    )
        external
        allow("SkaleManager")
        //onlyAuthorized
        returns (bool)
    {
        require(amount <= CAP - totalSupply(), "Amount is too big");
        _mint(
            operator,
            account,
            amount,
            userData,
            operatorData
        );

        return true;
    }

    function getDelegatedOf(address wallet) external returns (uint) {
        return DelegationService(contractManager.getContract("DelegationService")).getDelegatedOf(wallet);
    }

    function getSlashedOf(address wallet) external returns (uint) {
        return DelegationService(contractManager.getContract("DelegationService")).getSlashedOf(wallet);
    }

    function getLockedOf(address wallet) public returns (uint) {
        return DelegationService(contractManager.getContract("DelegationService")).getLockedOf(wallet);
    }

    // private

    function _getLockedOf(address wallet) internal returns (uint) {
        return getLockedOf(wallet);
    }
}

// --- END: SkaleToken.sol ---

// --- START: ISkaleToken.sol ---

interface ISkaleToken {
    function transfer(address to, uint256 value) external returns (bool success);
    function mint(
        address operator,
        address account,
        uint amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external returns (bool);
    function CAP() external view returns (uint);
}
// --- END: ISkaleToken.sol ---


contract SkaleBalances is Permissions, IERC777Recipient {
    IERC1820Registry private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
    mapping (address => uint) private _bountyBalances;
    //        wallet => timestamp
    mapping (address => uint) private _timeLimit;
    bool private _lockBounty = true;

    constructor(address newContractsAddress) Permissions(newContractsAddress) public {
        _erc1820.setInterfaceImplementer(address(this), keccak256("ERC777TokensRecipient"), address(this));
    }

    function withdrawBalance(address from, address to, uint amountOfTokens) external allow("DelegationService") {
        if (_timeLimit[from] != 0) {
            require(_timeLimit[from] <= now, "Bounty is locked");
            _timeLimit[from] = 0;
        }

        require(_bountyBalances[from] >= amountOfTokens, "Now enough tokens on balance for withdrawing");
        _bountyBalances[from] -= amountOfTokens;

        SkaleToken skaleToken = SkaleToken(contractManager.getContract("SkaleToken"));
        require(skaleToken.transfer(to, amountOfTokens), "Failed to transfer tokens");
    }
    // SWC-107-Reentrancy: L55-68
    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    )
        external
        allow("SkaleToken")
    {
        address recipient = abi.decode(userData, (address));
        stashBalance(recipient, amount);
    }

    function getBalance(address wallet) external view allow("DelegationService") returns (uint) {
        return _bountyBalances[wallet];
    }

    function setLockBounty(bool lock) external onlyOwner() {
        _lockBounty = lock;
    }

    function lockBounty(address wallet, uint timeLimit) external allow("DelegationService") {
        if (_lockBounty) {
            if (_timeLimit[wallet] == 0 || _timeLimit[wallet] > timeLimit) {
                _timeLimit[wallet] = timeLimit;
            }
        }
    }

    // private

    function stashBalance(address recipient, uint amount) internal {
        _bountyBalances[recipient] += amount;
    }
}

// --- END: SkaleBalances.sol ---
