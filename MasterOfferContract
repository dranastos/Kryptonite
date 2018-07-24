pragma solidity ^0.4.23;



contract MasterKTCAddress {
     function getKTCAddress() returns(address);
}

contract KTC_Contract {
    
    
    function transfer(address _to, uint256 _value, bytes _data, string _stringdata, uint256 _numdata, address _forwardto, uint _numdata2 ) public returns(bool ok);
    function transfer(address _to, uint256 _value) returns(bool ok) ;
    function balanceOf(address _address ) returns(uint256) ;
    function lister() returns(address);
    function whitelist() returns(address);
    function crown() returns(address);
    function feecontract() returns(address);
    function masterassetcontract() returns(address);
    
    
}


contract KTCWhitelist {
    
    function checkAddress ( address _address ) public returns(bool);
    
}




contract AssetContract {
    
    function memberShare( uint _share ) returns(address); 
    function updateMember( address _oldmember, address _newmember, uint _numbershare, uint _price, string _dochash, uint _offernumber ) returns(bool);
    function removeListing( uint _sharenumber );
    
    
}

contract MasterKTCAssets {
    
    function isKTCAsset( address _address) returns (bool);
    
}


contract Offer{
    
    event CancelOffer ( uint offernumber, address _seller,  uint _amount );
    
    
    string public offertype;
    address public AssetContractAddress;
    address public OffererAddress;
    uint public expires;
    uint public offeramount;
    uint public sharenumber;
    uint public currency;
    
    address public buyer;
    address public seller;
    
    address public KTC_Address;
    KTC_Contract public ktccontract;
    
    
    AssetContract public assetcontract;
    
    bool public OfferActive;
    bool public OfferFunded;
    uint public offerNumber;
    
     
    modifier onlyOfferer() {
		require( msg.sender == OffererAddress );
		_;
	}
	
	event BuyOfferFunded   ( uint offernumber, address _address, uint _amount );
    event BuyOfferAccepted ( uint offernumber, address _seller,  uint _amount );
    
     
    function cancelOffer() public onlyOfferer returns( bool ) {
       
       require ( OfferActive == true );
       cleanup();
       emit CancelOffer ( offerNumber,  msg.sender ,  offeramount );
       return true;
        
    }
    
    
    function cleanup() internal{
        
       OfferActive = false;
       if ( keccak256("Offer to Sell") == keccak256(offertype) ) assetcontract.removeListing( sharenumber );
        
    }
    
    function isExpired() constant returns(bool){
        
        return ( now >= expires );
        
    }
    
    function requirements( address _address){
        
       require ( OfferActive == true );
       require ( now < expires );
       require ( OffererAddress != _address );
        
    }
    
    function whitelistcheck ( address _address )returns (bool){
        
       address whiteListContractAddress = ktccontract.whitelist();
       KTCWhitelist whitelistcontract = KTCWhitelist ( whiteListContractAddress );    
       return whitelistcontract.checkAddress ( _address );   
       
        
    }
    
}




contract BuyOffer is Offer  {
    
    constructor (  address _AssetContractAddress, address _OffererAddress , uint _numberofdays, uint _offeramount, uint _sharenumber, uint _offernumber, uint _currency  ) public{
        
        MasterKTCAddress masterktcaddress = MasterKTCAddress ( 0xd21c6686efde85c183d9638a73bb813d00d2dd65 );
        KTC_Address = masterktcaddress.getKTCAddress();
        ktccontract = KTC_Contract ( KTC_Address);
        
        AssetContractAddress = _AssetContractAddress;
        assetcontract = AssetContract( AssetContractAddress );
        
        OffererAddress = _OffererAddress;
        expires = now + ( _numberofdays * 1 days) ;
        offeramount = _offeramount;
        OfferActive = true;
        sharenumber = _sharenumber;
        offerNumber = _offernumber;
        currency = _currency;
        offertype = "Offer to Buy";
       
        
    }
    
   
    
    function tokenFallback ( address _address, uint _value, bytes _data  ) public payable {
       
       require ( offeramount == _value );
       require ( _address == OffererAddress);
       OfferFunded = true;
       emit BuyOfferFunded ( offerNumber,  _address,  _value );
       
    }
    
    function acceptOffer( uint _share, string _dochash ) public returns(bool) {
        
        requirements ( msg.sender );
       
        if ( sharenumber != 0 ) require ( _share == sharenumber );
        require (  assetcontract.memberShare( _share ) == msg.sender );
        
        cleanup();
        
        buyer = OffererAddress;
        seller = msg.sender;
           
        emit BuyOfferAccepted ( offerNumber,  msg.sender ,  offeramount );
        ktccontract.transfer( ktccontract.feecontract() , ktccontract.balanceOf(this), "0" ,"", 0 , msg.sender, 0 );
        assetcontract.updateMember( msg.sender, OffererAddress, _share,  offeramount, _dochash, offerNumber );
        return true;
    }
   
   
    
   
   
  
    
}




contract SellOffer is Offer {
    
    event SellOfferAccepted ( uint offernumber, address _seller,  uint _amount );
    

   constructor (  address _AssetContractAddress, address _OffererAddress , uint _numberofdays, uint _offeramount, uint _sharenumber, uint _offernumber, uint _currency ) public{
        
        MasterKTCAddress masterktcaddress = MasterKTCAddress ( 0x947b5bd2c425b7393e212bea75e733d02f4071f1 );
        KTC_Address = masterktcaddress.getKTCAddress();
        ktccontract = KTC_Contract ( KTC_Address);
        
        AssetContractAddress = _AssetContractAddress;
        assetcontract = AssetContract( AssetContractAddress );
        
        OffererAddress = _OffererAddress;
        expires = now + ( _numberofdays * 1 days) ;
        offeramount = _offeramount;
        OfferActive = true;
        sharenumber = _sharenumber;
        offerNumber = _offernumber;
        currency = _currency;
        offertype = "Offer to Sell";
        
    }
    
    
    function tokenFallback( address sender, uint _value, bytes _data, string  _stringdata, uint _numdata) payable{
        
       require( whitelistcheck ( sender ) == true );
       require ( _value >= offeramount );
       requirements ( sender );
       
       bool result = assetcontract.updateMember( OffererAddress , sender , sharenumber, offeramount, _stringdata, offerNumber );
       if ( result ) {
       
           ktccontract.transfer( ktccontract.feecontract() , offeramount, "0" ,"", 0 , OffererAddress, 0 );
           cleanup();
           buyer = sender;
           seller = OffererAddress;
           emit SellOfferAccepted ( offerNumber,  msg.sender ,  offeramount );
           
       }
       
       
    } 
    
  
   function escrow(){
        
        require ( msg.sender == buyer );
        ktccontract.transfer( msg.sender, ktccontract.balanceOf(address(this)) );
        
    }
    
    
}


contract MasterOfferContract   {
    
    
    event BuyOfferEvent ( address _buyer, uint share, uint amount );
    event SellOfferEvent ( address _buyer, uint share, uint amount );
    
    address KTC_Address;
    KTC_Contract ktccontract;
    
    modifier onlyMasterKTCAsset() {
        MasterKTCAssets masterktcassets = MasterKTCAssets ( ktccontract.masterassetcontract() );
        require( masterktcassets.isKTCAsset( msg.sender ) == true );
		_;
	}
    
    
    constructor ( ) public {
        
        MasterKTCAddress masterktcaddress = MasterKTCAddress (  );// Ass KTC Master Address Contract
        KTC_Address = masterktcaddress.getKTCAddress();
        ktccontract = KTC_Contract ( KTC_Address);
        
        
    }
    
    
    function BuyOfferContract ( address offerer, uint _numberofdays, uint _offeramount, uint _sharenumber, uint offers, uint currency )  onlyMasterKTCAsset returns ( address) {
                    
        BuyOffer buyoffer = new BuyOffer( msg.sender, offerer , _numberofdays,  _offeramount, _sharenumber, offers, currency );
        emit BuyOfferEvent ( msg.sender, _sharenumber, _offeramount );
        return buyoffer;
       
    } 
                        
    
    function SellOfferContract (  address _offerer, uint _numberofdays, uint  _offeramount, uint _sharenumber, uint _offers, uint currency ) onlyMasterKTCAsset returns ( address ){
        
      
           
        SellOffer selloffer = new SellOffer(  msg.sender, _offerer , _numberofdays,  _offeramount, _sharenumber, _offers, currency );
        emit SellOfferEvent ( msg.sender, _sharenumber, _offeramount );
        return selloffer;
         
    }
    
    
   
    
    
    
    
}

