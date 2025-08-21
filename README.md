# 📘 PahanaEdu Billing System

A **Java EE web-based distributed billing and reporting application** developed for educational institutes and retail environments.  
This project provides **Admin & Staff dashboards**, customer & item management, bill generation with discounts, reporting, and secure authentication.

---

## 🚀 Features

### 🔑 Authentication & Roles
- Secure login with **Admin** and **Staff** roles  
- Role-based access to features and dashboards  

### 💳 Billing System
- Generate bills with **customer & item selection**  
- Support for **discounts (percentage-based)** and **payment processing**  
- Auto-redirect to **Print Receipt** after finalization  
- Staff bills recorded and linked to daily reports  

### 📊 Reporting
- **Admin Reports** – view all staff activity and bills  
- **Staff Reports** – personal billing history & revenue summary  
- Dashboard statistics:
  - Bills created today  
  - Total revenue today  
  - Tasks completed  
  - Customers served  

### 👥 Customer & Item Management
- Add, update, or deactivate **customers**  
- Manage **items**, pricing, and stock availability  

### 🌐 Distributed & Service-Oriented
- Built as a **distributed application with web services**  
- Provides **API endpoints** for external integration  

---

## 🛠️ Tech Stack

- **Frontend**: JSP, JSTL, HTML5, CSS3  
- **Backend**: Java Servlets, JDBC  
- **Frameworks**: Maven, MVC architecture  
- **Database**: MySQL (Workbench for schema & management)  
- **Server**: Apache Tomcat 9.0  
- **Design Patterns**:
  - **DAO (Data Access Object)** – for clean DB access  
  - **Singleton** – DB connection management  
  - **MVC** – separation of concerns (Controllers, Services, Views)  
  - **Factory** – for bill item creation  

---

## 📂 Project Structure


### Database Setup

```sql
CREATE DATABASE pahana_edu CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS pahanaedu;
CREATE DATABASE pahanaedu CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE pahanaedu;

-- USERS
CREATE TABLE users (
  userId     INT AUTO_INCREMENT PRIMARY KEY,
  username   VARCHAR(100) NOT NULL UNIQUE,
  password   VARCHAR(100) NOT NULL,         -- plain for now (matches your DAO)
  userRole   ENUM('ADMIN','STAFF') NOT NULL,
  createdAt  DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO users (username,password,userRole) VALUES
('admin','admin123','ADMIN'),
('staff','staff123','STAFF');

-- CUSTOMERS
CREATE TABLE customers (
  customerId     INT AUTO_INCREMENT PRIMARY KEY,
  accountNumber  VARCHAR(20) UNIQUE,
  name           VARCHAR(120) NOT NULL,
  address        VARCHAR(255),
  phone          VARCHAR(20),
  email          VARCHAR(120),
  status         ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  createdAt      DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ITEMS
CREATE TABLE items (
  itemId      INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(150) NOT NULL,
  unitPrice   DECIMAL(10,2) NOT NULL CHECK (unitPrice >= 0),
  stockQty    INT NOT NULL DEFAULT 0 CHECK (stockQty >= 0),
  category    VARCHAR(60),
  description TEXT,
  imageUrl    TEXT,
  isActive    BOOLEAN NOT NULL DEFAULT TRUE,
  createdAt   DATETIME DEFAULT CURRENT_TIMESTAMP,
  KEY idx_items_name (name),
  KEY idx_items_category (category)
) ENGINE=InnoDB;

-- BILLS (header)
CREATE TABLE bills (
  billId        INT AUTO_INCREMENT PRIMARY KEY,
  billNo        VARCHAR(30) UNIQUE,
  billDate      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  customerId    INT NULL,
  createdBy     INT NOT NULL,             -- users.userId
  subTotal      DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  discountAmt   DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  netTotal      DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  paidAmount    DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  paymentMethod VARCHAR(30),
  notes         TEXT,
  createdAt     DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_bills_customer
    FOREIGN KEY (customerId) REFERENCES customers(customerId)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_bills_user
    FOREIGN KEY (createdBy) REFERENCES users(userId)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- BILL LINES 
CREATE TABLE bill_items (
  lineId     INT AUTO_INCREMENT PRIMARY KEY,
  billId     INT NOT NULL,
  itemId     INT NULL,                 -- nullable so we can delete items
  itemName   VARCHAR(150) NOT NULL,    -- snapshot of items.name
  unitPrice  DECIMAL(10,2) NOT NULL,   -- snapshot of price at sale time
  qty        INT NOT NULL CHECK (qty > 0),
  lineTotal  DECIMAL(10,2) NOT NULL,   -- = unitPrice*qty
  createdAt  DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_bill_items_bill
    FOREIGN KEY (billId) REFERENCES bills(billId)
    ON DELETE CASCADE ON UPDATE CASCADE,     -- delete lines if bill deleted
  CONSTRAINT fk_bill_items_item
    FOREIGN KEY (itemId) REFERENCES items(itemId)
    ON DELETE SET NULL ON UPDATE CASCADE,    -- allow deleting billed items
  KEY idx_bill_items_billId (billId),
  KEY idx_bill_items_itemId (itemId)
) ENGINE=InnoDB;
