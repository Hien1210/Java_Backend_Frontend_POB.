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

/**
 * Servlet quản lý thông tin hồ sơ Shop (chỉnh sửa tên, mô tả, địa chỉ, SĐT, logo).
 * URL : /shop/profile
 * JSP : /admin/Shopprofile.jsp
 */
@WebServlet("/shop/profile")
public class ShopProfileServlet extends HttpServlet {

    private static final String VIEW = "/shop/Shopprofile.jsp";

    private final ShopDAO shopDAO = new ShopDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Account account = requireShopAccount(req, resp);
        if (account == null) return;

        Shop shop = requireApprovedShop(req, resp, account);
        if (shop == null) return;

        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Account account = requireShopAccount(req, resp);
        if (account == null) return;

        Shop shop = requireApprovedShop(req, resp, account);
        if (shop == null) return;

        String shopName = normalize(req.getParameter("shopName"));
        String shopDescription = normalize(req.getParameter("shopDescription"));
        String shopAddress = normalize(req.getParameter("shopAddress"));
        String shopPhone = normalize(req.getParameter("shopPhone"));
        String shopLogo = normalize(req.getParameter("shopLogo"));
        String clientKey = normalize(req.getParameter("clientKey"));
        String apiKey = normalize(req.getParameter("apiKey"));
        String checkSumKey = normalize(req.getParameter("checkSumKey"));

        if (shopName.isEmpty() || shopAddress.isEmpty() || shopPhone.isEmpty()) {
            req.setAttribute("loi", "Tên cửa hàng, địa chỉ và số điện thoại không được để trống!");
            Shop formShop = new Shop();
            formShop.setShopName(shopName);
            formShop.setShopDescription(shopDescription);
            formShop.setShopAddress(shopAddress);
            formShop.setShopPhone(shopPhone);
            formShop.setShopLogo(shopLogo);
            formShop.setClientKey(clientKey);
            formShop.setApiKey(apiKey);
            formShop.setCheckSumKey(checkSumKey);
            req.setAttribute("shopForm", formShop);
            req.getRequestDispatcher(VIEW).forward(req, resp);
            return;
        }

        // Chỉ cập nhật các trường hồ sơ + thông tin thanh toán (Client ID/API Key/Checksum Key), giữ nguyên trạng thái duyệt / owner.
        shop.setShopName(shopName);
        shop.setShopDescription(shopDescription);
        shop.setShopAddress(shopAddress);
        shop.setShopPhone(shopPhone);
        shop.setShopLogo(shopLogo);
        shop.setClientKey(clientKey);
        shop.setApiKey(apiKey);
        shop.setCheckSumKey(checkSumKey);

        shopDAO.updateShop(shop);

        resp.sendRedirect(req.getContextPath() + "/shop/profile?success=update");
    }

    private Account requireShopAccount(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        Account account = (session == null) ? null : (Account) session.getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        if (account.getRoleId() != 2) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ tài khoản shop mới được truy cập!");
            return null;
        }
        return account;
    }

    private Shop requireApprovedShop(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {
        Shop shop = shopDAO.selectShopByOwnerId(account.getId());
        if (shop == null || !isAccepted(shop.getStatus())) {
            resp.sendRedirect(req.getContextPath() + "/shop");
            return null;
        }
        req.setAttribute("currentShop", shop);
        req.getSession().setAttribute("currentShop", shop);
        return shop;
    }

    private boolean isAccepted(String status) {
        String v = normalize(status).toLowerCase();
        return "accept".equals(v) || "accepted".equals(v) || "approved".equals(v) || "active".equals(v);
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
