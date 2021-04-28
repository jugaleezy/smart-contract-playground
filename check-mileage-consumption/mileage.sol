pragma solidity >=0.7.0 <0.9.0;

import "./SafeMath.sol";

contract CheckMileage {
    using SafeMath for uint256;
    
    // address of contract owner
    address private owner;
    
    // create a user-defined type
    struct FlightDetails {
        address userAddr;
        string username;
        string flightName;
        uint tMileage;
        uint tPrice;
        bool discount;
    }
    
    // register user with userID and address ex. (LKD101R => 0x...)
    mapping(string => address) users;
    
    // register user flight details
    mapping(string => FlightDetails) userDetails;
    
    // emits an event when user reaches specific criteria
    event discount(string _userID, string _text);
    
    // check if owner
    modifier isOwner() {
        require(msg.sender == owner, 'Caller is not owner!');
        _;
    }
    
    //check caller address match user address
    modifier isUser(string memory _id) {
        require(msg.sender == users[_id], 'Caller address does not match!');
        _;
    }
    
    // constructor defining owner of contract
    constructor() {
        owner = msg.sender;
    }
    
    
    // function to register user
    function addUser(string memory _userID) public {
        users[_userID] = msg.sender;
    }
    
    // function to add user total mileage and total price
    function addMileage(string memory _userID, string memory _name, string memory _flightName, uint _mileage, uint _price) 
        public 
        isUser(_userID) 
        {
        FlightDetails storage fd = userDetails[_userID];
        fd.userAddr = msg.sender;
        fd.username = _name;
        fd.flightName = _flightName;
        uint percent = (_price*10)/100;
        ( ,uint total) = _mileage.tryAdd(percent);
        (bool val, uint sum) = fd.tMileage.tryAdd(total);
        if (val == true) {
            fd.tMileage = sum;
        }
        else {
            fd.tMileage = 0;
        }
        
        (bool val1, uint sumPrice) = fd.tPrice.tryAdd(_price);
        if (val1 == true) {
            fd.tPrice = sumPrice;
        }
        else {
            fd.tPrice = 0;
        }
        
        if (fd.tMileage >= 10000 && fd.tPrice >= 20000) {
            fd.discount = true;
            emit discount(_userID, 'Discount: 40% on emirates and 30% in etihad airline');
        }
        else {
            fd.discount = false;
        }
    }
    
    // function to get user mileage and price details
    function getUserDetails(string memory _userID) 
    public 
    view 
    isUser(_userID)
    returns (string memory, string memory, uint, uint, bool) 
    
    {
        FlightDetails storage fd = userDetails[_userID];
        return (fd.username, fd.flightName, fd.tMileage, fd.tPrice, fd.discount);
    }
    
    // function to check discount on ticket after user reached mileage and price criteria
    function checkDiscountPrice(string memory _userID, string memory _airline, uint _price) 
    public 
    view isUser(_userID) 
    returns (uint)
    {
        FlightDetails storage fd = userDetails[_userID];
        uint discountedPrice;
        if (fd.discount == true) {
            if (keccak256(abi.encodePacked(_airline)) == keccak256(abi.encodePacked("emirates"))) {
                discountedPrice = (_price*60)/100;
                return discountedPrice;
            }
            else if (keccak256(abi.encodePacked(_airline)) == keccak256(abi.encodePacked('etihad'))) {
                discountedPrice = (_price*70)/100;
                return discountedPrice;
            }
            else {
                return _price;
            }
        }
        else {
            return _price;
        }
        
    }
    
    // shows contract owner
    function getOwner() public view returns (address) {
        return owner;
    }
    
}
