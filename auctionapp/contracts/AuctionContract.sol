// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract Auction{

    address payable public Owner;

    uint startTime;
    uint endTime;

    enum AucStatus{
        NOT_STARTED,
        STARTED,
        ENDED
    }

    AucStatus public status;

    constructor ()  { 
        Owner = payable (msg.sender);
        status = AucStatus.STARTED;
        startTime = block.number;
        endTime = startTime + 1030;
    }

    uint public highestBid;
    address public highestBidder;
    mapping(address => uint) public allBids;

    mapping(address => uint) public participationFee;

    modifier onlyOwner(){
        require(msg.sender == Owner, "Only owner is allowed");
        _;
    }

    modifier restrictions(){
        require (msg.sender != Owner, "Owner cannot bid");
        require(endTime > block.number, "Auction has been ended");
        require(participationFee[msg.sender] > 0, "You have not deposited your participation fee");
        _;
    }

    function get() public view returns(AucStatus){
        return status;
    }

    function depositFee(uint fee) public payable {
        if(endTime > block.number){
            status = AucStatus.ENDED;
        }
        require(endTime > block.number, "Auction has been ended");
        require(fee == 10 ether, "Please pay 10 ether deposit fee");
        participationFee[msg.sender] = fee;
        bool sent = Owner.send(msg.value);
        require(sent, "Fee not sent");
    }

    function bid(uint amount) public restrictions {
        allBids[msg.sender] = amount;
        if(amount > highestBid){
            highestBid = amount;
            highestBidder = msg.sender;
        }
    }

    function getBalance() public view returns(uint){
        return Owner.balance;
    }

}