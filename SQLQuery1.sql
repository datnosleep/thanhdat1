-- Bảng Danh Mục Sản Phẩm (Categories)
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX)
);
INSERT INTO Categories (CategoryName, Description) 
VALUES (N'Quần áo', N'Các loại quần áo thời trang');

-- Bảng Sản Phẩm (Products)
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    CategoryID INT NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    ImageURL NVARCHAR(255),
    CreatedDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
INSERT INTO Products (CategoryID, ProductName, Description, Price, StockQuantity, ImageURL) 
VALUES (1, N'Áo thun nam', N'Áo thun cotton cao cấp', 150000.00, 100, 'https://example.com/aothun.jpg');

-- Bảng Khách Hàng (Customers)
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    Phone NVARCHAR(20),
    Address NVARCHAR(MAX),
    PasswordHash NVARCHAR(255) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);
INSERT INTO Customers (FullName, Email, Phone, Address, PasswordHash) 
VALUES (N'Nguyễn Văn A', 'nva@gmail.com', '0909123456', N'123 Đường ABC, TP.HCM', 'hashedpassword123');
-- Bảng Nhân Viên (Employees)
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    Role NVARCHAR(10) CHECK (Role IN ('Admin', 'Staff')) DEFAULT 'Staff',
    CreatedDate DATETIME DEFAULT GETDATE()
);
INSERT INTO Employees (FullName, Email, PasswordHash, Role) 
VALUES (N'Trần Thị B', 'ttb@gmail.com', 'hashedpassword456', 'Admin');
-- Bảng Đơn Hàng (Orders)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status NVARCHAR(20) CHECK (Status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')) DEFAULT 'Pending',
    ShippingAddress NVARCHAR(MAX) NOT NULL,
    PaymentMethod NVARCHAR(20) CHECK (PaymentMethod IN ('COD', 'Card', 'BankTransfer')) NOT NULL,
    EmployeeID INT,
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Orders_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
INSERT INTO Orders (CustomerID, TotalAmount, Status, ShippingAddress, PaymentMethod, EmployeeID) 
VALUES (1, 300000.00, 'Pending', N'123 Đường ABC, TP.HCM', 'COD', 1);
-- Bảng Chi Tiết Đơn Hàng (OrderDetails)
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) 
VALUES (1, 1, 2, 150000.00);
-- Bảng Giỏ Hàng (Cart)
CREATE TABLE Cart (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Cart_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
INSERT INTO Cart (CustomerID) VALUES (1);
-- Bảng Chi Tiết Giỏ Hàng (CartDetails)
CREATE TABLE CartDetails (
    CartDetailID INT PRIMARY KEY IDENTITY(1,1),
    CartID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    CONSTRAINT FK_CartDetails_Cart FOREIGN KEY (CartID) REFERENCES Cart(CartID),
    CONSTRAINT FK_CartDetails_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
INSERT INTO CartDetails (CartID, ProductID, Quantity) VALUES (1, 1, 2);
-- Bảng Kho Hàng (Inventory)
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    QuantityAdded INT NOT NULL,
    DateAdded DATETIME DEFAULT GETDATE(),
    EmployeeID INT,
    CONSTRAINT FK_Inventory_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT FK_Inventory_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
INSERT INTO Inventory (ProductID, QuantityAdded, EmployeeID) 
VALUES (1, 50, 1);
-- Bảng Thanh Toán (Payments)
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentStatus NVARCHAR(20) CHECK (PaymentStatus IN ('Pending', 'Completed', 'Failed')) DEFAULT 'Pending',
    TransactionID NVARCHAR(100),
    CONSTRAINT FK_Payments_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
INSERT INTO Payments (OrderID, Amount, PaymentStatus) 
VALUES (1, 300000.00, 'Pending');