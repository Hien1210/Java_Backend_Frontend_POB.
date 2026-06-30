package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.*;
import org.example.models.Account;
import org.example.models.Shop;

import java.io.IOException;
import java.util.List;

@WebServlet("/tong-quan")
public class TongQuanServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        AccountDAO accountDAO = new AccountDAOImpl();
        ShopDAO shopDAO = new ShopDAOImpl();

        // * ĐÃ THAY BẰNG HÀM GỌI DB
        int tongTaiKhoan = accountDAO.getTotalAccounts();
        int shopChoDuyet = accountDAO.countPendingShopAccounts();
        int shipperHoatDong = accountDAO.countActiveShippers();
        List<Account> top5Shop = accountDAO.findTop5PendingShopAccounts();

        req.setAttribute("tongTaiKhoan", tongTaiKhoan);
        req.setAttribute("shopChoDuyet", shopChoDuyet);
        req.setAttribute("shipperHoatDong", shipperHoatDong);
        req.setAttribute("top5Shop", top5Shop);

        req.getRequestDispatcher("/admin/TongQuanHeThong.jsp").forward(req, resp);

    }
}
