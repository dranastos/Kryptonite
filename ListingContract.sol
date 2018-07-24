pragma solidity ^0.4.23;


contract MasterKTCAddress {
     function getKTCAddress() returns(address);
}

contract KTC_Contract {
    
    function transfer(address _to, uint256 _value) returns(bool ok) ;
    function transfer(address _to, uint256 _value, bytes _data, string _stringdata, uint256 _numdata ) public returns(bool ok);
    
    
}


contract AssetContract{
    
     function Sell_Offer ( uint _offeramount, uint _numberofdays, uint _sharenumber, uint _currency ) returns ( address );
     function Buy_Offer  ( uint _offeramount, uint _numberofdays, uint _sharenumber, uint _currency ) returns ( address);
    
}

contract BuyOfferContract{
    
    function acceptOffer( uint _share, string _dochash ) public returns(bool);
    function cancelOffer() returns( bool );
    
}
    
contract SellOfferContract{
    
    function cancelOffer() returns( bool );
    function escrow();
    
}    

contract ListerContract  {
    
    
    address public KTC_Address;
    KTC_Contract ktccontract;
    
    
    
    address public owner;
    mapping ( address => bool ) public listers;
    mapping ( uint => address ) public listerAddresses;
    
    
    
    uint public numlisters;
    
    
    modifier onlyLister {
		require( listers[msg.sender] == true );
		_;
	}
    
   
   
    modifier onlyOwner {
		require( msg.sender == owner );
		_;
	}
    
   
    function ListerContract(){
        owner = msg.sender;
    
        MasterKTCAddress masterktcaddress = MasterKTCAddress (  0x947b5bd2c425b7393e212bea75e733d02f4071f1 );
        KTC_Address = masterktcaddress.getKTCAddress();
        ktccontract = KTC_Contract ( KTC_Address);
    
        
    }
   
   function addLister( address _address ) public onlyOwner{
       require ( _address != 0x0 );
       numlisters++;
       listers[ _address ] = true;
   }
   
   
   function removeLister( address _address ) public onlyOwner{
       listers[ _address ] = false;
   }
   
   function changeOwner( address _newowner ) public onlyOwner {
       owner = _newowner;
   }
   
   
   function Sell_Offer ( address _address, uint _offeramount, uint _numberofdays, uint _sharenumber, uint _currency ) onlyOwner returns ( address ){
       
         AssetContract assetcontract =  AssetContract ( _address ) ;
         return assetcontract.Sell_Offer  (  _offeramount, _numberofdays, _sharenumber, _currency );
        
        
   }
   
    function Buy_Offer  ( address _address,  uint _offeramount, uint _numberofdays, uint _sharenumber , uint _currency ) onlyOwner returns ( address){
        
         AssetContract assetcontract =  AssetContract ( _address ) ;
         return assetcontract.Buy_Offer  (  _offeramount, _numberofdays, _sharenumber, _currency  );
        
        
    }
    
    function CancelSellOffer( address _address ) onlyOwner {
        
         SellOfferContract selloffercontract =  SellOfferContract ( _address ) ;
         selloffercontract.cancelOffer();
        
        
    }
    
    function CancelBuyOffer( address _address ) onlyOwner {
        
         BuyOfferContract buyoffercontract =  BuyOfferContract ( _address ) ;
         buyoffercontract.cancelOffer();
        
        
    }
    
    function Escrow( address _address ){
        
         SellOfferContract selloffercontract =  SellOfferContract ( _address ) ;
         selloffercontract.escrow();
        
    }
    
    
    function tokenFallback ( address _sender, uint _value, bytes _data,  string _stringdata, uint _numdata, address _forwardto, uint numdata2 ) {
        
        ktccontract.transfer(  _forwardto, _value, _data,  _stringdata,  _numdata );
        
    }
   
   
   function tokenFallback ( address _sender, uint _value, bytes _data ) {
        
         ktccontract.transfer(  owner , _value );
        
    }
    
    
  
   
}
    
    
    
