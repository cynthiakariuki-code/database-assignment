-- create database bookstore;

 CREATE TABLE customer (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  FIRST_NAME VARCHAR(100) NOT NULL,
  LAST_NAME VARCHAR(100) NOT NULL,
  EMAIL VARCHAR(100) NOT NULL,
  PHONE VARCHAR(12),
  DATE_OF_BIRTH DATE,
  REGISTRATION_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  last_login TIMESTAMP,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE INDEX idx_customer_email (email),
  INDEX idx_customer_name (last_name, first_name)
  );
 
 CREATE TABLE country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(100) NOT NULL,
 	  country_code VARCHAR(3) NOT NULL,
	  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE INDEX idx_country_code (country_code)
  );

  CREATE TABLE address (
      address_id INT PRIMARY KEY AUTO_INCREMENT,
      street_address1 VARCHAR(255) NOT NULL,
      street_address2 VARCHAR(255),
      city VARCHAR(100) NOT NULL,
      state_province VARCHAR(100),
      postal_code VARCHAR(20) NOT NULL,
      country_id INT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      FOREIGN KEY (country_id) REFERENCES country(country_id),
      INDEX idx_address_location (city, state_province, country_id)
  );

 CREATE TABLE address_status (
      status_id INT PRIMARY KEY AUTO_INCREMENT,
      status_name VARCHAR(50) NOT NULL,
      description VARCHAR(255),
      is_active BOOLEAN DEFAULT TRUE,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      UNIQUE INDEX idx_status_name (status_name)
  );


 CREATE TABLE CUSTOMER_ADDRESS (
  CUSTOMER_ADDRESS_ID INT PRIMARY KEY auto_increment ,
  CUSTOMER_ID INT NOT NULL,
  ADDRESS_ID INT NOT NULL,
  STATUS_ID INT NOT NULL,
  ADDRESS_TYPE ENUM('home', 'work', 'billing', 'shipping', 'other') NOT NULL,
  IS_DEFAULT BOOLEAN DEFAULT FALSE,
  DATE_FROM DATE NOT NULL,
  DATE_TO DATE,
  CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UPDATE_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID),
  FOREIGN KEY (ADDRESS_ID) REFERENCES ADDRESS(ADDRESS_ID),
  FOREIGN KEY (STATUS_ID) REFERENCES ADDRESS_STATUS(STATUS_ID),
  INDEX idx_customer_address (customer_id, address_id),
  INDEX idx_address_type (address_type)
  );

shipping_method
CREATE TABLE shipping_method (
    method_id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(100) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL
);

Customer order table
CREATE TABLE cust_order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    shipping_method_id INT NOT NULL,
    destination_address_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(method_id),
    FOREIGN KEY (destination_address_id) REFERENCES address(address_id)
);

CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(50) NOT NULL
);


CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    PHONE VARCHAR(12)
);

CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    publisher_id INT,
    language_id INT,
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id)
);

CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL
); 


CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);


-- order_line
CREATE TABLE order_line (
    line_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- order_status
CREATE TABLE order_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    status_value VARCHAR(20) NOT NULL
);

-- order_history
CREATE TABLE order_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    status_id INT NOT NULL,
    status_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

-- Insert countries
INSERT INTO country (country_name, country_code) VALUES 
('United States', 'US'),
('United Kingdom', 'UK'),
('Canada', 'CA'),
('Australia', 'AU'),
('Italy', 'IT'),
('Spain', 'ES'),
('Japan', 'JP'),
('China', 'CN'),
('India', 'IN'),
('South Africa', 'ZA');

 -- Insert address status
INSERT INTO address_status (status_name, description) VALUES 
('current', 'Currently in use'),
('old', 'No longer in use'),
('temporary', 'Temporary address');

-- Insert a sample customer
INSERT INTO customer (first_name, last_name, email, phone) VALUES 
('John', 'Doe', 'john.doe@example.com', '+1234567890'),
('Jane', 'Smith', 'jane.smith@example.com', '+25471234568'),
('Michael', 'Brown', 'michael.brown@example.com', '+25471234569'),
('Emily', 'Davis', 'emily.davis@example.com', '+25471234570'),
('David', 'Wilson', 'david.wilson@example.com', '+25471234571'),
('Sarah', 'Johnson', 'sarah.johnson@example.com', '+25471234572'),
('Robert', 'Martinez', 'robert.martinez@example.com', '+25471234573'),
('Olivia', 'Anderson', 'olivia.anderson@example.com', '+25471234574'),
('Daniel', 'Thomas', 'daniel.thomas@example.com', '+25471234575'),
('Sophia', 'Jackson', 'sophia.jackson@example.com', '+25471234576');

-- Insert an address
INSERT INTO address (street_address1, city, state_province, postal_code, country_id) VALUES 
('123 Main St', 'New York', 'NY', '10001', 12);

-- Link customer to address
INSERT INTO customer_address (customer_id, address_id, status_id, address_type, is_default, date_from) VALUES 
(11, 3, 1, 'home', TRUE, '2025-04-13');

-- Insert into shipping_method
INSERT INTO shipping_method (method_name, cost) VALUES
('Standard Shipping', 4.99),
('Express Shipping', 9.99),
('Overnight Shipping', 19.99),
('International Shipping', 14.99);

-- Insert into order_status
INSERT INTO order_status (status_value) VALUES
('Pending Payment'),
('Processing'),
('Shipped'),
('Delivered'),
('Cancelled'),
('Returned');

-- Insert into cust_order (customer orders)
INSERT INTO cust_order (customer_id, shipping_method_id, destination_address_id, order_date) VALUES
(11, 1, 1, '2025-01-15 10:30:00'),  -- Customer 1, standard shipping
(12, 2, 1, '2025-02-20 14:15:00'),  -- Customer 1, express shipping
(13, 1, 2, '2025-03-05 09:45:00'),  -- Customer 2, standard shipping
(14, 3, 2, '2025-03-10 16:20:00');  -- Customer 2, overnight shipping

-- Insert into order_line (items in each order)
INSERT INTO order_line (order_id, book_id, price, quantity) VALUES
(1, 1, 12.99, 1),  -- Order 1: 1x Harry Potter
(1, 3, 9.99, 2),   -- Order 1: 2x The Shining
(2, 2, 15.99, 1),  -- Order 2: 1x Game of Thrones
(3, 4, 8.99, 1),   -- Order 3: 1x Murder on Orient Express
(3, 1, 12.99, 1),  -- Order 3: 1x Harry Potter
(4, 2, 15.99, 2),  -- Order 4: 2x Game of Thrones
(4, 3, 9.99, 1);   -- Order 4: 1x The Shining

-- Insert into order_history (status changes for orders)
INSERT INTO order_history (order_id, status_id, status_date) VALUES
-- Order 1 history
(1, 1, '2025-01-15 10:30:00'),  -- Pending Payment
(1, 2, '2025-01-15 11:45:00'),  -- Processing
(1, 3, '2025-01-16 09:15:00'),  -- Shipped
(1, 4, '2025-01-18 14:30:00'),  -- Delivered

-- Order 2 history
(2, 1, '2025-02-20 14:15:00'),  -- Pending Payment
(2, 2, '2025-02-20 15:30:00'),  -- Processing
(2, 3, '2025-02-21 08:45:00'),  -- Shipped

-- Order 3 history
(3, 1, '2025-03-05 09:45:00'),  -- Pending Payment
(3, 2, '2025-03-05 11:00:00'),  -- Processing
(3, 5, '2025-03-06 10:15:00'),  -- Cancelled

-- Order 4 history
(4, 1, '2025-03-10 16:20:00'),  -- Pending Payment
(4, 2, '2025-03-10 17:30:00'),  -- Processing
(4, 3, '2025-03-11 07:15:00'); -- Shipped


-- Create admin user with full privileges
CREATE USER 'bookstore_admin'@'localhost' IDENTIFIED BY 'Admin@123';
GRANT ALL PRIVILEGES ON BookStore.* TO 'bookstore_admin'@'localhost';
GRANT GRANT OPTION ON BookStore.* TO 'bookstore_admin'@'localhost';  -- Allows admin to grant privileges to others

-- Create read-write user for application
CREATE USER 'bookstore_app'@'localhost' IDENTIFIED BY 'App@123';
GRANT SELECT, INSERT, UPDATE, DELETE ON BookStore.* TO 'bookstore_app'@'localhost';

-- Create read-only user for reporting
CREATE USER 'bookstore_report'@'localhost' IDENTIFIED BY 'Report@123';
GRANT SELECT ON BookStore.* TO 'bookstore_report'@'localhost';

-- Apply the changes
FLUSH PRIVILEGES;

