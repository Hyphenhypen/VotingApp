// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        uint256 id;
        string name;
        uint256 numberOfVotes;
    }

    Candidate[] public candidates;
    address public owner;
    mapping(address => bool) public voters;

    address[] public listOfVoters;
    uint256 public votingStart;
    uint256 public votingEnd;

    bool public electionStarted;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not authorized");
        _;
    }

    // check if election is on going
    modifier electionOngoing(){
        require(electionStarted, "No election started");
        _;
    }

    // create a constructor
    constructor(){
        owner = msg.sender;
    }

    // to start an election
    function startElection(string[] memory _candidates, uint256 _votingDuration) public onlyOwner{
        require(electionStarted == false, "election is currently ongoing");
        delete candidates;
        resetAllVoterStatus();

        for(uint256 i=0; i< _candidates.length; i++){
            candidates.push(
                Candidate({
                    id: 1,
                    name: _candidates[i],
                    numberOfVotes: 0
                })
            );
        }
        electionStarted = true;
        votingStart = block.timestamp;
        votingEnd = block.timestamp + (_votingDuration * 1 minutes);
    }

    // to add a new candidate
    function addCandidate(string memory _name) public onlyOwner electionOngoing{
        candidates.push(
            Candidate({id: candidates.length, name: _name, numberOfVotes: 0})
        );
    }

    // check voters status
    function voterStatus(address _voter) public view electionOngoing returns (bool) {
        if(voters[_voter] == true){
            return true;
        }
        return false;
    }

    // to vote function
    function voteTo(uint256 _id) public electionOngoing{
        require(checkElectionPeriod(), "Election period has ended");
        require(
            !voterStatus(msg.sender),
            "You already voted. You can only vote once."
        );
        candidates[_id].numberOfVotes++;
        voters[msg.sender] = true;
        listOfVoters.push(msg.sender);
    }

    // get the number of votes
    function retrieveVotes() public view returns (Candidate[] memory){
        return candidates;
    }

    // monitor the election time
    function electionTimer() public view electionOngoing returns (uint256){
        if(block.timestamp >= votingEnd){
            return 0;
        }
        return (votingEnd - block.timestamp);
    }

    // check is election period is still ongoing
    function checkElectionPeriod() public returns (bool) {
        if(electionTimer() > 0){
            return true;
        }
        electionStarted = false;
        return false;
    }
    

    // function to reset all the voters status
    function resetAllVoterStatus() public onlyOwner{
        for(uint256 i=0; i<listOfVoters.length; i++){
            voters[listOfVoters[i]] = false;
        }
        delete listOfVoters;
    }
}