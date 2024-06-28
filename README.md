# Game Token

This solidity code is made for tokens and redeemable feature in online Degen gaming platform. Here players can play games and buy degen tokens, then exchange that for redeemable items in the shop.

## Description
This contract is written in Solidity language, a programming language used for developing smart contracts on the Ethereum blockchain. In smart contract first we imported 3 libraries ```ERC20, Ownable, ERC@)Burnable```. In this contract player will submit request for tokens and wait in queue using ```buyDegen()``` and then the owner will mint tokens for all the players in the queue using ```mintToken()```.After receiveing tokens, player can use it to reedem cards from  enum ```Cards``` using ```redeemCards()```, or can send to other users, and if they don't need them anymore than can burn them using ```burnDegen()``` and anytime they can check their tokens through ```checkBalance()```.

### Getting Started
#### Execution program
````javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract GameToken is ERC20, Ownable, ERC20Burnable {
    constructor() ERC20("Game Token", "GTKN") Ownable(msg.sender) {}

    // Game items
    enum Items { Weapon, Armor, Potion, Consumable }

    struct Player {
        address playerAddress;
        uint256 amount;
    }

    // Player queue for buying game tokens
    Player[] public players;

    struct PlayerInventory {
        uint256 weapons;
        uint256 armors;
        uint256 potions;
        uint256 consumables;
    }

    // Player inventory
    mapping(address => PlayerInventory) public playerInventory;

    function buyGameToken(address _playerAddress, uint256 _amount) public {
        players.push(Player({playerAddress: _playerAddress, amount: _amount}));
    }

    function mintToken() public onlyOwner {
        // Mint tokens for players in the queue
        while (players.length != 0) {
            uint256 i = players.length - 1;
            if (players[i].playerAddress != address(0)) {
                _mint(players[i].playerAddress, players[i].amount);
                players.pop();
            }
        }
    }

    function transferGameToken(address _to, uint256 _amount) public {
        require(_amount <= balanceOf(msg.sender), "Insufficient balance");
        _transfer(msg.sender, _to, _amount);
    }

    function redeemItem(Items _item) public {
        if (_item == Items.Weapon) {
            require(balanceOf(msg.sender) >= 10, "Insufficient tokens");
            playerInventory[msg.sender].weapons += 1;
            burn(10);
        } else if (_item == Items.Armor) {
            require(balanceOf(msg.sender) >= 20, "Insufficient tokens");
            playerInventory[msg.sender].armors += 1;
            burn(20);
        } else if (_item == Items.Potion) {
            require(balanceOf(msg.sender) >= 5, "Insufficient tokens");
            playerInventory[msg.sender].potions += 1;
            burn(5);
        } else if (_item == Items.Consumable) {
            require(balanceOf(msg.sender) >= 3, "Insufficient tokens");
            playerInventory[msg.sender].consumables += 1;
            burn(3);
        } else {
            revert("Invalid item selected");
        }
    }

    function burnToken(address _of, uint256 _amount) public {
        _burn(_of, _amount);
    }

    function checkBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }
}
````

To run this code, first go to https://faucets.chain.link/ and claim free fuji testnet avax faucet using login via github. 
Now Head towards remixIDE or hardhat as per your intreset, in this project remix was used for its ease.
create a new ```MyContract.sol``` file and copy the content of ```GameToken.sol``` into it.
In left side go to compile tab and choose the compatible compiler.
Then in deploy section choose injection wallet (metamask, phantom, etc.).
click Deploy and confirm the transaction.

### Interaction with contract

1. The contract is deployed with the name "Game Token" and the symbol "GTKN".
2. The contract inherits from the ERC20, Ownable, and ERC20Burnable contracts from the OpenZeppelin library.
3. The contract owner is set to the address that deployed the contract.


##### Author
Ashutosh Sharan 
(https://www.linkedin.com/in/ashutosh-sharan-177630249/)
 ###### License
 This  GameToken  is licensed under the MIT License