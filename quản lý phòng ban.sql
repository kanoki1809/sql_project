create database QuanLyPhongBan;
use QuanLyPhongBan;
set names utf8mb4;


create table NHANVIEN (
  MANV char(5) primary key,
  TENNV varchar(30) collate utf8mb4_unicode_ci,
  GTINH char(3),
  MAIL varchar(30),
  MA_TEAM char(5),
  MAPH char(5) collate utf8mb4_unicode_ci,
  LUONG float
) engine =InnoDB default charset =utf8mb4 collate =utf8mb4_unicode_ci;

create table PHONG (
  MAPH char(5) primary key,
  TENPH varchar(50) collate utf8mb4_unicode_ci,
  TRPH char(5),
  MABAN varchar(5)
) default charset =utf8mb4 collate =utf8mb4_unicode_ci;

create table BAN (
  MABAN char(5) primary key,
  TENBAN varchar(30) collate utf8mb4_unicode_ci,
  TRBAN char(5),
  TENCV varchar(30) collate utf8mb4_unicode_ci
) engine =InnoDB default charset =utf8mb4 collate =utf8mb4_unicode_ci;

create table CONGVIEC (
  MACV char(5) primary key,
  TENCV varchar(30) collate utf8mb4_unicode_ci,
    NGAYBD date,
  NGAYKT date,
  DO_UU_TIEN varchar(30) collate utf8mb4_unicode_ci,
  TIENDO_HIENTAI DECIMAL(10,2) 
) engine =InnoDB default charset =utf8mb4 collate =utf8mb4_unicode_ci;

create table TEAM (
  MA_TEAM char(5) primary key,
  TRNHOM char(5),
  MAPH char(5) 
) engine =InnoDB default charset =utf8mb4 collate =utf8mb4_unicode_ci;

create table CONGVIEC_PC (
  MAPC char(5) primary key,
  TENCV_PC varchar(30) collate utf8mb4_unicode_ci,
  MACV char(5),
  DO_UU_TIEN varchar(30) collate utf8mb4_unicode_ci,
  TILE_TRONGCV DECIMAL(10,2),
   TIENDO_HIENTAI DECIMAL(10,2) 
) default charset =utf8mb4 collate =utf8mb4_unicode_ci;

create table PC_CV_CHUNG (
  MACV char(5),
  MA_TEAM char(5),
  MAPC char(5),
  NGAYBD date,
  NGAYKT date,
  DO_UU_TIEN varchar(30) collate utf8mb4_unicode_ci,
  primary key (MACV, MA_TEAM, MAPC)
) default charset =utf8mb4 collate =utf8mb4_unicode_ci;



create table PHEDUYET_CV (
  MAPD char(5) primary key,
  MACV char(5),
  DAT_YEUCAU varchar(30) collate utf8mb4_unicode_ci,
  MAGD char(5),
  GHICHU varchar(30) collate utf8mb4_unicode_ci
) default charset =utf8mb4 collate =utf8mb4_unicode_ci;

create table CV_CANHAN (
  MACV_CN char(5) primary key,
  TENCV_CN varchar(30) collate utf8mb4_unicode_ci,
  MAPC char(5),
   TIENDO_HIENTAI DECIMAL(10,2),
    TILE_TRONGCV DECIMAL(10,2)
) default charset =utf8mb4 collate =utf8mb4_unicode_ci;

create table PC_TEAM (
  MACV_CN char(5),
  MANV char(5),
  MAPC char(5),
  NGAYBD date,
  NGAYKT date,
  DO_UU_TIEN varchar(30) collate utf8mb4_unicode_ci,
  primary key (MACV_CN, MANV)
) default charset =utf8mb4 collate =utf8mb4_unicode_ci;

create table BC_CANHAN (
  MACV_CN char(5),
  MANV char(5),
  NGAYBC date,
  TIENDO_BC DECIMAL(10,2),
  primary key (MACV_CN,  NGAYBC)
) default charset =utf8mb4 collate =utf8mb4_unicode_ci;

alter table NHANVIEN add 
constraint FK_NV_TEAM foreign key (MA_TEAM) references TEAM(MA_TEAM);
alter table NHANVIEN add 
constraint FK_NV_PH foreign key (MAPH) references PHONG(MAPH);


alter table PHONG add
constraint FK_PH_NV foreign key (TRPH) references NHANVIEN(MANV);
alter table PHONG add
constraint FK_PH_BAN foreign key (MABAN) references BAN(MABAN);


alter table BAN add
constraint FK_BAN_NV foreign key (TRBAN) references NHANVIEN(MANV);


alter table TEAM add
constraint FK_TEAM_PH foreign key (MAPH) references PHONG(MAPH);
alter table TEAM add
constraint FK_TEAM_NV foreign key (TRNHOM) references NHANVIEN(MANV);


alter table CONGVIEC_PC add
constraint FK_CVPC_CV foreign key (MACV) references CONGVIEC(MACV);

alter table PC_CV_CHUNG add
constraint FK_PCCVCHUNG_CV foreign key (MACV) references CONGVIEC(MACV);
alter table PC_CV_CHUNG add
constraint FK_PCCVCHUNG_TEAM foreign key (MA_TEAM) references TEAM(MA_TEAM);
alter table PC_CV_CHUNG add
constraint FK_PCCVCHUNG_PC foreign key (MAPC) references CONGVIEC_PC(MAPC);

alter table PHEDUYET_CV add
constraint FK_PD_CV foreign key (MACV) references CONGVIEC(MACV);
alter table PHEDUYET_CV add
constraint FK_PD_NV foreign key (MAGD) references NHANVIEN(MANV);

alter table CV_CANHAN add
constraint FK_CVCN_PC foreign key (MAPC) references CONGVIEC_PC(MAPC);

alter table PC_TEAM add
constraint FK_PCTEAM_CVCN foreign key (MACV_CN) references CV_CANHAN(MACV_CN);
alter table PC_TEAM add
constraint FK_PCTEAM_PC foreign key (MAPC) references CV_CANHAN(MAPC);
alter table PC_TEAM add
constraint FK_PCTEAM_NV foreign key (MANV) references NHANVIEN(MANV);

alter table BC_CANHAN add
constraint FK_BCCN_CVCN foreign key (MACV_CN) references CV_CANHAN(MACV_CN);
alter table BC_CANHAN add
constraint FK_BCCN_NV foreign key (MANV) references NHANVIEN(MANV);






INSERT INTO NHANVIEN(MANV, TENNV, GTINH, MAIL, MA_TEAM, MAPH, LUONG) VALUES
('NV001', 'Nguyễn Văn A', 'Nam', 'nva@gmail.com', null, null, 15000000),
('NV002', 'Trần Thị B', 'Nu', 'ttb@gmail.com', null, null, 12500000),
('NV003', 'Phạm Hoàng C', 'Nam', 'phc@gmail.com', null, null, 17000000),
('NV004', 'Lê Thị D', 'Nu', 'ltd@gmail.com', null, null, 13500000),
('NV005', 'Nguyễn Hoàng E', 'Nam', 'nhe@gmail.com', null,null, 14500000),
('NV006', 'Trần Minh F', 'Nam', 'tmf@gmail.com', null, null, 12000000),
('NV007', 'Phạm Văn G', 'Nam', 'pvg@gmail.com', null ,null, 18000000),
('NV008', 'Lê Thị H', 'Nu', 'lth@gmail.com', null, null, 13000000),
('NV009', 'Nguyễn Tuấn I', 'Nam', 'nti@gmail.com', null, null, 15500000),
('NV010', 'Trần Thị K', 'Nu', 'ttk@gmail.com', null, null, 14000000);

INSERT INTO BAN(MABAN, TENBAN, TRBAN, TENCV) VALUES
('BAN01', 'Ban giám đốc', 'NV001', 'Phê duyệt'),
('BAN02', 'Ban quản lý', 'NV002', 'Quản lý nhân sự'),
('BAN03', 'Ban dự án', 'NV003', 'Thực hiện dự án');

INSERT INTO PHONG(MAPH, TENPH, TRPH, MABAN) VALUES
('PH01', 'Phòng giám đốc', 'NV004', 'BAN01'),
('PH02', 'Phòng nhân sự', 'NV005', 'BAN02'),
('PH03', 'Phòng dự án', 'NV006', 'BAN03');

INSERT INTO TEAM(MA_TEAM, TRNHOM, MAPH) VALUES
('TEAM1', 'NV007', 'PH01'),
('TEAM2', 'NV009', 'PH02'),
('TEAM3', 'NV006', 'PH03'),
('TEAM4', 'NV001', 'PH01');

INSERT INTO CONGVIEC(MACV, TENCV,  NGAYBD, NGAYKT, DO_UU_TIEN, TIENDO_HIENTAI) VALUES
('CV001', 'Phân tích yêu cầu khách hàng', '2021-01-01', '2021-01-31', 'Cao',null),
('CV002', 'Thiết kế trang web','2021-02-01', '2021-05-02','Trung binh',null);

INSERT INTO CONGVIEC_PC(MAPC, TENCV_PC, MACV, DO_UU_TIEN, TILE_TRONGCV,TIENDO_HIENTAI) VALUES
('PC001', 'Phân tích yêu cầu khách hàng', 'CV001', 'Cao', 1.0,NULL),
('PC002', 'Thiết kế giao diện', 'CV002', 'Trung bình', 0.4,NULL),
('PC003', 'Lập trình backend', 'CV002', 'Thấp', 0.4,NULL),
('PC004', 'gửi sản phẩm cho khách hàng', 'CV002', 'Thấp', 0.2,NULL);

INSERT INTO PC_CV_CHUNG(MACV, MA_TEAM, MAPC, NGAYBD, NGAYKT, DO_UU_TIEN) VALUES
('CV001', 'TEAM1', 'PC001', '2021-01-01', '2021-01-31', 'Cao'),
('CV002', 'TEAM2', 'PC002', '2021-02-01', '2021-03-15', 'Trung bình'),
('CV002', 'TEAM3', 'PC003', '2021-04-01', '2021-04-30', 'Thấp'),
('CV002', 'TEAM1', 'PC004', '2021-04-30', '2021-05-02', 'Thấp');



/*INSERT INTO PHEDUYET_CV(MAPD, MACV, DAT_YEUCAU, MAGD,GHICHU) VALUES
('PD001', 'CV001', 'đạt', 'NV001',NULL),
('PD002', 'CV002', ' chưa đạt', 'NV001',NULL);*/


INSERT INTO CV_CANHAN(MACV_CN, TENCV_CN, MAPC,TILE_TRONGCV,TIENDO_HIENTAI) VALUES
('CVCN1', 'phân tích yêu cầu','PC001',0.5,NULL),
('CVCN2', 'đánh giá yêu cầu khách hàng','PC001',0.5,NULL),
('CVCN3', 'lấy ý kiến của khách hàng','PC002',0.3,NULL),
('CVCN4', 'thiết kế giao diện', 'PC002',0.7,NULL),
('CVCN5', 'xây dựng chức năng', 'PC003',1.0,NULL),
('CVCN6', 'gửi sản phẩm cho khách hàng','PC004',1.0,NULL);


INSERT INTO PC_TEAM(MACV_CN, MANV, MAPC,NGAYBD, NGAYKT, DO_UU_TIEN) VALUES
('CVCN1', 'NV005', 'PC001','2021-01-01', '2021-01-15', 'Cao' ),
('CVCN2', 'NV005', 'PC001','2021-01-15', '2021-01-31', 'Trung bình'),
('CVCN3', 'NV008', 'PC002','2021-02-01', '2021-02-28', 'Thấp'),
('CVCN4', 'NV009', 'PC002','2021-02-01', '2021-03-15', 'Thấp'),
('CVCN5', 'NV010', 'PC003','2021-04-01', '2021-04-30', 'Thấp'),
('CVCN6', 'NV006', 'PC004','2021-05-01', '2021-05-02', 'Thấp');


INSERT INTO BC_CANHAN(MACV_CN, MANV, NGAYBC, TIENDO_BC) VALUES
('CVCN1', 'NV005', '2021-01-10', 1.0),
('CVCN2', 'NV005', '2021-01-17', 1.0),
('CVCN3', 'NV008', '2021-02-05', 0.6),
('CVCN4', 'NV009', '2021-02-10', 0.3),
('CVCN5', 'NV010', '2021-04-15', 0.7),
('CVCN6', 'NV006', '2021-05-2', 0.8);

UPDATE NHANVIEN 
SET MA_TEAM='TEAM3'
WHERE MANV='NV006';
UPDATE NHANVIEN 
SET  MAPH='PH03'
WHERE MANV='NV006';

UPDATE NHANVIEN 
SET MA_TEAM='TEAM2'
WHERE MANV='NV007';
UPDATE NHANVIEN 
SET  MAPH='PH03'
WHERE MANV='NV007';

UPDATE NHANVIEN 
SET MA_TEAM='TEAM2' 
WHERE MANV='NV008';
UPDATE NHANVIEN 
SET MAPH='PH03'
WHERE MANV='NV008';

UPDATE NHANVIEN 
SET MA_TEAM='TEAM3'
WHERE MANV='NV009';
UPDATE NHANVIEN 
SET  MAPH='PH03'
WHERE MANV='NV009';

UPDATE NHANVIEN 
SET MA_TEAM='TEAM3'
WHERE MANV='NV010';
UPDATE NHANVIEN 
SET MAPH='PH03'
WHERE MANV='NV010';

UPDATE NHANVIEN 
SET MAPH='PH01'
WHERE MANV='NV004';

UPDATE NHANVIEN 
SET MAPH='PH02'
WHERE MANV='NV005';
UPDATE NHANVIEN 
SET MA_TEAM='TEAM1'
WHERE MANV='NV005';



/*NGÀY BÁO CÁO PHẢI TRONG KHOẢNG THỜI GIAN PHÂN CÔNG*/


DELIMITER $$
CREATE TRIGGER check_ngay_bc_canhan
BEFORE INSERT ON BC_CANHAN
FOR EACH ROW
BEGIN
    DECLARE valid_date INT DEFAULT 0;
    SELECT COUNT(*) INTO valid_date
    FROM PC_TEAM 
    WHERE NEW.MACV_CN = MACV_CN AND NEW.NGAYBC BETWEEN NGAYBD AND NGAYKT;
    IF valid_date = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ngay bao cao khong dung!';
    END IF;
END$$
DELIMITER ;
DROP TRIGGER check_ngay_bc_canhan;
INSERT INTO BC_CANHAN(MACV_CN, MANV, NGAYBC, TIENDO_BC) VALUES
('CVCN1', 'NV007', '2021-02-10', 0.2);


/*NGÀY PHÂN CÔNG CÔNG VIỆC CHO CÁC THÀNH VIÊN TRONG TEAM PHẢI TRONG KHOẢNG THỜI GIAN PHÂN CÔNG CÔNG VIỆC CHO CÁC TEAM*/
DELIMITER $$
CREATE TRIGGER check_ngay_pc
BEFORE INSERT ON PC_TEAM
FOR EACH ROW
BEGIN
    DECLARE valid_date INT DEFAULT 0;
    SELECT COUNT(*) INTO valid_date
    FROM PC_CV_CHUNG 
    WHERE NEW.MAPC = MAPC AND NEW.NGAYBD >= NGAYBD AND NEW.NGAYKT <= NGAYKT;
    IF valid_date = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'thoi gian phan cong cho cac thanh vien trong team khong phu hop';
    END IF;
END$$
DELIMITER ;
INSERT INTO PC_TEAM(MACV_CN, MANV, MAPC,NGAYBD, NGAYKT, DO_UU_TIEN, TIENDO_HIENTAI) VALUES
('CVCN1', 'NV001', 'PC001','2021-05-01', '2021-05-15', 'Cao', null)


/*TỈ LỆ CÁC CÔNG VIỆC PHÂN CÔNG PHẢI CÓ TỔNG BẰNG 1*/
DELIMITER $$
CREATE TRIGGER check_cv_pc
BEFORE INSERT ON CONGVIEC_PC
FOR EACH ROW
BEGIN
    DECLARE total_sum DECIMAL(10,2) DEFAULT 0;
    SELECT SUM(TILE_TRONGCV) INTO total_sum
    FROM CONGVIEC_PC
    WHERE NEW.MACV = MACV;
    SET total_sum = total_sum + NEW.TILE_TRONGCV;
    IF total_sum > 1.0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ti le phan cong cong viec chua chinh xac';
    END IF;
END$$
DELIMITER ;
drop trigger check_cv_pc;
INSERT INTO CONGVIEC_PC(MAPC, TENCV_PC, MACV, DO_UU_TIEN, TILE_TRONGCV) VALUES
('PC006', 'gửi sản phẩm cho khách hàng', 'CV001', 'Thấp', 0.2);
delete from CONGVIEC_PC where mapc='PC006'

DELIMITER $$
CREATE TRIGGER check_cv_pc_team
BEFORE INSERT ON CV_CANHAN
FOR EACH ROW
BEGIN
    DECLARE total_sum DECIMAL(10,2) DEFAULT 0;
    SELECT SUM(TILE_TRONGCV) INTO total_sum
    FROM CV_CANHAN
    WHERE NEW.MAPC = MAPC;
    SET total_sum = total_sum + NEW.TILE_TRONGCV;
    IF total_sum > 1.0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ti le phan cong cong viec chua chinh xac';
    END IF;
END$$
DELIMITER ;
INSERT INTO CV_CANHAN(MACV_CN, TENCV_CN, MAPC,TIENDO_HIENTAI,TILE_TRONGCV) VALUES
('CVCN7', 'phân tích yêu cầu', 'PC001',null,0.5);

/**/
DELIMITER $$
CREATE TRIGGER check_TIENDO_BC_and_NGAYBC
BEFORE INSERT ON BC_CANHAN
FOR EACH ROW
BEGIN
    DECLARE previous_TIENDO_BC DECIMAL(10,2);
    DECLARE previous_NGAYBC DATE;
    SELECT TIENDO_BC, NGAYBC INTO previous_TIENDO_BC, previous_NGAYBC
    FROM BC_CANHAN
    WHERE MACV_CN = NEW.MACV_CN
    ORDER BY NGAYBC DESC
    LIMIT 1;
    IF (NEW.TIENDO_BC < previous_TIENDO_BC OR NEW.NGAYBC < previous_NGAYBC) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Loi nhap tien do hoac ngay bao cao!';
    END IF;
END$$
DELIMITER ;





/*CẬP NHẬT TIẾN ĐỘ CỦA CÁC CÔNG VIỆC CÁ NHÂN*/
DELIMITER $$
CREATE TRIGGER update_td_cn_them
AFTER INSERT ON BC_CANHAN
FOR EACH ROW
BEGIN
    UPDATE CV_CANHAN
    SET TIENDO_HIENTAI = NEW.TIENDO_BC
    WHERE MACV_CN = NEW.MACV_CN;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER update_td_cn_sua
AFTER UPDATE ON BC_CANHAN
FOR EACH ROW
BEGIN
    UPDATE CV_CANHAN
    SET TIENDO_HIENTAI = NEW.TIENDO_BC
    WHERE MACV_CN = NEW.MACV_CN;
END$$
DELIMITER ;

/*CẬP NHẬT TIẾN ĐỘ CỦA CÁC CÔNG VIỆC PHÂN CÔNG */
DELIMITER $$
CREATE TRIGGER update_tdpc_sua
AFTER UPDATE ON CV_CANHAN
FOR EACH ROW
BEGIN

        UPDATE CONGVIEC_PC
        SET TIENDO_HIENTAI = (SELECT SUM(TIENDO_HIENTAI * TILE_TRONGCV) FROM CV_CANHAN WHERE MAPC = NEW.MAPC)
        WHERE MAPC = NEW.MAPC;
  
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER insert_update_tdpc_them
AFTER INSERT ON CV_CANHAN
FOR EACH ROW
BEGIN
     UPDATE CONGVIEC_PC
        SET TIENDO_HIENTAI = (SELECT SUM(TIENDO_HIENTAI * TILE_TRONGCV) FROM CV_CANHAN WHERE MAPC = NEW.MAPC)
        WHERE MAPC = NEW.MAPC;
END$$
DELIMITER ;
/**/
DELIMITER $$
CREATE TRIGGER update_TDCV
AFTER UPDATE ON CONGVIEC_PC
FOR EACH ROW
BEGIN

        UPDATE CONGVIEC
        SET TIENDO_HIENTAI = (SELECT SUM(TIENDO_HIENTAI * TILE_TRONGCV) FROM CONGVIEC_PC WHERE MACV = NEW.MACV)
        WHERE MACV = NEW.MACV;
  
END$$
DELIMITER ;
/**/

DELIMITER $$
CREATE TRIGGER insert_into_PHEDUYET_CV
AFTER UPDATE ON CONGVIEC
FOR EACH ROW
BEGIN
     DECLARE next_MAPD CHAR(5);
    IF NEW.TIENDO_HIENTAI = 1.0 THEN
        SELECT CONCAT('PD', LPAD(COALESCE(MAX(SUBSTR(MAPD, 3)) + 1, 1), 3, '0')) INTO next_MAPD
        FROM PHEDUYET_CV;
        INSERT INTO PHEDUYET_CV (MAPD, MACV, MAGD)
        VALUES (next_MAPD, NEW.MACV, 'NV001');
    END IF;
END$$
DELIMITER ;

/**/
DELIMITER $$
CREATE TRIGGER insert_into_CONGVIEC
AFTER UPDATE ON PHEDUYET_CV
FOR EACH ROW
BEGIN
  DECLARE next_MACV CHAR(5);
        DECLARE current_TENCV VARCHAR(30);
    IF NEW.DAT_YEUCAU = 'Không đạt' THEN

        SELECT CONCAT('CV', LPAD(COALESCE(MAX(SUBSTR(MACV, 3)) + 1, 1), 3, '0')) INTO next_MACV
        FROM CONGVIEC;
        SELECT TENCV INTO current_TENCV
        FROM CONGVIEC
        WHERE MACV = NEW.MACV;
        INSERT INTO CONGVIEC (MACV, TENCV,DO_UU_TIEN)
        VALUES (next_MACV, current_TENCV,'Cao');
    END IF;
END$$
DELIMITER ;
/**/
DELIMITER $$
CREATE PROCEDURE generate_bonus_report()
BEGIN
    CREATE TEMPORARY TABLE bonus_report
    SELECT DISTINCT N.MANV, N.TENNV, MONTH(P.NGAYKT) as 'thang',
        CASE
            WHEN PD.DAT_YEUCAU = 'Đạt' AND N.MANV = (SELECT TRNHOM FROM TEAM WHERE MA_TEAM = N.MA_TEAM) THEN N.LUONG
            WHEN PD.DAT_YEUCAU = 'Đạt' THEN 0.5 * N.LUONG
            ELSE 0
        END AS BONUS
   
FROM NHANVIEN AS N JOIN PC_TEAM AS P ON N.MANV = P.MANV
JOIN CONGVIEC_PC AS CP ON P.MAPC = CP.MAPC
JOIN CONGVIEC AS C ON CP.MACV = C.MACV
JOIN PHEDUYET_CV AS PD ON PD.MACV = CP.MACV;
SELECT * FROM bonus_report;
DROP TABLE bonus_report;
END$$
DELIMITER ;

CALL generate_bonus_report();


/**/
DELIMITER //
CREATE PROCEDURE add_task(IN task_name VARCHAR(30), IN priority VARCHAR(30),IN DAYBD DATE, IN DAYKT DATE)
BEGIN
  DECLARE next_MACV CHAR(5);
  DECLARE next_MAPC CHAR(5);
   SELECT CONCAT('CV', LPAD(COALESCE(MAX(SUBSTR(MACV, 3)) + 1, 1), 3, '0')) INTO next_MACV
   FROM CONGVIEC;
    INSERT INTO CONGVIEC(MACV,TENCV, DO_UU_TIEN,NGAYBD,NGAYKT,TIENDO_HIENTAI) VALUES(next_MACV,task_name, priority,DAYBD,DAYKT,0);

   SELECT CONCAT('PC', LPAD(COALESCE(MAX(SUBSTR(MAPC, 3)) + 1, 1), 3, '0')) INTO next_MAPC
   FROM CONGVIEC_PC;
    INSERT INTO CONGVIEC_PC(MAPC,TENCV_PC, MACV, DO_UU_TIEN,TILE_TRONGCV,TIENDO_HIENTAI) VALUES( next_MAPC,task_name, next_MACV, priority,1,0);
SELECT TEAM.MA_TEAM, PHONG.TENPH
FROM TEAM
LEFT JOIN PHONG ON TEAM.MAPH = PHONG.MAPH
WHERE TEAM.MA_TEAM NOT IN (SELECT MA_TEAM FROM PC_CV_CHUNG);
END //
DELIMITER ;
INSERT INTO TEAM(MA_TEAM, TRNHOM, MAPH) VALUES
('TEAM4', 'NV001', 'PH01');
CALL add_task('New Task', 'Cao','2022-02-02','2022-02-10');


/**/
DELIMITER //
CREATE PROCEDURE suggest_teams_for_high_priority_tasks()
BEGIN
   
    DROP TEMPORARY TABLE IF EXISTS high_priority_tasks;
    CREATE TEMPORARY TABLE high_priority_tasks AS
    SELECT MACV,TENCV,TIENDO_HIENTAI
    FROM CONGVIEC
    WHERE DO_UU_TIEN = N'Cao'
    AND TIENDO_HIENTAI < 0.5;
    
    DROP TEMPORARY TABLE IF EXISTS low_priority_teams;
    CREATE TEMPORARY TABLE low_priority_teams AS
    SELECT DISTINCT MA_TEAM
    FROM PC_CV_CHUNG
    JOIN CONGVIEC ON PC_CV_CHUNG.MACV = CONGVIEC.MACV
    WHERE PC_CV_CHUNG.DO_UU_TIEN = N'Thấp';
    SELECT *
    FROM high_priority_tasks
    JOIN low_priority_teams;
END //
DELIMITER ;
CALL suggest_teams_for_high_priority_tasks();



