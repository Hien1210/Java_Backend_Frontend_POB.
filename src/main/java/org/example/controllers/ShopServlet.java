package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.ShopDAO;
import org.example.daos.ShopDAOImpl;
import org.example.models.Account;
import org.example.models.Shop;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/shops")
public class ShopServlet extends HttpServlet {

    private ShopDAO shopDAO;

    @Override
    public void init() {
        // Khởi tạo đối tượng DAO kết nối SQL Server
        shopDAO = new ShopDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đồng bộ tiếng Việt khi client gửi dữ liệu qua phương thức POST
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        doGet(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đồng bộ tiếng Việt cho phương thức GET
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 1. KIỂM TRA ĐĂNG NHẬP VÀ QUYỀN TRUY CẬP (VÒNG TRONG)
        HttpSession session = request.getSession();
        Account currentAcc = (Account) session.getAttribute("account");

        if (currentAcc == null) {
            response.sendRedirect(request.getContextPath() + "/DangNhap.jsp");
            return;
        }

        long roleId = currentAcc.getRoleId();
        // Nếu là Người mua hàng (Role 3) -> Từ chối truy cập ngay lập tức
        if (roleId == 3) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Tài khoản của bạn không có quyền vào khu vực quản lý này!");
            return;
        }

        if (roleId == 2) {
            Shop ownerShop = shopDAO.selectShopByOwnerId(currentAcc.getId());
            if (ownerShop == null || !isAccepted(ownerShop.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/shop");
                return;
            }
        }

        // 2. ĐIỀU HƯỚNG CÁC HÀNH ĐỘNG CRUD
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "new":
                    // Chỉ có Chủ shop (Role 2) mới được quyền đăng ký shop mới
                    if (roleId == 1) {
                        showNewForm(request, response);
                    } else {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ tài khoản Chủ cửa hàng mới có thể tạo shop mới!");
                    }
                    break;

                case "insert":
                    if (roleId == 2) {
                        insertShop(request, response, currentAcc);
                    } else {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Hành vi bị từ chối!");
                    }
                    break;

                case "edit":
                    showEditForm(request, response, currentAcc);
                    break;

                case "update":
                    updateShop(request, response, currentAcc);
                    break;

                case "delete":
                    // CHỈ ADMIN (Role 1) mới được quyền xóa mềm shop khỏi hệ thống
                    if (roleId == 1) {
                        deleteShop(request, response);
                    } else {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xóa cửa hàng này!");
                    }
                    break;

                default:
                    listShops(request, response, currentAcc);
                    break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    // --- CÁC HÀM XỬ LÝ LOGIC CHI TIẾT ---

    // 1. LẤY DANH SÁCH: Admin xem hết, Chủ shop chỉ xem được shop của mình
    private void listShops(HttpServletRequest request, HttpServletResponse response, Account currentAcc)
            throws ServletException, IOException {
        List<Shop> allShops = shopDAO.selectAllShops();
        List<Shop> filteredList = new ArrayList<>();

        if (currentAcc.getRoleId() == 1) {
            // Admin (Role 1) -> Lấy toàn bộ danh sách để kiểm duyệt
            filteredList = allShops;
        } else if (currentAcc.getRoleId() == 2) {
            // Chủ shop (Role 2) -> Lọc chỉ hiển thị shop có owner_id trùng với id tài khoản đang đăng nhập
            filteredList = allShops.stream()
                    .filter(shop -> shop.getOwnerId() == currentAcc.getId())
                    .collect(Collectors.toList());
        }

        request.setAttribute("listShop", filteredList);
        request.getRequestDispatcher("/shopDanhSach.jsp").forward(request, response);
    }

    // 2. MỞ TRANG THÊM MỚI
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/shopThemSua.jsp").forward(request, response);
    }

    // 3. LƯU BẢN GHI THÊM MỚI
    private void insertShop(HttpServletRequest request, HttpServletResponse response, Account currentAcc)
            throws IOException {
        Shop newShop = extractShopFromRequest(request);

        // BẢO MẬT: Ép buộc ownerId phải là ID của tài khoản đang đăng nhập, không lấy từ form nhằm tránh hack đổi ID
        newShop.setOwnerId(currentAcc.getId());

        shopDAO.insertShop(newShop);
        response.sendRedirect("shops");
    }

    // 4. MỞ TRANG CẬP NHẬT (EDIT): Chống sửa chéo shop của người khác
    private void showEditForm(HttpServletRequest request, HttpServletResponse response, Account currentAcc)
            throws ServletException, IOException {
        long id = Long.parseLong(request.getParameter("id"));
        Shop existingShop = shopDAO.selectShopById(id);

        if (existingShop == null) {
            response.sendRedirect("shops?error=notfound");
            return;
        }

        // BẢO MẬT: Nếu là Chủ shop (Role 2) nhưng cố tình đổi tham số ?id= trên URL để xem shop khác -> Chặn lại ngay
        if (currentAcc.getRoleId() == 2 && existingShop.getOwnerId() != currentAcc.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không được quyền chỉnh sửa cửa hàng của người khác!");
            return;
        }

        request.setAttribute("shop", existingShop);
        request.getRequestDispatcher("/shopThemSua.jsp").forward(request, response);
    }

    // 5. LƯU DỮ LIỆU CẬP NHẬT (UPDATE)
    private void updateShop(HttpServletRequest request, HttpServletResponse response, Account currentAcc)
            throws IOException {
        long id = Long.parseLong(request.getParameter("id"));
        Shop existingShop = shopDAO.selectShopById(id);

        if (existingShop == null) {
            response.sendRedirect("shops?error=notfound");
            return;
        }

        // BẢO MẬT: Kiểm tra lại quyền chính chủ trước khi lưu vào DB lần cuối
        if (currentAcc.getRoleId() == 2 && existingShop.getOwnerId() != currentAcc.getId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Hành động trái phép!");
            return;
        }

        Shop updateData = extractShopFromRequest(request);
        updateData.setId(id); // Gan ID de chay lenh WHERE id = ?

        // Luôn bảo toàn các trường quan trọng không cho phép sửa qua form
        updateData.setOwnerId(existingShop.getOwnerId());
        updateData.setStatus(existingShop.getStatus());
        updateData.setRejectionReason(existingShop.getRejectionReason());
        updateData.setApprovedBy(existingShop.getApprovedBy());
        updateData.setApproveDate(existingShop.getApproveDate());

        shopDAO.updateShop(updateData);
        response.sendRedirect("shops");
    }

    // 6. XÓA MỀM (Chỉ đổi trạng thái is_deleted trong DB thành 1)
    private void deleteShop(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        long id = Long.parseLong(request.getParameter("id"));
        shopDAO.deleteShop(id);
        response.sendRedirect("shops");
    }

    /**
     * Hàm phụ trợ bóc tách dữ liệu an toàn từ Form sang Đối tượng Shop.
     */
    private Shop extractShopFromRequest(HttpServletRequest request) {
        Shop shop = new Shop();

        shop.setShopName(request.getParameter("shopName"));
        shop.setShopDescription(request.getParameter("shopDescription"));
        shop.setShopAddress(request.getParameter("shopAddress"));
        shop.setShopPhone(request.getParameter("shopPhone"));
        shop.setShopLogo(request.getParameter("shopLogo"));
        shop.setStatus(request.getParameter("status"));
        shop.setRejectionReason(request.getParameter("rejectionReason"));

        // Xử lý an toàn trường người duyệt (Approved By)
        String approvedByStr = request.getParameter("approvedBy");
        if (approvedByStr != null && !approvedByStr.trim().isEmpty()) {
            shop.setApprovedBy(Long.parseLong(approvedByStr));
        } else {
            shop.setApprovedBy(0);
        }

        // Xử lý an toàn trường thời gian duyệt (Approved At)
        String approveDatStr = request.getParameter("approveDate");
        if (approveDatStr != null && !approveDatStr.trim().isEmpty()) {
            shop.setApproveDate(LocalDateTime.parse(approveDatStr));
        } else {
            shop.setApproveDate(null);
        }

        return shop;
    }

    private boolean isAccepted(String status) {
        if (status == null) {
            return false;
        }

        String value = status.trim().toLowerCase();
        return "accept".equals(value) || "accepted".equals(value) || "approved".equals(value) || "active".equals(value);
    }
}
