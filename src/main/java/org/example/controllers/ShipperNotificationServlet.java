package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.NotificationDAO;
import org.example.daos.NotificationDAOImpl;
import org.example.models.Account;
import org.example.models.Notification;

import java.io.IOException;
import java.util.List;

@WebServlet("/shipper/thongbao")
public class ShipperNotificationServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAOImpl();

    private Account getShipperAccount(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/dangnhap"); return null; }
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 4) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        return account;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Account account = getShipperAccount(req, resp);
        if (account == null) return;

        List<Notification> notifications = notificationDAO.findByAccountId(account.getId());
        int unreadCount = notificationDAO.countUnread(account.getId());

        req.setAttribute("notifications", notifications);
        req.setAttribute("unreadCount", unreadCount);
        req.getRequestDispatcher("/shipper/thongbao.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Account account = getShipperAccount(req, resp);
        if (account == null) return;

        String action = req.getParameter("action");
        if ("markAll".equals(action)) {
            notificationDAO.markAllAsRead(account.getId());
        } else {
            String idParam = req.getParameter("id");
            if (idParam != null) {
                try {
                    long id = Long.parseLong(idParam);
                    notificationDAO.markAsRead(id, account.getId());
                } catch (NumberFormatException ignored) {}
            }
        }
        resp.sendRedirect(req.getContextPath() + "/shipper/thongbao");
    }
}
