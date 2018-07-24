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

 

contract FeeContract  {
    
    
    address public KTC_Address;
    KTC_Contract ktccontract;
    
    address public owner;
    
    uint public tradefee;
    uint public bookingfee;
    
    uint public buyerofferfee;
    uint public sellerofferfee;
    
    
    
    
    uint[] public payments;
    uint[] public etherpayments;
    
    
    modifier onlyOwner {
		require( msg.sender == owner );
		_;
	}
    
   
    function FeeContract(){
    
        owner = msg.sender;
        MasterKTCAddress masterktcaddress = MasterKTCAddress ( ); // add master KTC Address
        KTC_Address = masterktcaddress.getKTCAddress();
        ktccontract = KTC_Contract ( KTC_Address);
        
        tradefee = 200;
        payments.push( 0 );
        
         buyerofferfee  = 0;
         sellerofferfee = 0;
        
        
    
    }
   
    function changeOwner( address _newowner ) public onlyOwner {
    
       owner = _newowner;
   
       
    }
   
   // fee 100 = 1.00% 
    function setTradeFee ( uint feepercent ) onlyOwner {
       
        require ( feepercent<10000);
        
        tradefee = feepercent;
        
    }
    
    function calculatefee( uint sum ) returns (uint) {
        return (sum*tradefee)/10000;
    }
   
    function buyerofferfee()  returns  ( uint) {
         return buyerofferfee;    
    }
    
    function sellerofferfee() returns ( uint ){
        return sellerofferfee;
    }
    
    function setBuyerofferfee( uint _buyerofferfee ) onlyOwner {
         buyerofferfee = _buyerofferfee;    
    }
    
    function setSellerofferfee( uint _sellerofferfee ) onlyOwner {
        sellerofferfee = _sellerofferfee;
    }
    
    
    
    
    
    function tokenFallback ( address _sender, uint _value, bytes _data,  string _stringdata, uint _numdata, address _forwardto, uint numdata2 ) {
        
       payments.push( _value );
       uint net = _value - calculatefee( _value );
       ktccontract.transfer(  _forwardto , net );
     
        
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
   
    
  
   
}
    
    
    
