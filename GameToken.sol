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
