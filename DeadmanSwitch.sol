// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract DeadmanSwitch {
    address ownerAddress;
    address beneficiaryAddress;
    uint lastBlock;
    uint constant maximumBlockDuration = 10; 
    uint contractEther = 0;

    receive() external payable {
        contractEther += msg.value;
    }
    
    constructor() payable {
        contractEther += msg.value;
        ownerAddress = msg.sender;
        beneficiaryAddress = 0x7eE6Aa95edC6a8fBE7471f0e691Ce6105C051Be1;
        lastBlock = block.number; //the block number when the smart contract gets deployed
    }

    modifier onlyOwner() {
        require(msg.sender == ownerAddress);
        _;
    }

    modifier onlyBeneficiary() {
        require(msg.sender == beneficiaryAddress);
        _;
    }

    function keepAlive() public onlyOwner {
        uint currentBlockNumber = block.number;
        require(currentBlockNumber - lastBlock <= maximumBlockDuration);
        lastBlock = currentBlockNumber;
    }

    function fetchMoney() public onlyBeneficiary{
        require(block.number - lastBlock > maximumBlockDuration);
        selfdestruct(payable(beneficiaryAddress));
    }
}
