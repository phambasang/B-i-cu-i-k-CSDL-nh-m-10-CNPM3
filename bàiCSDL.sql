CREATE DATABASE quanlyhoatdongkinhdoanhthietbigiadinh ;
use quanlyhoatdongkinhdoanhthietbigiadinh

CREATE TABLE kho (
  ID varchar(10) PRIMARY KEY,
  ten_hang varchar(50),
  ngay_nhap date,
  ngay_xuat date,
  nguoi_nhap varchar(50),
  nguoi_xuat varchar(50)
);

CREATE TABLE nhanvien (
  ID varchar(10) PRIMARY KEY,
  ten_nhanvien varchar(50),
  ngay_vao_lam date,
  ngay_nghi date,
  gio_vao_lam varchar(50),
  gio_tanca varchar(50),
  ngay_nghi_phep date
);

CREATE TABLE hang_ban (
  ID varchar(10) PRIMARY KEY,
  ten_hang varchar(50),
  so_luong int,
  gia_ban int
);



CREATE TABLE hoa_don_ban (
  ID varchar(10) PRIMARY KEY,
  ngay_ban date,
  nhanvien_id varchar(10),
  FOREIGN KEY (nhanvien_id) REFERENCES nhanvien(ID)
);

CREATE TABLE ct_hoa_don_ban (
  ID varchar(10) PRIMARY KEY,
  hoa_don_ban_id varchar(10),
  FOREIGN KEY (hoa_don_ban_id) REFERENCES hoa_don_ban(ID),
  hang_ban_id varchar(10),
  FOREIGN KEY (hang_ban_id) REFERENCES hang_ban(ID),
  so_luong int,
  gia_ban int
);


INSERT INTO nhanvien(ID, ten_nhanvien, ngay_vao_lam, ngay_nghi, gio_vao_lam, gio_tanca, ngay_nghi_phep)
VALUES
('NV001', 'Nguyen Van A', '2022-01-01', '2022-01-02', '8:00', '17:00', '2022-01-15'),
('NV002', 'Tran Thi B', '2022-01-02', '2022-01-03', '8:30', '17:30', '2022-01-20'),
('NV003', 'Hoang Van C', '2022-01-03', '2022-01-04', '9:00', '18:00', '2022-01-25');


INSERT INTO kho(ID, ten_hang, ngay_nhap, ngay_xuat, nguoi_nhap, nguoi_xuat)
VALUES
('KHO001', 'Bàn làm việc', '2022-01-01', '2022-01-05', 'NV001', ''),
('KHO002', 'Ghế xoay', '2022-01-02', '2022-01-06', 'NV001', ''),
('KHO003', 'Kệ sách', '2022-01-03', '2022-01-07', 'NV002', ''),
('KHO004', 'Tủ quần áo', '2022-01-04', '2022-01-08', 'NV002', ''),
('KHO005', 'Giường ngủ', '2022-01-05', '2022-01-09', 'NV003', ''),
('KHO006', 'Bàn ăn', '2022-01-06', '2022-01-10', 'NV003', '');


INSERT INTO hang_ban(ID, ten_hang, so_luong, gia_ban)
VALUES
('HB001', 'Bàn làm việc', 10, 2000000),
('HB002', 'Ghế xoay', 20, 1000000),
('HB003', 'Kệ sách', 5, 1500000),
('HB004', 'Tủ quần áo', 7, 3000000),
('HB005', 'Giường ngủ', 8, 4000000),
('HB006', 'Bàn ăn', 15, 2500000);


INSERT INTO hoa_don_ban(ID, ngay_ban, nhanvien_id)
VALUES
('HD001', '2022-01-10', 'NV001'),
('HD002', '2022-01-11', 'NV002'),
('HD003', '2022-01-12', 'NV003');


INSERT INTO ct_hoa_don_ban (ID, hoa_don_ban_id, hang_ban_id, so_luong,  gia_ban)
VALUES 
('CTHD001','HD001', 'HB001',3, 250000),
('CTHD002','HD002', 'HB002',2, 500000),
('CTHD003','HD003', 'HB003', 500000, 3),
('CTHD004','HD003', 'HB004', 300000, 1);



CREATE LOGIN [sang] WITH PASSWORD=N'123456', 
DEFAULT_DATABASE=[quanlyhoatdongkinhdoanhthietbigiadinh], 
CHECK_EXPIRATION=OFF, 
CHECK_POLICY=OFF

--Xóa tài khoản người dùng đăng nhập
DROP LOGIN [sang];



UPDATE hang_ban
SET gia_ban = 50000
WHERE ID = 'HB001';


CREATE PROCEDURE Getkho
AS
BEGIN
    SELECT * FROM kho
END

EXEC Getkho


CREATE FUNCTION dbo.CalculateTotalPrice
(
    @gia_ban INT,
    @so_luong INT
)
RETURNS INT
AS
BEGIN
    DECLARE @tong_gia INT
    SET @tong_gia = @gia_ban * @so_luong
    RETURN @tong_gia END



CREATE TRIGGER update_so_luong_ban
AFTER INSERT ON ct_hoa_don_ban
FOR EACH ROW
BEGIN
    UPDATE hang_ban SET so_luong = so_luong - NEW.so_luong WHERE id = NEW.hang_ban_id;
END;

