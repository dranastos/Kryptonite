pragma solidity ^0.4.23;


contract MasterKTCAddress {
     function getKTCAddress() returns(address);
}

contract KTC_Contract {
    
    function transfer(address _to, uint256 _value) returns(bool ok) ;
    function transfer(address _to, uint256 _value, bytes _data, string _stringdata, uint256 _numdata ) public returns(bool ok);
    function balanceOf(address _address ) returns(uint256) ;
    function crown() returns(address);
    function disbursementcontract() returns(address);
    function stakerscontract() returns(address);
    
}

 

contract InflationContract  {
    
    
    address public KTC_Address;
    KTC_Contract ktccontract;
    address public owner;
    uint[] public payments;
    
    
   
    modifier onlyOwner {
		require( msg.sender == owner );
		_;
	}
    
   
    function InflationContract(){
        owner = msg.sender;
        MasterKTCAddress masterktcaddress = MasterKTCAddress ( 0x947b5bd2c425b7393e212bea75e733d02f4071f1 );
        KTC_Address = masterktcaddress.getKTCAddress();
        ktccontract = KTC_Contract ( KTC_Address);
    }
   
    function changeOwner( address _newowner ) public onlyOwner {
       owner = _newowner;
    }
   
    function tokenFallback ( address _sender, uint _value, bytes _data ) {
       
       payments.push( _value );
       uint share = _value/2;
       address secondshare = ktccontract.disbursementcontract();
       
       if ( ktccontract.stakerscontract() != 0 )  secondshare = ktccontract.stakerscontract();
       ktccontract.transfer( ktccontract.disbursementcontract() , share );
       ktccontract.transfer(  secondshare , share );
       
    }
    
    function withdrawEther() onlyOwner {
        owner.transfer(this.balance);
    }
    
    function withdrawKTC() onlyOwner {
        ktccontract.transfer( ktccontract.disbursementcontract() ,ktccontract.balanceOf(this) );
    }
   
    
  
   
}
    
    
    
