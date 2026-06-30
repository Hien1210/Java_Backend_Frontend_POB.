package org.example.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.models.Account;

import java.io.IOException;

@WebFilter(urlPatterns = "/*")
public class AppFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String url = req.getRequestURI();

        System.out.println("Có người đã truy cập vào trang: " + url);

        if (url.endsWith(req.getContextPath() + "/") ||
                url.contains("/dangnhap") ||
                url.contains("/dangky") ||
                url.contains("/xacnhanotp") ||
                url.contains("/register.jsp") ||
                url.contains("/nhapOTP.jsp") ||
                url.contains("/DangNhap.jsp") ||
                url.contains("/quenmatkhau") ||
                url.contains("/logout") ||
                url.contains("/index.jsp") ||
                url.contains(".css") || url.contains(".js") || url.contains(".png") ||
                url.contains(".jpg") || url.contains(".ico") || url.contains("*"))

        {

            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        Account account = null;

        if (session != null) {
            account = (Account) session.getAttribute("account");
        }

        if (account == null) {
            System.out.println("Chưa đăng nhập, redirect về /dangnhap. URL bị chặn: " + url);
            resp.sendRedirect(req.getContextPath() + "/dangnhap"); // Đổi thành /dangnhap cho đồng bộ
            return;
        }

        // SUPER_ADMIN (roleId = 1)
        if (url.contains("/super-admin/") || url.contains("/super_admin/")) {
            if (account.getRoleId() != 1) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập!");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // ADMIN (roleId = 2) - Chủ shop
        if (url.contains("/admin/") || url.contains("/shop")) {
            // Cho phép role 1 (Super Admin) và role 2 (Shop Owner)
            if (account.getRoleId() != 1 && account.getRoleId() != 2) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập!");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // SHIPPER (roleId = 4)
        if (url.contains("/shipper/")) {
            if (account.getRoleId() != 4) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập!");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // USER (roleId = 3)
        if (url.contains("/user/")) {
            if (account.getRoleId() != 3) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập!");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}
