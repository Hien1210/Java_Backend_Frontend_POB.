package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.*;
import org.example.models.*;
import org.example.utils.PayOSUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Bấm "Thanh toán" từ giỏ hàng: GET hiện hóa đơn tạm để xác nhận,
 * POST tạo Order + OrderDetail từ CartItem (mỗi shop trong giỏ là 1 đơn riêng) rồi xóa giỏ hàng.
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final String REVIEW_VIEW = "/checkoutThanhToan.jsp";

    private final CartDAO cartDAO = new CartDAOImpl();
    private final CartItemDAO cartItemDAO = new CartItemDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();
    private final ProductSizeDAO productSizeDAO = new ProductSizeDAOImpl();
    private final ShopDAO shopDAO = new ShopDAOImpl();
    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Long cartId = parseId(req.getParameter("cartId"));
        if (cartId == null) {
            resp.sendRedirect(req.getContextPath() + "/cart?error=not_found");
            return;
        }

        Cart cart = cartDAO.findById(cartId);
        if (cart == null) {
            resp.sendRedirect(req.getContextPath() + "/cart?error=not_found");
            return;
        }

        List<CheckoutLine> lines = buildLines(cart);
        if (lines.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart?error=empty_cart");
            return;
        }

        showReview(req, resp, cart, lines, null);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Long cartId = parseId(req.getParameter("cartId"));
        Cart cart = cartId == null ? null : cartDAO.findById(cartId);
        if (cart == null) {
            resp.sendRedirect(req.getContextPath() + "/cart?error=not_found");
            return;
        }

        List<CheckoutLine> lines = buildLines(cart);
        if (lines.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart?error=empty_cart");
            return;
        }

        String receiverName = normalize(req.getParameter("receiverName"));
        String receiverPhone = normalize(req.getParameter("receiverPhone"));
        String shippingAddress = normalize(req.getParameter("shippingAddress"));
        String paymentMethod = normalize(req.getParameter("paymentMethod"));
        double deliveryFee = parseDouble(req.getParameter("deliveryFee"));

        String error = validate(receiverName, receiverPhone, shippingAddress, paymentMethod, deliveryFee);
        if (error != null) {
            showReview(req, resp, cart, lines, error);
            return;
        }

        Map<Long, List<CheckoutLine>> byShop = new LinkedHashMap<>();
        for (CheckoutLine line : lines) {
            byShop.computeIfAbsent(line.getShopId(), k -> new ArrayList<>()).add(line);
        }

        boolean isPayOS = "PAYOS".equals(paymentMethod);
        if (isPayOS && byShop.size() > 1) {
            showReview(req, resp, cart, lines, "Gio hang co nhieu shop, vui long thanh toan PayOS rieng cho tung shop (xoa bot san pham hoac chon COD)");
            return;
        }

        Shop payOsShop = null;
        if (isPayOS) {
            payOsShop = shopDAO.selectShopById(byShop.keySet().iterator().next());
            if (payOsShop == null || isBlank(payOsShop.getClientKey()) || isBlank(payOsShop.getApiKey()) || isBlank(payOsShop.getCheckSumKey())) {
                showReview(req, resp, cart, lines, "Shop nay chua cau hinh PayOS (Client ID/API Key/Checksum Key), vui long chon phuong thuc khac");
                return;
            }
        }

        List<Long> createdOrderIds = new ArrayList<>();
        for (Map.Entry<Long, List<CheckoutLine>> entry : byShop.entrySet()) {
            double subtotal = 0;
            for (CheckoutLine line : entry.getValue()) {
                subtotal += line.getLineTotal();
            }

            Order order = new Order();
            order.setUserId(cart.getUserId());
            order.setShopId(entry.getKey());
            order.setReceiverName(receiverName);
            order.setReceiverPhone(receiverPhone);
            order.setShippingAddress(shippingAddress);
            order.setPaymentMethod(paymentMethod);
            order.setStaTus("PENDING");
            order.setDeliveryFee(deliveryFee);
            order.setTotalPrice(subtotal + deliveryFee);

            long orderId = orderDAO.createAndReturnId(order);
            if (orderId <= 0) {
                showReview(req, resp, cart, lines, "Loi tao don hang, vui long thu lai");
                return;
            }

            for (CheckoutLine line : entry.getValue()) {
                OrderDetail detail = new OrderDetail();
                detail.setOrderId(orderId);
                detail.setProductId(line.getProductId());
                detail.setProductSizeId(line.getSizeId());
                detail.setQuantity(line.getQuantity());
                detail.setPrice(line.getUnitPrice());
                orderDetailDAO.create(detail);
            }

            createdOrderIds.add(orderId);
        }

        if (isPayOS) {
            long orderId = createdOrderIds.get(0);
            Order createdOrder = orderDAO.findById(orderId);
            long amount = Math.round(createdOrder.getTotalPrice());
            String baseUrl = baseUrl(req);
            String returnUrl = baseUrl + req.getContextPath() + "/payos/return?source=cart";
            String cancelUrl = returnUrl;
            String description = "Thanh toan DH" + orderId;
            if (description.length() > 25) {
                description = description.substring(0, 25);
            }

            PayOSUtil.PaymentLinkResult result = PayOSUtil.createPaymentLink(
                    payOsShop.getClientKey(), payOsShop.getApiKey(), payOsShop.getCheckSumKey(),
                    orderId, amount, description, returnUrl, cancelUrl);

            if (!result.success) {
                showReview(req, resp, cart, lines, "Khong tao duoc link thanh toan PayOS: " + result.errorMessage);
                return;
            }

            orderDAO.setPayosOrderCode(orderId, orderId);

            for (CartItem item : cartItemDAO.findByCartId(cart.getId())) {
                cartItemDAO.delete(item.getId());
            }

            resp.sendRedirect(result.checkoutUrl);
            return;
        }

        for (CartItem item : cartItemDAO.findByCartId(cart.getId())) {
            cartItemDAO.delete(item.getId());
        }

        StringBuilder ids = new StringBuilder();
        for (int i = 0; i < createdOrderIds.size(); i++) {
            if (i > 0) ids.append(',');
            ids.append(createdOrderIds.get(i));
        }
        resp.sendRedirect(req.getContextPath() + "/bill?orderIds=" + ids);
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String baseUrl(HttpServletRequest req) {
        StringBuilder sb = new StringBuilder();
        sb.append(req.getScheme()).append("://").append(req.getServerName());
        boolean isDefaultPort = ("http".equals(req.getScheme()) && req.getServerPort() == 80)
                || ("https".equals(req.getScheme()) && req.getServerPort() == 443);
        if (!isDefaultPort) {
            sb.append(":").append(req.getServerPort());
        }
        return sb.toString();
    }

    private void showReview(HttpServletRequest req, HttpServletResponse resp, Cart cart, List<CheckoutLine> lines, String error)
            throws ServletException, IOException {
        double subtotal = 0;
        for (CheckoutLine line : lines) {
            subtotal += line.getLineTotal();
        }

        req.setAttribute("cart", cart);
        req.setAttribute("lines", lines);
        req.setAttribute("subtotal", subtotal);
        if (error != null) {
            req.setAttribute("error", error);
        }
        req.getRequestDispatcher(REVIEW_VIEW).forward(req, resp);
    }

    private List<CheckoutLine> buildLines(Cart cart) {
        List<CheckoutLine> lines = new ArrayList<>();

        for (CartItem item : cartItemDAO.findByCartId(cart.getId())) {
            Product product = productDAO.findById(item.getProductId());
            if (product == null) {
                continue;
            }

            ProductSize size = productSizeDAO.findById(item.getProductSizeId());
            if (size == null) {
                continue;
            }

            Shop shop = shopDAO.selectShopById(product.getShopId());
            String shopName = shop == null ? ("Shop #" + product.getShopId()) : shop.getShopName();

            lines.add(new CheckoutLine(
                    product.getId(), product.getProductName(),
                    size.getId(), size.getSizeName(), size.getPrice(),
                    item.getQuantity(), product.getShopId(), shopName
            ));
        }

        return lines;
    }

    private String validate(String receiverName, String receiverPhone, String shippingAddress, String paymentMethod, double deliveryFee) {
        if (receiverName.isEmpty()) {
            return "Vui long nhap ten nguoi nhan";
        }
        if (receiverPhone.isEmpty()) {
            return "Vui long nhap so dien thoai nguoi nhan";
        }
        if (shippingAddress.isEmpty()) {
            return "Vui long nhap dia chi giao hang";
        }
        if (paymentMethod.isEmpty()) {
            return "Vui long chon phuong thuc thanh toan";
        }
        if (deliveryFee < 0) {
            return "Phi giao hang khong hop le";
        }
        return null;
    }

    private Long parseId(String value) {
        try {
            String normalized = normalize(value);
            return normalized.isEmpty() ? null : Long.parseLong(normalized);
        } catch (Exception e) {
            return null;
        }
    }

    private double parseDouble(String value) {
        try {
            String normalized = normalize(value);
            return normalized.isEmpty() ? 0 : Double.parseDouble(normalized);
        } catch (Exception e) {
            return -1;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }

    public static final class CheckoutLine {
        private final long productId;
        private final String productName;
        private final long sizeId;
        private final String sizeName;
        private final double unitPrice;
        private final int quantity;
        private final long shopId;
        private final String shopName;

        public CheckoutLine(long productId, String productName, long sizeId, String sizeName, double unitPrice,
                             int quantity, long shopId, String shopName) {
            this.productId = productId;
            this.productName = productName;
            this.sizeId = sizeId;
            this.sizeName = sizeName;
            this.unitPrice = unitPrice;
            this.quantity = quantity;
            this.shopId = shopId;
            this.shopName = shopName;
        }

        public long getProductId() { return productId; }
        public String getProductName() { return productName; }
        public long getSizeId() { return sizeId; }
        public String getSizeName() { return sizeName; }
        public double getUnitPrice() { return unitPrice; }
        public int getQuantity() { return quantity; }
        public long getShopId() { return shopId; }
        public String getShopName() { return shopName; }
        public double getLineTotal() { return unitPrice * quantity; }
    }
}
