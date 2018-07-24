pragma solidity ^0.4.23;

contract KTC_Contract {
    
    
    function transfer(address _to, uint256 _value, bytes _data, string _stringdata, uint256 _numdata, address _forwardto, uint _numdata2 ) public returns(bool ok);
    function transfer(address _to, uint256 _value) returns(bool ok) ;
    function balanceOf(address _address ) returns(uint256) ;
    function lister() returns(address);
    function whitelist() returns(address);
    function crown() returns(address);
    function feecontract() returns(address);
    
    
}


contract KTCWhitelist {
    
    function checkAddress ( address _address ) public returns(bool);
    
}




contract BuyOffer {
    
    
    string public offertype = "Offer to Buy";
    address public AssetContractAddress;
    address public OffererAddress;
    uint public expires;
    uint public offeramount;
    uint public sharenumber;
    
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
    
    
    constructor ( address KTC, address _AssetContractAddress, address _OffererAddress , uint _numberofdays, uint _offeramount, uint _sharenumber, uint _offernumber ) public{
        
        KTC_Address = KTC;
        ktccontract = KTC_Contract ( KTC_Address);
        
        AssetContractAddress = _AssetContractAddress;
        assetcontract = AssetContract( AssetContractAddress );
        
        OffererAddress = _OffererAddress;
        expires = now + ( _numberofdays * 1 days) ;
        offeramount = _offeramount;
        OfferActive = true;
        sharenumber = _sharenumber;
        offerNumber = _offernumber;
        
       
        
    }
    
    function tokenFallback ( address _address, uint _value, bytes _data  ) public {
       
       require ( offeramount == _value );
       require ( _address == OffererAddress);
       OfferFunded = true;
       emit BuyOfferFunded ( offerNumber,  _address,  _value );
       
    }
    
    function acceptOffer( uint _share, string _dochash ) public returns(bool) {
        
        require ( now < expires );
        require ( OfferActive == true );
        require ( OffererAddress != msg.sender );
        
        
        if ( sharenumber != 0 ) require ( _share == sharenumber );
        
        
        //require (  assetcontract.isMember( msg.sender) );
        require (  assetcontract.memberShare( _share ) == msg.sender );
        
        OfferActive = false;
       
        emit BuyOfferAccepted ( offerNumber,  msg.sender ,  offeramount );
        
        
    
        ktccontract.transfer( ktccontract.feecontract() , ktccontract.balanceOf(this), "0" ,"", 0 , msg.sender, 0 );
        
        assetcontract.updateMember( msg.sender, OffererAddress, _share,  offeramount, _dochash, offerNumber );
        return true;
    }
   
    function cancelOffer() public onlyOfferer returns( bool ) {
       
       require ( OfferActive == true );
       OfferActive = false;
       ktccontract.transfer( msg.sender,  ktccontract.balanceOf(this) );
       return true;
       
    }
}




contract SellOffer  {
    
    
    string public offertype = "Offer to Sell";
    address public AssetContractAddress;
    address public OffererAddress;
    uint public expires;
    uint public offeramount;
    uint public sharenumber;
    
    address public KTC_Address;
    KTC_Contract public ktccontract;
    
    
    AssetContract public assetcontract;
    
    bool public OfferActive;
    uint public offerNumber;
    
    
    modifier onlyOfferer() {
		require( msg.sender == OffererAddress );
		_;
	}
	
		
	
    event SellOfferAccepted ( uint offernumber, address _seller,  uint _amount );
    event CancelOffer ( uint offernumber, address _seller,  uint _amount );
    
	

    
    
    constructor ( address KTC, address _AssetContractAddress, address _OffererAddress , uint _numberofdays, uint _offeramount, uint _sharenumber, uint _offernumber ) public{
        
        KTC_Address = KTC;
        ktccontract = KTC_Contract ( KTC_Address);
        
        AssetContractAddress = _AssetContractAddress;
        assetcontract = AssetContract( AssetContractAddress );
        
        OffererAddress = _OffererAddress;
        expires = now + ( _numberofdays * 1 days) ;
        offeramount = _offeramount;
        OfferActive = true;
        sharenumber = _sharenumber;
        offerNumber = _offernumber;
        
    }
    
    
     function tokenFallback( address sender, uint _value, bytes _data, string  _stringdata, uint _numdata){
        
       require ( _value == offeramount );
       require ( OfferActive == true );
       require ( now < expires );
       require ( OffererAddress != sender );
       
       bool result = assetcontract.updateMember( OffererAddress , sender , sharenumber, offeramount, _stringdata, offerNumber );
       
       
       if ( result ) {
       
          
           ktccontract.transfer( ktccontract.feecontract() , offeramount, "0" ,"", 0 , OffererAddress, 0 );
         
           OfferActive = false;
          
           emit SellOfferAccepted ( offerNumber,  msg.sender ,  offeramount );
           
       }
       
    } 
   

    function cancelOffer() public onlyOfferer returns( bool ) {
       
       require ( OfferActive == true );
       OfferActive = false;
     
       emit CancelOffer ( offerNumber,  msg.sender ,  offeramount );
       return true;
        
    }
    
    
}


/*

contract Bookings {
    
    
    mapping ( uint => address ) public allBookings;  
    mapping ( uint => uint )    public bookingReference;
    
    uint public totalbookings;
    address[] public bookingsAddress;
    
    
}
*/

contract Offerable {
    
    
    mapping ( address => bool ) public allOffers;   
    
    event AssetTrade( address _buyer, address _seller, uint _price, string _dochash, uint _offernumber );
    
    uint public offers;
    address[] public offerAddresses;
    
    
    struct transaction  {
        
        address buyer;
        address seller;
        uint price;
        string dochash;
        
        uint offernumber;
        
    }
    
    
    transaction[] public transactions;
    
    
    
    function createTransaction ( address _buyer, address _seller, uint _price, string _dochash, uint _offernumber ) internal {
        
        transactions.push (  transaction( _buyer, _seller, _price, _dochash,  _offernumber )  );
        emit AssetTrade( _buyer, _seller, _price, _dochash,  _offernumber );
        
    }
    
}


//contract AssetContract is Bookings, Offerable, WhiteListChecker  {

contract AssetContract  is  Offerable  {
    
    address public KTC_Address;
    KTC_Contract public ktccontract;
    address[] public members;
    string public AssetType;
    uint public AssetNumber;
    
    address public whiteListContractAddress;
    KTCWhitelist public whitelistcontract;
    
    address public KTCAssetsAddress;
    KTCAssets public ktcassets;
    
    uint[] paymentRef;
      
    
    event BuyOfferEvent ( address _buyer, uint share, uint amount );
    event SellOfferEvent ( address _buyer, uint share, uint amount );

    
    
    modifier onlyOffers() {
		require( allOffers[msg.sender] == true );
		_;
	}
	
	modifier onlyKTC() {
		require(  msg.sender == KTC_Address );
		_;
	}
    
    constructor ( string _assettype, address KTC, uint _assetnumber, address _ktcassets ) public {
        
        AssetType = _assettype;
        AssetNumber = _assetnumber;
        KTC_Address = KTC;
        ktccontract = KTC_Contract ( KTC_Address);
        whiteListContractAddress = ktccontract.whitelist();
        whitelistcontract = KTCWhitelist ( whiteListContractAddress );
        
        KTCAssetsAddress = _ktcassets;
        ktcassets = KTCAssets ( KTCAssetsAddress );
        offers = 0;
        paymentRef.push(0); 
        members.push( 0 );
        for ( uint i = 0; i < 14; i++ ){
           members.push( ktccontract.lister() );
        }
        
        offerAddresses.push(0x0);
        transactions.push (  transaction( 0x0, 0x0, 0, "", 0 )  );
        
    }
    
    function tokenFallback ( address _address, uint _value, bytes _data, string _stringdata, uint256 _numdata ) onlyKTC{
        
        require ( _numdata != 0x0 );
        paymentRef.push(_numdata);  
        
        
        
        uint share = _value/13;
        for ( uint i = 0; i < 13; i++ ){
           
           ktccontract.transfer( members[i] , share);
           
        }
        
    }
    
    function paymentRefLength() returns (uint) {
        
        return paymentRef.length;
    }
   
   
   
   
   function isMember( address _address) constant public returns(bool) {
       
        for ( uint i = 0; i < 13; i++ ){
           if( members[i] == _address ) return true;
        }
       return false;
       
   }
   
   function memberShare( uint _share ) constant public returns (address) {
       
          return members[_share];
       
   }

 
    //Share Number is Optional if they only want a specific share
    function Buy_Offer ( uint _offeramount, uint _numberofdays, uint _sharenumber ) returns ( address) {
        
        require ( members [_sharenumber ] != msg.sender );
        require ( whitelistcontract.checkAddress ( msg.sender ) );
        offers++;
        
      
        BuyOffer buyoffer = new BuyOffer( KTC_Address, address(this), msg.sender , _numberofdays,  _offeramount, _sharenumber, offers );
        allOffers[ buyoffer ] = true;
        offerAddresses.push(buyoffer);
        emit BuyOfferEvent ( msg.sender, _sharenumber, _offeramount );
        return buyoffer;
       
        
    }  
    
    
    function Sell_Offer ( uint _offeramount, uint _numberofdays, uint _sharenumber ) returns ( address ){
        
        require ( memberShare ( _sharenumber ) == msg.sender );
        offers++;
  
        SellOffer selloffer = new SellOffer( KTC_Address, address(this), msg.sender , _numberofdays,  _offeramount, _sharenumber, offers );
        allOffers[ selloffer ] = true;
        offerAddresses.push(selloffer);
        emit SellOfferEvent ( msg.sender, _sharenumber, _offeramount );
        return selloffer;
         
        
    }
    
    
    function updateMember( address _oldmember, address _newmember, uint _numbershare, uint _price, string _dochash, uint _offernumber )  onlyOffers returns(bool) {
        
        require ( whitelistcontract.checkAddress ( _newmember ) == true );
        require ( members[_numbershare] == _oldmember );
        createTransaction ( _newmember, _oldmember,  _price,  _dochash ,  _offernumber );
        
        members[_numbershare] = _newmember;
        ktcassets.addTrade ( _newmember, _oldmember, _price, _offernumber );
        return true;
        
    }
    
    
    
    
}


contract MasterKTCAssets{
    
    
    mapping ( address => bool ) public assets;
    uint public numberofassets;
    address[] public assetaddresses;
    
    address public KTC_Address;
    KTC_Contract public ktccontract;
    address public manager;
    
    
    
    
    
    
     struct transaction  {
        
        address assetaddress;
        address buyer;
        address seller;
        uint KTC;
        uint assetoffernumber;
        
    }
    
    transaction[] public transactions;
    
     
    
    string [] public AssetType;
    
    
    event AssetTrade ( address indexed AssetContract, address indexed Buyer, address indexed Seller, uint KTC, uint AssetOfferNumber );
    
    
    
    modifier onlyCrown() {
		require( msg.sender == ktccontract.crown() );
		_;
	}
	
	modifier onlyKTCAsset(){
		require( assets[msg.sender] == true );
		_;
	}
	
	modifier onlyManager(){
		require( msg.sender == manager );
		_;
	}
	
	
	
    
    
    constructor(){
        
        KTC_Address = ; // Add KTC Master Address Contract
        ktccontract = KTC_Contract ( KTC_Address);
        AssetType.push("RealEstate");
        AssetType.push("Aircraft");
        AssetType.push("Vessel");
        
        assetaddresses.push( 0x0 );
        transactions.push( transaction(0x0 , 0x0, 0x0, 0, 0 ));
        
        manager = msg.sender;
               
       
        
    }
    

    function DeployAsset( string assettype ) onlyManager{
        
        require( ktccontract.lister() != 0);
        require( isValidAssetType( assettype ) == true );
        numberofassets++;
        AssetContract assetcontract = new AssetContract( assettype, KTC_Address, numberofassets, address(this) );
        assets[assetcontract] = true;
        assetaddresses.push( assetcontract );
       

   
    }
    
    function isValidAssetType( string _string ) constant public returns(bool){
        
        uint arrayLength = AssetType.length;
        for ( uint i; i<arrayLength; i++ ){
            if( keccak256(AssetType[i]) == keccak256( _string ) ){ return true;}
        }
        return false;
        
    }
    
    function addTrade ( address Buyer, address Seller, uint _KTC, uint assetoffernumber ) onlyKTCAsset {
        
        transactions.push( transaction( msg.sender, Buyer, Seller, _KTC, assetoffernumber ) );
        emit AssetTrade ( msg.sender, Buyer, Seller, _KTC, assetoffernumber );
        
        
        
    }
    
    function updateKTCAddress ( address _address ) onlyCrown {
        
         KTC_Address = _address;
        
    }
    
    
     function updateManager ( address _address ) onlyManager {
        
         manager = _address;
        
    }
   
    
    function getTransaction ( uint _num ) constant returns ( address assetaddress , address buyer, address seller, uint KTC, uint assetoffernumber ) {
        
         return ( transactions[_num].assetaddress , transactions[_num].buyer, transactions[_num].seller, transactions[_num].KTC, transactions[_num].assetoffernumber);
        
        
    }
    
    
}
