package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.models.Account;

import java.io.IOException;

@WebServlet("/shipper/status")
public class ShipperStatusServlet extends HttpServlet {

    private final AccountDAO accountDAO = new AccountDAOImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        Object obj = session.getAttribute("account");
        if (!(obj instanceof Account)) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        Account account = (Account) obj;
        if (account.getRoleId() != 4) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        // Toggle trạng thái online
        boolean newStatus = !account.isOnline();
        boolean updated = accountDAO.updateShipperOnlineStatus(account.getId(), newStatus);

        if (updated) {
            // Cập nhật lại session để JSP đọc trạng thái mới ngay
            account.setOnline(newStatus);
            session.setAttribute("account", account);
        }

        resp.sendRedirect(req.getContextPath() + "/shipper/donhang");
    }
}
