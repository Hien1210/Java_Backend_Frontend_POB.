package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.OrderDAO;
import org.example.daos.OrderDAOImpl;
import org.example.daos.ShopDAO;
import org.example.daos.ShopDAOImpl;
import org.example.models.Order;
import org.example.models.Shop;
import org.example.utils.PayOSUtil;

import java.io.IOException;
import java.util.List;

/**
 * PayOS chuyển trình duyệt người dùng về đây sau khi thanh toán xong (thành công hoặc hủy)
 * kèm query string ?orderCode=...&status=...&code=...&cancel=...
 *
 * Query string có thể bị người dùng tự sửa trên URL nên KHÔNG tin trực tiếp, mà gọi lại API
 * PayOS (getPaymentStatus) bằng client_key/api_key của đúng shop để lấy trạng thái xác thực.
 */
@WebServlet("/payos/return")
public class PayOSReturnServlet extends HttpServlet {

    private static final String FAILED_VIEW = "/thanhToanThatBai.jsp";
    private static final String POS_FAILED_VIEW = "/shop/ThanhToanThatBaiPos.jsp";

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final ShopDAO shopDAO = new ShopDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String source = normalize(req.getParameter("source"));
        boolean isPos = "pos".equalsIgnoreCase(source);
        String failedView = isPos ? POS_FAILED_VIEW : FAILED_VIEW;

        Long orderCode = parseId(req.getParameter("orderCode"));
        if (orderCode == null) {
            req.setAttribute("loi", "Thieu thong tin don hang tu PayOS");
            req.getRequestDispatcher(failedView).forward(req, resp);
            return;
        }

        List<Order> orders = orderDAO.findByPayosOrderCode(orderCode);
        if (orders.isEmpty()) {
            req.setAttribute("loi", "Khong tim thay don hang ung voi ma PayOS " + orderCode);
            req.getRequestDispatcher(failedView).forward(req, resp);
            return;
        }

        Order order = orders.get(0);
        Shop shop = shopDAO.selectShopById(order.getShopId());
        if (shop == null) {
            req.setAttribute("loi", "Khong tim thay shop cua don hang");
            req.getRequestDispatcher(failedView).forward(req, resp);
            return;
        }

        String status = PayOSUtil.getPaymentStatus(shop.getClientKey(), shop.getApiKey(), orderCode);

        if ("PAID".equalsIgnoreCase(status)) {
            orderDAO.updatePaymentStatusByPayosOrderCode(orderCode, "PAID");
            if (isPos) {
                order.setStaTus("DONE");
                orderDAO.update(order);
                resp.sendRedirect(req.getContextPath() + "/shop/pos?invoiceId=" + order.getId());
            } else {
                resp.sendRedirect(req.getContextPath() + "/bill?orderIds=" + order.getId());
            }
            return;
        }

        req.setAttribute("loi", "Thanh toan PayOS khong thanh cong (trang thai: " + (status == null ? "khong xac dinh" : status) + ")");
        req.setAttribute("order", order);
        req.getRequestDispatcher(failedView).forward(req, resp);
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }

    private Long parseId(String value) {
        try {
            return (value == null || value.trim().isEmpty()) ? null : Long.parseLong(value.trim());
        } catch (Exception e) {
            return null;
        }
    }
}
