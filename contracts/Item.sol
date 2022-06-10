pragma solidity ^0.7.0;

import './Marketplace.sol';

contract Item {

    //Item Atributtes
    string public indentifier;
    uint public price;
    uint index;
    Marketplace marketContract;

    constructor(Marketplace _contract, uint _price, uint _index) {
        index = _index;
        price = _price;
        marketContract = _contract;
    }

    receive() external payable {
        require( msg.value >= price, "Invalid amount" );
        (bool success, ) = address(marketContract).call{value:msg.value}(abi.encodeWithSignature("handlePaymet(uint256)", index));
        require(success, "Payment denied");
    }

    fallback() external {

    }
}