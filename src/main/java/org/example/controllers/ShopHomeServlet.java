package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.OrderDAO;
import org.example.daos.OrderDAOImpl;
import org.example.daos.ShopDAO;
import org.example.daos.ShopDAOImpl;
import org.example.daos.ShopDashboardDAO;
import org.example.daos.ShopDashboardDAOImpl;
import org.example.models.Account;
import org.example.models.Order;
import org.example.models.Shop;
import org.example.models.ShopDashboardStats;

import java.io.IOException;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/shop")
public class ShopHomeServlet extends HttpServlet {

    private final ShopDAO shopDAO = new ShopDAOImpl();
    private final ShopDashboardDAO shopDashboardDAO = new ShopDashboardDAOImpl();
    private final OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Account account = requireShopAccount(req, resp);
        if (account == null) {
            return;
        }

        Shop shop = shopDAO.selectShopByOwnerId(account.getId());
        forwardByShopStatus(req, resp, shop);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Account account = requireShopAccount(req, resp);
        if (account == null) {
            return;
        }

        Shop existingShop = shopDAO.selectShopByOwnerId(account.getId());
        if (existingShop != null && isPending(existingShop.getStatus())) {
            resp.sendRedirect(req.getContextPath() + "/shop");
            return;
        }

        if (existingShop != null && isAccepted(existingShop.getStatus())) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Shop đã được duyệt, không thể đăng ký lại.");
            return;
        }

        Shop shop = readShopInfo(req);
        shop.setOwnerId(account.getId());
        shop.setStatus("pending");
        shop.setRejectionReason(null);
        shop.setApprovedBy(0);
        shop.setApproveDate(null);

        if (existingShop != null && isRejected(existingShop.getStatus())) {
            shop.setId(existingShop.getId());
            shopDAO.updateShop(shop);
        } else {
            shopDAO.insertShop(shop);
        }

        resp.sendRedirect(req.getContextPath() + "/shop");
    }

    private void forwardByShopStatus(HttpServletRequest req, HttpServletResponse resp, Shop shop)
            throws ServletException, IOException {
        if (shop == null) {
            req.getRequestDispatcher("/shopDangKyThongTin.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("shop", shop);
        if (isPending(shop.getStatus())) {
            req.getRequestDispatcher("/shopChoDuyet.jsp").forward(req, resp);
        } else if (isAccepted(shop.getStatus())) {
            loadDashboard(req, shop.getId());
            req.getRequestDispatcher("/shop/trangcuahang.jsp").forward(req, resp);
        } else if (isRejected(shop.getStatus())) {
            req.getRequestDispatcher("/shopTuChoi.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/shopChoDuyet.jsp").forward(req, resp);
        }
    }

    private void loadDashboard(HttpServletRequest req, long shopId) {
        ShopDashboardStats stats = shopDashboardDAO.getDashboardStats(shopId);
        req.setAttribute("doanhThuHomNay", stats.getDoanhThuHomNay());
        req.setAttribute("doanhThuTuanNay", stats.getDoanhThuTuanNay());
        req.setAttribute("doanhThuThangNay", stats.getDoanhThuThangNay());
        req.setAttribute("tongDon", stats.getTongDon());
        req.setAttribute("donHoanThanh", stats.getDonHoanThanh());
        req.setAttribute("donHuy", stats.getDonHuy());
        req.setAttribute("donChoXuLy", stats.getDonChoXuLy());
        req.setAttribute("tongSanPham", stats.getTongSanPham());
        req.setAttribute("tongTopping", stats.getTongTopping());
        req.setAttribute("topSanPhamBanChay", stats.getTopSanPhamBanChay());
        req.setAttribute("doanhThu7NgayQua", stats.getDoanhThu7NgayQua());

        List<Order> donHangGanDay = orderDAO.findByShopId(shopId).stream()
                .sorted(Comparator.comparing(Order::getId).reversed())
                .limit(5)
                .collect(Collectors.toList());
        req.setAttribute("donHangGanDay", donHangGanDay);
    }

    private Account requireShopAccount(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = session == null ? null : (Account) session.getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }

        if (account.getRoleId() != 2) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ tài khoản shop mới được truy cập trang này.");
            return null;
        }

        return account;
    }

    private Shop readShopInfo(HttpServletRequest req) {
        Shop shop = new Shop();
        shop.setShopName(normalize(req.getParameter("shopName")));
        shop.setShopDescription(normalize(req.getParameter("shopDescription")));
        shop.setShopAddress(normalize(req.getParameter("shopAddress")));
        shop.setShopPhone(normalize(req.getParameter("shopPhone")));
        shop.setShopLogo(normalize(req.getParameter("shopLogo")));
        return shop;
    }

    private boolean isPending(String status) {
        return "pending".equalsIgnoreCase(normalize(status));
    }

    private boolean isAccepted(String status) {
        String value = normalize(status).toLowerCase();
        return "accept".equals(value) || "accepted".equals(value) || "approved".equals(value) || "active".equals(value);
    }

    private boolean isRejected(String status) {
        String value = normalize(status).toLowerCase();
        return "reject".equals(value) || "rejected".equals(value);
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
