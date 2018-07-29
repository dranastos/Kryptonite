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
    
}

 

contract MasterKTCAddresses  {
    
    
    address public KTC_Address;
    address public DAH_Address;
    
    
    address public owner;
    
    modifier onlyOwner {
		require( msg.sender == owner );
		_;
	}
    
   
    function MasterKTCAddresses(){
        owner = msg.sender;
    }
   
    function changeOwner( address _newowner ) public onlyOwner {
    
       owner = _newowner;
   
       
    }
    
    function getKTCAddress() returns(address) {
        return KTC_Address;
    }
   
   
   function setKTCAddress( address _address)onlyOwner {
        KTC_Address = _address;
    }
   
   function getDAHAddress() returns(address) {
        return DAH_Address;
    }
   
   
   function setDAHAddress( address _address)onlyOwner {
        DAH_Address = _address;
    }
    
  
   
}
    
    
    
