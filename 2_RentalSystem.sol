// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title RentalSystem - ระบบเช่าทรัพย์สิน
/// @notice Smart Contract สำหรับระบบเช่าทรัพย์สิน (Rental System)
contract RentalSystem {
    address public owner;
    uint256 public rentalFee; // ค่าธรรมเนียมการเช่า (wei)

    mapping(address => bool) public hasPaidRental; // ตรวจสอบว่าผู้ใช้ชำระเงินค่าเช่าแล้วหรือยัง

    // Events
    event RentalFeeSet(uint256 newFee);
    event RentalPaid(address indexed renter, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice เจ้าของสามารถตั้งค่าธรรมเนียมการเช่า
    /// @param _fee ค่าธรรมเนียมการเช่า (wei)
    function setRentalFee(uint256 _fee) public onlyOwner {
        require(_fee > 0, "Fee must be greater than 0");
        rentalFee = _fee;
        emit RentalFeeSet(_fee);
    }

    /// @notice ผู้ใช้สามารถชำระค่าธรรมเนียมการเช่าเพื่อใช้ทรัพย์สิน
    function payRental() public payable {
        require(rentalFee > 0, "Rental fee not set yet");
        require(msg.value == rentalFee, "Incorrect payment amount");
        require(!hasPaidRental[msg.sender], "Already paid rental fee");

        hasPaidRental[msg.sender] = true;

        emit RentalPaid(msg.sender, msg.value);
    }

    /// @notice ตรวจสอบผู้ที่ชำระเงินค่าเช่าแล้ว
    /// @param _renter ที่อยู่ของผู้เช่าที่ต้องการตรวจสอบ
    /// @return สถานะการชำระเงิน (true = ชำระแล้ว, false = ยังไม่ชำระ)
    function checkPaymentStatus(address _renter) public view returns (bool) {
        return hasPaidRental[_renter];
    }

    /// @notice เจ้าของสามารถถอนเงินจาก Contract
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(owner).transfer(balance);
    }
}
