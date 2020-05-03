pragma solidity ^0.6.6;


contract Lottery {
    address public manager;
    address payable[] public players;

    constructor() public {
        manager = msg.sender;
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    function enter() public payable {
        require(msg.value > 0.1 ether);

        players.push(msg.sender);
    }

    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(abi.encode(block.timestamp, block.difficulty, now))
            );
    }

    function pickWinner() public restricted {
        uint256 index = random() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0);
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }
}
