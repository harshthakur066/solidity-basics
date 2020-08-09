pragma solidity ^0.6.6;

contract Vidco {
    address payable public doctor;
    address payable public patient;
    bool public paid;
    bool public firstPayment;

    constructor() public {
        paid = false;
        firstPayment = false;
    }

    function pay(address payable docId) public payable {
        patient = msg.sender;
        doctor = docId;
        require(msg.value > 0.0010 ether);
        paid = true;
        firstPayment = true;
    }
    
    function addOn() public payable {
        require(firstPayment == true);
        require(msg.value > 0.0010 ether);
    }

    function recieve(uint256 fees) public {
        require(firstPayment == true);
        doctor.transfer(fees);
        paid = false;
        patient.transfer(address(this).balance);
    }
}
