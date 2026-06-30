# PROJECT_STRUCTURE.md

> Đọc file này trước khi sửa code. Mục tiêu: biết nhanh dự án làm gì, cấu trúc ra sao, và khi user yêu cầu một chức năng thì cần mở file nào.

## 1. Tổng quan

- Đồ án tốt nghiệp: ứng dụng web đặt đồ ăn (food ordering) — quản lý shop, sản phẩm, giỏ hàng, đơn hàng, shipper, tài khoản, super admin duyệt shop.
- Stack: **Java Servlet/JSP** thuần (không dùng Spring), build bằng **Maven**, chạy trên **Apache Tomcat**.
- Kiến trúc: Servlet (Controller) → DAO (truy cập DB qua JDBC) → Model (POJO) → JSP (View).
- DB: SQL Server (`mssql-jdbc`), kết nối qua [DBUtil.java](src/main/java/org/example/utils/DBUtil.java).
- Mật khẩu hash bằng `jbcrypt`. Gửi email OTP bằng `javax.mail` qua [EmailUtil.java](src/main/java/org/example/utils/EmailUtil.java).

## 2. Cấu trúc thư mục chính

```
src/main/java/org/example/
  controllers/   -> Servlet, mỗi servlet = 1 endpoint (@WebServlet)
  daos/          -> Data Access Object, có interface (XxxDAO) + impl (XxxDAOImpl)
  models/        -> POJO (entity), tên trùng bảng DB (số ít)
  filter/        -> Servlet Filter (auth, chặn truy cập)
  utils/         -> DBUtil (kết nối DB), EmailUtil (gửi mail OTP)

src/main/web/    -> JSP views (KHÔNG nằm trong WEB-INF nên có thể truy cập trực tiếp)
  shop/          -> trang quản lý cho shop owner (sản phẩm, topping, loại sản phẩm, hồ sơ shop...)
  admin/         -> trang cho super admin (duyệt shop, tổng quan hệ thống, quản lý tài khoản)
  user/          -> trang cho người dùng thường
  shipper/       -> trang cho shipper
  WEB-INF/       -> web.xml, config

pom.xml          -> Maven dependencies (jakarta servlet, mssql-jdbc, jstl, jbcrypt, javax.mail)
CRUD_DA_LAM.md   -> log các CRUD đã hoàn thành (cart, order, cart-items, order-details)
```

## 3. Bảng tra cứu nhanh: Endpoint → Servlet → DAO → JSP

| Endpoint (URL) | Servlet | DAO | Model | JSP liên quan |
|---|---|---|---|---|
| `/dangnhap` | [DangNhapServlet.java](src/main/java/org/example/controllers/DangNhapServlet.java) | AccountDAO | Account | [DangNhap.jsp](src/main/web/DangNhap.jsp) |
| `/dangky` | [DangKyServlet.java](src/main/java/org/example/controllers/DangKyServlet.java) | AccountDAO | Account | [register.jsp](src/main/web/register.jsp) |
| `/dangky-shipper` | [Dangkyshipperservlet.java](src/main/java/org/example/controllers/Dangkyshipperservlet.java) | AccountDAO | Account | [registerShipper.jsp](src/main/web/registerShipper.jsp) |
| `/dangky-shop` | [DangKyShopServlet.java](src/main/java/org/example/controllers/DangKyShopServlet.java) | ShopDAO | Shop | [registerShop.jsp](src/main/web/registerShop.jsp), [shopDangKyThongTin.jsp](src/main/web/shopDangKyThongTin.jsp) |
| `/logout` | [DangXuatServlet.java](src/main/java/org/example/controllers/DangXuatServlet.java) | - | - | - |
| `/quenmatkhau` | [QuenMatKhauServlet.java](src/main/java/org/example/controllers/QuenMatKhauServlet.java) | AccountDAO | Account | [quenmatkhau.jsp](src/main/web/quenmatkhau.jsp) |
| `/xacnhanotp` | [XacNhanOTPServlet.java](src/main/java/org/example/controllers/XacNhanOTPServlet.java) | AccountDAO | Account | [nhapOTP.jsp](src/main/web/nhapOTP.jsp) |
| `/quanlitaikhoan` | [QuanLiTaiKhoanServlet.java](src/main/java/org/example/controllers/QuanLiTaiKhoanServlet.java) | AccountDAO | Account | [quanlitaikhoan.jsp](src/main/web/quanlitaikhoan.jsp), [admin/quanlitaikhoan.jsp](src/main/web/admin/quanlitaikhoan.jsp) (trang super admin, không có servlet riêng forward tới) |
| `/cart` | [CartServlet.java](src/main/java/org/example/controllers/CartServlet.java) | [CartDAO.java](src/main/java/org/example/daos/CartDAO.java)/[CartDAOImpl.java](src/main/java/org/example/daos/CartDAOImpl.java) | [Cart.java](src/main/java/org/example/models/Cart.java) | [themSuaGioHang.jsp](src/main/web/themSuaGioHang.jsp), [quanLyGioHang.jsp](src/main/web/quanLyGioHang.jsp), [DanhSachGioHang.jsp](src/main/web/DanhSachGioHang.jsp) |
| `/cart-items` | [CartItemServlet.java](src/main/java/org/example/controllers/CartItemServlet.java) | CartItemDAO/Impl | [CartItem.java](src/main/java/org/example/models/CartItem.java) | [cartItemDanhSach.jsp](src/main/web/cartItemDanhSach.jsp), [cartItemThemSua.jsp](src/main/web/cartItemThemSua.jsp) |
| `/orders` | [OrderServlet.java](src/main/java/org/example/controllers/OrderServlet.java) | OrderDAO/Impl | [Order.java](src/main/java/org/example/models/Order.java) | [orderDanhSach.jsp](src/main/web/orderDanhSach.jsp), [orderThemSua.jsp](src/main/web/orderThemSua.jsp) |
| `/order-details` | [OrderDetailServlet.java](src/main/java/org/example/controllers/OrderDetailServlet.java) | OrderDetailDAO/Impl | [OrderDetail.java](src/main/java/org/example/models/OrderDetail.java) | [orderDetailDanhSach.jsp](src/main/web/orderDetailDanhSach.jsp), [orderDetailThemSua.jsp](src/main/web/orderDetailThemSua.jsp) |
| `/order-logs` | [OrderLogServlet.java](src/main/java/org/example/controllers/OrderLogServlet.java) | OrderLogDAO/Impl | [OrderLog.java](src/main/java/org/example/models/OrderLog.java) | - |
| `/checkout` | [CheckoutServlet.java](src/main/java/org/example/controllers/CheckoutServlet.java) | CartDAO, CartItemDAO, ProductDAO, ProductSizeDAO, ShopDAO, OrderDAO, OrderDetailDAO | Cart, CartItem, Order, OrderDetail | [checkoutThanhToan.jsp](src/main/web/checkoutThanhToan.jsp) |
| `/payos/return` | [PayOSReturnServlet.java](src/main/java/org/example/controllers/PayOSReturnServlet.java) | OrderDAO, ShopDAO + [PayOSUtil.java](src/main/java/org/example/utils/PayOSUtil.java) | Order, Shop | [thanhToanThatBai.jsp](src/main/web/thanhToanThatBai.jsp) (thất bại) hoặc redirect `/bill` (thành công) |
| `/payos/webhook` | [PayOSWebhookServlet.java](src/main/java/org/example/controllers/PayOSWebhookServlet.java) | OrderDAO, ShopDAO + PayOSUtil | Order, Shop | - (server-to-server, không có UI) |
| `/bill` | [BillServlet.java](src/main/java/org/example/controllers/BillServlet.java) | OrderDAO + [BillUtil.java](src/main/java/org/example/utils/BillUtil.java) | Order, [BillView](src/main/java/org/example/models/BillView.java) | [hoaDon.jsp](src/main/web/hoaDon.jsp) |
| `/shop/bills` | [ShopBillServlet.java](src/main/java/org/example/controllers/ShopBillServlet.java) | OrderDAO (findByShopId), ShopDAO + BillUtil | Order, Shop, BillView | [shop/Quanlybill.jsp](src/main/web/shop/Quanlybill.jsp), [shop/HoaDonShop.jsp](src/main/web/shop/HoaDonShop.jsp) |
| `/Category` | [CategoryServlet.java](src/main/java/org/example/controllers/CategoryServlet.java) | CategoryDAO/Impl | [Category.java](src/main/java/org/example/models/Category.java) | [taoCategory.jsp](src/main/web/taoCategory.jsp) |
| `/product` | [ProductServlet.java](src/main/java/org/example/controllers/ProductServlet.java) | ProductDAO/Impl, ProductSizeDAO/Impl | [Product.java](src/main/java/org/example/models/Product.java), [ProductSize.java](src/main/java/org/example/models/ProductSize.java), [ProductImage.java](src/main/java/org/example/models/ProductImage.java) | [taoProduct.jsp](src/main/web/taoProduct.jsp) |
| `/shops` | [ShopServlet.java](src/main/java/org/example/controllers/ShopServlet.java) | ShopDAO/Impl | [Shop.java](src/main/java/org/example/models/Shop.java) | [shopDanhSach.jsp](src/main/web/shopDanhSach.jsp), [shopThemSua.jsp](src/main/web/shopThemSua.jsp) |
| `/shop` (trang chủ shop) | [ShopHomeServlet.java](src/main/java/org/example/controllers/ShopHomeServlet.java) | ShopDAO | Shop | [shopTrangChu.jsp](src/main/web/shopTrangChu.jsp), [shop/trangcuahang.jsp](src/main/web/shop/trangcuahang.jsp) |
| `/shop/profile` | [ShopProfileServlet.java](src/main/java/org/example/controllers/ShopProfileServlet.java) | ShopDAO/Impl | Shop | [shop/Shopprofile.jsp](src/main/web/shop/Shopprofile.jsp) |
| `/shop/products` | [ShopProductServlet.java](src/main/java/org/example/controllers/ShopProductServlet.java) | ProductDAO/Impl, ProductSizeDAO/Impl | Product, ProductSize | [shop/Quanlysanpham.jsp](src/main/web/shop/Quanlysanpham.jsp) (giá theo size, không có giá ở cấp sản phẩm) |
| `/shop/product-types` | [ShopProductTypeServlet.java](src/main/java/org/example/controllers/ShopProductTypeServlet.java) | CategoryDAO/Impl | Category (cột DB: `name`, `description`, `is_deleted` — field `status` của model không có cột tương ứng, DAO tự bỏ qua) | [shop/Quanlyloaisanpham.jsp](src/main/web/shop/Quanlyloaisanpham.jsp) |
| `/shop/toppings` | [ShopToppingServlet.java](src/main/java/org/example/controllers/ShopToppingServlet.java) | [ToppingDAO.java](src/main/java/org/example/daos/ToppingDAO.java)/[ToppingDAOImpl.java](src/main/java/org/example/daos/ToppingDAOImpl.java) | [Topping.java](src/main/java/org/example/models/Topping.java) | [shop/Quanlytopping.jsp](src/main/web/shop/Quanlytopping.jsp) |
| `/shop/topping-categories` | [QuanLyLoaiToppingServlet.java](src/main/java/org/example/controllers/QuanLyLoaiToppingServlet.java) | [ToppingCategoryDAO.java](src/main/java/org/example/daos/ToppingCategoryDAO.java)/[ToppingCategoryDAOImpl.java](src/main/java/org/example/daos/ToppingCategoryDAOImpl.java) | [ToppingCategory.java](src/main/java/org/example/models/ToppingCategory.java) (cột DB: `name`, `description`, `is_deleted` — không có `status`) | [shop/Quanlyloaitopping.jsp](src/main/web/shop/Quanlyloaitopping.jsp) |
| `/super-admin/shop-requests` | [SuperAdminShopRequestServlet.java](src/main/java/org/example/controllers/SuperAdminShopRequestServlet.java) | ShopDAO/Impl | Shop | [shopChoDuyet.jsp](src/main/web/shopChoDuyet.jsp), [shopTuChoi.jsp](src/main/web/shopTuChoi.jsp), [admin/yeuCauShop.jsp](src/main/web/admin/yeuCauShop.jsp), [admin/chiTietYeuCauShop.jsp](src/main/web/admin/chiTietYeuCauShop.jsp) |
| `/tong-quan` | [TongQuanServlet.java](src/main/java/org/example/controllers/TongQuanServlet.java) | [ThongKeDAO.java](src/main/java/org/example/daos/ThongKeDAO.java)/[ThongKeDAOImpl.java](src/main/java/org/example/daos/ThongKeDAOImpl.java) | - | [admin/TongQuanHeThong.jsp](src/main/web/admin/TongQuanHeThong.jsp) |

## 4. Các trang JSP khác chưa gắn servlet rõ ràng (theo role)

- `user/trangnguoidung.jsp` — trang chủ người dùng.
- `shipper/trangchucuashipper.jsp` — trang chủ shipper.
- `quanLyCuaHang.jsp`, `shopThemSua.jsp` — quản lý cửa hàng.
- `index.jsp` — trang chủ chung.

## 5. Filter (chặn truy cập / phân quyền)

- [AuthFilter.java](src/main/java/org/example/filter/AuthFilter.java) — kiểm tra đăng nhập/phân quyền theo role.
- [AppFilter.java](src/main/java/org/example/filter/AppFilter.java) — filter chung của app (vd: set encoding).

## 6. Models (entity, tên bảng DB tương ứng)

`Account, Cart, CartItem, CartItemTopping, Category, Order, OrderDetail, OrderDetailTopping, OrderLog, Product, ProductImage, ProductSize, Role, Shop, Topping, ToppingCategory` — đều ở [src/main/java/org/example/models/](src/main/java/org/example/models).

## 7. Quy ước khi thêm chức năng mới (theo pattern đã có, xem [CRUD_DA_LAM.md](CRUD_DA_LAM.md))

1. Tạo `XxxDAO` (interface) + `XxxDAOImpl` trong `daos/`.
2. Tạo Servlet trong `controllers/` với `@WebServlet("/duong-dan")`, gọi DAO.
3. Tạo JSP danh sách (`xxxDanhSach.jsp`) + JSP thêm/sửa (`xxxThemSua.jsp`) trong `src/main/web/` (hoặc thư mục role tương ứng: `shop/` cho shop owner, `admin/` cho super admin, `user/`, `shipper/`).
4. Validate input ở servlet, redirect kèm `success`/`error` qua query string.
5. DAO nên tự dò tên bảng số ít/số nhiều và cột `is_deleted` (xoá mềm) nếu có, theo pattern đã dùng ở Cart/Order.

## 8. Khi user yêu cầu sửa/thêm tính năng — tra nhanh

- "Sửa giỏ hàng" → mục `/cart`, `/cart-items` ở bảng trên.
- "Sửa bấm bill/thanh toán/checkout/hóa đơn" → `/checkout` (giỏ hàng → tạo Order/OrderDetail), `/bill` (khách hàng xem/in hóa đơn), `/shop/bills` (shop owner xem/in hóa đơn các đơn thuộc shop mình, dùng chung [BillUtil.java](src/main/java/org/example/utils/BillUtil.java) với `/bill`).
- "Sửa đơn hàng" → mục `/orders`, `/order-details`.
- "Sửa trang quản lý sản phẩm/loại sản phẩm/topping của shop" → mục `/shop/products`, `/shop/product-types`, `/shop/toppings`, `/shop/topping-categories`, JSP trong `shop/`.
- "Sửa đăng nhập/đăng ký/quên mật khẩu/OTP" → các servlet `DangNhapServlet, DangKyServlet, QuenMatKhauServlet, XacNhanOTPServlet`.
- "Sửa duyệt shop / super admin" → `SuperAdminShopRequestServlet`, `TongQuanServlet`, JSP trong `admin/`.
- "Sửa kết nối DB" → [DBUtil.java](src/main/java/org/example/utils/DBUtil.java).
- "Sửa gửi mail" → [EmailUtil.java](src/main/java/org/example/utils/EmailUtil.java).
