
// --- START: Main.sol ---
// SWC-102-Outdated Compiler Version: L2
pragma solidity ^0.4.21;


// --- START: Voting.sol ---


// --- START: CoalichainToken.sol ---


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

}




/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    Unpause();
  }
}



/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}





/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}





/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;



  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public constant returns (uint256 balance) {
    return balances[_owner];
  }

}

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {

    require(_to != address(0));
	uint256 _allowance = 0;

    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
    // require (_value <= _allowance);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
	
	if(_from != address(this)){
       _allowance = allowed[_from][_to];
		allowed[_from][_to] = _allowance.sub(_value);
	}

    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  /**
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   */
  function increaseApproval (address _spender, uint _addedValue)
    returns (bool success) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval (address _spender, uint _subtractedValue)
    returns (bool success) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}



/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 */
contract BurnableToken is StandardToken {

    event Burn(address indexed burner, uint256 value);

    /**
     * @dev Burns a specific amount of tokens.
     * @param _value The amount of token to be burned.
     */
    function burn(uint256 _value) public {
        require(_value > 0);

        address burner = msg.sender;
        balances[burner] = balances[burner].sub(_value);
        totalSupply = totalSupply.sub(_value);
        Burn(burner, _value);
    }
}

// Coalichain (https://coalichain.io)



/**
 * The Coalichain token (ZUZ) has a fixed supply and restricts the ability
 * to transfer tokens until after ICO (owner calls the shots wrt to that)
 *
 * Owner may let a token sale contract transfer ZUZ to buyers during ICO by set the amount through setCrowdsale method
 */
contract CoalichainToken is StandardToken, BurnableToken, Ownable {

    // Constants
    string  public constant name = "Coalichain Token";
    string  public constant symbol = "ZUZ";
    uint8   public constant decimals = 18;
    uint256 public constant INITIAL_SUPPLY      = 770000000 * (10 ** uint256(decimals));
    uint256 public constant CROWDSALE_ALLOWANCE = 462000000 * (10 ** uint256(decimals));
    uint256 public constant ADMIN_ALLOWANCE     = 308000000 * (10 ** uint256(decimals));

    // Properties
    uint256 public crowdSaleAllowance;      // the number of tokens available for crowdsales
    uint256 public adminAllowance;          // the number of tokens available for the administrator
    address public crowdSaleAddr = 0xd742955953f5c510f21a65c90ab87823d0b12683;     // the address of a crowdsale contract set to sale ZUZ
    address public adminAddr;        // the address of the token admin account
    bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not

    // Modifiers
    modifier onlyWhenTransferEnabled() {
        if (!transferEnabled) {
            require(msg.sender == adminAddr || msg.sender == crowdSaleAddr);
        }
        _;
    }

    /**
     * The listed addresses are not valid recipients of tokens.
     *
     * 0x0           - the zero address is not valid
     * this          - the contract itself should not receive tokens
     * owner         - the owner has all the initial tokens, but cannot receive any back
     * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
     * crowdSaleAddr - the crowdsale has an allowance of tokens to transfer, but does not receive any
     */
    modifier validDestination(address _to) {
        require(_to != address(0x0));
        require(_to != address(this));
        require(_to != owner);
        require(_to != address(adminAddr));
        require(_to != address(crowdSaleAddr));
        _;
    }

    /**
     * Constructor - instantiates token supply and allocates balanace of
     * to the owner (msg.sender).
     */
    function CoalichainToken() {
        // the owner is a custodian of tokens that can
        // give an allowance of tokens for crowdsales
        // or to the admin, but cannot itself transfer
        // tokens; hence, this requirement
        //require(msg.sender != _admin);

        totalSupply = INITIAL_SUPPLY;
        crowdSaleAllowance = CROWDSALE_ALLOWANCE;
        adminAllowance = ADMIN_ALLOWANCE;
        adminAddr = msg.sender;

        // mint all tokens
        balances[msg.sender] = totalSupply;
        Transfer(address(0x0), msg.sender, totalSupply);

        //adminAddr = owner;
        approve(adminAddr, adminAllowance);
    }

	 function transferToContract(address _from, uint256 _value) returns (bool) {
        return super.transferFrom(_from, address(this), _value);
    }

	 function transferFromContract(address _to, uint256 _value) returns (bool) {
        return super.transferFrom(address(this), _to, _value);
    }

    /**
     * Associates this token with a current crowdsale, giving the crowdsale
     * an allowance of tokens from the crowdsale supply. This gives the
     * crowdsale the ability to call transferFrom to transfer tokens to
     * whomever has purchased them.
     *
     * Note that if _amountForSale is 0, then it is assumed that the full
     * remaining crowdsale supply is made available to the crowdsale.
     *
     * @param _crowdSaleAddr The address of a crowdsale contract that will sell this token
     * @param _amountForSale The supply of tokens provided to the crowdsale
     */
    function setCrowdsale(address _crowdSaleAddr, uint256 _amountForSale) external onlyOwner {
        require(!transferEnabled);
        require(_amountForSale <= crowdSaleAllowance);

        // if 0, then full available crowdsale supply is assumed
        uint amount = (_amountForSale == 0) ? crowdSaleAllowance : _amountForSale;

        // Clear allowance of old, and set allowance of new
        approve(crowdSaleAddr, 0);
        approve(_crowdSaleAddr, amount);

        crowdSaleAddr = _crowdSaleAddr;
    }

    /**
     * Enables the ability of anyone to transfer their tokens. This can
     * only be called by the token owner. Once enabled, it is not
     * possible to disable transfers.
     */
    function enableTransfer() external onlyOwner {
        transferEnabled = true;
        approve(crowdSaleAddr, 0);
        approve(adminAddr, 0);
        crowdSaleAllowance = 0;
        adminAllowance = 0;
    }

    /**
     * Overrides ERC20 transfer function with modifier that prevents the
     * ability to transfer tokens until after transfers have been enabled.
     */
    function transfer(address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
        return super.transfer(_to, _value);
    }

    /**
     * Overrides ERC20 transferFrom function with modifier that prevents the
     * ability to transfer tokens until after transfers have been enabled.

    function transferFrom(address _from, address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
        bool result = super.transferFrom(_from, _to, _value);
        if (result) {
            if (msg.sender == crowdSaleAddr)
                crowdSaleAllowance = crowdSaleAllowance.sub(_value);
            if (msg.sender == adminAddr)
                adminAllowance = adminAllowance.sub(_value);
        }
        return result;
    }
     */
    /**
     * Overrides the burn function so that it cannot be called until after
     * transfers have been enabled.
     *
     * @param _value    The amount of tokens to burn in ZUZ
     */
    function burn(uint256 _value) public {
        require(transferEnabled || msg.sender == owner);
        require(balances[msg.sender] >= _value);
        super.burn(_value);
        Transfer(msg.sender, address(0x0), _value);
    }
}

// --- END: CoalichainToken.sol ---

// --- START: Types.sol ---
library Types{
    enum Service {
      CREATE_BALLOT,
      VOTE,
      UNVOTE,
      CHANGE_VOTE
    }
}

// --- END: Types.sol ---

contract Voting {
  using SafeMath for uint256;

  enum Stages {
      UNREGISTERED,
      REGISTERED,
      VOTED
  }

  struct Voter {
    address voterAddress; // The address of the voter
    Stages state;
    address votedFor;
  }

  mapping (address => Voter) private voterInfo;
  address private owner;
  Main private mainContract;
  address private mainAddress;
  mapping (address => uint256) public votesReceived;
  address[] public candidateList;
  address private coaliWallet;
  uint256 public _balloutDBId = 0;
  
  event Voted(address voterAddress, address candidate, uint256 newVotesReceived, uint256 correlationID);
  event Unvoted(address voterAddress, address candidate, uint256 newVotesReceived, uint256 correlationID);
  event voterApproved(address voterAddress);

  constructor(
      address _owner,
      address[] candidateNames,
      address _coaliWallet,
	  uint256 balloutDBId)
      public {

      candidateList = candidateNames;
      coaliWallet = _coaliWallet;
      mainContract = Main(msg.sender); // TODO: check if the msg.sender is secure!
      mainAddress = msg.sender;
      owner = _owner;
	  _balloutDBId = balloutDBId;
      voterInfo[_owner].state = Stages.VOTED;
  }



  function getCandidatesList() view public returns (address[], uint256[]){
     uint256[] memory votes = new uint256[](candidateList.length);
     for (uint index = 0; index < candidateList.length; index++) {
       votes[index] = votesReceived[candidateList[index]];
     }
     return (candidateList, votes);
  }

  function getMyVoterState() public view returns (uint8) {
    return (uint8(voterInfo[msg.sender].state) + 1);
  }


  function totalVotesFor(address candidate) view public returns (uint256) {
      require(validCandidate(candidate));
      return votesReceived[candidate];
  }

  function getBalloutDBID() view public returns (uint256){
	return _balloutDBId;
  }


  function voteForCandidate(address candidate, uint256 correlationID) public returns (bool) {

      require(validCandidate(candidate));

      
	if(voterInfo[msg.sender].votedFor != candidate) {
		   voterInfo[msg.sender].votedFor = candidate;
		   votesReceived[candidate] = votesReceived[candidate].add(1);
		   emit Voted(msg.sender, candidate, votesReceived[candidate], correlationID);
		   
		   mainContract.payForService(msg.sender, 1000000);

	  }

	  return true;
    }


    function changeVote(address newCandidate, uint256 correlationID) public returns (bool) {
        require(msg.sender != owner);
        address oldCandidate = voterInfo[msg.sender].votedFor;
        require(validCandidate(newCandidate));
        require(validCandidate(oldCandidate));
   

        votesReceived[oldCandidate] = votesReceived[oldCandidate].sub(1);
        votesReceived[newCandidate] = votesReceived[newCandidate].add(1);
        voterInfo[msg.sender].votedFor = newCandidate;
        emit Unvoted(msg.sender, oldCandidate, votesReceived[oldCandidate], correlationID);
        emit Voted(msg.sender, newCandidate, votesReceived[newCandidate], correlationID);

		if (mainContract.chargeZuz()) {
            mainContract.payForService(msg.sender, uint256(Types.Service.CHANGE_VOTE));
        }
		
			return true;
    }


    function unvoteForCandidate(uint256 correlationID) public returns (bool) {
        require(msg.sender != owner);
        address candidate = voterInfo[msg.sender].votedFor;
  
        votesReceived[candidate] = votesReceived[candidate].sub(1);
        voterInfo[msg.sender].state = Stages(uint(voterInfo[msg.sender].state).sub(1));
        emit Unvoted(msg.sender, candidate, votesReceived[candidate], correlationID);

       if (mainContract.chargeZuz()) {
            mainContract.payForService(msg.sender, uint256(Types.Service.UNVOTE));
        }
		
		return true;
    }

    function validCandidate(address candidate) view public returns (bool) {
        for(uint i = 0; i < candidateList.length; i++) {
            if (candidateList[i] == candidate) {
                return true;
              }
          }

        return false;
    }
}

// --- END: Voting.sol ---

contract Main{
    using SafeMath for uint256;

    mapping (uint256 => uint256) public prices; // maps a uint casted Service enum to it's price
    address private owner = msg.sender;
    address private ZuzOwner;
    address[] private ballotAddresses;

    CoalichainToken private ZuzToken;
    bool public chargeZuz = true;

	uint256 balloutId = 0;

   event balloutCreated(address balloutAddress, uint256 correlationId);
     event Log(string message, address from, address to, uint256 value);

    modifier onlyOwner(address sender) {
        require(sender == owner);
        _;
    }

    modifier onlyKnownContract(address sender) {
        assert(isKnownContract(sender));
        _;
    }


    constructor(address ZuzAddress) public {
        ZuzToken = CoalichainToken(ZuzAddress);
        ZuzOwner = ZuzToken.adminAddr();
        prices[uint(Types.Service.CREATE_BALLOT)] = 5000000;

    }

    function changeOwner(address newOwner) public onlyOwner(msg.sender) {
        require(newOwner != address(0));
        owner = newOwner;
    }

    function createBallot(address[] candidates, uint256 correlationId) public returns (bool){
    
        Voting bl = new Voting(msg.sender, candidates, owner, correlationId);
        // SWC-107-Reentrancy: L51
        ballotAddresses.push(bl);

		emit balloutCreated(bl, correlationId);
		
		    bool isSuccessful = ZuzToken.transferFrom(
            msg.sender,
           owner,
            prices[uint(Types.Service.CREATE_BALLOT)]
        );

        require(isSuccessful == true);
		
		return true;
    }



    function payForService(address voterAddress, uint256 amount)
        external
        onlyKnownContract(msg.sender) {

        bool isSuccessful = ZuzToken.transferFrom(
            voterAddress,
            owner,
            amount
        );
        
       require(isSuccessful == true);
    }


    // Constants updaters


    function updateBallotPrice(uint256 newPrice) public onlyOwner(msg.sender) {
        prices[uint(Types.Service.CREATE_BALLOT)] = newPrice;
    }


    // Getters


    function getBallotsAddresses() view public returns (address[]) {
        return ballotAddresses;
    }

    // Helper functions

    // Should be used both internally and externally, by the KYC server
    function isKnownContract(address contractAddress) view public returns (bool){
        for (uint i = 0; i < ballotAddresses.length; i++){
            if (ballotAddresses[i] == contractAddress){
                return true;
            }
        }

        return false;
  }


}

// --- END: Main.sol ---
