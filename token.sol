Token.sol new token solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Voting {
    // Chairperson of the voting
    address public chairperson;

    // A struct to hold voter information
    struct Voter {
        bool hasVoted; // True if the person has already voted
        uint vote;     // Index of the voted proposal
        uint weight;   // Weight of the vote
}

    // A struct to hold proposal information
    struct Proposal {
        string name;   // Name of the proposal
        uint voteCount; // Number of accumulated votes
    }

    // Mapping to store voter details
    mapping(address => Voter) public voters;

    // Array to store proposals
    Proposal[] public proposals;
// Function to give the right to vote to a voter
    function giveRightToVote(address voter) public {
        require(msg.sender == chairperson, "Only the chairperson can give the right to vote.");
        require(!voters[voter].hasVoted, "The voter has already voted.");
        require(voters[voter].weight == 0, "The voter already has the right to vote.");

        voters[voter].weight = 1;
    }

    // Function to vote for a proposal
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight > 0, "You have no right to vote.");
        require(!sender.hasVoted, "You have already voted.");

        sender.hasVoted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }// Function to get the winning proposal
    function winningProposal() public view returns (uint winningProposalIndex) {
        uint winningVoteCount = 0;

        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposalIndex = i;
            }
        }
    }

    // Function to get the winner's name
    function winnerName() public view returns (string memory winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }
}
