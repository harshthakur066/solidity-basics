pragma solidity ^0.6.6;


contract CampaignFactory {
    Campaign[] public deployedCampagins;

    function createCampagin(uint256 minimun) public {
        Campaign newCampaign = new Campaign(minimun, msg.sender);
        deployedCampagins.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns (Campaign[] memory) {
        return deployedCampagins;
    }
}


contract Campaign {
    struct Request {
        string description;
        uint256 value;
        address payable recipient;
        bool complete;
        mapping(address => bool) approvals;
        uint256 approvalsCount;
    }

    Request[] public request;
    address public manager;
    uint256 public minimumContribution;
    mapping(address => bool) public approvers;
    uint256 approversCount;

    modifier restricted() {
        require(msg.sender == manager, "Sender not authorized.");
        _;
    }

    constructor(uint256 minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }

    function contribute() public payable {
        require(
            msg.value > minimumContribution,
            "Value is less than minimu contribution"
        );
        approversCount++;

        approvers[msg.sender] = true;
    }

    function createRequest(
        string memory description,
        uint256 value,
        address payable recipient
    ) public restricted {
        Request memory newRequest = Request({
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalsCount: 0
        });

        request.push(newRequest);
    }

    function approveRequest(uint256 index) public {
        Request storage req = request[index];

        require(approvers[msg.sender], "Sender not authorized.");
        require(!req.approvals[msg.sender], "Sender not authorized.");

        req.approvals[msg.sender] = true;
        req.approvalsCount++;
    }

    function finalRequest(uint256 index) public restricted {
        Request storage req = request[index];

        require(
            req.approvalsCount > (approversCount / 2),
            "total yes vote should be more than 50% of totlal contributors "
        );
        require(!req.complete, "should be completed as true");

        req.recipient.transfer(req.value);
        req.complete = true;
    }
}
