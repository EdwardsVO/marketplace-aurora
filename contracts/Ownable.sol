pragma solidity ^0.7.0;

contract Ownable {

    address public _owner;

    constructor () {
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(isOwner(), "Only the owner can do this action");
        _;
    }

    // Check if the sender is the owner
    function isOwner() public view returns(bool) {
        return (msg.sender == _owner);
    }

}
