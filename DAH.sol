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

contract MasterKTCAddress {
     function getKTCAddress() returns(address);
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


contract KTC_Contract {
    
    
    function transfer(address _to, uint256 _value, bytes _data, string _stringdata, uint256 _numdata, address _forwardto, uint _numdata2 ) public returns(bool ok);
    function transfer(address _to, uint256 _value) returns(bool ok) ;
    function balanceOf(address _address ) returns(uint256) ;
    function lister() returns(address);
    function whitelist() returns(address);
    function crown() returns(address);
    function feecontract() returns(address);
    
    
}


contract Restrict {
    
    
    
   
    
    address public KTC_Address;
    KTC_Contract ktccontract;
    mapping ( address => bool ) public Unrestricted;
    mapping ( address => uint ) public timelock;
    
    
   


   function WhatIsNow (  ) constant returns(uint){
        
        uint time = now;
        
        return time;
        
    }
    
}


contract DAH is Restrict  {

    using SafeMath for uint256;
    /* Public variables of the token */
    string public constant name = "DAH Trade Coin";
    string public constant symbol = "DAH";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    uint256 public initialSupply;
    
    event Compare ( uint _now, uint _timelock );
    
  

    mapping( address => uint256) public balanceOf;
    mapping( address => mapping(address => uint256)) public allowance;
    
    
    mapping ( address => uint256 ) public timelock;
    
    


    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Transfer(address indexed from, address indexed to, uint value, bytes data);
    event Transfer(address indexed from, address indexed to, uint value, bytes data, string _stringdata, uint256 _numdata );
    event Approval(address indexed owner, address indexed spender, uint value);

    /* This notifies clients about the amount burnt */
    event Burn(address indexed from, uint256 value);
    event Minted(address indexed to, uint256 value);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor(uint256 supply) public  {
        initialSupply = 10**uint256(decimals)*supply; 
        balanceOf[msg.sender] = initialSupply; // Give the creator all initial tokens
        totalSupply = initialSupply; // Update total supply
        
        MasterKTCAddress masterktcaddress = MasterKTCAddress (  );// add master address
        KTC_Address = masterktcaddress.getKTCAddress();
        ktccontract = KTC_Contract ( KTC_Address);
        
        Unrestricted [ msg.sender ] = true; 
       
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
        restriction ( _to );
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(  _value ); // Subtract from the sender
        balanceOf[_to] = balanceOf[_to].add( _value ); // Add the same to the recipient
        
         if(isContract( _to )) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
            receiver.tokenFallback(msg.sender, _value, empty);
        }
        
        emit Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
        return true;
    }
    
   
    function transfer(address _to, uint256 _value, bytes _data ) public returns(bool ok) {
        
        require(_to != 0x0); // Prevent transfer to 0x0 address. Use burn() instead
        restriction ( _to );
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
    
    
    function restriction ( address _to ) internal {
        
         require ( Unrestricted[ msg.sender] == true || now > timelock [msg.sender] );
         MasterKTCAddress masterktcaddress = MasterKTCAddress ( 0x5c6211bfdde9d1e9d99bf4fbd321c6c1a1b98078 );
         if (  Unrestricted[ msg.sender] != true ) 
        {
            require ( _to == masterktcaddress.getKTCAddress() );
            require ( restrictionExpired ( msg.sender ) == true );
        }
        
         if (  Unrestricted[ msg.sender] == true && _to != masterktcaddress.getKTCAddress() ) 
        {
            timelock[ _to ] = now + (2 * 1 minutes);
        }
    
        
    }
    
     function restrictionExpired ( address _address )  constant returns(bool){
        
        if ( now > timelock [ _address ] && timelock [ _address ] != 0 ) 
        {
            emit Compare ( now , timelock [ _address ]);
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

   
    
    
    
}

