# TONG QUAN HE THONG

> File nay tom tat he thong la gi, lam duoc gi, dung cho ai. Doc PROJECT_STRUCTURE.md de tra endpoint/servlet/DAO/JSP cu the, doc CRUD_DA_LAM.md de xem lich su sua loi/them tinh nang, doc Database.md de xem schema DB day du.

## 1. He thong la gi

Day la **do an tot nghiep**: mot ung dung web **dat do an online** (mo hinh giong GrabFood/ShopeeFood thu nho) cho phep:
- Khach hang dat mon tu cac shop, thanh toan, theo doi don hang.
- Chu shop (shop owner) quan ly san pham/topping/don hang cua rieng minh, ban hang tai quay (POS).
- Shipper nhan va giao don hang.
- Super admin duyet shop moi dang ky, quan ly tai khoan, xem thong ke toan he thong.

## 2. Cong nghe su dung

- **Java Servlet/JSP thuan** (khong Spring), build bang **Maven**, chay tren **Apache Tomcat**.
- Kien truc 3 lop: **Servlet (Controller)** → **DAO (JDBC)** → **Model (POJO)**, hien thi qua **JSP (View)**.
- DB: **SQL Server** (driver `mssql-jdbc`), ket noi qua [DBUtil.java](src/main/java/org/example/utils/DBUtil.java).
- Mat khau hash bang `jbcrypt`. Gui email OTP bang `javax.mail` qua [EmailUtil.java](src/main/java/org/example/utils/EmailUtil.java).
- Thanh toan online qua **PayOS** ([PayOSUtil.java](src/main/java/org/example/utils/PayOSUtil.java)), ngoai ra con COD (tien mat) va BANK (QR chuyen khoan thu cong).

## 3. Cac vai tro (role) trong he thong

He thong phan quyen theo `role_id` trong bang `Accounts` (FK toi bang `Roles`):

| Role | Vai tro | Khu vuc JSP |
|---|---|---|
| Super Admin | Duyet shop dang ky, quan ly tai khoan, xem tong quan thong ke he thong | `admin/` |
| Shop (chu cua hang) | Quan ly san pham, topping, ban hang tai quay (POS), xem/quan ly hoa don cua shop | `shop/` |
| User | Khach hang: dat mon, gio hang, checkout, xem hoa don | thu muc goc `src/main/web/`, `user/` |
| Shipper | Nhan/giao don hang | `shipper/` |

`AuthFilter` ([AuthFilter.java](src/main/java/org/example/filter/AuthFilter.java)) chan truy cap theo role; moi servlet cung tu kiem tra session + `roleId` truoc khi xu ly (vd `ShopPosServlet` yeu cau `roleId == 2`).

## 4. Cac module chinh da lam duoc

### 4.1. Tai khoan & xac thuc
- Dang ky tai khoan khach hang (`DangKyServlet` — `/dangky`), xac nhan OTP qua email (`XacNhanOTPServlet` — `/xacnhanotp`).
- Dang nhap / dang xuat (`DangNhapServlet` — `/dangnhap`, `DangXuatServlet` — `/dangxuat`).
- Quen mat khau / dat lai mat khau qua OTP email (`QuenMatKhauServlet` — `/quenmatkhau`).
- Dang ky rieng cho Shipper (`Dangkyshipperservlet` — `/dangkyshipper`) va cho Shop (`DangKyShopServlet` — `/dangkyshop`, kem ho so cua hang gui cho Super Admin duyet).
- Mat khau hash bang `jbcrypt`, khong luu plain text.

### 4.2. Shop (chu cua hang)
- Dang ky mo shop → cho Super Admin duyet (`PENDING` → `ACTIVE`/`REJECTED`, kem ly do tu choi).
- Trang chu/dashboard rieng cua shop (`ShopHomeServlet` — `/shop/home`).
- **Quan ly san pham** (`ShopProductServlet` — `/shop/products`): them/sua/xoa san pham, gia theo tung size (khong phai gia chung o cap san pham), gan loai san pham.
- **Quan ly loai san pham** (`ShopProductTypeServlet` — `/shop/producttypes`): CRUD danh muc/loai mon cua shop.
- **Quan ly topping** (`ShopToppingServlet` — `/shop/toppings`): CRUD topping (gia rieng, gan vao loai topping).
- **Quan ly loai topping** (`QuanLyLoaiToppingServlet` — `/shop/toppingcategories`): CRUD nhom topping (vd "Size them", "Trang mieng"...).
- **Ho so cua hang** (`ShopProfileServlet` — `/shop/profile`): cap nhat dia chi, SDT, logo, mo ta, toa do (locationX/locationY), va key tich hop PayOS (`client_key`/`api_key`/`check_sum_key`).
- **Ban hang tai quay — POS "Bam Bill"** (`ShopPosServlet` — `/shop/pos`):
  - Chon mon + size + topping, tinh lai tien tu DB (khong tin gia client gui len) → tao Order/OrderDetail/OrderDetailTopping.
  - Chon 1 trong 3 hinh thuc thanh toan: COD (tien mat), BANK (QR chuyen khoan), PAYOS (tao link thanh toan PayOS qua API, redirect khach sang trang PayOS).
  - Don COD/BANK → `status=DONE` ngay (khach nhan hang + tra tien tai quay); don PAYOS → `status=PENDING` cho den khi xac nhan thanh toan.
  - Popup xac nhan hoa don sau khi tao don: xem lai chi tiet, **cap nhat trang thai thanh toan** (UNPAID/PENDING/PAID) qua action `updatePaymentStatus`, co banner bao luu thanh cong/that bai.
  - Huy don (`discardOrder`) khi thanh toan PayOS bi huy/loi — chi huy duoc don chua PAID cua dung shop.
  - In hoa don ngay tu popup.
- **Quan ly hoa don** (`ShopBillServlet` — `/shop/bills`, view `Quanlybill.jsp`): xem danh sach hoa don cua shop, loc theo tu khoa/ngay/trang thai thanh toan/hinh thuc thanh toan, xem chi tiet (`HoaDonShop.jsp`)/in hoa don (modal readonly).

### 4.3. Khach hang (User)
- Xem san pham theo shop (`ProductServlet`, `CategoryServlet`).
- **Gio hang** (`CartServlet` — `/cart`, `CartItemServlet` — `/cartitem`): them/sua so luong/xoa mon trong gio (kem topping da chon).
- **Checkout** (`CheckoutServlet` — `/checkout`): tao Order + OrderDetail (+ OrderDetailTopping) tu gio hang theo tung shop, chon hinh thuc thanh toan, xoa gio hang sau khi dat thanh cong.
- **Thanh toan online qua PayOS**: tao link thanh toan luc checkout, xu ly ket qua tra ve (`PayOSReturnServlet` — `/payos/return`) va webhook xac nhan thanh toan tu PayOS (`PayOSWebhookServlet` — `/payos/webhook`), ky/xac thuc bang HMAC-SHA256 voi `check_sum_key` cua tung shop.
- **Xem/in hoa don** sau khi dat (`BillServlet` — `/bill`).
- Quan ly don hang chung (`OrderServlet`, `OrderDetailServlet`) va log/lich su trang thai don (`OrderLogServlet`) — dung lam tang quan tri/du lieu noi bo.

### 4.4. Shipper
- **Trang danh sach don duoc giao** (`ShipperOrderServlet` — `/shipper/donhang`, view `trangchucuashipper.jsp`): xem cac don hang da gan cho minh (kem ten/dia chi/SDT shop, dia chi nhan, hinh thuc thanh toan, tong tien).
- **Cap nhat trang thai giao hang** tung phan: `READY_FOR_PICKUP` → `SHIPPING` (action `updateStatusToShipping`), `SHIPPING` → `DONE` (action `updateStatusToDone`) — chi cho phep tren don dung `shipperId` cua minh va dung trang thai hien tai (kiem tra ca hai dieu kien truoc khi update).
- *Luu y*: servlet nay co thuc va hoat dong nhung **chua duoc liet ke trong PROJECT_STRUCTURE.md** (thieu sot can bo sung trong tai lieu do). Hien **chua co man hinh gan shipper vao don** hay chuyen tiep `PENDING → CONFIRMED → READY_FOR_PICKUP`, nen luong giao hang day du tu dau-den-cuoi van chua hoan chinh (xem muc 6).

### 4.5. Super Admin
- Duyet/tu choi yeu cau mo shop (`SuperAdminShopRequestServlet` — kem ly do tu choi).
- Quan ly tai khoan toan he thong (`QuanLiTaiKhoanServlet`): xem/khoa/sua thong tin tai khoan cua moi role.
- Quan ly shop tong quat (`ShopServlet`).
- Trang tong quan he thong (`TongQuanServlet` — `/tong-quan`) — thong ke tong hop (qua `ThongKeDAO`).

### 4.6. Ha tang dung chung
- `BillUtil` — build hoa don dung chung cho ca luong khach hang (`/bill`) va shop (`/shop/bills`), tai su dung fragment `_invoiceModal.jspf` cho ca POS (mode "pos") va Quan ly hoa don (mode "readonly").
- DAO tu nhan dien schema thuc te qua `DatabaseMetaData` (ten bang so it/so nhieu, cot tuy chon nhu `is_deleted`, `payment_status`, `payos_order_code`, `shipper_id`...), cache lai trong bien static `CACHED_SCHEMA` (`OrderDAOImpl`) — **can restart app sau khi `ALTER TABLE` thu cong** de schema moi duoc nhan dien — xem chi tiet trong CRUD_DA_LAM.md.
- `AuthFilter`/`AppFilter` kiem tra dang nhap + phan quyen theo `role_id` truoc khi vao cac khu vuc `shop/`, `admin/`, `shipper/`.

## 5. Vong doi mot don hang (Order)

```
Tao don (POS hoac Checkout)
  └─ status (staTus): PENDING/CONFIRMED/READY_FOR_PICKUP/SHIPPING/DONE/CANCELLED
  └─ payment_status: UNPAID/PENDING/PAID

POS (tai quay):
  - PayOS         -> status=PENDING cho den khi PayOS xac nhan thanh toan
  - COD/BANK/CASH -> status=DONE ngay (vi khach nhan hang + tra tien tai quay)

Checkout (khach hang, giao hang):
  - Tao don voi status=PENDING, payment_status=UNPAID mac dinh
  - Shipper co man hinh cap nhat tung phan READY_FOR_PICKUP -> SHIPPING -> DONE
    (ShipperOrderServlet) nhung con thieu buoc PENDING -> CONFIRMED -> READY_FOR_PICKUP
    va buoc gan shipper vao don — xem muc 6
```

## 6. Han che / huong phat trien tiep theo

- **Chua co bao cao doanh thu** cho shop (theo ngay/tuan/thang, mon ban chay) — hien chi co danh sach don le.
- **Luong giao hang chua hoan chinh**: shipper da co man hinh chuyen `READY_FOR_PICKUP → SHIPPING → DONE` (`/shipper/donhang`), nhung con thieu: (1) man hinh/logic gan shipper vao don, va (2) buoc chuyen `PENDING → CONFIRMED → READY_FOR_PICKUP` cho shop xac nhan don dat qua app khach hang. Trang thai `DONE` qua POS thi co san vi khach nhan hang + tra tien ngay tai quay.
- `ShipperOrderServlet` (`/shipper/donhang`) **chua duoc liet ke trong PROJECT_STRUCTURE.md** — can bo sung vao bang endpoint cua tai lieu do.
- Mot so cot DB duoc them thu cong qua `ALTER TABLE` (vd `payment_status`, `payos_order_code`) nhung chua duoc dong bo vao script tao bang ban dau trong Database.md tai thoi diem them — can luon doi chieu schema thuc te khi gap loi "luu khong duoc" ma khong co exception ro rang.
