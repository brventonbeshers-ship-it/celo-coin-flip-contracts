// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract CoinFlipV2 {
    address public owner;
    uint256 public totalFlips;
    uint256 public totalWins;
    bool public gamePaused;

    struct UserStats {
        uint256 flips;
        uint256 wins;
        uint256 lastFlip;
        bool lastResult;
    }

    mapping(address => UserStats) public userStats;

    event CoinFlipped(address indexed player, bool guess, bool result, bool win);

    modifier onlyOwner() { require(msg.sender == owner, "Not authorized"); _; }
    modifier whenNotPaused() { require(!gamePaused, "Game paused"); _; }

    constructor() { owner = msg.sender; }

    function flip(bool guessHeads) external whenNotPaused returns (bool result, bool win) {
        uint256 hash = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), msg.sender, totalFlips, block.timestamp)));
        result = (hash % 2 == 0);
        win = (guessHeads == result);

        totalFlips++;
        if (win) totalWins++;

        UserStats storage stats = userStats[msg.sender];
        stats.flips++;
        if (win) stats.wins++;
        stats.lastFlip = block.number;
        stats.lastResult = result;

        emit CoinFlipped(msg.sender, guessHeads, result, win);
    }

    function getUserStats(address user) external view returns (uint256 flips, uint256 wins, uint256 lastFlip, bool lastResult) {
        UserStats memory s = userStats[user];
        return (s.flips, s.wins, s.lastFlip, s.lastResult);
    }

    function setGamePaused(bool _paused) external onlyOwner { gamePaused = _paused; }
}
