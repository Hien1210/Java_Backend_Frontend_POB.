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
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.models.Account;

import java.io.IOException;
import java.util.List;

@WebServlet("/super-admin/shop-requests")
public class SuperAdminShopRequestServlet extends HttpServlet {

    private final ShopDAO shopDAO = new ShopDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Account admin = requireSuperAdmin(req, resp);
        if (admin == null) {
            return;
        }

        String action = req.getParameter("action");
        if ("detail".equals(action)) {
            showDetail(req, resp);
            return;
        }

        AccountDAO accountDAO = new AccountDAOImpl();
        List<Account> pendingShops = accountDAO.findPendingShopAccounts();
        req.setAttribute("pendingShops", pendingShops);
        req.getRequestDispatcher("/admin/yeuCauShop.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Account admin = requireSuperAdmin(req, resp);
        if (admin == null) {
            return;
        }

        Long shopId = parseId(req.getParameter("id"));
        if (shopId == null) {
            resp.sendRedirect(req.getContextPath() + "/super-admin/shop-requests?error=invalid_id");
            return;
        }

        String action = normalize(req.getParameter("action"));
        if ("accept".equals(action)) {
            boolean updated = shopDAO.updateShopApproval(shopId, "ACTIVE", null, admin.getId());
            if (!updated) {
                req.setAttribute("loi", "Khong the chap nhan yeu cau shop. Vui long kiem tra lai du lieu.");
                showDetail(req, resp);
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/super-admin/shop-requests?success=accepted");
            return;
        }

        if ("reject".equals(action)) {
            String reason = normalize(req.getParameter("rejectionReason"));
            if (reason.isEmpty()) {
                req.setAttribute("loi", "Vui long nhap ly do tu choi.");
                showDetail(req, resp);
                return;
            }

            boolean updated = shopDAO.updateShopApproval(shopId, "REJECTED", reason, admin.getId());
            if (!updated) {
                req.setAttribute("loi", "Khong the tu choi yeu cau shop. Vui long kiem tra lai du lieu.");
                showDetail(req, resp);
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/super-admin/shop-requests?success=rejected");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/super-admin/shop-requests");
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long shopId = parseId(req.getParameter("id"));
        if (shopId == null) {
            resp.sendRedirect(req.getContextPath() + "/super-admin/shop-requests?error=invalid_id");
            return;
        }

        Shop shop = shopDAO.selectShopById(shopId);
        if (shop == null) {
            req.setAttribute("loi", "Khong tim thay yeu cau shop.");
        } else {
            req.setAttribute("shop", shop);
        }

        req.getRequestDispatcher("/admin/chiTietYeuCauShop.jsp").forward(req, resp);
    }

    private Account requireSuperAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = session == null ? null : (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 1) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }

        return account;
    }

    private Long parseId(String value) {
        try {
            String normalized = normalize(value);
            return normalized.isEmpty() ? null : Long.parseLong(normalized);
        } catch (Exception e) {
            return null;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
