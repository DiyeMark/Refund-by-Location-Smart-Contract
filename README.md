# Refund-by-Location-Smart-Contract
**Table of Contents**

- [Refund-by-Location-Smart-Contract](#Refund-by-Location-Smart-Contract)
    - [Overview](#Overview)
    - [Approach](#Approach)
    - [Project Structure](#project-structure)
        - [casino-ethereum](#casino-ethereum)
        - [flutter_web3_example](#flutter_web3_example)
        - [refund-by-location](#refund-by-location)
            - [admin](#admin)
            - [app](#app)
            - [contracts](#contracts)
        - [root folder](#root-folder)
    - [Installation guide](#installation-guide)
## Overview
The refund by location smart contract is aimed to be used when one party, for example an employer, agrees to pay another party, for example an employee, for being present in a certain geographic area for a certain duration. The employee’s phone sends its GPS location to a smart contract at a certain interval. Based on the pre-agreed contract codified in an Ethereum smart contract, a cryptocurrency payment is executed when all the agreed conditions are met.  

If, at any point, the GPS sensor indicates that an employee is outside the range of the agreed GPS area, the contract state will be updated to indicate that it is out of compliance.

## Approach
We will have an Admin Web App that will interact with a smart contract to handle all necessary admin functionalities. On the other hand we will have a client/employee Mobile Application that will handle all the necessary interactions with smart contract from the client side.

## Project Structure
This repository has a number of files and folders. Here is a short explanation about them.

### casino-ethereum:
This is a simple casino built with solidity, truffle and react

### flutter_web3_example:
This is a flutter web3 example app

### refund-by-location:
This folder contains the project implementation

#### admin
This folder contains the admin web app

#### app
This folder contains the employee mobile app

#### contracts
This folder contains the smart contract
