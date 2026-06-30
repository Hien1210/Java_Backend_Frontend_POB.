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
import org.example.models.Account;
import org.example.models.Order;
import org.example.models.Shop;
import org.example.models.ShipperOrderView;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/shipper/donhang")
public class ShipperOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final ShopDAO shopDAO = new ShopDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = currentShipper(req);
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        List<Order> orders = orderDAO.findByShipperId(account.getId());
        List<ShipperOrderView> danhSachDonHang = new ArrayList<>();
        for (Order order : orders) {
            ShipperOrderView view = new ShipperOrderView();
            view.setId(order.getId());
            view.setStatus(order.getStaTus());
            view.setShippingAddress(order.getShippingAddress());
            view.setReceiverName(order.getReceiverName());
            view.setReceiverPhone(order.getReceiverPhone());
            view.setPaymentMethod(order.getPaymentMethod());
            view.setTotalPrice(order.getTotalPrice());
            view.setCreatedAt(order.getCreatedAt());

            Shop shop = shopDAO.selectShopById(order.getShopId());
            if (shop != null) {
                view.setShopName(shop.getShopName());
                view.setShopAddress(shop.getShopAddress());
                view.setShopPhone(shop.getShopPhone());
            }

            danhSachDonHang.add(view);
        }

        req.setAttribute("danhSachDonHang", danhSachDonHang);
        req.getRequestDispatcher("/shipper/trangchucuashipper.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account account = currentShipper(req);
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String orderIdParam = req.getParameter("orderId");
        String action = req.getParameter("action");

        if (orderIdParam != null && action != null) {
            long orderId;
            try {
                orderId = Long.parseLong(orderIdParam);
            } catch (NumberFormatException e) {
                orderId = 0;
            }

            Order order = orderId > 0 ? orderDAO.findById(orderId) : null;
            if (order != null && order.getShipperId() == account.getId()) {
                if ("updateStatusToShipping".equals(action) && "READY_FOR_PICKUP".equals(order.getStaTus())) {
                    order.setStaTus("SHIPPING");
                    orderDAO.update(order);
                } else if ("updateStatusToDone".equals(action) && "SHIPPING".equals(order.getStaTus())) {
                    order.setStaTus("DONE");
                    orderDAO.update(order);
                }
            }
        }

        resp.sendRedirect(req.getContextPath() + "/shipper/donhang");
    }

    private Account currentShipper(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return null;
        }
        Object obj = session.getAttribute("account");
        if (!(obj instanceof Account)) {
            return null;
        }
        Account account = (Account) obj;
        return account.getRoleId() == 4 ? account : null;
    }
}
