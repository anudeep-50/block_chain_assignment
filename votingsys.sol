// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {

    // Define candidate structure
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // Store candidates by their ID
    mapping(uint => Candidate) public candidates;
    // Store the address of voters
    mapping(address => bool) public voters;
    
    uint public candidatesCount;
    uint public totalVotes;
    
    address public owner;
    bool public votingEnded;

    event votedEvent(uint indexed _candidateId);

    // Modifier to ensure only the owner can call certain functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can execute this.");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender], "You have already voted.");
        _;
    }

    modifier votingOpen() {
        require(!votingEnded, "Voting has ended.");
        _;
    }

    constructor() {
        owner = msg.sender; // Set the contract creator as the owner
        candidatesCount = 0;
        totalVotes = 0;
        votingEnded = false;
    }

    // Function to add a candidate to the voting list
    function addCandidate(string memory _name) public onlyOwner {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    // Function to vote for a candidate
    function vote(uint _candidateId) public hasNotVoted votingOpen {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate.");

        // Mark the sender as having voted
        voters[msg.sender] = true;

        // Update vote count for the chosen candidate
        candidates[_candidateId].voteCount++;
        totalVotes++;

        emit votedEvent(_candidateId);
    }

    // Function to end the voting
    function endVoting() public onlyOwner {
        require(!votingEnded, "Voting has already ended.");
        votingEnded = true;
    }

    // Function to get the winner's candidate ID
    function getWinner() public view returns (uint winningCandidateId) {
        uint winningVoteCount = 0;
        for (uint i = 1; i <= candidatesCount; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winningCandidateId = i;
            }
        }
    }

    // Function to get the name of the winner
    function getWinnerName() public view returns (string memory) {
        uint winningCandidateId = getWinner();
        return candidates[winningCandidateId].name;
    }

    // Function to get the total votes for a candidate
    function getCandidateVotes(uint _candidateId) public view returns (uint) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate.");
        return candidates[_candidateId].voteCount;
    }
}
