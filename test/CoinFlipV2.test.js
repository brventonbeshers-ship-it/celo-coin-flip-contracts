const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CoinFlipV2", function () {
  let cf, owner, player;

  beforeEach(async function () {
    [owner, player] = await ethers.getSigners();
    const CF = await ethers.getContractFactory("CoinFlipV2");
    cf = await CF.deploy();
  });

  it("should start with zero flips", async function () {
    expect(await cf.totalFlips()).to.equal(0);
  });

  it("should allow a flip", async function () {
    await cf.connect(player).flip(true);
    expect(await cf.totalFlips()).to.equal(1);
  });

  it("should track user stats", async function () {
    await cf.connect(player).flip(true);
    await cf.connect(player).flip(false);
    const stats = await cf.getUserStats(player.address);
    expect(stats.flips).to.equal(2);
  });

  it("should emit CoinFlipped event", async function () {
    await expect(cf.connect(player).flip(true)).to.emit(cf, "CoinFlipped");
  });

  it("should allow owner to pause", async function () {
    await cf.setGamePaused(true);
    await expect(cf.connect(player).flip(true)).to.be.revertedWith("Game paused");
  });
});
