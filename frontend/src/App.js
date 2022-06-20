import React, { useEffect, useState } from 'react'
import { ethers } from 'ethers'

import './styles/App.css'
import DeNftContract from './utils/DeNFT.json'

// Constants
const CONTRACT_ADDRESS = '0xe9abbe7f0618157888413b116130f2111118bba4'

const App = () => {
  const [currentAccount, setCurrentAccount] = useState('')

  const checkIfWalletIsConnected = async () => {
    /*
     * First make sure we have access to window.ethereum
     */
    const { ethereum } = window

    if (!ethereum) {
      console.log('Make sure you have metamask!')
      return
    } else {
      console.log('We have the ethereum object', ethereum)
    }

    /*
     * Check if we're authorized to access the user's wallet
     */
    const accounts = await ethereum.request({ method: 'eth_accounts' })

    /*
     * User can have multiple authorized accounts, we grab the first one if its there!
     */
    if (accounts.length !== 0) {
      const account = accounts[0]
      console.log('Found an authorized account:', account);
      setCurrentAccount(account);

      // Listener: In case, User comes to our site and already had their wallet connected + authorized.
      startNFTMintEventListener();
    } else {
      console.log('No authorized account found')
    }
  }

  /*
   * Implement your connectWallet method here
   */
  const connectWallet = async () => {
    try {
      const { ethereum } = window

      if (!ethereum) {
        alert('Get MetaMask!')
        return
      }

      /*
       * Fancy method to request access to account.
       */
      const accounts = await ethereum.request({ method: 'eth_requestAccounts' })

      /*
       * authorized metamask acccount
       */
      console.log('Connected', accounts[0]);
      setCurrentAccount(accounts[0]);
      // Listener: In case, User comes to our site and already had their wallet connected + authorized.
      startNFTMintEventListener();
    } catch (error) {
      console.log(error)
    }
  }

  // actually call to contract for minting NFT
  const contractMintNftCall = async () => {
    try {
      const { ethereum } = window

      if (ethereum) {
        // MetaMask injects a Web3 Provider as "web3.currentProvider", so
        // we can wrap it up in the ethers.js Web3Provider, which wraps a
        // Web3 Provider and exposes the ethers.js Provider API.

        const provider = new ethers.providers.Web3Provider(ethereum)

        // There is only ever up to one account in MetaMask exposed
        const signer = provider.getSigner()

        const connectedContract = new ethers.Contract(
          CONTRACT_ADDRESS,
          DeNftContract.abi,
          signer,
        )

        console.log('Going to pop wallet now to pay gas...')
        let nftTxn = await connectedContract.mintAnNFT()

        console.log('Mining...wait!')
        await nftTxn.wait()

        console.log(
          `Mined, Transaction at: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`,
        )
      } else {
        console.log("Ethereum object doesn't exist!")
      }
    } catch (error) {
      console.log(error)
    }
  }

  // setup our NFT minted listener
  const startNFTMintEventListener = async () => {
    console.log('nft minted listener is called...');
    try {
      const { ethereum } = window

      if (ethereum) {
        // Same stuff again
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();

        const connectedContract = new ethers.Contract(
          CONTRACT_ADDRESS,
          DeNftContract.abi,
          signer,
        )

        // capture contract event upon new NFT is minted
        connectedContract.on('nftMinted', (from, tokenId) => {
          console.log(from, tokenId.toNumber(), `https://testnets.opensea.io/assets/${CONTRACT_ADDRESS}/${tokenId.toNumber()}`);
          alert(
            `Your NFT is minted and sent it to your wallet. It can take about 10 min to show up on OpenSea. Here's the link: https://testnets.opensea.io/assets/${CONTRACT_ADDRESS}/${tokenId.toNumber()}`,
          );
        });

      } else {
        console.log("Ethereum object doesn't exist!")
      }
    } catch (error) {
      console.log(error)
    }
  }

  // connect to wallet error component
  const renderNotConnectedContainer = () => (
    <button
      className="cta-button connect-wallet-button"
      onClick={connectWallet}
    >
      Connect to Wallet
    </button>
  )

  /*
   * This runs our function when the page loads.
   */
  useEffect(() => {
    checkIfWalletIsConnected();
  }, [])

  return (
    <div className="App">
      <div className="container">
        <div className="header-container">
          <p className="header gradient-text">My NFT Collection</p>
          <p className="sub-text">
            Each unique. Each beautiful. Discover your NFT today.
          </p>
          {currentAccount === '' ? (
            renderNotConnectedContainer()
          ) : (
            <button
              onClick={contractMintNftCall}
              className="cta-button connect-wallet-button"
            >
              Mint NFT
            </button>
          )}
        </div>
      </div>
    </div>
  )
}

export default App
