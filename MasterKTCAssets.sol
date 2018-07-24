pragma solidity ^0.4.23;

contract MasterKTCAddress {
     function getKTCAddress() returns(address);
}


contract FeeContract  {
    
    function buyerofferfee()  returns  ( uint) ;
    function sellerofferfee() returns ( uint );
    
}
contract KTC_Contract {
    
    
    function transfer(address _to, uint256 _value, bytes _data, string _stringdata, uint256 _numdata, address _forwardto, uint _numdata2 ) public returns(bool ok);
    function transfer(address _to, uint256 _value) returns(bool ok) ;
    function balanceOf(address _address ) returns(uint256) ;
    function lister() returns(address);
    function whitelist() returns(address);
    function crown() returns(address);
    function feecontract() returns(address);
    function masteroffercontract() returns (address);
    function bookingcontrollercontract() returns (address);
    
    
}


contract KTCWhitelist {
    
    function checkAddress ( address _address ) public returns(bool);
    
}


contract MasterOfferContract{
    
    function BuyOfferContract (  address _buyer , uint  _numberofdays, uint  _offeramount, uint  _sharenumber, uint offers, uint currency )returns(address);
    function SellOfferContract(   address _buyer , uint  _numberofdays, uint  _offeramount, uint  _sharenumber, uint offers, uint currency )returns(address);
}


contract OfferContract{
    
    function isExpired()returns(bool);
    
    
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
    
    address[13] public assetlistings;
    
    
    
    
    struct transaction  {
        
        address buyer;
        address seller;
        uint price;
        string dochash;
        uint offernumber;
        address tradecontract;
        
    }
    
    
    transaction[] public transactions;
    
    
    
    function createTransaction ( address _buyer, address _seller, uint _price, string _dochash, uint _offernumber, address _tradecontract ) internal {
        
        transactions.push (  transaction( _buyer, _seller, _price, _dochash,  _offernumber , _tradecontract)  );
        emit AssetTrade( _buyer, _seller, _price, _dochash,  _offernumber );
        
    }
    
}


//contract AssetContract is Bookings, Offerable, WhiteListChecker  {

contract AssetContract  is  Offerable  {
    
    address public KTC_Address;
    KTC_Contract public ktccontract;
    address[]  members;
    string public AssetType;
    uint public AssetNumber;
    
    address public whiteListContractAddress;
    KTCWhitelist public whitelistcontract;
    
    address public KTCAssetsAddress;
    MasterKTCAssets public ktcassets;
    
    mapping ( uint => uint ) public payments;
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
        ktcassets = MasterKTCAssets ( KTCAssetsAddress );
        offers = 0;
        paymentRef.push(0); 
        members.push( 0 );
        for ( uint i = 0; i < 14; i++ ){
           members.push( ktccontract.lister() );
        }
        
        offerAddresses.push(0x0);
        transactions.push (  transaction( 0x0, 0x0, 0, "", 0, 0x0 )  );
        
    }
    
    function tokenFallback ( address _address, uint _value, bytes _data, string _stringdata, uint256 _numdata ) onlyKTC{
        
        require ( _numdata != 0x0 );
        require ( _address == ktccontract.bookingcontrollercontract()); 
        paymentRef.push(_numdata);  
        payments[_numdata] = _value;
        
        
        
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
    function Buy_Offer ( uint _offeramount, uint _numberofdays, uint _sharenumber, uint currency ) payable returns ( address) {
        
        
        FeeContract feecontract = FeeContract( ktccontract.feecontract() );
        require ( msg.value >= feecontract.buyerofferfee() );
        
        require ( members [_sharenumber ] != msg.sender );
        require ( whitelistcontract.checkAddress ( msg.sender ) );
        
        offers++;
        MasterOfferContract buyoffer = MasterOfferContract (ktccontract.masteroffercontract());
        address offeraddress = buyoffer.BuyOfferContract(  msg.sender , _numberofdays,  _offeramount, _sharenumber, offers, currency );
        allOffers[ offeraddress ] = true;
        offerAddresses.push(offeraddress);
        
        if ( msg.value > 0 ) ktccontract.feecontract().transfer ( msg.value );
        
        emit BuyOfferEvent ( msg.sender, _sharenumber, _offeramount );
        return buyoffer;
       
        
    }  
    
    
    function Sell_Offer ( uint _offeramount, uint _numberofdays, uint _sharenumber, uint currency ) payable returns ( address ){
        
    
        FeeContract feecontract = FeeContract( ktccontract.feecontract() );
        require ( msg.value >= feecontract.sellerofferfee() );
        
        require ( memberShare ( _sharenumber ) == msg.sender );
        if ( assetlistings[ _sharenumber ] != 0 ) removeExpiredListing( assetlistings[ _sharenumber ] , _sharenumber );
        require ( assetlistings[ _sharenumber ] == 0 );
        
        offers++;
        MasterOfferContract selloffer = MasterOfferContract (ktccontract.masteroffercontract());  
        address offeraddress = selloffer.SellOfferContract(   msg.sender , _numberofdays,  _offeramount, _sharenumber, offers, currency );
        allOffers[ offeraddress ] = true;
        offerAddresses.push(offeraddress);
        assetlistings[ _sharenumber ] = offeraddress; 
        
        if ( msg.value > 0 )ktccontract.feecontract().transfer ( msg.value );
        
        emit SellOfferEvent ( msg.sender, _sharenumber, _offeramount );
        return selloffer;
         
        
    }
    
    function removeListing( uint _sharenumber )   {
        
        require ( msg.sender == assetlistings[ _sharenumber ] );
        assetlistings[ _sharenumber ] = 0;
        
    }
    
    function removeExpiredListing( address _address, uint _sharenumber ) internal {
        
        OfferContract offercontract = OfferContract ( _address );
        if ( offercontract.isExpired() ) assetlistings[ _sharenumber ] = 0;
        
    }
    
  
    
    
    function updateMember( address _oldmember, address _newmember, uint _numbershare, uint _price, string _dochash, uint _offernumber )  onlyOffers returns(bool) {
        
        require ( whitelistcontract.checkAddress ( _newmember ) == true );
        require ( members[_numbershare] == _oldmember );
        createTransaction ( _newmember, _oldmember,  _price,  _dochash ,  _offernumber, msg.sender );
        
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
        
        MasterKTCAddress masterktcaddress = MasterKTCAddress ( 0x947b5bd2c425b7393e212bea75e733d02f4071f1 );
        KTC_Address = masterktcaddress.getKTCAddress();
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
    
    function isKTCAsset( address _address ) returns (bool) {
        
        return assets[ _address ];
        
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
