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
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * Webhook server-to-server PayOS gọi khi 1 link thanh toán đổi trạng thái.
 * Phải cấu hình URL này (https://<domain-public>/payos/webhook) trên PayOS Dashboard của shop.
 * Chỉ dùng để xác thực phụ; nguồn xác thực chính khi user còn ở trình duyệt là /payos/return
 * (gọi lại API PayOS để lấy trạng thái thật, không tin query string).
 */
@WebServlet("/payos/webhook")
public class PayOSWebhookServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final ShopDAO shopDAO = new ShopDAOImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String body = readBody(req);

        JSONObject json;
        try {
            json = new JSONObject(body);
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        JSONObject data = json.optJSONObject("data");
        String signature = json.optString("signature", null);
        if (data == null || signature == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        long orderCode = data.optLong("orderCode", -1);
        if (orderCode < 0) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        List<Order> orders = orderDAO.findByPayosOrderCode(orderCode);
        if (orders.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        Order order = orders.get(0);
        Shop shop = shopDAO.selectShopById(order.getShopId());
        if (shop == null || shop.getCheckSumKey() == null) {
            resp.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        boolean validSignature = PayOSUtil.verifyWebhookSignature(shop.getCheckSumKey(), data, signature);
        if (!validSignature) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String code = json.optString("code", "");
        if ("00".equals(code)) {
            orderDAO.updatePaymentStatusByPayosOrderCode(orderCode, "PAID");
        }

        resp.setStatus(HttpServletResponse.SC_OK);
    }

    private String readBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new java.io.BufferedReader(
                new java.io.InputStreamReader(req.getInputStream(), StandardCharsets.UTF_8))) {
            char[] buf = new char[1024];
            int n;
            while ((n = reader.read(buf)) != -1) {
                sb.append(buf, 0, n);
            }
        }
        return sb.toString();
    }
}
