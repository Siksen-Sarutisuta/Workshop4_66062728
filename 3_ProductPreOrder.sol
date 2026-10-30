// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ProductPreOrder - ระบบจองสินค้า
/// @notice Smart Contract สำหรับระบบจองสินค้า (Product Pre-Order)
contract ProductPreOrder {
    address public owner;
    uint256 public productPrice; // ราคาสินค้า (wei)
    uint256 public totalOrders;  // จำนวนการสั่งซื้อทั้งหมด

    struct Order {
        uint256 amount;     // จำนวนเงินที่ชำระ
        uint256 timestamp;  // เวลาที่สั่งซื้อ
    }

    mapping(address => Order[]) public orders;       // เก็บข้อมูลการสั่งซื้อของผู้ซื้อ
    mapping(address => uint256) public orderCount;   // จำนวนการสั่งซื้อของแต่ละคน

    // Events
    event ProductPriceSet(uint256 newPrice);
    event OrderPlaced(address indexed buyer, uint256 amount, uint256 orderIndex);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice เจ้าของสามารถตั้งราคาสินค้า
    /// @param _price ราคาสินค้า (wei)
    function setProductPrice(uint256 _price) public onlyOwner {
        require(_price > 0, "Price must be greater than 0");
        productPrice = _price;
        emit ProductPriceSet(_price);
    }

    /// @notice ผู้ใช้สามารถสั่งซื้อสินค้าโดยโอน ETH เข้า Contract
    function placeOrder() public payable {
        require(productPrice > 0, "Product price not set yet");
        require(msg.value == productPrice, "Incorrect payment amount");

        // เก็บข้อมูลการสั่งซื้อ
        orders[msg.sender].push(Order({
            amount: msg.value,
            timestamp: block.timestamp
        }));

        orderCount[msg.sender]++;
        totalOrders++;

        emit OrderPlaced(msg.sender, msg.value, orderCount[msg.sender]);
    }

    /// @notice ผู้สั่งซื้อสามารถดูจำนวนการสั่งซื้อของตนเองได้
    /// @return จำนวนการสั่งซื้อของผู้เรียก
    function getMyOrderCount() public view returns (uint256) {
        return orderCount[msg.sender];
    }

    /// @notice เจ้าของสามารถดูจำนวนการสั่งซื้อของผู้สั่งซื้อได้
    /// @param _buyer ที่อยู่ของผู้ซื้อ
    /// @return จำนวนการสั่งซื้อของผู้ซื้อคนนั้น
    function getOrderCountByBuyer(address _buyer) public view onlyOwner returns (uint256) {
        return orderCount[_buyer];
    }

    /// @notice เจ้าของสามารถดูจำนวนการสั่งซื้อทั้งหมดได้
    /// @return จำนวนการสั่งซื้อทั้งหมด
    function getTotalOrders() public view onlyOwner returns (uint256) {
        return totalOrders;
    }

    /// @notice เจ้าของสามารถถอนเงินจาก Contract
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(owner).transfer(balance);
    }
}
