// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title SubscriptionSystem - ระบบสมาชิกแบบสมัครสมาชิกรายเดือน
/// @notice Smart Contract สำหรับระบบสมาชิกแบบสมัครสมาชิกรายเดือน (Subscription System)
contract SubscriptionSystem {
    address public owner;
    uint256 public monthlyFee; // ค่าสมาชิกรายเดือน (wei)

    struct Subscriber {
        bool isActive;        // สถานะสมาชิก
        uint256 expireTime;   // เวลาหมดอายุสมาชิก
    }

    mapping(address => Subscriber) public subscribers;

    // Events
    event MonthlyFeeSet(uint256 newFee);
    event SubscriptionPaid(address indexed subscriber, uint256 expireTime);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice เจ้าของสามารถกำหนดค่าสมาชิกแบบรายเดือน
    /// @param _fee ค่าสมาชิกรายเดือน (wei)
    function setMonthlyFee(uint256 _fee) public onlyOwner {
        require(_fee > 0, "Fee must be greater than 0");
        monthlyFee = _fee;
        emit MonthlyFeeSet(_fee);
    }

    /// @notice ผู้ใช้สามารถชำระค่าสมาชิกเพื่อเข้าถึงบริการ
    function subscribe() public payable {
        require(monthlyFee > 0, "Monthly fee not set yet");
        require(msg.value == monthlyFee, "Incorrect payment amount");

        Subscriber storage sub = subscribers[msg.sender];

        // ถ้าสมาชิกยังไม่หมดอายุ ให้ต่ออายุจากเวลาหมดอายุเดิม
        // ถ้าหมดอายุแล้วหรือยังไม่เคยสมัคร ให้เริ่มนับจากตอนนี้
        uint256 startTime;
        if (sub.isActive && sub.expireTime > block.timestamp) {
            startTime = sub.expireTime;
        } else {
            startTime = block.timestamp;
        }

        sub.isActive = true;
        sub.expireTime = startTime + 30 days; // สมาชิก 30 วัน

        emit SubscriptionPaid(msg.sender, sub.expireTime);
    }

    /// @notice ตรวจสอบว่าสมาชิกยังคงมีสถานะใช้งานอยู่หรือไม่
    /// @param _subscriber ที่อยู่ของสมาชิกที่ต้องการตรวจสอบ
    /// @return สถานะการใช้งาน (true = ยังใช้งานอยู่, false = หมดอายุ)
    function isSubscriptionActive(address _subscriber) public view returns (bool) {
        Subscriber memory sub = subscribers[_subscriber];
        return sub.isActive && sub.expireTime > block.timestamp;
    }

    /// @notice เจ้าของสามารถถอนเงินจาก Contract
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        payable(owner).transfer(balance);
    }
}
