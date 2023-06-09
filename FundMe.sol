// SPDX-License-Identifier: MIT 

/// contract is supposed to accept ETH funding by anyone and then let the owner withdraw
pragma solidity ^0.8.18; 


contract FundMe {


    uint256 public constant min_ETH = 0.01 * 10 ** 18; 
    address _owner; 
    constructor() {

        _owner = msg.sender; 
    }

    mapping(address => uint) public funderValue;


    address bubaddress = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2; 
    address[] funders;  
    event funded(address funder, uint _value); 
    event fundWithdrawn(uint _amount); 
    event ownerchanged(address _newOwner); 

    function fund() public payable {
        require(msg.value >= min_ETH);
        funderValue[msg.sender] = msg.value; 
        funders.push(msg.sender); 
        emit funded(msg.sender, msg.value);
    }

    modifier onlyOwner{
        require(msg.sender==_owner,"not the owner");
        _;
    }

    function withdraw() public onlyOwner {
        require (address(this).balance > min_ETH); 
         (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        emit fundWithdrawn(address(this).balance); 
    } 

    function changeOwnerToBub(address _newOwner) public onlyOwner{
        _owner = bubaddress; 
        emit ownerchanged(_newOwner);
    }

}
