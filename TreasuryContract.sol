pragma solidity ^0.4.23;


contract MasterKTCAddress {
     function getKTCAddress() returns(address);
}

contract PurchasingContract {

    
    
    
    
}
contract KTC_Contract {
    
    function transfer(address _to, uint256 _value) returns(bool ok) ;
    function transfer(address _to, uint256 _value, bytes _data, string _stringdata, uint256 _numdata ) public returns(bool ok);
    function balanceOf(address _address ) returns(uint256) ;
    function crown() returns(address);
    function disbursementcontract() returns(address);
    function mintRequest ( address _to, uint256 _amount, uint256 _mintrequest );
    function mintComplete ( uint256 _mintRequest );
    
}

contract voting {
    
     struct approvalSignatures {
        
        address one;
        address two;
        address three;
        bool sent;
        
        
    }
    
     mapping ( address => approvalSignatures ) public votes;
     
       
   
    
    
    function checkNextEmptySlots ( address _purchasingcontractaddress ) returns ( uint ){
        
        
        if ( votes[ _purchasingcontractaddress ].one == 0 ) return 1;
        if ( votes[ _purchasingcontractaddress ].two == 0 ) return 2;
        if ( votes[ _purchasingcontractaddress ].three == 0 ) return 3;
        return 0;
    
    }
    
    function checkIfVoted ( address _purchasingcontractaddress ) returns ( bool ){
        
        if ( votes[ _purchasingcontractaddress ].one == msg.sender ) return true;
        if ( votes[ _purchasingcontractaddress ].two == msg.sender ) return true;
        if ( votes[ _purchasingcontractaddress ].three == msg.sender ) return true;
        return false;
    
    }
    
    function countVotes ( address _purchasingcontractaddress ) returns ( uint ){
        
        uint votecount = 0;
        if ( votes[ _purchasingcontractaddress ].one != 0 ) votecount++;
        if ( votes[ _purchasingcontractaddress ].two != 0 ) votecount++;
        if ( votes[ _purchasingcontractaddress ].three != 0 ) votecount++;
        return votecount;
        
    }
    
}

contract TreasuryContract is voting  {
    
    address public owner;
    address public KTC_Address;
    KTC_Contract ktccontract;
    
    mapping ( address => bool ) founders;
    
   
    
   
    
    uint[] public payments;
    uint[] public etherpayments;
    
    
    mapping ( address => uint ) public purchasingContract;
    mapping ( uint => address ) public purchasingContractIdMap;

    uint public purchasingContractId;
    
    modifier onlyOwner {
		require( msg.sender == owner );
		_;
	}
	
	modifier onlyFounder {
		require( founders[msg.sender] == true );
		_;
	}
    
   
    function TreasuryContract(){
    
        owner = msg.sender;
        MasterKTCAddress masterktcaddress = MasterKTCAddress ( 0x947b5bd2c425b7393e212bea75e733d02f4071f1 );
        KTC_Address = masterktcaddress.getKTCAddress();
        ktccontract = KTC_Contract ( KTC_Address);
        
    }
   
    function addFounder( address _founder ) public onlyOwner {
    
       founders[ _founder] = true;
   
       
    }
    
    function removeFounder( address _founder ) public onlyOwner {
    
       founders[ _founder] = false;
   
       
    }
    
    function tokenFallback ( address _sender, uint _value, bytes _data,  string _stringdata, uint _numdata, address _forwardto, uint numdata2 ) {
        
        payments.push(_value );
    }
    
    
    
    function fundPurchasingContract ( address _address, uint  _amount) onlyFounder {
        
        purchasingContractId++;
        purchasingContract[ _address ] = _amount;
        purchasingContractIdMap[ purchasingContractId ] = _address;
    }
    
     function approvePurchasingContract( address _purchasingcontractaddress ) onlyFounder {
        
        require ( checkIfVoted ( _purchasingcontractaddress ) == false );
        uint slot = checkNextEmptySlots (  _purchasingcontractaddress );
        if ( slot == 1 ) votes[ _purchasingcontractaddress ].one = msg.sender;
        if ( slot == 2 ) votes[ _purchasingcontractaddress ].two = msg.sender;
        if ( slot == 3 ) votes[ _purchasingcontractaddress ].three = msg.sender;
        
        if ( countVotes(_purchasingcontractaddress) >3 ) sendFundsRequested( _purchasingcontractaddress );
        
    }
    
  
    
    function sendFundsRequested( address _purchasingcontractaddress ) internal {
        
        require( votes[ _purchasingcontractaddress ].sent == false );
        ktccontract.transfer (_purchasingcontractaddress, purchasingContract[ _purchasingcontractaddress ] );
        votes[ _purchasingcontractaddress ].sent = true;
    }
    
    function ()payable{
        
        etherpayments.push ( msg.value );
        
    }
   
    function withdrawEther() onlyOwner {
        
        owner.transfer(this.balance);
        
    }
    
    function withdrawKTC() onlyOwner {
        
        ktccontract.transfer(owner,ktccontract.balanceOf(this));
        
    }
    
    function mintRequest ( address _to, uint256 _amount, uint256 _mintrequest ) public onlyFounder {
        
        ktccontract.mintRequest ( _to,  _amount, _mintrequest) ;
        
    }
    
    function mintComplete ( uint256 _mintRequest ) public onlyFounder {
        
         ktccontract.mintComplete ( _mintRequest) ;
        
    }
   
    
  
   
}
    
    
    
