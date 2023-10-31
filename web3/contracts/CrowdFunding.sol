// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    // this is like a object in js, but here we need to define the data type
    // address is a datatype in solidity. uint256 is a datatype in solidity. i.e for int
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    // we need mapping because in solidity we cannot use  Campaign[0] -> this is not possible. we need to create a map first
    // struct only defines the structure of the object. but we need to create a map to store the data.
    mapping(uint256 => Campaign) public Campaigns;

    // this is part of contract state. stored on blockchain
    uint256 public numberOfCampaigns = 0;

    /**
     * This function is public and it retuns an id of the campaign which is the integer value
     * _name is the common naming convention in solidity. _name is the parameter
     * the use of memory keyword is data will be stored in memory during the execution and it wont persists beyond function call.
     *  Solidity uses memory for function parameters to optimize gas usage when dealing with data that doesn't need to be stored on the blockchain's persistent storage (storage).
     *
     * In Solidity, you have two places to store data:
     * storage (which is more expensive and persistent) and
     * memory (which is temporary and cheaper).
     *
     * - Storage is persistent, so it's written to the blockchain and stays there forever.
     * - Stack is temporary, and it's cleared after the function finishes execution. used for smaller one coz stack size is limited
     */
    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        // we are grabbing reference to a specific campaign in the Campaigns array. after creating the new
        // campaign this number is incremented by 1
        Campaign storage campaign = Campaigns[numberOfCampaigns];
        // require is like if statement.
        // block.timestamp is the current time
        require(
            campaign.deadline < block.timestamp,
            "Deadline is in the past, it should be in the future"
        );
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.image = _image;
        campaign.amountCollected = 0;

        numberOfCampaigns++;
        // returning the last index of the campaign
        return numberOfCampaigns - 1;
    }

    function donateToCampaingn() {}

    function getDonators() {}

    function getCampaigns() {}
}
