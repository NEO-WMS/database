CREATE DATABASE wms;

USE wms;

## 이메일 인증 번호 테이블 생성
CREATE TABLE email_auth_number (
    email VARCHAR(100) PRIMARY KEY,
    auth_number VARCHAR(6) NOT NULL
);

## 유저 테이블 생성
CREATE TABLE user (
    user_id VARCHAR(20) PRIMARY KEY,
    user_password VARCHAR(255) NOT NULL,
    user_email VARCHAR(100) NOT NULL UNIQUE,
    user_role VARCHAR(25) NOT NULL DEFAULT('ROLE_USER') CHECK (
        user_role IN (
            'ROLE_USER',
            'ROLE_ADMIN'
        )
    )
);



## 입고
- 입고 및 작업 스케줄링

### 공급자 (provider)
CREATE TABLE provider {
  provider_id INT PRIMARY KEY,
  provider_name VARCHAR(100) NOT NULL,
  provider_address VARCHAR(255) NOT NULL
}

## 주문접수
- 고객사 주문접수 및 수신
### 주문 (order)
CREATE TABLE order {
  order_id INT PRIMARY KEY,
  order_date INT NOT NULL
}

### 주문상세 (orderDetail)
CREATE TABLE orderDetail {
  order_detailId INT PRIMARY KEY,
  order_quantity INT NOT NULL,
  expected_date DATETIME NOT NULL DEFAULT(now()),
  actual_date DATETIME NOT NULL DEFAULT(now())
}

# 배송
CREATE TABLE transfer {
  transter_id INT PRIMARY KEY,
  transfer_quantity INT NOT NULL,
  sent_date DATETIME NOT NULL DEFAULT(now()),
  received_date DATETIME NOT NULL DEFAULT(now())
}

## 출고
- 다양한 운송장 등록 및 처리
- 신속한 출고 확정관리

### 고객 (customer)
CREATE TABLE customer {
  customerId INT PRIMARY KEY,
  customerName VARCHAR(100) NOT NULL,
  customerAddress VARCHAR(255) NOT NULL
}

### 출고 (delivery)
CREATE TABLE delivery {
  deliveryId INT PRIMARY KEY,
  deliveryDate INT NOT NULL
}

### 주문상세 (orderDetail)
CREATE TABLE delivery_detail {
  deliveryDetailId INT PRIMARY KEY,
  deliveryQuantity INT NOT NULL,
  expectedDate DATETIME NOT NULL DEFAULT(now()),
  ActualDate DATETIME NOT NULL DEFAULT(now())
}

## 장소 (location)
CREATE TABLE location {
  locationId INT PRIMARY KEY,
  locationName VARCHAR(100) NOT NULL,
  locationAddress VARCHAR(255) NOT NULL
}



## 재고관리
- 재고변동에 대한 실시간 재고관리
### product

CREATE TABLE product {
  product_id INT PRIMARY KEY,
  product_code VARCHAR(100) NOT NULL,
  bar_code VARCHAR(100) NOT NULL,
  product_name VARCHAR(100) NOT NULL,
  product_description VARCHAR(2000),
  product_category VARCHAR(100) NOT NULL,
  reorder_quantity INT NOT NULL
  packed_weight DECIMAL(10,2), 
  packed_height DECIMAL(10,2),
  packed_width DECIMAL(10,2),
  Packed_depth DECIMAL(10,2),
  refrigerated TINYINT NOT NULL DEFAULT(flase)
}

CREATE TABLE inventory {
  inventory_id INT PRIMARY KEY,
  quantity_available INT,
  minimum_stock_level INT,
  maximum_stock_level INT,
  reorder_point INT
}

## 임가공
- 주문별 재고 할당작업
### 


## 반풀/입출
- 다양한 입출관리
- 주문배송, 지정일배송, 교환배송, 재발송, 기타출고, 반품회수 등
###







## 공지사항 게시물 테이블 생성
CREATE TABLE announcement_board (
    announcement_board_number INT PRIMARY KEY AUTO_INCREMENT,
    announcement_board_title VARCHAR(100) NOT NULL,
    announcement_board_contents TEXT NOT NULL,
    announcement_board_writer_id VARCHAR(20) NOT NULL,
    announcement_board_write_datetime DATETIME NOT NULL DEFAULT(now()),
    announcement_board_view_count INT NOT NULL DEFAULT(0),
    CONSTRAINT fk_announcement_board_writer_id FOREIGN KEY (announcement_board_writer_id) REFERENCES user (user_id) ON DELETE CASCADE
);
## 트렌드 게시물 테이블 생성
CREATE TABLE trend_board (
    trend_board_number INT PRIMARY KEY AUTO_INCREMENT,
    trend_board_title VARCHAR(100) NOT NULL,
    trend_board_contents TEXT NOT NULL,
    trend_board_writer_id VARCHAR(20) NOT NULL,
    trend_board_write_datetime DATETIME NOT NULL DEFAULT(now()),
    trend_board_like_count INT NOT NULL DEFAULT(0),
		trend_board_view_count INT NOT NULL DEFAULT(0),
    trend_board_thumbnail_image LONGTEXT NOT NULL,
    CONSTRAINT fk_trend_board_writer_id FOREIGN KEY (trend_board_writer_id) REFERENCES user (user_id) ON DELETE CASCADE
);

## 트렌드 게시물 답글 테이블 생성
CREATE TABLE trend_board_comment (
    trend_board_comment_number INT PRIMARY KEY AUTO_INCREMENT,
    trend_board_number INT NOT NULL,
    trend_board_comment_contents TEXT NOT NULL,
    trend_board_comment_writer_id VARCHAR(20) NOT NULL,
    trend_board_comment_write_datetime DATETIME NOT NULL DEFAULT(now()),
    trend_board_parent_comment_number INT default NULL,
    CONSTRAINT fk_trend_board_parent_comment_number_fk FOREIGN KEY (
        trend_board_parent_comment_number
    ) REFERENCES trend_board_comment (trend_board_comment_number) ON DELETE CASCADE,
    CONSTRAINT fk_trend_board_comment_writer_id FOREIGN KEY (trend_board_comment_writer_id) REFERENCES user (user_id) ON DELETE CASCADE,
    CONSTRAINT fk_trend_board_number FOREIGN KEY (trend_board_number) REFERENCES trend_board (trend_board_number) ON DELETE CASCADE
);

## Q&A 게시물 테이블 생성
CREATE TABLE qna_board (
    qna_board_number INT PRIMARY KEY AUTO_INCREMENT,
    qna_board_status BOOLEAN NOT NULL DEFAULT(false),
    qna_board_title VARCHAR(100) NOT NULL,
    qna_board_contents TEXT NOT NULL,
    qna_board_writer_id VARCHAR(20) NOT NULL,
    qna_board_write_datetime DATETIME NOT NULL DEFAULT(now()),
    qna_board_view_count INT NOT NULL DEFAULT(0),
    qna_board_comment TEXT,
    CONSTRAINT fk_qna_board_writer_id FOREIGN KEY (qna_board_writer_id) REFERENCES user (user_id) ON DELETE CASCADE
);
## 고객 게시물 테이블 생성
CREATE TABLE customer_board (
    customer_board_number INT PRIMARY KEY AUTO_INCREMENT,
    customer_board_title VARCHAR(100) NOT NULL,
    customer_board_contents TEXT NOT NULL,
    customer_board_writer_id VARCHAR(20) NOT NULL,
    customer_board_write_datetime DATETIME NOT NULL DEFAULT(now()),
    customer_board_view_count INT NOT NULL DEFAULT(0),
    secret BOOLEAN NOT NULL DEFAULT(false),
    CONSTRAINT fk_customet_board_writer_id FOREIGN KEY (customer_board_writer_id) REFERENCES user (user_id) ON DELETE CASCADE
);

## 고객 게시물 답글 테이블 생성
CREATE TABLE customer_board_comment (
    customer_board_comment_number INT PRIMARY KEY AUTO_INCREMENT,
    customer_board_number INT NOT NULL,
    customer_board_comment_contents TEXT NOT NULL,
    customer_board_comment_writer_id VARCHAR(20) NOT NULL,
    customer_board_comment_write_datetime DATETIME NOT NULL DEFAULT(now()),
    customer_board_parent_comment_number INT default NULL,
    CONSTRAINT fk_customer_board_parent_comment_number_fk FOREIGN KEY (
        customer_board_parent_comment_number
    ) REFERENCES customer_board_comment (customer_board_comment_number) ON DELETE CASCADE,
    CONSTRAINT fk_customer_board_comment_writer_id_fk FOREIGN KEY (
        customer_board_comment_writer_id
    ) REFERENCES user (user_id) ON DELETE CASCADE,
    CONSTRAINT fk_customer_board_number FOREIGN KEY (customer_board_number) REFERENCES customer_board (customer_board_number) ON DELETE CASCADE
);

## 디자이너 게시물 테이블 생성
CREATE TABLE designer_board (
    designer_board_number INT PRIMARY KEY AUTO_INCREMENT,
    designer_board_title VARCHAR(100) NOT NULL,
    designer_board_contents TEXT NOT NULL,
    designer_board_writer_id VARCHAR(20) NOT NULL,
    designer_board_write_datetime DATETIME NOT NULL DEFAULT(now()),
    designer_board_view_count INT NOT NULL DEFAULT(0),
    CONSTRAINT fk_desiner_board_writer_id FOREIGN KEY (designer_board_writer_id) REFERENCES user (user_id) ON DELETE CASCADE
);

## 디자이너 게시물 답글 테이블 생성
CREATE TABLE designer_board_comment (
    designer_board_comment_number INT PRIMARY KEY AUTO_INCREMENT,
    designer_board_number INT NOT NULL,
    designer_board_comment_contents TEXT NOT NULL,
    designer_board_comment_writer_id VARCHAR(20) NOT NULL,
    designer_board_comment_write_datetime DATETIME NOT NULL DEFAULT(now()),
    designer_board_parent_comment_number INT default NULL,
    CONSTRAINT fk_designer_board_parent_comment_number_fk FOREIGN KEY (
        designer_board_parent_comment_number
    ) REFERENCES designer_board_comment (designer_board_comment_number) ON DELETE CASCADE,
    CONSTRAINT fk_designer_board_comment_writer_id_fk FOREIGN KEY (
        designer_board_comment_writer_id
    ) REFERENCES user (user_id) ON DELETE CASCADE,
    CONSTRAINT fk_designer_board_number FOREIGN KEY (designer_board_number) REFERENCES designer_board (designer_board_number) ON DELETE CASCADE
);NT fk_login_id FOREIGN KEY (login_id) REFERENCES user (user_id) ON DELETE CASCADE
);

## 채팅방 테이블 생성
CREATE TABLE chat_room (
    room_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,
    designer_id VARCHAR(50) NOT NULL,
    room_name VARCHAR(100) NOT NULL,
    chat_room_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES user(user_id),
    FOREIGN KEY (designer_id) REFERENCES user(user_id)
);

## 채팅방 message 테이블 생성
CREATE TABLE chat_message (
    message_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    chatroom_id BIGINT NOT NULL,
    sender_id VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    send_datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (chatroom_id) REFERENCES chat_room(room_id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES user(user_id) ON DELETE CASCADE 
);

# 트렌드 게시판 좋아요 관계 테이블 생성
CREATE TABLE like_table (
  user_id varchar(20)  NOT NULL,
  trend_board_number int NOT NULL ,
  PRIMARY KEY (user_id, trend_board_number),
  KEY fk_trend_board_idx (trend_board_number),
  KEY fk_user_id_idx (user_id),
  CONSTRAINT fk_user_has_trend_board1 FOREIGN KEY (trend_board_number) REFERENCES trend_board (trend_board_number) ON DELETE CASCADE,
  CONSTRAINT fk_user_has_user1 FOREIGN KEY (user_id) REFERENCES  user (user_id) ON DELETE CASCADE
);

## 방문로그 테이블 생성
CREATE TABLE login_log (
    sequence INT PRIMARY KEY AUTO_INCREMENT,
    login_id VARCHAR(20),
    login_date DATETIME NOT NULL DEFAULT(now()),
    CONSTRAI

## 개발자 계정 생성
CREATE USER 'developer' @'%' IDENTIFIED BY 'P!ssw0rd';

GRANT ALL PRIVILEGES ON hair.* TO 'developer' @'%';