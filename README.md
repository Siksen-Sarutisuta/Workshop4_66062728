# Workshop 4: Smart Contract Assignment (66062728)

Repository สำหรับส่งงาน Smart Contract Workshop 4 บน Sepolia Testnet

---

## 📋 Deployed Contracts (Sepolia Testnet)

| ข้อ | ระบบ (System) | Contract Address | Sepolia Etherscan Link |
|:---:|:---|:---:|:---:|
| **1** | **Subscription System** (ระบบสมาชิกรายเดือน) | `0x46849CE3F69b637eCE4c41e647d89dEb8beC693f` | [ดูบน Etherscan](https://sepolia.etherscan.io/address/0x46849CE3F69b637eCE4c41e647d89dEb8beC693f) |
| **2** | **Rental System** (ระบบเช่าทรัพย์สิน) | `0xC8296d99e6D3Ea063E1Fc22D2de81914aA589C0E` | [ดูบน Etherscan](https://sepolia.etherscan.io/address/0xC8296d99e6D3Ea063E1Fc22D2de81914aA589C0E) |
| **3** | **Product Pre-Order** (ระบบจองสินค้า) | `0x055F794402Fbf89f8763a8b4a24A071Ab058AD4E` | [ดูบน Etherscan](https://sepolia.etherscan.io/address/0x055F794402Fbf89f8763a8b4a24A071Ab058AD4E) |

---

## 📂 รายละเอียดไฟล์ Smart Contract

1. **`1_SubscriptionSystem.sol`**
   - เจ้าของกำหนดค่าสมาชิกรายเดือน (`setMonthlyFee`)
   - ผู้ใช้ชำระค่าสมาชิกเข้าถึงบริการ (`subscribe`)
   - ตรวจสอบสถานะสมาชิกว่ายังใช้งานอยู่หรือไม่ (`isSubscriptionActive`)

2. **`2_RentalSystem.sol`**
   - เจ้าของตั้งค่าธรรมเนียมการเช่า (`setRentalFee`)
   - ผู้ใช้ชำระค่าธรรมเนียมการเช่าเพื่อใช้ทรัพย์สิน (`payRental`)
   - ตรวจสอบผู้ที่ชำระเงินค่าเช่าแล้ว (`checkPaymentStatus`)

3. **`3_ProductPreOrder.sol`**
   - ผู้ใช้สั่งซื้อสินค้าโดยโอน ETH เข้า Contract (`placeOrder`)
   - เก็บข้อมูลการสั่งซื้อของผู้ซื้อ
   - ผู้สั่งซื้อดูจำนวนการสั่งซื้อของตนเอง (`getMyOrderCount`)
   - เจ้าของดูจำนวนการสั่งซื้อของผู้ซื้อแต่ละคน (`getOrderCountByBuyer`)
   - เจ้าของดูจำนวนการสั่งซื้อทั้งหมด (`getTotalOrders`)
