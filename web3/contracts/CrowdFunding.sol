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
    // creating an array of objects- object that follows a structure of Campaign
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
        // we are creating the new campaign. grabbing reference to a specific campaign in the Campaigns array. after creating the new
        // campaign this number is incremented by 1.
        // struct will act as a datatype. infact it is a composable datatype. so we are using Campaign as a datatype here.
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

    // this function is used to create a donation. it accepts the campaign id
    // payable keyword denotes that it can accept ether
    function donateToCampaingn(uint256 _id) public payable {
        // value we will be sending from frontend.
        uint256 amount = msg.value;

        // grabbing the specific campaign which we want to donate to
        Campaign storage campaign = Campaigns[_id];

        // pushing the address to donators array
        campaign.donators.push(msg.sender);

        // pushing the amount to donations array
        campaign.donations.push(amount);

        // this will transfer the ethers to the campaign owner. , is a placholder. this returns a bool value
        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountCollected += amount;
        }
    }

    // tihs funcrion takes in capaign id and returns the donators and donations. second one is- string array
    function getDonators(
        uint256 _id
    ) public view returns (address[] memory, uint256[] memory) {
        // Campaign storage campaign = Campaigns[_id];
        return (Campaigns[_id].donators, Campaigns[_id].donations);
    }

    /**
     * This function returns all the campaigns
     */
    function getCampaigns() public view returns (Campaign[] memory) {
        // creating an empty array of type Campaign
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns); // [{}, {}, {}]

        for (uint256 i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = Campaigns[i];
            allCampaigns[i] = item; // just polpulatong the array
        }
        return allCampaigns;
    }
}
