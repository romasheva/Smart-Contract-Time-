// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;


contract TimeShop{
    mapping (address => bool) buyers;
    uint public price = 2 ether;
    address public owner;
    address public shopAddress;
    bool fullyPaid;

    event ItemFullyPaid(uint _price, address _shopAddress);

    constructor() {
        owner = msg.sender;
        shopAddress = address(this);
    }

    function getBuyer(address _addr) public view returns(bool){
        require(owner == msg.sender, "You are not an Owner!");
        return buyers[_addr];
    }

    function addBuyer(address _addr) public {
        require(owner == msg.sender, "You are not an Owner!");
        buyers[_addr] = true;
    }

    function getBalance() public view returns(uint) {
        return shopAddress.balance;
    }

    function withdrawAll() public {
        require(owner == msg.sender && fullyPaid && shopAddress.balance > 0, "Rejected");

        address payable receiver = payable(msg.sender);

        receiver.transfer(shopAddress.balance);
    }

    receive() external payable {
        require(buyers[msg.sender] && msg.value <= price && !fullyPaid, "Rejected!");

        if(shopAddress.balance == price) {
            fullyPaid = true;

            emit ItemFullyPaid(price, shopAddress);
        }
    }
}                                                     