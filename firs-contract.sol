pragma solidity ^0.6.6;


contract Inbox {
    string public message;

    // No need of any function to get or read the values for variables, if they are public it will be automatically formed

    constructor(string memory initialMessage) public {
        message = initialMessage;
    }

    function setMessage(string memory newMessage) public {
        message = newMessage;
    }
}
