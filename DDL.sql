-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0;

SET
    @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS,
    FOREIGN_KEY_CHECKS = 0;

SET
    @OLD_SQL_MODE = @@SQL_MODE,
    SQL_MODE = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema wms
-- -----------------------------------------------------
-- 창고 관리 시스템 데이터베이스

-- -----------------------------------------------------
-- Schema wms
--
-- 창고 관리 시스템 데이터베이스
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `wms` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;

USE `wms`;

-- -----------------------------------------------------
-- Table `wms`.`client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`client` (
    `client_no` INT NOT NULL AUTO_INCREMENT COMMENT '일련번호',
    `client_code` VARCHAR(40) NOT NULL COMMENT '거래처 코드',
    `client_category` INT NOT NULL COMMENT '분류',
    `client_name` VARCHAR(50) NOT NULL COMMENT '거래처명',
    `client_owner` VARCHAR(50) NOT NULL COMMENT '대표자명',
    `client_tel` VARCHAR(40) NOT NULL COMMENT '전화번호',
    `client_fax` VARCHAR(40) NULL COMMENT '팩스번호',
    `client_bank` VARCHAR(40) NULL COMMENT '은행명',
    `client_account` VARCHAR(100) NULL COMMENT '은행계좌',
    `client_zipcode` VARCHAR(100) NULL COMMENT '우편번호',
    `client_address1` VARCHAR(100) NULL COMMENT '주소1',
    `client_address2` VARCHAR(100) NULL COMMENT '주소2',
    `client_email` VARCHAR(100) NULL COMMENT '이메일',
    `client_business` VARCHAR(100) NULL COMMENT '사업자등록번호',
    PRIMARY KEY (`client_no`)
) ENGINE = InnoDB COMMENT = '거래처';

-- -----------------------------------------------------
-- Table `wms`.`item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`item` (
    `item_no` INT NOT NULL AUTO_INCREMENT COMMENT '일련번호',
    `item_client_no` INT NOT NULL COMMENT '거래처번호',
    `item_code` VARCHAR(30) NOT NULL COMMENT '품목코드\n',
    `item_name` VARCHAR(50) NOT NULL COMMENT '품목명\n',
    `item_in_price` INT NOT NULL COMMENT '입고단가',
    `item_out_price` INT NOT NULL COMMENT '출고단가',
    `item_image` LONG NULL COMMENT '이미지\n',
    PRIMARY KEY (`item_no`),
    INDEX `client_no_idx` (`item_client_no` ASC) VISIBLE,
    CONSTRAINT `fk_item_client_no` FOREIGN KEY (`item_client_no`) REFERENCES `wms`.`client` (`client_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '품목';

-- -----------------------------------------------------
-- Table `wms`.`warehouse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`warehouse` (
    `warehouse_no` INT NOT NULL AUTO_INCREMENT COMMENT '번호',
    `warehouse_code` VARCHAR(30) NOT NULL COMMENT '창고코드',
    `warehouse_name` VARCHAR(30) NOT NULL COMMENT '창고명',
    PRIMARY KEY (`warehouse_no`)
) ENGINE = InnoDB COMMENT = '창고';

-- -----------------------------------------------------
-- Table `wms`.`area`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`area` (
    `area_no` INT NOT NULL AUTO_INCREMENT COMMENT '번호',
    `area_ware_no` INT NOT NULL COMMENT '창고번호\n',
    `area_code` VARCHAR(30) NOT NULL COMMENT '구역코드\n',
    `area_name` VARCHAR(30) NOT NULL COMMENT '구역명\n',
    PRIMARY KEY (`area_no`),
    INDEX `ware_no_idx` (`area_ware_no` ASC) VISIBLE,
    CONSTRAINT `fk_area_ware_no` FOREIGN KEY (`area_ware_no`) REFERENCES `wms`.`warehouse` (`warehouse_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '구역';

-- -----------------------------------------------------
-- Table `wms`.`rack`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`rack` (
    `rack_no` INT NOT NULL AUTO_INCREMENT COMMENT '번호',
    `rack_area_no` INT NOT NULL COMMENT '구역번호',
    `rack_code` VARCHAR(30) NOT NULL COMMENT '랙코드',
    `rack_name` VARCHAR(30) NOT NULL COMMENT '랙명',
    PRIMARY KEY (`rack_no`),
    INDEX `area_no_idx` (`rack_area_no` ASC) VISIBLE,
    CONSTRAINT `fk_rack_area_no` FOREIGN KEY (`rack_area_no`) REFERENCES `wms`.`area` (`area_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '랙';

-- -----------------------------------------------------
-- Table `wms`.`cell`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`cell` (
    `cell_no` INT NOT NULL AUTO_INCREMENT COMMENT '번호',
    `cell_rack_no` INT NOT NULL COMMENT '랙번호',
    `cell_code` VARCHAR(30) NOT NULL COMMENT '셀코드',
    `cell_name` VARCHAR(30) NOT NULL COMMENT '셀명',
    PRIMARY KEY (`cell_no`),
    INDEX `rack_no_idx` (`cell_rack_no` ASC) VISIBLE,
    CONSTRAINT `fk_cell_rack_no` FOREIGN KEY (`cell_rack_no`) REFERENCES `wms`.`rack` (`rack_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '셀';

-- -----------------------------------------------------
-- Table `wms`.`warehouse_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`warehouse_detail` (
    `warehouse_detail_no` INT NOT NULL AUTO_INCREMENT COMMENT '일련번호',
    `warehouse_detail_lot_code` VARCHAR(30) NOT NULL COMMENT '로트 코드',
    `warehouse_detail_amount` INT NOT NULL COMMENT '재고 수량',
    `warehouse_detail_ordered_amount` INT NULL COMMENT '수주 체결 수량',
    `warehouse_detail_item_no` INT NOT NULL COMMENT '품목 번호',
    `warehouse_detail_ware_no` INT NOT NULL COMMENT '창고번호',
    `warehouse_detail_area_no` INT NOT NULL COMMENT '구역번호',
    `warehouse_detail_rack_no` INT NOT NULL COMMENT '랙번호',
    `warehouse_detail_cell_no` INT NOT NULL COMMENT '셀번호',
    PRIMARY KEY (`warehouse_detail_no`),
    INDEX `item_no_idx` (
        `warehouse_detail_item_no` ASC
    ) VISIBLE,
    INDEX `ware_no_idx` (
        `warehouse_detail_ware_no` ASC
    ) VISIBLE,
    INDEX `area_no_idx` (
        `warehouse_detail_area_no` ASC
    ) VISIBLE,
    INDEX `rack_no_idx` (
        `warehouse_detail_rack_no` ASC
    ) VISIBLE,
    INDEX `cell_no_idx` (
        `warehouse_detail_cell_no` ASC
    ) VISIBLE,
    CONSTRAINT `fk_warehouse_detail_item_no` FOREIGN KEY (`warehouse_detail_item_no`) REFERENCES `wms`.`item` (`item_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_warehouse_detail_ware_no` FOREIGN KEY (`warehouse_detail_ware_no`) REFERENCES `wms`.`warehouse` (`warehouse_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_warehouse_detail_area_no` FOREIGN KEY (`warehouse_detail_area_no`) REFERENCES `wms`.`area` (`area_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_warehouse_detail_rack_no` FOREIGN KEY (`warehouse_detail_rack_no`) REFERENCES `wms`.`rack` (`rack_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_warehouse_detail_cell_no` FOREIGN KEY (`warehouse_detail_cell_no`) REFERENCES `wms`.`cell` (`cell_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '창고별 재고현황';

-- -----------------------------------------------------
-- Table `wms`.`item_movement_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`item_movement_history` (
    `item_movement_history_no` INT NOT NULL AUTO_INCREMENT COMMENT '일련번호',
    `item_movement_history_lot_no` VARCHAR(100) NOT NULL COMMENT '로트번호',
    `item_movement_history_item_no` INT NOT NULL COMMENT '품목번호',
    `item_movement_history_amount` INT NOT NULL COMMENT '이동수량',
    `item_movement_history_day` DATE NOT NULL DEFAULT(now()) COMMENT '이동일자',
    `item_movement_history_pr_ware_no` INT NOT NULL COMMENT '기존창고번호',
    `item_movement_history_pr_area_no` INT NOT NULL COMMENT '기존구역번호',
    `item_movement_history_pr_rack_no` INT NOT NULL COMMENT '기존랙번호',
    `item_movement_history_pr_cell_no` INT NOT NULL COMMENT '기존셀번호',
    `item_movement_history_ware_no` INT NOT NULL COMMENT '이동창고번호',
    `item_movement_history_area_no` INT NOT NULL COMMENT '이동구역번호',
    `item_movement_history_rack_no` INT NOT NULL COMMENT '이동랙번호',
    `item_movement_history_cell_no` INT NOT NULL COMMENT '이동셀번호',
    PRIMARY KEY (`item_movement_history_no`),
    INDEX `pr_ware_no_idx` (
        `item_movement_history_pr_ware_no` ASC
    ) VISIBLE,
    INDEX `pr_area_no_idx` (
        `item_movement_history_pr_area_no` ASC
    ) VISIBLE,
    INDEX `pr_rack_no_idx` (
        `item_movement_history_pr_rack_no` ASC
    ) VISIBLE,
    INDEX `pr_cell_no_idx` (
        `item_movement_history_pr_cell_no` ASC
    ) VISIBLE,
    INDEX `ware_no_idx` (
        `item_movement_history_ware_no` ASC
    ) VISIBLE,
    INDEX `area_no_idx` (
        `item_movement_history_area_no` ASC
    ) VISIBLE,
    INDEX `rack_no_idx` (
        `item_movement_history_rack_no` ASC
    ) VISIBLE,
    INDEX `cell_no_idx` (
        `item_movement_history_cell_no` ASC
    ) VISIBLE,
    CONSTRAINT `fk_item_movement_history_pr_ware_no` FOREIGN KEY (
        `item_movement_history_pr_ware_no`
    ) REFERENCES `wms`.`warehouse` (`warehouse_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_item_movement_history_pr_area_no` FOREIGN KEY (
        `item_movement_history_pr_area_no`
    ) REFERENCES `wms`.`area` (`area_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_item_movement_history_pr_rack_no` FOREIGN KEY (
        `item_movement_history_pr_rack_no`
    ) REFERENCES `wms`.`rack` (`rack_area_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_item_movement_history_pr_cell_no` FOREIGN KEY (
        `item_movement_history_pr_cell_no`
    ) REFERENCES `wms`.`cell` (`cell_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `wfk_item_movement_history_are_no` FOREIGN KEY (
        `item_movement_history_ware_no`
    ) REFERENCES `wms`.`warehouse` (`warehouse_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_item_movement_history_area_no` FOREIGN KEY (
        `item_movement_history_area_no`
    ) REFERENCES `wms`.`area` (`area_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_item_movement_history_rack_no` FOREIGN KEY (
        `item_movement_history_rack_no`
    ) REFERENCES `wms`.`rack` (`rack_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_item_movement_history_cell_no` FOREIGN KEY (
        `item_movement_history_cell_no`
    ) REFERENCES `wms`.`cell` (`cell_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '재고이동';

-- -----------------------------------------------------
-- Table `wms`.`department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`department` (
    `department_no` INT NOT NULL AUTO_INCREMENT COMMENT '번호',
    `department_code` VARCHAR(30) NOT NULL COMMENT '부서코드',
    `department_name` VARCHAR(30) NOT NULL COMMENT '부서명',
    PRIMARY KEY (`department_no`)
) ENGINE = InnoDB COMMENT = '부서';

-- -----------------------------------------------------
-- Table `wms`.`rank`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`rank` (
    `rank_no` INT NOT NULL AUTO_INCREMENT COMMENT '번호\n',
    `rank_code` VARCHAR(30) NOT NULL COMMENT '직급코드',
    `rank_name` VARCHAR(30) NOT NULL COMMENT '직급명',
    PRIMARY KEY (`rank_no`)
) ENGINE = InnoDB COMMENT = '직급';

-- -----------------------------------------------------
-- Table `wms`.`member`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`member` (
    `member_no` INT NOT NULL AUTO_INCREMENT COMMENT '번호\n',
    `member_id` VARCHAR(30) NOT NULL UNIQUE COMMENT '아이디',
    `member_pw` VARCHAR(50) NOT NULL COMMENT '비밀번호',
    `member_name` VARCHAR(30) NOT NULL COMMENT '이름',
    `member_dep_no` INT NOT NULL COMMENT '부서번호',
    `member_rank_no` INT NOT NULL COMMENT '직급번호',
    `member_email` VARCHAR(50) NOT NULL COMMENT '이메일',
    `member_image` LONG NULL COMMENT '프로필 사진',
    `member_reg_date` DATE NULL DEFAULT(now()) COMMENT '최초가입일',
    `member_role` VARCHAR(25) NOT NULL DEFAULT('ROLE_USER') CHECK (
        member_role IN ('ROLE_USER', 'ROLE_ADMIN')
    ),
    PRIMARY KEY (`member_no`),
    INDEX `dep_no_idx` (`member_dep_no` ASC) VISIBLE,
    INDEX `rank_no_idx` (`member_rank_no` ASC) VISIBLE,
    CONSTRAINT `fk_member_dep_no` FOREIGN KEY (`member_dep_no`) REFERENCES `wms`.`department` (`department_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_member_rank_no` FOREIGN KEY (`member_rank_no`) REFERENCES `wms`.`rank` (`rank_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '사원정보';

-- -----------------------------------------------------
-- Table `wms`.`order_sheet`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`order_sheet` (
    `order_sheet_no` INT NOT NULL AUTO_INCREMENT COMMENT '일련번호',
    `order_sheet_member_no` INT NOT NULL COMMENT '담당자번호',
    `order_sheet_client_no` INT NOT NULL COMMENT '고객사번호',
    `order_sheet_day` DATE NOT NULL DEFAULT(now()) COMMENT '작성일자',
    `order_sheet_status` INT NOT NULL COMMENT '진행상태',
    `order_sheet_out_day` DATE NOT NULL COMMENT '납기일자',
    PRIMARY KEY (`order_sheet_no`),
    INDEX `member_no_idx` (`order_sheet_member_no` ASC) VISIBLE,
    INDEX `client_no_idx` (`order_sheet_client_no` ASC) VISIBLE,
    CONSTRAINT `fk_order_sheet_member_no` FOREIGN KEY (`order_sheet_member_no`) REFERENCES `wms`.`member` (`member_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_order_sheet_client_no` FOREIGN KEY (`order_sheet_client_no`) REFERENCES `wms`.`client` (`client_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '수주서';

-- -----------------------------------------------------
-- Table `wms`.`sell`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`sell` (
    `sell_no` INT NOT NULL AUTO_INCREMENT COMMENT '일련번호',
    `sell_member_no` INT NOT NULL COMMENT '담당자번호',
    `sell_order_no` INT NULL COMMENT '수주번호',
    `sell_day` DATE NOT NULL DEFAULT(now()) COMMENT '판매일자',
    PRIMARY KEY (`sell_no`),
    INDEX `order_no_idx` (`sell_order_no` ASC) VISIBLE,
    INDEX `member_no_idx` (`sell_member_no` ASC) VISIBLE,
    CONSTRAINT `fk_sell_order_no` FOREIGN KEY (`sell_order_no`) REFERENCES `wms`.`order_sheet` (`order_sheet_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_sell_member_no` FOREIGN KEY (`sell_member_no`) REFERENCES `wms`.`member` (`member_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '판매(출고)';

-- -----------------------------------------------------
-- Table `wms`.`purchase_sheet`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`purchase_sheet` (
    `purchase_sheet_no` INT NOT NULL AUTO_INCREMENT COMMENT '일련번호',
    `purchase_sheet_day` DATE NOT NULL DEFAULT(now()) COMMENT '작성일자',
    `purchase_sheet_delivery_date` DATE NULL COMMENT '납기일자',
    `purchase_sheet_status` INT NOT NULL COMMENT '발주진행상태',
    `purchase_sheet_order_no` INT NULL COMMENT '수주번호',
    `purchase_sheet_member_no` INT NOT NULL COMMENT '담당자번호',
    `purchase_sheet_client_no` INT NOT NULL COMMENT '거래처번호',
    PRIMARY KEY (`purchase_sheet_no`),
    INDEX `order_no_idx` (`purchase_sheet_order_no` ASC) VISIBLE,
    INDEX `member_no_idx` (
        `purchase_sheet_member_no` ASC
    ) VISIBLE,
    INDEX `client_no_idx` (
        `purchase_sheet_client_no` ASC
    ) VISIBLE,
    CONSTRAINT `fk_purchase_sheet_order_no` FOREIGN KEY (`purchase_sheet_order_no`) REFERENCES `wms`.`order_sheet` (`order_sheet_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_purchase_sheet_member_no` FOREIGN KEY (`purchase_sheet_member_no`) REFERENCES `wms`.`member` (`member_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_purchase_sheet_client_no` FOREIGN KEY (`purchase_sheet_client_no`) REFERENCES `wms`.`client` (`client_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '발주서';

-- -----------------------------------------------------
-- Table `wms`.`order_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`order_detail` (
    `order_detail_no` INT NOT NULL AUTO_INCREMENT COMMENT '일련번호',
    `order_detail_order_no` INT NOT NULL COMMENT '수주서번호',
    `order_detail_item_no` INT NOT NULL COMMENT '품목번호',
    `order_detail_amount` INT NOT NULL COMMENT '주문수량',
    PRIMARY KEY (`order_detail_no`),
    INDEX `order_no_idx` (`order_detail_order_no` ASC) VISIBLE,
    INDEX `item_no_idx` (`order_detail_item_no` ASC) VISIBLE,
    CONSTRAINT `fk_order_detail_order_no` FOREIGN KEY (`order_detail_order_no`) REFERENCES `wms`.`order_sheet` (`order_sheet_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_order_detail_item_no` FOREIGN KEY (`order_detail_item_no`) REFERENCES `wms`.`item` (`item_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '수주서 상세';

-- -----------------------------------------------------
-- Table `wms`.`purchase_sheet_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`purchase_sheet_detail` (
    `purchase_sheet_detail_no` INT NOT NULL AUTO_INCREMENT COMMENT '일련번호',
    `purchase_sheet_detail_purchase_sheet_no` INT NOT NULL COMMENT '발주서번호',
    `purchase_sheet_detail_order_detail_no` INT NULL COMMENT '수주상세번호',
    `purchase_sheet_detail_amount` INT NOT NULL COMMENT '발주수량',
    `purchase_sheet_detail_status` INT NOT NULL COMMENT '입고진행상태',
    `purchase_sheet_detail_item_no` INT NOT NULL COMMENT '품목번호',
    `purchase_sheet_detail_ware_no` INT NOT NULL COMMENT '입고예정창고번호',
    PRIMARY KEY (`purchase_sheet_detail_no`),
    INDEX `order_detail_no_idx` (
        `purchase_sheet_detail_order_detail_no` ASC
    ) VISIBLE,
    INDEX `item_no_idx` (
        `purchase_sheet_detail_item_no` ASC
    ) VISIBLE,
    INDEX `ware_no_idx` (
        `purchase_sheet_detail_ware_no` ASC
    ) VISIBLE,
    CONSTRAINT `fk_purchase_sheet_detail_purchase_sheet_no` FOREIGN KEY (`purchase_sheet_detail_no`) REFERENCES `wms`.`purchase_sheet` (`purchase_sheet_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_purchase_sheet_detail_order_detail_no` FOREIGN KEY (
        `purchase_sheet_detail_order_detail_no`
    ) REFERENCES `wms`.`order_detail` (`order_detail_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_purchase_sheet_detail_item_no` FOREIGN KEY (
        `purchase_sheet_detail_item_no`
    ) REFERENCES `wms`.`item` (`item_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_purchase_sheet_detail_ware_no` FOREIGN KEY (
        `purchase_sheet_detail_ware_no`
    ) REFERENCES `wms`.`warehouse` (`warehouse_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '발주서 상세';

-- -----------------------------------------------------
-- Table `wms`.`sell_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`sell_detail` (
    `sell_detail_no` INT NOT NULL AUTO_INCREMENT COMMENT '일련번호',
    `sell_detail_item_no` INT NOT NULL COMMENT '품목번호',
    `sell_detail_amount` INT NOT NULL COMMENT '수량',
    `sell_detail_sell_price` INT NOT NULL COMMENT '판매단가',
    `sell_detail_lot_no` INT NOT NULL COMMENT '로트번호',
    `sell_detail_sell_detail_no` INT NOT NULL COMMENT '판매상세번호',
    PRIMARY KEY (`sell_detail_no`),
    INDEX `item_no_idx` (`sell_detail_item_no` ASC) VISIBLE,
    CONSTRAINT `fk_sell_detail_item_no` FOREIGN KEY (`sell_detail_item_no`) REFERENCES `wms`.`item` (`item_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '판매(출고)상세';

-- -----------------------------------------------------
-- Table `wms`.`lot`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`lot` (
    `lot_no` INT NOT NULL AUTO_INCREMENT COMMENT '일련번호',
    `lot_code` VARCHAR(30) NOT NULL COMMENT '로트코드\n',
    `lot_item_no` INT NOT NULL COMMENT '품목번호',
    PRIMARY KEY (`lot_no`),
    INDEX `item_no_idx` (`lot_item_no` ASC) VISIBLE,
    CONSTRAINT `fk_lot_item_no` FOREIGN KEY (`lot_item_no`) REFERENCES `wms`.`item` (`item_no`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '로트넘버';

-- -----------------------------------------------------
-- Table `wms`.`input_warehouse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`input_warehouse` (
    `input_warehouse_no` INT NOT NULL AUTO_INCREMENT COMMENT '일련번호\n',
    `input_warehouse_member_no` INT NOT NULL COMMENT '담당자번호',
    `input_warehouse_purchase_sheet_no` INT NULL COMMENT '발주서번호',
    `input_warehouse_status` VARCHAR(45) NOT NULL COMMENT '구분',
    PRIMARY KEY (`input_warehouse_no`),
    INDEX `member_no_idx` (
        `input_warehouse_member_no` ASC
    ) VISIBLE,
    INDEX `purchase_sheet_no_idx` (
        `input_warehouse_purchase_sheet_no` ASC
    ) VISIBLE,
    CONSTRAINT `fk_input_warehouse_member_no` FOREIGN KEY (`input_warehouse_member_no`) REFERENCES `wms`.`member` (`member_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_input_warehouse_purchase_sheet_no` FOREIGN KEY (
        `input_warehouse_purchase_sheet_no`
    ) REFERENCES `wms`.`purchase_sheet` (`purchase_sheet_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '입고';

-- -----------------------------------------------------
-- Table `wms`.`input_warehouse_detail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`input_warehouse_detail` (
    `input_warehouse_detail_no` INT NOT NULL AUTO_INCREMENT COMMENT '일련번호',
    `input_warehouse_detail_input_warehouse_no` INT NOT NULL COMMENT '입고번호',
    `input_warehouse_detail_purchase_sheet_detail_no` INT NULL COMMENT '발주서상세번호',
    `input_warehouse_detail_status` INT NOT NULL COMMENT '구분',
    `input_warehouse_detail_arrival_date` DATE NOT NULL COMMENT '입고일자',
    `input_warehouse_detail_qty` INT NOT NULL COMMENT '입고수량',
    `input_warehouse_detail_warehouse_no` INT NOT NULL COMMENT '초기창고코드',
    `input_warehouse_detail_area_no` INT NOT NULL COMMENT '구역번호',
    `input_warehouse_detail_rack_no` INT NOT NULL COMMENT '랙번호',
    `input_warehouse_detail_cell_no` INT NOT NULL COMMENT '셀번호',
    `input_warehouse_detail_lot_no` INT NOT NULL COMMENT '로드코드',
    `input_warehouse_detail_item_no` INT NOT NULL COMMENT '품목코드',
    PRIMARY KEY (`input_warehouse_detail_no`),
    INDEX `input_warehouse_no_idx` (
        `input_warehouse_detail_input_warehouse_no` ASC
    ) VISIBLE,
    INDEX `purchase_sheet_detail_no_idx` (
        `input_warehouse_detail_purchase_sheet_detail_no` ASC
    ) VISIBLE,
    INDEX `ware_no_idx` (
        `input_warehouse_detail_warehouse_no` ASC
    ) VISIBLE,
    INDEX `area_no_idx` (
        `input_warehouse_detail_area_no` ASC
    ) VISIBLE,
    INDEX `rack_no_idx` (
        `input_warehouse_detail_rack_no` ASC
    ) VISIBLE,
    INDEX `cell_no_idx` (
        `input_warehouse_detail_cell_no` ASC
    ) VISIBLE,
    INDEX `lot_no_idx` (
        `input_warehouse_detail_lot_no` ASC
    ) VISIBLE,
    INDEX `item_code_idx` (
        `input_warehouse_detail_item_no` ASC
    ) VISIBLE,
    CONSTRAINT `fk_input_warehouse_detail_input_warehouse_no` FOREIGN KEY (
        `input_warehouse_detail_input_warehouse_no`
    ) REFERENCES `wms`.`input_warehouse` (`input_warehouse_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_input_warehouse_detail_purchase_sheet_detail_no` FOREIGN KEY (
        `input_warehouse_detail_purchase_sheet_detail_no`
    ) REFERENCES `wms`.`purchase_sheet_detail` (`purchase_sheet_detail_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_input_warehouse_detail_warehouse_no` FOREIGN KEY (
        `input_warehouse_detail_warehouse_no`
    ) REFERENCES `wms`.`warehouse` (`warehouse_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_input_warehouse_detail_area_no` FOREIGN KEY (
        `input_warehouse_detail_area_no`
    ) REFERENCES `wms`.`area` (`area_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_input_warehouse_detail_rack_no` FOREIGN KEY (
        `input_warehouse_detail_rack_no`
    ) REFERENCES `wms`.`rack` (`rack_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_input_warehouse_detail_cell_no` FOREIGN KEY (
        `input_warehouse_detail_cell_no`
    ) REFERENCES `wms`.`cell` (`cell_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_input_warehouse_detail_lot_no` FOREIGN KEY (
        `input_warehouse_detail_lot_no`
    ) REFERENCES `wms`.`lot` (`lot_no`) ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT `fk_input_warehouse_detail_item_no` FOREIGN KEY (
        `input_warehouse_detail_item_no`
    ) REFERENCES `wms`.`item` (`item_no`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB COMMENT = '입고상세';

-- -----------------------------------------------------
-- Table `wms`.`board`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `wms`.`board` (
    `board_no` INT NOT NULL AUTO_INCREMENT COMMENT '게시물 번호',
    `board_title` VARCHAR(100) NOT NULL COMMENT '게시물 제목',
    `board_content` TEXT NOT NULL COMMENT '게시물 내용',
    `board_date` DATE NOT NULL COMMENT '게시물 작성일',
    PRIMARY KEY (`board_no`)
) ENGINE = InnoDB COMMENT = '게시물 테이블';

SET SQL_MODE = @OLD_SQL_MODE;

SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;

SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;

DROP USER IF EXISTS 'developer' @'%';

CREATE USER 'developer' @'%' IDENTIFIED BY 'P!ssw0rd';

GRANT ALL PRIVILEGES ON wms.* TO 'developer' @'%';