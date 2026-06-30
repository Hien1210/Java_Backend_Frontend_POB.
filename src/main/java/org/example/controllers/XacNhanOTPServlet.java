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

@WebServlet("/xacnhanotp")
public class XacNhanOTPServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/nhapOTP.jsp").forward(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Object otpSession = session.getAttribute("otp");
        if (otpSession == null) {
            resp.sendRedirect(req.getContextPath() + "/dangky");
            return;
        }

        String otp = otpSession.toString();
        String otp1 =  req.getParameter("otp1");
        String otp2 =  req.getParameter("otp2");
        String otp3 =  req.getParameter("otp3");
        String otp4=  req.getParameter("otp4");
        String otp5 =  req.getParameter("otp5");
        String otp6 =  req.getParameter("otp6");
        String otpNguoiDungNhap = otp1+otp2+otp3+otp4+otp5+otp6;
        if (otp.equals(otpNguoiDungNhap)){
            AccountDAO dao = new AccountDAOImpl();
            String username  = (String) session.getAttribute("username");
            String pass = (String)  session.getAttribute("password");
            String fullname = (String)  session.getAttribute("fullname");
            String phone =  (String) session.getAttribute("phone");
            String email =  (String) session.getAttribute("email");
            long roleId = getRegisterRoleId(session);

            Account account = new Account();
            account.setUserName(username);
            account.setPassWord(pass);
            account.setEmail(email);
            account.setFullName(fullname);
            account.setPhone(phone);
            account.setRoleId(roleId);
            boolean created = dao.create(account);

            if (created) {
                clearRegisterSession(session);

                // CHUYỂN HƯỚNG THEO ROLE
                if (roleId == 4) {
                    // SHIPPER -> chuyển đến trang chủ Shipper
                    resp.sendRedirect(req.getContextPath() + "/shipper/donhang");
                } else if (roleId == 2) {
                    // SHOP -> chuyển đến trang chủ Shop
                    resp.sendRedirect(req.getContextPath() + "/shop");
                } else if (roleId == 1) {
                    // ADMIN -> chuyển đến trang chủ Admin
                    resp.sendRedirect(req.getContextPath() + "/tong-quan");
                } else {
                    // USER -> quay về trang đăng nhập
                    req.setAttribute("thongbao", "Đăng ký thành công! Vui lòng đăng nhập.");
                    req.getRequestDispatcher("/DangNhap.jsp").forward(req, resp);
                }
                return;
            } else {
                req.setAttribute("loi", "Đăng ký thất bại, vui lòng thử lại!");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }
        } else {
            req.setAttribute("loi", "Mã OTP không chính xác!");
            req.getRequestDispatcher("/nhapOTP.jsp").forward(req, resp);
            return;
        }
    }


    private long getRegisterRoleId(HttpSession session) {
        Object role = session.getAttribute("registerRoleId");
        if (role instanceof Number) {
            return ((Number) role).longValue();
        }

        try {
            return Long.parseLong(String.valueOf(role));
        } catch (Exception e) {
            return 3L;
        }
    }

    private void clearRegisterSession(HttpSession session) {
        session.removeAttribute("otp");
        session.removeAttribute("username");
        session.removeAttribute("password");
        session.removeAttribute("fullname");
        session.removeAttribute("phone");
        session.removeAttribute("email");
        session.removeAttribute("registerRoleId");
    }
}
