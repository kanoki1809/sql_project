create database qlch
use qlch

--KHACHHANG (MAKH, TENKH,SDT,LOAIKH, GIOITINH)
CREATE TABLE KHACHHANG(
    MAKH INT PRIMARY KEY DEFAULT 0,
    TENKH NVARCHAR(100),
    SDT VARCHAR(20),
	DIACHI NVARCHAR(100),
    LOAIKH VARCHAR(10)  CHECK(LOAIKH IN ('New', 'Normal', 'VIP')) DEFAULT 'New',
	GIOITINH NVARCHAR(10)  CHECK(GIOITINH IN (N'Nam', N'Nữ'))
);
---
CREATE TABLE BAN
	(
	 SOBAN INT PRIMARY KEY,
	 TRANGTHAI NVARCHAR(20) CHECK (TRANGTHAI IN (N'TRỐNG', N'ĐÃ CÓ NGƯỜI')) DEFAULT N'TRỐNG'
	 );
	/*Tạo bảng KHO */

-- KHO(MANL, TENNL,DVT, SOLUONG, GIANHAP, GIABAN)
CREATE TABLE KHO(
	MANL INT PRIMARY KEY,
	TENNL NVARCHAR (100),
	DVT NVARCHAR(20),
	SOLUONG float,
	GIA float
	);

/*Tạo bảng nhân viên*/
--NHANVIEN(MANV, TENNV, NGAYVL,CHUCVU, GIOITINH, SDT)
CREATE TABLE Nhanvien
(
    MANV INT PRIMARY KEY,
    TENNV NVARCHAR(100),
    NGAYVL DATE,
	SDT VARCHAR(20),
    CHUCVU NVARCHAR(10)  CHECK (Chucvu IN(N'THU NGÂN', N'PHỤC VỤ', N'QUẢN LÝ', N'PHA CHẾ')),
	GIOITINH NVARCHAR(10)  CHECK (GIOITINH IN (N'Nam', N'Nữ')),
	LUONG FLOAT
);

/*Tạo bảng hóa đơn, MaKH khóa ngoại */
--HOADON (MAHD, MAKH, NGAYLAP, TONGTIEN, MANV)
CREATE TABLE HOADON(
    MaHD INT PRIMARY KEY DEFAULT 0,
	MANV INT,
    MAKH INT,
    NGAYLAP DATE,
    TONGTIEN FLOAT,
    FOREIGN KEY (MAKH) REFERENCES KHACHHANG(MAKH),
	FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)
);
/*Tạo bảng MENU */
--MENU (MASP, TENSP, GIA, SOLUONG) 
CREATE TABLE MENU(
    MASP INT PRIMARY KEY,
    TENSP NVARCHAR(100),
    GIA DECIMAL(10,2)
);
/*Tạo bảng chi tiết hóa đơn*/
--CTHD(MAHD, MASP, SOLUONG, GIA)
CREATE TABLE CTHD(
	MAHD INT,
	MASP INT,
	SOBAN INT,
	SOLUONG INT,
	GIA DECIMAL(12,2),
	GIAMGIA DECIMAL (2,2),
	FOREIGN KEY (MAHD) REFERENCES HOADON(MAHD),
	FOREIGN KEY (MASP)REFERENCES MENU(MASP),
	FOREIGN KEY (SOBAN)REFERENCES BAN(SOBAN),
	PRIMARY KEY (MAHD,MASP,SOBAN)
	);



/*Tạo bảng CÔNG THỨC */
-- CONGTHUC (MASP, MANL, SOLUONG)
CREATE TABLE CONGTHUC (
	MASP INT, 
	MANL INT,
	SOLUONG FLOAT,
	PRIMARY KEY (MASP, MANL),
	FOREIGN KEY (MASP) REFERENCES MENU(MASP),
	FOREIGN KEY (MANL) REFERENCES KHO(MANL)
	);

/*Tạo bảng HÓA ĐƠN NHẬP*/
-- HOADONNHAP(MAHDN, NGAYNHAP, TONGTIEN, MANV)
CREATE TABLE HOADONNHAP(
	MAHDN INT PRIMARY KEY,
	NGAYNHAP DATE,
	TONG DECIMAL (12,2),
	MANV INT,
	FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)
	);

/*Tạo bảng CHI TIẾT HÓA ĐƠN NHẬP*/
--CTHDNHAP (MAHDN, MANL, SOLUONG,GIA, CHIETKHAU)
CREATE TABLE CTHDNHAP (
	MAHDN INT,
	MANL INT,
	SOLUONG INT,
	THANHTIEN FLOAT,
	CHIETKHAU DECIMAL(2,2),
	PRIMARY KEY (MAHDN, MANL),
	FOREIGN KEY (MAHDN) REFERENCES HOADONNHAP(MAHDN),
	FOREIGN KEY (MANL) REFERENCES KHO(MANL)
	);




-- CA(MACA, GIOBD, GIOKT)
CREATE TABLE CA(
	MACA INT PRIMARY KEY,
	GIOBD TIME,
	GIOKT TIME
	);
	

CREATE TABLE LICHLAMVIEC
(
NGAY DATE,
MACA INT,
MANV INT,
GHICHU NVARCHAR(100),
FOREIGN KEY (MACA) REFERENCES CA(MACA),
FOREIGN KEY (MANV) REFERENCES NHANVIEN(MANV)
);

--Trigger setluong
go
CREATE TRIGGER SetLuongNhanVien
ON NHANVIEN
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Nhanvien
    SET Luong = CASE 
                        WHEN i.CHUCVU = N'THU NGÂN' THEN 25000
                        WHEN i.CHUCVU = N'PHỤC VỤ' THEN 25000
                        WHEN i.CHUCVU = N'PHA CHẾ' THEN 25000
                        WHEN i.CHUCVU = N'QUẢN LÝ' THEN 30000
                     
                    END
    FROM NHANVIEN NV
    INNER JOIN inserted I ON NV.MANV = I.MANV;

END;

--test setluongnv
INSERT INTO NHANVIEN (MANV, TENNV, NGAYVL, SDT, CHUCVU, GIOITINH)
VALUES
    (6, N'Trần A', '2023-05-01', '0364977341', N'THU NGÂN', N'Nam')
select *from nhanvien where manv=6

--Trigger tính tiền hàng HOADON
go
CREATE TRIGGER Total_Money
ON CTHD
AFTER INSERT, UPDATE
AS
BEGIN
     UPDATE CTHD
    SET GIAMGIA = CASE 
                        WHEN K.LOAIKH = 'New' THEN 0
                        WHEN K.LOAIKH = 'Normal' THEN 0.05
                        WHEN K.LOAIKH = 'VIP' THEN 0.1
                        
                    END
    FROM CTHD C, inserted i, HOADON H, KHACHHANG K
   WHERE I.MAHD=C.MAHD AND C.MAHD= H.MAHD AND H.MAKH= K.MAKH
	UPDATE CTHD SET gia = c.Soluong * p.Gia FROM inserted ins,CTHD c,Menu p WHERE   ins.MaHD = c.MaHD and c.MaSP= p.MaSP
    UPDATE Hoadon
    SET Tongtien = ( SELECT SUM(gia*(1-GIAMGIA))FROM CTHD WHERE CTHD.MaHD = inserted.MaHD)
    FROM Hoadon
    JOIN inserted ON Hoadon.MaHD = inserted.MaHD
END;

---test
INSERT INTO HOADON (MaHD, MANV, MAKH, NGAYLAP)
VALUES
    (11, 1, 2, '2023-05-02')
INSERT INTO CTHD (MAHD, MASP, SOBAN, SOLUONG)
VALUES
    -- MAHD 1
    (11, 1, 1, 2 ),
    (11, 2, 1, 1)

	select * from hoadon, cthd where hoadon.mahd=cthd.mahd and hoadon.mahd=11
	delete from   cthd where mahd=11
	 delete from hoadon where mahd=11
--Trigger tính tiền hàng HOADONNHAP biết giá nl ứng với số lượng là 1000 gam hoặc 1000ml
go
CREATE TRIGGER total_nhap
ON CTHDNHAP
AFTER INSERT, UPDATE
AS
BEGIN
    
	UPDATE CTHDNHAP SET Thanhtien = c.Soluong * p.Gia*0.001 FROM inserted ins,CTHDNHAP c,KHO p WHERE   ins.MaHDN = c.MaHDN and c.MaNL= p.MaNL
    UPDATE HOADONNHAP
    SET TONG = ( SELECT SUM(THANHTIEN*(1-CHIETKHAU))FROM CTHDNHAP WHERE CTHDNHAP.MaHDN = inserted.MaHDN)
    FROM HOADONNHAP H
    JOIN inserted ON H.MaHDN = inserted.MaHDN
END;

--trigger thêm số lượng trong kho khi nhập
go
CREATE TRIGGER Nhap_kho
ON CTHDNHAP
AFTER INSERT
AS
BEGIN
    UPDATE KHO
	SET SOLUONG =( kho.SOLUONG + (SELECT inserted.SOLUONG FROM CTHDNHAP Where CTHDNHAP.MAHDN = INSERTED.MAHDN AND INSERTED.MANL=CTHDNHAP.MANL))
	from kho
	join inserted on kho.MANL= inserted.MANL
END;
--test
select* from kho
INSERT INTO HOADONNHAP (MAHDN, NGAYNHAP, MANV)
VALUES
    (11, '2023-04-01', 1)
INSERT INTO CTHDNHAP (MAHDN, MANL, SOLUONG, CHIETKHAU)
VALUES
    (11, 1, 5000, 0.1)

select * from kho

drop trigger Nhap_kho
---trigger phân loại khách hàng
go
CREATE TRIGGER Khachhang_Phanloai
ON Hoadon
AFTER INSERT, update, delete
AS
BEGIN
    UPDATE Khachhang
    SET LoaiKH = 
        CASE 
            WHEN (SELECT COUNT(*) FROM Hoadon WHERE MaKh = inserted.MaKH) BETWEEN 1 AND 2 THEN 'New'
            WHEN (SELECT COUNT(*) FROM Hoadon WHERE MaKh = inserted.MaKH) BETWEEN 3 AND 5 THEN 'Normal'
            WHEN (SELECT COUNT(*) FROM Hoadon WHERE  MaKh = inserted.MaKH) > 5 OR (SELECT SUM(Tongtien) FROM Hoadon WHERE MaKH = inserted.MaKH) > 1000000 THEN 'VIP'
    
        END
    FROM Khachhang
    JOIN inserted ON Khachhang.MaKH = inserted.MaKH;

END;
go
CREATE TRIGGER Khachhang_Phanloai2
ON Hoadon
for delete
AS
BEGIN
    UPDATE Khachhang
    SET LoaiKH = 
        CASE 
            WHEN (SELECT COUNT(*) FROM Hoadon WHERE MaKh = deleted.MaKH) BETWEEN 1 AND 2 THEN 'New'
            WHEN (SELECT COUNT(*) FROM Hoadon WHERE MaKh = deleted.MaKH) BETWEEN 3 AND 5 THEN 'Normal'
            WHEN (SELECT COUNT(*) FROM Hoadon WHERE  MaKh = deleted.MAKH )> 5 OR (SELECT SUM(Tongtien) FROM Hoadon WHERE MaKH = deleted.MaKH) > 1000000 THEN 'VIP'
    
        END
    FROM Khachhang
    JOIN deleted ON Khachhang.MaKH = deleted.MaKH;

END;
---test phân loại kh
INSERT INTO HOADON (MaHD, MANV, MAKH, NGAYLAP)
VALUES
    (13, 1, 2, '2023-05-02'),
    (12, 1, 2, '2023-05-02')
SELECT k.makh, tenkh,loaiKH,COUNT(hd.mahd) AS 'Số lượng hoá đơn', SUM(hd.tongtien) AS 'Tổng tiền hàng'
FROM khachhang k
JOIN hoadon hd ON k.makh = hd.makh
GROUP BY k.makh, tenkh,loaikh



	delete  from hoadon where mahd =12
	delete  from hoadon where mahd =13
	drop trigger Khachhang_Phanloai
---TRIGGER TRẠNG THÁI BÀN
GO
CREATE TRIGGER FIND_TABLE
ON CTHD
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM CTHD WHERE MAHD = (SELECT MAHD FROM INSERTED) AND SOBAN <> (SELECT SOBAN FROM INSERTED))
        BEGIN
            RAISERROR('ĐÃ CÓ NGƯỜI', 16, 1)
            ROLLBACK TRANSACTION
            RETURN
        END
	ELSE
		BEGIN
            UPDATE BAN SET TRANGTHAI = N'ĐÃ CÓ NGƯỜI' WHERE SOBAN = (SELECT SOBAN FROM INSERTED)
        END
	
END;


INSERT INTO CTHD (MAHD, MASP, SOBAN, SOLUONG)
VALUES
   (1, 5, 1, 2 )
   select * from ban
 INSERT INTO CTHD (MAHD, MASP, SOBAN, SOLUONG)
VALUES
   (10, 5, 1, 2 )   

--- TRỪ NL--
   GO
   CREATE TRIGGER TRU_NL
ON CTHD
AFTER INSERT
AS
BEGIN
    DECLARE @MASP INT, @SOLUONG INT, @MANL INT, @SOLUONGNL INT

    SELECT @MASP = MASP, @SOLUONG = SOLUONG FROM INSERTED

    DECLARE mat_cursor CURSOR FOR
    SELECT MANL, SOLUONG FROM CONGTHUC WHERE MASP = @MASP

    OPEN mat_cursor

    FETCH NEXT FROM mat_cursor INTO @MANL, @SOLUONGNL

    WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE KHO SET SOLUONG = SOLUONG - (@SOLUONG * @SOLUONGNL) WHERE MANL = @MANL

            FETCH NEXT FROM mat_cursor INTO @MANL, @SOLUONGNL
        END

    CLOSE mat_cursor
    DEALLOCATE mat_cursor
END;

select * from kho
INSERT INTO CTHD (MAHD, MASP, SOBAN, SOLUONG)
VALUES
   (1, 9, 1, 2 )
select * from kho
select * from congthuc c,menu m where c.masp=9 and c.masp=m.masp



-- chèn dữ liệu vào bảng BAN
	INSERT INTO BAN (SOBAN)
VALUES 
    (1 ),
    (2 ),
    (3 ),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9),
    (10);

	
	/* Insert dữ liệu cho bảng KHO */
INSERT INTO KHO (MANL, TENNL, DVT, SOLUONG,GIA)
VALUES
(1, N'Bột kem sữa', N'ml', 5000,100000),
(2, N'Sữa đặc', N'ml', 1200,20000),
(3, N'Trà', N'gam', 500,200000),
(4, N'Đá', N'gam', 8000,10000),
(5, N'Siro cam', N'ml', 200,10000),
(6, N'Siro táo', N'ml', 100,10000),
(7, N'Siro thơm', N'ml', 900,10000),
(8, N'Hạt cafe robusta', N'gam', 400,300000),
(9, N'Trân châu', N'gam', 1000,50000),
(10, N'Hạt cafe arabica', N'gam', 300,150000);

-- Insert dữ liệu vào bảng KHACHHANG
INSERT INTO KHACHHANG ( MAKH,TENKH, SDT, DIACHI, GIOITINH)
VALUES
    ( 1,N'Nguyễn Văn An', '0123456789', N'Lê Thị Riêng, Quận 1, Hồ Chí Minh',  N'Nam'),
    ( 2,N'Nguyễn Thị Băng', '0987654321', N'Quận 3, Hồ Chí Minh', N'Nữ'),
    ( 3,N'Trần Văn Công', '0123412345', N'Quận 8, Hồ Chí Minh',N'Nam'),
    ( 4,N'Lê Thị Dương', '0123456789', N'Quận 6, Hồ Chí Minh', N'Nữ'),
    ( 5,N'Phạm Văn Em', '0987654321', N'Nha Trang',  N'Nam'),
    ( 6,N'Huỳnh Thị Thanh Ngân', '0123412345', N'Quận 10, Hồ Chí Minh', N'Nữ'),
    ( 7,N'Dương Văn Anh', '0123456789', N'Dĩ An,Bình Dương', N'Nam'),
    ( 8,N'Đỗ Thị Hoa', '0987654321', N'Thủ Đức, Hồ Chí Minh', N'Nữ'),
    ( 9,N'Lê Văn Khanh', '0123412345', N'Quận 2, Hồ Chí Minh',  N'Nam'),
    ( 10,N'Nguyễn Thị Kiều', '0123456789', N'Quận 5, Hồ Chí Minh',  N'Nữ');

	---TỰ THÊM MAKH--
go
CREATE TRIGGER Set_CustomerID
ON Khachhang
AFTER INSERT
AS
BEGIN
    DECLARE @maxID INT;
    SELECT @maxID = MAX(Makh) FROM khachhang;
    UPDATE khachhang
    SET Makh = @maxID + 1
    FROM khachhang k
    JOIN inserted I ON k.makh = I.Makh
END;
	
-- Insert dữ liệu vào bảng NHANVIEN
INSERT INTO NHANVIEN (MANV, TENNV, NGAYVL, SDT, CHUCVU, GIOITINH)
VALUES
    (1, N'Trần Hoàng Nguyên', '2023-05-01', '0364977341', N'THU NGÂN', N'Nam'),
    (2, N'Trần Hoàng Ánh Duyên', '2023-05-09', '0964395651', N'PHỤC VỤ', N'Nữ'),
    (3, N'Lê Hải Nam', '2023-05-12', '0372995253', N'PHA CHẾ', N'Nam'),
    (4, N'Trần Nguyễn Yến Nhi', '2023-06-01', '0965852984', N'PHỤC VỤ', N'Nữ'),
    (5, N'Nguyễn Thị Cẩm Ly', '2023-06-02', '0934882343', N'QUẢN LÝ', N'Nữ');



-- Chèn dữ liệu vào bảng HOADON
INSERT INTO HOADON (MaHD, MANV, MAKH, NGAYLAP)
VALUES
    (1, 1, 1, '2023-05-02'),
    (2, 1, 2, '2023-05-02'),
    (3, 1, 3, '2023-05-03'),
    (4, 2, 4, '2023-05-03'),
    (5, 1, 5, '2023-05-04'),
    (6, 3, 6, '2023-05-05'),
    (7, 5, 7, '2023-05-05'),
    (8, 5, 8, '2023-05-06'),
    (9, 4, 9, '2023-05-07'),
    (10, 1, 10,'2023-05-07');

	--TỰ THÊM MÃ HÓA ĐƠN--
go
CREATE TRIGGER Set_BillID
ON HOADON
AFTER INSERT
AS
BEGIN
    DECLARE @maxID INT;
    SELECT @maxID = MAX(MaHD) FROM HOADON;
    UPDATE HOADON
    SET MaHD = @maxID + 1
    FROM HOADON H
    JOIN inserted I ON H.MaHD = I.MaHD
END;
--test
INSERT INTO HOADON (MANV, MAKH, NGAYLAP)
VALUES
    ( 1, 2, '2023-05-02')
	select*from hoadon
--set day hóa đơn
go
CREATE TRIGGER Set_BillDate
ON HOADON
AFTER INSERT
AS
BEGIN
    UPDATE HOADON
    SET NGAYLAP = GETDATE()
    FROM HOADON H
    JOIN inserted I ON H.MaHD = I.MaHD
END;



-- Insert dữ liệu vào bảng Menu
INSERT INTO MENU (MASP, TENSP, GIA)
VALUES
    (1, N'Cà phê đen', 25000),
    (2, N'Trà sữa machiato', 35000),
    (3, N'Cà phê sữa', 30000),
    (4, N'Trà sữa truyền thống', 35000),
    (5, N'Trà sữa socola', 35000),
    (6, N'Cold brew', 30000),
    (7, N'Nước ép cam', 40000),
    (8, N'Nước ép thơm', 40000),
    (9, N'Nước ép táo', 40000),
    (10, N'Trân châu', 5000);


	INSERT INTO Ca (MaCa,  Giobd, Giokt)
  VALUES (1,  '07:00:00', '12:00:00'),
       (2,  '12:00:00', '17:00:00'),
       (3,  '17:00:00', '22:00:00');



-- Chèn dữ liệu vào bảng HOADONNHAP
INSERT INTO HOADONNHAP (MAHDN, NGAYNHAP, TONG, MANV)
VALUES
    (1, '2023-04-01', 0, 1),
    (2, '2023-05-02', 0, 1),
    (3, '2023-05-25', 0, 5),
    (4, '2023-06-01', 0, 4),
    (5, '2023-06-15', 0, 5);


-- Chèn dữ liệu vào bảng CTHDNHAP
INSERT INTO CTHDNHAP (MAHDN, MANL, SOLUONG, CHIETKHAU)
VALUES
    (1, 1, 5000, 0.1),
    (1, 2, 6000, 0.1),
    (2, 3, 3000, 0.2),
    (2, 4, 8000,  0.15),
    (3, 5, 20000,  0.1),
    (3, 6, 1000,  0.1),
    (3, 7, 9000,  0.12),
    (4, 8, 4000,  0.1),
    (4, 9, 6000,  0.15),
    (5, 10, 5000,  0.12);

---Chèn vào bảng LICHLAMVIEC
INSERT INTO LICHLAMVIEC (NGAY, MACA, MANV, GHICHU)
VALUES 
	('2023-05-02', 1, 2, N'Ca sáng'),
	('2023-05-02', 2, 4, N'Ca chiều'),
	('2023-05-02', 3, 3, N'Ca tối'),
	('2023-05-03', 1, 1, N'Ca sáng'),
	('2023-05-03', 2, 2, N'Ca chiều'),
	('2023-05-03', 3, 3, N'Ca tối'),
	('2023-05-04', 1, 4, N'Ca sáng'),
	('2023-05-04', 2, 3, N'Ca chiều'),
	('2023-05-04', 3, 5, N'Ca tối'),
	('2023-05-05', 1, 3, N'Ca sáng'),
	('2023-05-05', 2, 2, N'Ca chiều'),
	('2023-05-05', 3, 1, N'Ca tối'),
	('2023-05-06', 1, 4, N'Ca sáng'),
	('2023-05-06', 2, 3, N'Ca chiều'),
	('2023-05-06', 3, 2, N'Ca tối'),
	('2023-05-07', 1, 4, N'Ca sáng'),
	('2023-05-07', 2, 3, N'Ca chiều'),
	('2023-05-07', 3, 5, N'Ca tối');

--bảng CTHD
INSERT INTO CTHD (MAHD, MASP, SOBAN, SOLUONG)
VALUES
    -- MAHD 1
    (1, 1, 1, 2 ),
    (1, 2, 1, 1),
    (1, 3, 1, 3),
    -- MAHD 2
    (2, 4, 2, 2),
    (2, 5, 2, 1),   
    -- MAHD 3
    (3, 6, 3, 3),
    (3, 7, 3, 2),
    -- MAHD 4
    (4, 8, 4, 2),
    (4, 9, 4, 1),
    (4, 10, 4, 3),    
    -- MAHD 5
    (5, 1, 5, 2),
    (5, 2, 5, 1),
    (5, 3, 5, 3),  
    -- MAHD 6
    (6, 4, 6, 2),
    -- MAHD 7
    (7, 5, 7, 1),
    (7, 6, 7, 3),
    (7, 7, 7, 2),  
    -- MAHD 8
    (8, 8, 8, 2),
    -- MAHD 9
    (9, 9, 9, 1),
    (9, 10, 9, 3),
    -- MAHD 10
    (10, 1, 10, 2),
    (10, 2, 10, 1),
    (10, 3, 10, 3);

	/* Insert dữ liệu vào bảng CONGTHUC */
INSERT INTO CONGTHUC (MASP, MANL, SOLUONG)
VALUES
(1, 8, 20),
(1, 10, 10),
(2, 2, 10),
(2, 8, 10),
(2, 9, 50),
(3, 8, 10),
(3, 1, 10),
(3, 2,5),
(4, 8, 10),
(4, 3, 10),
(4, 4, 10),
(5, 8, 10),
(5, 3, 10),
(5, 5, 20),
(6, 8, 10),
(6, 6, 20),
(6, 4, 5),
(7, 7, 10),
(7, 4, 10),
(7, 5, 5),
(8, 7, 10),
(8, 3, 10),
(8, 6, 5),
(9, 7, 10),
(9, 4, 10),
(9, 6, 5),
(10, 9, 5)


----phân quyền
CREATE LOGIN LG1 WITH PASSWORD = '123'
CREATE LOGIN LG4 WITH PASSWORD = '123'
CREATE LOGIN LG5 WITH PASSWORD = '123'

GO

-- Tạo role
CREATE ROLE Quanly;


-- Tạo user
CREATE USER Quanly1 FOR LOGIN LG5
CREATE USER Thungan FOR LOGIN LG1
CREATE USER Phucvu FOR LOGIN LG4


-- Quản lý có toàn quyền trên bảng NHANVIEN, CHAMCONG, LICHLAMVIEC
GRANT ALL PRIVILEGES ON NHANVIEN TO Quanly
GRANT ALL PRIVILEGES ON CHAMCONG TO Quanly
GRANT ALL PRIVILEGES ON LICHLAMVIEC TO Quanly

-- Thu ngân có quyền truy vấn, cập nhật, thêm, xóa trên bảng CTHD
GRANT SELECT, UPDATE, INSERT, DELETE ON CTHD TO Thungan
-- Thu ngân có quyền truy vấn, cập nhật, thêm, xóa trên bảng KHACHHANG
GRANT SELECT, UPDATE, INSERT, DELETE ON KHACHHANG TO Thungan

-- Phục vụ có quyền truy vấn, cập nhật, thêm, xóa trên bảng MENU
GRANT SELECT, UPDATE, INSERT, DELETE ON MENU TO Phucvu


-- Phục vụ bị từ chối quyền INSERT trên bảng NHANVIEN
DENY INSERT ON NHANVIEN TO Phucvu

-- Thu ngân bị từ chối quyền DELETE bảng KHACHHANG
DENY DELETE ON KHACHHANG TO Thungan

-- Thu ngân bị xóa quyền truy vấn, cập nhật, thêm, xóa trên bảng KHACHHANG
REVOKE SELECT, UPDATE, INSERT, DELETE ON KHACHHANG FROM Thungan


BACKUP DATABASE qlch TO DISK = 'D:\Lyly\QLTT\TH\QLCHH.bak'

RESTORE DATABASE qlch FROM DISK = 'D:\Lyly\QLTT\TH\QLCHH.bak'




---proc quá trình order 
go
CREATE PROCEDURE CreateNewOrder @TENKH NVARCHAR(50), @MASP INT, @SL INT, @MANV INT
AS
BEGIN
    
 DECLARE @MAKH INT

    IF EXISTS (SELECT * FROM KHACHHANG WHERE TENKH = @TENKH)
        BEGIN
            SELECT @MAKH = MAKH FROM KHACHHANG WHERE TENKH = @TENKH
        END
    ELSE
        BEGIN
         SELECT  @MAKH= MAX(MAKH)+1 FROM KHACHHANG
           INSERT INTO KHACHHANG (MAKH,TENKH) VALUES (@MAKH,@TENKH)
		  
        END
		DECLARE @MAHD INT
		SELECT @MAHD= MAX(MAHD)+1 FROM HOADON
    INSERT INTO HOADON(MAHD,MAKH,MANV,NGAYLAP)VALUES  (@MAHD,@MAKH,@MANV,GETDATE())
    SELECT SOBAN AS N'CÁC BÀN TRỐNG' FROM BAN WHERE TRANGTHAI = N'TRỐNG'
	DECLARE @SOBAN INT
	IF EXISTS (SELECT * FROM BAN WHERE TRANGTHAI = N'TRỐNG')
	BEGIN
	SELECT @SOBAN = SOBAN FROM BAN WHERE TRANGTHAI = N'TRỐNG'
	END
    SELECT * FROM MENU
   INSERT INTO CTHD ( MAHD,MASP, SOBAN, SOLUONG) VALUES (@MAHD, @MASP, @SOBAN, @SL)
       
END;
EXEC CreateNewOrder @TENKH = N'NHI', @MASP =2,@SL=1, @MANV=4
select * from khachhang,hoadon,cthd,ban 
where khachhang.MAKH=hoadon.MAKH and hoadon.MaHD= cthd.MAHD  and cthd.SOBAN=ban.SOBAN and khachhang.MAKH=11

---proc tính lợi nhuận
go
CREATE PROCEDURE LoiNhuan_Time
    @FromDate DATE,
    @ToDate DATE
AS
BEGIN
    DECLARE @DoanhThu FLOAT;
    DECLARE @TongHoaDonNhap FLOAT;
    DECLARE @TongLuongNhanVien FLOAT;
    DECLARE @LuongTinhTheoGio FLOAT;
    DECLARE @LoiNhuan FLOAT;

    -- Tính tổng doanh thu
    SELECT @DoanhThu = SUM(HD.TONGTIEN)
    FROM HOADON HD
    WHERE HD.NGAYLAP BETWEEN @FromDate AND @ToDate;

    -- Tính tổng hóa đơn nhập
    SELECT @TongHoaDonNhap = SUM(HDN.TONG)
    FROM HOADONNHAP HDN
    WHERE HDN.NGAYNHAP BETWEEN @FromDate AND @ToDate;

	    -- Tính tổng lương nhân viên
	    SELECT @TongLuongNhanVien = SUM(Luong) 
    FROM (
        SELECT NV.MANV, SUM(DATEDIFF(HOUR, C.GIOBD, C.GIOKT)) * NV.LUONG AS Luong
        FROM Nhanvien NV
        INNER JOIN LichLamViec L ON NV.MANV = L.MANV
        INNER JOIN CA C ON L.MACA = C.MACA
        WHERE L.NGAY BETWEEN @FromDate AND @ToDate
        GROUP BY NV.MANV, NV.LUONG
    ) AS LuongNhanVien;


    -- Tính lợi nhuận
    SET @LoiNhuan = @DoanhThu - @TongHoaDonNhap - @TongLuongNhanVien ;

    SELECT @LoiNhuan AS LoiNhuan;
END;

---DROP PROC LoiNhuan_Time

go

DECLARE @FromDate DATE = '2023-05-01';
DECLARE @ToDate DATE = '2023-05-30';

EXEC  LoiNhuan_Time @FromDate, @ToDate

---Tính lương nhân viên trong khoảng thời gian
go
CREATE PROCEDURE LuongNV_Time
    @FromDate DATE,
    @ToDate DATE
AS
BEGIN
    SELECT NV.MANV, NV.TENNV, SUM(DATEDIFF(HOUR, C.GIOBD, C.GIOKT)) AS SoGioLamViec, NV.LUONG AS LuongGio
    INTO #TempLuong
    FROM LICHLAMVIEC L
    INNER JOIN CA C ON L.MACA = C.MACA
    INNER JOIN Nhanvien NV ON L.MANV = NV.MANV
    WHERE L.NGAY BETWEEN @FromDate AND @ToDate
    GROUP BY NV.MANV, NV.TENNV, NV.LUONG;

    SELECT MANV, TENNV, SoGioLamViec, SoGioLamViec * LuongGio AS Luong
    FROM #TempLuong;

    DROP TABLE #TempLuong;
END;

DECLARE @FromDate DATE = '2023-05-01';
DECLARE @ToDate DATE = '2023-05-30';

EXEC LuongNV_Time @FromDate, @ToDate



