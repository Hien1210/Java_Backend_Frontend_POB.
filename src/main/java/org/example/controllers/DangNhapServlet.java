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

@WebServlet("/dangnhap")
public class DangNhapServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
            req.getRequestDispatcher("/DangNhap.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        AccountDAO dao = new AccountDAOImpl();

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        Account account = dao.DangNhap(username, password);

        if (account != null) {
            // Lưu account vào session
            HttpSession session = req.getSession();
            session.setAttribute("account", account);
            session.setAttribute("role", account.getRoleId());

            // ✅ CHUYỂN HƯỚNG THEO ROLE
            int roleId = (int) account.getRoleId();
            switch (roleId) {
                case 1: // SUPER_ADMIN
                    resp.sendRedirect(req.getContextPath() + "/tong-quan");
                    return;
                case 2: // ADMIN (Shop)
                    resp.sendRedirect(req.getContextPath() + "/shop");
                    return;
                case 3: // USER
                    resp.sendRedirect(req.getContextPath() + "/index.jsp");
                    return;
                case 4: // SHIPPER
                    resp.sendRedirect(req.getContextPath() + "/shipper/donhang");
                    return;
                default:
                    resp.sendRedirect(req.getContextPath() + "/index.jsp");
                    return;
            }


        } else {
            req.setAttribute("loi", "Tên đăng nhập hoặc mật khẩu không đúng!");
            req.getRequestDispatcher("/DangNhap.jsp").forward(req, resp);
        }
    }
}
