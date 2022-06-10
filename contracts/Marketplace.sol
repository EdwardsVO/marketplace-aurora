pragma solidity ^0.7.0;

import "./Item.sol";
import "./Ownable.sol";

contract Marketplace is Ownable{

    enum ItemStatus { OnSale, Paid, Delivered }
    event NewItemStatus( uint index, uint status, address _contract); //Log once an item chage its status

    uint index; //Unique identifier for all items
     
    //Contract Structures
    struct Created_Item {
        Item _item;
        Marketplace.ItemStatus _status;
        string _title;
        uint _price;
    }

    mapping (uint => Created_Item) public stock; //Main contract structure that contains all items created


    //Function for create and storage items within the market stock
    function createItem(string memory _title, uint _price) public onlyOwner {
        Item item = new Item(this, _price, index); //Intansce Item contract
        stock[index]._item = item; //Save item within the stock storage in Market contract
        stock[index]._status = ItemStatus.OnSale; //Save the Item status
        stock[index]._title = _title; //Save item title
        stock[index]._price = _price;

        emit NewItemStatus(index, uint(stock[index]._status), address(item)); //Log the item sale
        index ++; //Refresh the IDs
    }

    //Function only callable by the Item Contract for registering the item payment within the market contract
    function handlePayment(uint _index) public payable {
        Item item = stock[_index]._item; //Get the item object
        require(item.price() == msg.value, "Invalid payment amount"); //Check if the price equals to the amount sent
        require(stock[_index]._status == ItemStatus.OnSale, "Item already sold"); //Check if the item is on sale 
        stock[_index]._status = ItemStatus.Paid; // Update the item status

        emit NewItemStatus(_index, uint(stock[_index]._status), address(item)); //Log the payment
    }

    //Function for set to delivered the item status
    function handleDelivery(uint _index) public onlyOwner {
        require( stock[_index]._status == ItemStatus.Paid, "Item not paid"); //Check if the item was already paid
        stock[_index]._status = ItemStatus.Delivered; //Update the item status to delivered

        emit NewItemStatus(_index, uint(stock[_index]._status), address(stock[_index]._item)); //Log the delivery
    }
       



}