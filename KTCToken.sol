pragma solidity ^0.4.21;

contract ERC223ReceivingContract { 
/**
 * @dev Standard ERC223 function that will handle incoming token transfers.
 *
 * @param _from  Token sender address.
 * @param _value Amount of tokens.
 * @param _data  Transaction metadata.
 */
    function tokenFallback(address _from, uint _value, bytes _data) public;
    function tokenFallback(address _from, uint _value, bytes _data, string _stringdata, uint256 _numdata ) public;  
    function tokenFallback(address _from, uint _value, bytes _data, string _stringdata, uint256 _numdata, address _forwardto, uint256 _numdata2 ) public;  
    
}


contract tokenRecipient {
    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
}



contract DAH_Contract {
    function burn( uint amount );
}


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns(uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns(uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns(uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns(uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract Crownable {

	using SafeMath for uint8;

    event NewDAH(address dah);
    event NewCrown(address crown);
	event NewManager(address manager);
	event NewMinter(address minter);
	event ManagerRemoved(address manager);
    event NewTreasurer(address treasurer);
    event NewWhiteList(address whitelist);
    event NewLister(address lister);
    event NewFeeContract(address feecontract);
    event NewDisbursementContract(address disbursementcontract);
    event NewMasterOfferContract(address masteroffercontract);
    event NewMasterAssetContract(address masterassetcontract);
    event NewBookingControllerContract(address bookingcontrollercontract);
    event NewInflationContract(address inflationcontract);
    event NewStakersContract(address stakerscontract);
    event NewExpansionContract(address expansioncontract);
    
    struct Vote {
        address[3] voted;
        uint8 voteCount;
    }
	
	mapping(address => bool) manager;
	mapping(address => Vote) proposal;
	
	address public dah;
	
	address public minter;
	address public crown;
	address public treasurer;
	
	address public whitelist;
	address public lister;
	address public feecontract;
	address public disbursementcontract;
	address public masteroffercontract;
	address public masterassetcontract;
	address public bookingcontrollercontract;
	address public inflationcontract;
	address public stakerscontract;
	address public expansioncontract;
	
	address public firstLord;
	address public secondLord;
	address public thirdLord;

	uint256 managerCount;

	constructor(address fLord, address sLord, address tLord) public {
	    crown = msg.sender;
	    firstLord = fLord;
	    secondLord = sLord;
	    thirdLord = tLord;
	}

	modifier onlyManager() {
		require(manager[msg.sender] == true);
		_;
	}

	modifier onlyMinter() {
		require( minter == msg.sender);
		_;
	}
	
	modifier onlyCrown() {
		require( crown == msg.sender );
		_;
	}
	
	modifier onlyTreasurer() {
		require( treasurer == msg.sender );
		_;
	}
	
	modifier onlyInflationContract() {
		require( inflationcontract == msg.sender );
		_;
	}
	
	modifier onlyLord() {
	    require((msg.sender == firstLord) || (msg.sender == secondLord) || (msg.sender == thirdLord));
	    _;
	}
	
	function setDAH(address newDAH) public onlyCrown {
		require(newDAH != address(0));
		dah = newDAH;
		emit NewDAH(newDAH);
	}
	
	function setMinter(address newMinter) public onlyCrown {
		require(newMinter != address(0));
		minter = newMinter;
		emit NewMinter(newMinter);
	}

    function setTreasurer(address newTreasurer) public onlyCrown {
		require(newTreasurer != address(0));
		treasurer = newTreasurer;
		emit NewMinter(newTreasurer);
	}
	
	function setWhitelist(address newWhitelist) public onlyManager() {
		require(newWhitelist != address(0));
		whitelist = newWhitelist;
		emit NewWhiteList(newWhitelist);
	}
	
	function setLister(address newlister) public onlyManager() {
		require(newlister != address(0));
		lister = newlister;
		emit NewLister(newlister);
	}
	
	function setFeeContract(address newfeecontract) public onlyManager() {
		require(newfeecontract != address(0));
		feecontract = newfeecontract;
		emit NewFeeContract(newfeecontract);
	}
	
	function setDisbursementContract(address newdisbursementcontract) public onlyCrown() {
		require(newdisbursementcontract != address(0));
		disbursementcontract = newdisbursementcontract;
		emit NewDisbursementContract(newdisbursementcontract);
	}
	
	function setMasterOfferContract(address newmasteroffercontract) public onlyCrown() {
		require(newmasteroffercontract != address(0));
		masteroffercontract = newmasteroffercontract;
		emit NewMasterOfferContract(newmasteroffercontract);
	}
	
	function setMasterAssetContract(address newmasterassetcontract) public onlyCrown() {
		require(newmasterassetcontract != address(0));
		masterassetcontract = newmasterassetcontract;
		emit NewMasterAssetContract(newmasterassetcontract);
	}
	
	function setBookingControllerContract(address newbookingcontrollercontract) public onlyCrown() {
		require(newbookingcontrollercontract != address(0));
		bookingcontrollercontract = newbookingcontrollercontract;
		emit NewBookingControllerContract(newbookingcontrollercontract);
	}
	
	function setInflationContract(address newinflationcontract) public onlyCrown() {
		require(newinflationcontract != address(0));
	    inflationcontract = newinflationcontract;
		emit NewInflationContract(newinflationcontract);
	}
	
	function setStakersContract(address newstakerscontract) public onlyCrown() {
		require(newstakerscontract != address(0));
	    stakerscontract = newstakerscontract;
		emit NewStakersContract(newstakerscontract);
	}
	
	function setExpansionContract(address newexpansioncontract) public onlyCrown() {
		require(newexpansioncontract != address(0));
	    expansioncontract = newexpansioncontract;
		emit NewExpansionContract(newexpansioncontract);
	}

	function addManager(address newManager) public onlyCrown {
		require(newManager != address(0));
		managerCount++;
		manager[newManager] = true;
		emit NewManager(newManager);
	}

    function removeManager(address managerAddress) public onlyCrown {
		require(managerCount > 1);
		managerCount--;
		manager[managerAddress] = false;
		emit ManagerRemoved(managerAddress);
	}
	
	function changeCrown(address newCrown) public onlyLord {
	    require(newCrown != 0x0);
	    
	    // Checks if already voted
	    for (uint256 i=0; i<proposal[newCrown].voted.length-1; i++) {
	        if (msg.sender == proposal[newCrown].voted[i]) {
	            revert();
	        }    
	    }
	    
	    // Appends to end vote
	    for (uint256 a=0; a<proposal[newCrown].voted.length-1; a++) {
	        if (proposal[newCrown].voted[a] == 0x0) {
	            proposal[newCrown].voted[a] = msg.sender;
	            proposal[newCrown].voteCount++;
	            if (proposal[newCrown].voteCount == 2) {
	                crown = newCrown;
	                emit NewCrown(newCrown);
	                break;
	            } else {
	                break;
	            }
	        }
	    }
	}
}


contract Mintable {
    
    mapping ( uint256 => address ) public mintRequestBeneficiary;
    mapping ( uint256 => uint256 ) public mintRequestAmount;
    mapping ( uint256 => bool )    public mintRequestApproval;
    mapping ( uint256 => bool )    public mintRequestCompleted;
    mapping ( uint256 => uint256 ) public mintRequestSequence;
    
    uint256 public mintSequence;
    
    
    
}


contract Inflation {
    
    uint public start;
    uint public payments;
    
    
    
}

contract KTC is Crownable, Mintable, Inflation  {

    using SafeMath for uint256;
    /* Public variables of the token */
    string public constant name = "Kryptonite Trade Coin";
    string public constant symbol = "KTC";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    uint256 public initialSupply;

    mapping( address => uint256) public balanceOf;
    mapping( address => mapping(address => uint256)) public allowance;
    
    


    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Transfer(address indexed from, address indexed to, uint value, bytes data);
    event Transfer(address indexed from, address indexed to, uint value, bytes data, string _stringdata, uint256 _numdata );
    event Approval(address indexed owner, address indexed spender, uint value);

    /* This notifies clients about the amount burnt */
    event Burn(address indexed from, uint256 value);
    event Minted(address indexed to, uint256 value);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor(uint256 supply, address fLord, address sLord, address tLord) public Crownable(fLord, sLord, tLord) {
        initialSupply = 10**uint256(decimals)*supply; 
        balanceOf[msg.sender] = initialSupply; // Give the creator all initial tokens
        totalSupply = initialSupply; // Update total supply
        manager [ msg.sender ] = true;
        managerCount = 1;
        start = now;
    }

    function balanceOf(address tokenHolder) public constant returns(uint256) {
        return balanceOf[tokenHolder];
    }

    function totalSupply() public constant returns(uint256) {
        return totalSupply;
    }


    function transfer(address _to, uint256 _value) public returns(bool ok) {
        require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
        require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
        bytes memory empty;
        
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
        balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
        
         if(isContract( _to )) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, empty);
        }
        
        emit Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
        return true;
    }
    
    function transferx(address _to, uint256 _value ) public returns(bool ok) {
        require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
        require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
        
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
        balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
        
        
        emit Transfer(msg.sender, _to, _value ); // Notify anyone listening that this transfer took place
        return true;
    }
    
    function transfer(address _to, uint256 _value, bytes _data ) public returns(bool ok) {
        require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
        require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
        
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
        balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
        
         if(isContract( _to )) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, _data);
        }
        
        emit Transfer(msg.sender, _to, _value, _data); // Notify anyone listening that this transfer took place
        return true;
    }
    
    function transfer(address _to, uint256 _value, bytes _data, string _stringdata, uint256 _numdata ) public returns(bool ok) {
        require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
        require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
        
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
        balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
        
         if(isContract( _to )) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, _data, _stringdata, _numdata);
        }
        
        emit Transfer(msg.sender, _to, _value, _data , _stringdata, _numdata ); // Notify anyone listening that this transfer took place
        return true;
    }
    
    function transfer(address _to, uint256 _value, bytes _data, string _stringdata, uint256 _numdata, address _forwardto, uint _numdata2 ) public returns(bool ok) {
        require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
        require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
        
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
        balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
        
         if(isContract( _to )) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, _data, _stringdata, _numdata, _forwardto , _numdata2);
        }
        
        emit Transfer(msg.sender, _to, _value, _data , _stringdata, _numdata ); // Notify anyone listening that this transfer took place
        return true;
    }
    
    function isContract( address _to ) internal view returns ( bool ){
        uint codeLength = 0;
        
        assembly {
            // Retrieve the size of the code on target address, this needs assembly .
            codeLength := extcodesize(_to)
        }
        
        if(codeLength>0) {
            return true;
        }
        
        return false;
        
    }
    
    /* Allow another contract to spend some tokens in your behalf */
    function approve(address _spender, uint256 _value) public returns(bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval( msg.sender ,_spender, _value);
        return true;
    }

    /* Approve and then communicate the approved contract in a single tx */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
        return allowance[_owner][_spender];
    }

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
        require(_from != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
        require(balanceOf[_from] >= _value); // Check if the sender has enough
        require(_value <= allowance[_from][msg.sender]); // Check allowance
        balanceOf[_from] = balanceOf[_from].sub( _value ); // Subtract from the sender
        balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
        emit Transfer(_from, _to, _value);
        return true;
    }
  
    function burn(uint256 _value) public returns(bool success) {
        require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
       
        balanceOf[msg.sender] = balanceOf[msg.sender].sub( _value ); // Subtract from the sender
        totalSupply = totalSupply.sub( _value ); // Updates totalSupply
        emit Burn(msg.sender, _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) public returns(bool success) {
        require(_from != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
        require(balanceOf[_from] >= _value); 
        require(_value <= allowance[_from][msg.sender]); 
        balanceOf[_from] = balanceOf[_from].sub( _value ); 
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub( _value ); 
        totalSupply = totalSupply.sub( _value ); // Updates totalSupply
        emit Burn(_from, _value);
        return true;
    }

    function mint(  uint256 _mintRequest ) internal onlyTreasurer {
    	require( _mintRequest != 0x0);
    	balanceOf[mintRequestBeneficiary[mintRequestSequence[ _mintRequest ]]] = balanceOf[mintRequestBeneficiary[mintRequestSequence[ _mintRequest ]]].add( mintRequestAmount[mintRequestSequence[ _mintRequest ]]);
    	totalSupply = totalSupply.add( mintRequestAmount[mintRequestSequence[ _mintRequest ]]);
    	emit Minted( mintRequestBeneficiary[mintRequestSequence[ _mintRequest ]] , mintRequestAmount[mintRequestSequence[ _mintRequest ]]);
    }
    
    function mintRequest ( address _to, uint256 _amount, uint256 _mintrequest ) public onlyTreasurer {
        mintSequence ++;
        mintRequestBeneficiary[ mintSequence ] = _to;
        mintRequestAmount[ mintSequence ] = _amount;
        require ( mintRequestSequence[ _mintrequest ] == 0 );
        mintRequestSequence[ _mintrequest ] = mintSequence;
    }
    
    function mintApprove ( uint256 _mintRequest ) public onlyMinter {
        require ( mintRequestSequence[ _mintRequest ] != 0 );
        mintRequestApproval[mintRequestSequence[ _mintRequest ]] = true;
    }
    
    function mintComplete ( uint256 _mintRequest ) public onlyTreasurer {
        require ( mintRequestSequence[ _mintRequest ] != 0 );
        require ( mintRequestApproval[mintRequestSequence[ _mintRequest ]] == true);
        mintRequestCompleted[mintRequestSequence[ _mintRequest ]] = true;
        mint (  _mintRequest );
    }
    
    function inflate () internal {
        
        require ( inflationcontract != 0 );
        uint twopercent = 2*(totalSupply/100);
        totalSupply = totalSupply.add( twopercent );
        balanceOf[inflationcontract] = balanceOf[inflationcontract].add( twopercent );
        
        
    }
    
    function inflation() onlyInflationContract returns ( uint ){
        
        uint timepassed = now - start;
        uint yrs =  (timepassed / 1 years);
        require ( payments < yrs );
        if ( payments < yrs ){
            payments++;
            inflate();
        }
        return yrs;
    }
    
    
    function tokenFallback(address _sender, uint _amount, bytes _data ){
        
        require ( msg.sender == dah );
        totalSupply = totalSupply.add( _amount );
        balanceOf[ _sender ] = balanceOf[_sender].add( _amount );
        
        DAH_Contract dahcontract = DAH_Contract ( dah );
        dahcontract.burn ( _amount );
        
    }
    
    
    
}

contract Fabric is Crownable {
    
    constructor(address fLord, address sLord, address tLord) public Crownable(fLord, sLord, tLord) {}
    
    function createNewContract(uint256 supply, address fLord, address sLord, address tLord) public returns (address) {
        return new KTC(supply, fLord, sLord, tLord);
    }
    
}
