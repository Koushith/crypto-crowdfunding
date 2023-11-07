import { useAddress, useContract, useMetamask, useContractWrite } from '@thirdweb-dev/react';

import React, { useContext, createContext } from 'react';

import { ethers } from 'ethers';

const StateContext = createContext()


export const StateContextProvider = ({ children }) => {

  // connecting to deployed contract address- getting which contract?
   const { contract } = useContract("0x385e14781b7165Ef29546EC49967ca14671A7f50");
  console.log("what is contract?-", contract)

  // This will return the currently connected wallet address
  const address = useAddress()
  console.log("which address- useAddr", address)

  // used for metamask popup
  const connect = useMetamask()

  // Generic hook for calling any smart contract function that requires a transaction to take place.
  const { mutateAsync: createCampaign, isLoading } = useContractWrite(contract, "createCampaign")

  // function that writes to Blockchain. write operation
  const publishCampaign = async (form) => {
    try {
      // this is called according to contract
      const data = await createCampaign({
        args: [
          address, // currently connected owner address
          form.title,
          form.description,
          form.target,
          new Date(form.deadline).getTime(), // deadline
          form.image
        ]
      })

      console.log("contract call success----", data)

    } catch (error) {
      console.log("Something went wrong. couldnt write to the blockchain")
    }

  }


  // getAllCampaigns from chain. read operation.
  // refer docs, either you can use contract.call or hooks
  const getCampaigns = async () => {

    const campaigns = await contract.call("getCampaigns")
    console.log("all campaigns", campaigns)

    const parsedCampaings = campaigns.map((campaign, i) => ({
      owner: campaign.owner,
      title: campaign.title,
      description: campaign.description,
      target: ethers.utils.formatEther(campaign.target.toString()), // util dunc. it will be in fractions hard to format it.
      deadline: campaign.deadline.toNumber(),
      amountCollected: ethers.utils.formatEther(campaign.amountCollected.toString()),
      image: campaign.image,
      pId: i
    }));

    return parsedCampaings

  }

  // get the campaign created by loggedin user
  const getUserCampaigns = async () => {
    const allCampaigns = await getCampaigns();

    const filteredCampaigns = allCampaigns.filter((campaign) => campaign.owner === address);

    return filteredCampaigns;
  }


  return (
    <StateContext.Provider value={{
      address,
      contract,
      connect,
      createCampaign: publishCampaign,
      getCampaigns,
      getUserCampaigns,
      // donate,
      // getDonations
    }}>
      {children}
    </StateContext.Provider>
  )
}

export const useStateContext = () => useContext(StateContext)