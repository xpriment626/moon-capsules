## Overview

Moon Capsules is a smart contract submitted for the Moonbeam "Bear Necessities" hackathon.

## Features

- A factory generates capsule ERC721 contracts
- Users can deposit assets into the capsule
- The capsules can act as tradable portfolios or user-generated index funds
- Users can list their capsules for sale and define precisely what kind of asset they want in exchange for their portfolio
- Holding a capsule grants voting power in the Moon Capsule DAO

## Motivation

Crypto degens are able to put together some of the most outlandish portfolios, and it's not uncommon to see people sitting on bags of memee coins, in-game NFT items, or startup moonshot DAO tokens. However, liquidity problems can arise when it comes to the more unconventional portfolio compositions.

The idea of Moon Capsules is to leverage the concept of "coincidence of wants" in a p2p context, and allow users to define what a fair value exchange is according to their portfolio composition.

### Example Flow

- Alice is a meme coin degen who was late to the party and has now been sitting on a bag of 15 illiquid coins for many months.
- Alice lists her meme coin portfolio on Moon Capsules for $4000 worth of MATIC tokens. She knows that there's a good chance that somewhere out there, there's at least one person who's still on the meme coin hype and wouldn't mind taking a chance on a ready-made portfolio of 15 coins. From Alice's POV, it's better that she gets back a fixed amount of MATIC rather than jumping through different DEXs and eating slippage to liquidate her position.
- Bob comes along and sees Alice's portfolio listed and happens to be willing to part with some of his MATIC. 
- Alice locks her capsule into and escrow contract and Bob does the same for his MATIC.
- In the happy path, both parties are able to withdraw the asset of the other.
- *ESCROW LOGIG FOR UNHAPPY PATH TBD*