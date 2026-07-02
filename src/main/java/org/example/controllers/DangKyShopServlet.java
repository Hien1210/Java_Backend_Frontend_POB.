package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.utils.EmailUtil;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/dangky-shop")
public class DangKyShopServlet extends HttpServlet {

    private static final String VIEW = "/registerShop.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        AccountDAO dao = new AccountDAOImpl();

        String username = normalize(req.getParameter("username"));
        String password = normalize(req.getParameter("password"));
        String confirmPassword = normalize(req.getParameter("confirm_password"));
        String fullname = normalize(req.getParameter("fullname"));
        String phone = normalize(req.getParameter("phone"));
        String email = normalize(req.getParameter("email"));

        if (password.length() < 8 || password.length() > 16 || password.contains(" ")) {
            fail(req, resp, "Mật khẩu phải từ 8-16 ký tự và không chứa khoảng trắng!", username, fullname, phone, email);
            return;
        }

        if (!password.equals(confirmPassword)) {
            fail(req, resp, "Mật khẩu không khớp!", username, fullname, phone, email);
            return;
        }

        if (dao.tonTaiEmail(email)) {
            fail(req, resp, "Email đã được đăng ký!", username, fullname, phone, email);
            return;
        }

        if (dao.tonTaiUsername(username)) {
            fail(req, resp, "Username đã được đăng ký!", username, fullname, phone, email);
            return;
        }

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));
        String otp = String.format("%06d", new java.security.SecureRandom().nextInt(1000000));

        try {
            String htmlContent = buildShopOtpEmail(otp, email);
            EmailUtil.sendEmail(email, "Xác nhận đăng ký Shop POB", htmlContent);
            System.out.println("📧 Email OTP Shop đã gửi đến: " + email);
        } catch (Exception e) {
            e.printStackTrace();
            fail(req, resp, "Không thể gửi email, vui lòng thử lại! (" + e.getMessage() + ")", username, fullname, phone, email);
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("username", username);
        session.setAttribute("password", hashedPassword);
        session.setAttribute("fullname", fullname);
        session.setAttribute("phone", phone);
        session.setAttribute("email", email);
        session.setAttribute("registerRoleId", 2L);

        resp.sendRedirect(req.getContextPath() + "/xacnhanotp");
    }

    /**
     * Khi có lỗi: hiển thị lại thông báo lỗi VÀ giữ lại dữ liệu người dùng đã nhập
     * (trừ mật khẩu).
     */
    private void fail(HttpServletRequest req, HttpServletResponse resp, String message,
                      String username, String fullname, String phone, String email)
            throws ServletException, IOException {
        req.setAttribute("loi", message);
        req.setAttribute("username", username);
        req.setAttribute("fullname", fullname);
        req.setAttribute("phone", phone);
        req.setAttribute("email", email);
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }

    private String buildShopOtpEmail(String otp, String email) {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Xác nhận đăng ký Shop</title>
        </head>
        <body style="margin:0;padding:0;font-family:'Segoe UI',Arial,sans-serif;background:#f4f7fb;">
            <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%%" style="max-width:600px;margin:40px auto;background:#ffffff;border-radius:16px;box-shadow:0 8px 32px rgba(0,0,0,0.08);overflow:hidden;">
                <tr>
                    <td style="background:linear-gradient(135deg,#1a1a2e,#273053);padding:32px 40px;text-align:center;">
                        <h1 style="color:#ffffff;font-size:24px;font-weight:700;margin:0;letter-spacing:1px;">🏪 POB</h1>
                        <p style="color:rgba(255,255,255,0.6);font-size:13px;margin:6px 0 0;letter-spacing:2px;">HỆ THỐNG ĐẶT HÀNG</p>
                    </td>
                </tr>
                <tr>
                    <td style="padding:40px 40px 30px;">
                        <h2 style="color:#1a1a2e;font-size:20px;font-weight:600;margin:0 0 8px;">Đăng ký Shop</h2>
                        <p style="color:#666;font-size:15px;line-height:1.6;margin:0 0 24px;">
                            Chào bạn,<br>
                            Vui lòng nhập mã OTP dưới đây để hoàn tất đăng ký tài khoản <strong>Shop</strong> trên hệ thống POB.
                        </p>
                        
                        <div style="background:#f8f9fc;border-radius:12px;padding:28px;text-align:center;border:1px dashed #d1d5e5;margin-bottom:24px;">
                            <div style="font-size:11px;color:#888;text-transform:uppercase;letter-spacing:1.5px;margin-bottom:8px;">Mã xác thực (OTP)</div>
                            <div style="font-size:36px;font-weight:800;color:#273053;letter-spacing:8px;font-family:'Courier New',monospace;">%s</div>
                            <div style="font-size:12px;color:#999;margin-top:10px;">⏳ Hiệu lực trong <strong>5 phút</strong></div>
                        </div>
                        
                        <div style="background:#f0fdf4;border-radius:8px;padding:14px 18px;border-left:4px solid #20d489;margin-bottom:24px;">
                            <p style="color:#166534;font-size:13px;margin:0;">📧 Email đăng ký: <strong>%s</strong></p>
                        </div>
                        
                        <p style="color:#888;font-size:13px;line-height:1.6;margin:0 0 8px;">
                            Nếu bạn không yêu cầu đăng ký, vui lòng bỏ qua email này.
                        </p>
                        <p style="color:#aaa;font-size:12px;margin:0;">
                            Mã OTP có hiệu lực trong 5 phút. Không chia sẻ mã này với bất kỳ ai.
                        </p>
                    </td>
                </tr>
                <tr>
                    <td style="background:#f8f9fc;padding:20px 40px;text-align:center;border-top:1px solid #e9ecef;">
                        <p style="color:#999;font-size:12px;margin:0;">
                            © 2025 POB - Hệ thống đặt hàng<br>
                            <span style="color:#bbb;">Email này được gửi tự động, vui lòng không trả lời.</span>
                        </p>
                    </td>
                </tr>
            </table>
        </body>
        </html>
        """.formatted(otp, email);
    }


}


