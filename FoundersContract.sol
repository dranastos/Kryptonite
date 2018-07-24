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

contract founder{
    
      struct founder {
        address founder;
        uint shares;
    }
   
    founder[] public founders;
    
     function countFounders () constant returns ( uint ) {
       uint count;
       for(uint i = 0; i< founders.length; i++ ){
           if (  founders[i].shares > 0 ) count++;
       }
       return count;
   }
   
   function closeFounderGap() internal {
       
       for(uint i = 1; i < founders.length; i++ ){
           if (  founders[i].shares == 0 ) {
               
               
              
               founders[i].founder = founders[founders.length -1  ].founder; 
               founders[i].shares  = founders[founders.length -1 ].shares; 
               founders[founders.length -1 ].founder = 0; 
               founders[founders.length -1 ].shares = 0; 
               
               
           
              
           }
        }
   }
   
      function founderExists( address _address ) constant returns ( uint ){
       
       for(uint i = 0; i< founders.length; i++ ){
           if ( _address == founders[i].founder ) return i;
       }
       return 0;
   }
 
   function founderShares( address _address ) constant returns ( uint ){
       
       uint exists = founderExists( _address );
       if ( exists >0 ) return founders[exists].shares;
      
       return 0;
   }
   
   
    
    
}

contract FoundersContract  is founder {
    
    using SafeMath for uint;
    
    
    
    address public KTC_Address;
    KTC_Contract ktccontract;
    address public owner;
    uint public shares;
  
  
   
    modifier onlyCrown {
		require( msg.sender == ktccontract.crown() );
		_;
	}
    
    function FoundersContract(){
        
        owner = msg.sender;
        MasterKTCAddress masterktcaddress = MasterKTCAddress ( 0x947b5bd2c425b7393e212bea75e733d02f4071f1 );
        KTC_Address = masterktcaddress.getKTCAddress();
        ktccontract = KTC_Contract ( KTC_Address);
        shares = 10000000;
        founders.push( founder( 0x0,0 ) );
        
         founders.push(founder ( 0x5d2799BcA28f1DbA513914b0f928644f9dA1C247, 3000000));
         founders.push(founder ( 0x79613aBC09134C67a074bE01D5558C5f75F88931, 3000000));
         founders.push(founder ( 0x0F514716Edd2e04DbE0F1C775bc821dcc38180c5, 1333333));
         founders.push(founder ( 0x5d68ab781c3e2c2ccec56a41fbaafc4f1d0cdc15, 1333333));
         founders.push(founder ( 0x0Ef453054ed0D58213d4ebb14289FCec8FCe6969, 1333333));
         shares = 1;
        
    }
   
   function addFounder( address _founder, uint _shares ) onlyCrown{
       
       require ( shares > 0 );
       require( founderExists( _founder ) == 0 );
       shares = shares.sub( _shares );
       founders.push( founder ( _founder, _shares ) );
       
   }
   
   function transferShares ( address _newshareowner, uint _shares ){
       
       uint exists = founderExists( _newshareowner );
       uint transferer = founderExists( msg.sender );
       require ( transferer != 0 );
       founders[transferer].shares = founders[exists].shares.sub( _shares );        
       if ( exists != 0 ){
            founders[exists].shares = founders[exists].shares.add( _shares );
            if ( founders[transferer].shares == 0 ){
                 founders[transferer].founder = 0;
            }
           
        } else {
           
                if ( founders[transferer].shares == 0 ){
                     founders[transferer].founder = _newshareowner;
                     founders[transferer].shares = _shares;
       
                }else{
                    
                    founders.push( founder ( _newshareowner, _shares ) );
                }    
       }
       
        closeFounderGap();
   }
   

  
    
}
