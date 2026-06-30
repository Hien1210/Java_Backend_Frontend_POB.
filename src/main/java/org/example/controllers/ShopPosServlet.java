package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.*;
import org.example.models.*;
import org.example.utils.BillUtil;
import org.example.utils.PayOSUtil;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

/**
 * "Bấm Bill" — shop owner tạo đơn hàng tại quầy (POS), chọn món + topping,
 * chọn phương thức thanh toán, xác nhận để tạo Order/OrderDetail/OrderDetailTopping.
 * URL: /shop/pos
 */
@WebServlet("/shop/pos")
public class ShopPosServlet extends HttpServlet {

    private static final String VIEW = "/shop/Banhang.jsp";

    private final ShopDAO shopDAO = new ShopDAOImpl();
    private final CategoryDAO categoryDAO = new CategoryDAOImpl();
    private final ProductDAO productDAO = new ProductDAOImpl();
    private final ProductSizeDAO productSizeDAO = new ProductSizeDAOImpl();
    private final ToppingCategoryDAO toppingCategoryDAO = new ToppingCategoryDAOImpl();
    private final ToppingDAO toppingDAO = new ToppingDAOImpl();
    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final OrderDetailDAO orderDetailDAO = new OrderDetailDAOImpl();
    private final OrderDetailToppingDAO orderDetailToppingDAO = new OrderDetailToppingDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Account account = requireShopAccount(req, resp);
        if (account == null) return;

        Shop shop = requireApprovedShop(req, resp, account);
        if (shop == null) return;

        Long invoiceId = parseLong(req.getParameter("invoiceId"));
        if (invoiceId != null) {
            Order order = orderDAO.findById(invoiceId);
            if (order != null && order.getShopId() == shop.getId()) {
                req.setAttribute("bill", BillUtil.build(order));
                req.setAttribute("modalMode", "pos");
            }
        }

        forwardPage(req, resp, shop);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Account account = requireShopAccount(req, resp);
        if (account == null) return;

        Shop shop = requireApprovedShop(req, resp, account);
        if (shop == null) return;

        String action = normalize(req.getParameter("action"));

        if ("updatePaymentStatus".equals(action)) {
            Long id = parseLong(req.getParameter("id"));
            String status = normalize(req.getParameter("status"));
            boolean saved = id != null && Boolean.TRUE.equals(orderDAO.updatePaymentStatus(id, shop.getId(), status));
            resp.sendRedirect(req.getContextPath() + "/shop/pos?invoiceId=" + id + "&saved=" + (saved ? "1" : "0"));
            return;
        }

        if ("discardOrder".equals(action)) {
            discardOrder(req, resp, shop);
            return;
        }

        // action=create (mặc định)
        createOrder(req, resp, shop, account);
    }

    /**
     * Huỷ đơn vừa tạo khi thanh toán PayOS thất bại/bị hủy ("không lưu bill") —
     * người dùng bấm "Xác nhận" trên trang thất bại, chỉ huỷ được đơn CHƯA thanh toán của đúng shop.
     */
    private void discardOrder(HttpServletRequest req, HttpServletResponse resp, Shop shop) throws IOException {
        Long id = parseLong(req.getParameter("id"));
        if (id != null) {
            Order order = orderDAO.findById(id);
            if (order != null && order.getShopId() == shop.getId() && !"PAID".equalsIgnoreCase(order.getPaymentStatus())) {
                for (OrderDetail detail : orderDetailDAO.findByOrderId(id)) {
                    orderDetailDAO.delete(detail.getId());
                }
                orderDAO.delete(id);
            }
        }
        resp.sendRedirect(req.getContextPath() + "/shop/pos");
    }

    // ── TẠO ĐƠN HÀNG TẠI QUẦY ───────────────────────────────────────────────

    private void createOrder(HttpServletRequest req, HttpServletResponse resp, Shop shop, Account account)
            throws ServletException, IOException {

        String[] productIds = req.getParameterValues("lineProductId[]");
        String[] sizeIds = req.getParameterValues("lineSizeId[]");
        String[] qtys = req.getParameterValues("lineQty[]");
        String[] toppingStrs = req.getParameterValues("lineToppings[]");

        if (productIds == null || productIds.length == 0) {
            req.setAttribute("loi", "Vui lòng chọn ít nhất 1 món trước khi xác nhận!");
            forwardPage(req, resp, shop);
            return;
        }

        String customerName = normalize(req.getParameter("customerName"));
        String paymentMethodInput = normalize(req.getParameter("paymentMethod")).toUpperCase(Locale.ROOT);
        String paymentMethodDb = mapPaymentMethod(paymentMethodInput);

        // Tính toán lại từ DB, không tin giá phía client gửi lên
        double total = 0;
        java.util.List<long[]> lineRefs = new java.util.ArrayList<>(); // [productId, sizeId, qty]
        java.util.List<Double> linePrices = new java.util.ArrayList<>();
        java.util.List<java.util.List<long[]>> lineToppingRefs = new java.util.ArrayList<>(); // [toppingId, qty]

        for (int i = 0; i < productIds.length; i++) {
            Long productId = parseLong(productIds[i]);
            Long sizeId = sizeIds != null && i < sizeIds.length ? parseLong(sizeIds[i]) : null;
            int qty = sizeIds != null && qtys != null && i < qtys.length ? parseInt(qtys[i], 1) : 1;
            if (productId == null || sizeId == null || qty <= 0) continue;

            Product product = productDAO.findById(productId, shop.getId());
            ProductSize size = productSizeDAO.findById(sizeId);
            if (product == null || size == null || size.getProductId() != productId) continue;

            double lineSubtotal = size.getPrice() * qty;
            java.util.List<long[]> toppingsForLine = new java.util.ArrayList<>();

            if (toppingStrs != null && i < toppingStrs.length && !toppingStrs[i].isBlank()) {
                for (String pair : toppingStrs[i].split(",")) {
                    String[] parts = pair.split(":");
                    if (parts.length != 2) continue;
                    Long toppingId = parseLong(parts[0]);
                    int toppingQty = parseInt(parts[1], 0);
                    if (toppingId == null || toppingQty <= 0) continue;

                    Topping topping = toppingDAO.findById(toppingId);
                    if (topping == null || topping.getShopId() != shop.getId()) continue;

                    lineSubtotal += topping.getPrice() * toppingQty;
                    toppingsForLine.add(new long[]{toppingId, toppingQty});
                }
            }

            total += lineSubtotal;
            lineRefs.add(new long[]{productId, sizeId, qty});
            linePrices.add(size.getPrice());
            lineToppingRefs.add(toppingsForLine);
        }

        if (lineRefs.isEmpty()) {
            req.setAttribute("loi", "Danh sách món không hợp lệ, vui lòng thử lại!");
            forwardPage(req, resp, shop);
            return;
        }

        boolean isPayOS = "PAYOS".equals(paymentMethodInput);
        if (isPayOS && (isBlank(shop.getClientKey()) || isBlank(shop.getApiKey()) || isBlank(shop.getCheckSumKey()))) {
            req.setAttribute("loi", "Shop chua cau hinh PayOS (Client ID/API Key/Checksum Key) trong Thong tin cua hang!");
            forwardPage(req, resp, shop);
            return;
        }

        Order order = new Order();
        order.setUserId(account.getId());
        order.setShopId(shop.getId());
        order.setReceiverName(customerName.isEmpty() ? "Khách tại quầy" : customerName);
        order.setReceiverPhone("0000000000");
        order.setShippingAddress("Tại quầy");
        order.setTotalPrice(total);
        order.setDeliveryFee(0.0);
        order.setPaymentMethod(paymentMethodDb);
        order.setPaymentStatus("CASH".equals(paymentMethodInput) ? "PAID" : "PENDING");
        order.setStaTus(isPayOS ? "PENDING" : "DONE");

        long orderId = orderDAO.createAndReturnId(order);
        if (orderId <= 0) {
            req.setAttribute("loi", "Không thể tạo đơn hàng, vui lòng thử lại!");
            forwardPage(req, resp, shop);
            return;
        }

        for (int i = 0; i < lineRefs.size(); i++) {
            long[] ref = lineRefs.get(i);
            OrderDetail detail = new OrderDetail();
            detail.setOrderId(orderId);
            detail.setProductId(ref[0]);
            detail.setProductSizeId(ref[1]);
            detail.setQuantity((int) ref[2]);
            detail.setPrice(linePrices.get(i));

            long detailId = orderDetailDAO.createAndReturnId(detail);
            if (detailId <= 0) continue;

            for (long[] toppingRef : lineToppingRefs.get(i)) {
                Topping topping = toppingDAO.findById(toppingRef[0]);
                if (topping == null) continue;
                OrderDetailTopping odt = new OrderDetailTopping();
                odt.setOrderDetailId(detailId);
                odt.setToppingId(toppingRef[0]);
                odt.setQuantity((int) toppingRef[1]);
                odt.setPrice(topping.getPrice());
                orderDetailToppingDAO.create(odt);
            }
        }

        if (isPayOS) {
            String baseUrl = baseUrl(req);
            String returnUrl = baseUrl + req.getContextPath() + "/payos/return?source=pos";
            String description = "Thanh toan DH" + orderId;
            if (description.length() > 25) {
                description = description.substring(0, 25);
            }

            PayOSUtil.PaymentLinkResult result = PayOSUtil.createPaymentLink(
                    shop.getClientKey(), shop.getApiKey(), shop.getCheckSumKey(),
                    orderId, Math.round(total), description, returnUrl, returnUrl);

            if (!result.success) {
                for (OrderDetail detail : orderDetailDAO.findByOrderId(orderId)) {
                    orderDetailDAO.delete(detail.getId());
                }
                orderDAO.delete(orderId);
                req.setAttribute("loi", "Khong tao duoc link thanh toan PayOS: " + result.errorMessage);
                forwardPage(req, resp, shop);
                return;
            }

            orderDAO.setPayosOrderCode(orderId, orderId);
            resp.sendRedirect(result.checkoutUrl);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/shop/pos?invoiceId=" + orderId);
    }

    private String mapPaymentMethod(String input) {
        switch (input) {
            case "QR": return "BANK";
            case "PAYOS": return "PAYOS";
            default: return "COD";
        }
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

    // ── FORWARD ──────────────────────────────────────────────────────────────

    private void forwardPage(HttpServletRequest req, HttpServletResponse resp, Shop shop)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.findByShopId(shop.getId());

        List<Product> products = productDAO.findByShopId(shop.getId());
        products.removeIf(p -> "HIDDEN".equalsIgnoreCase(p.getStaTus()));
        for (Product p : products) {
            p.setSizes(productSizeDAO.findByProductId(p.getId()));
        }

        List<ToppingCategory> toppingCategories = toppingCategoryDAO.findByShopId(shop.getId());
        List<Topping> toppings = toppingDAO.findByShopId(shop.getId());

        req.setAttribute("danhsachLoai", categories);
        req.setAttribute("danhsachSanPham", products);
        req.setAttribute("danhsachLoaiTopping", toppingCategories);
        req.setAttribute("danhsachTopping", toppings);

        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    // ── HELPERS ──────────────────────────────────────────────────────────────

    private Account requireShopAccount(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Account account = (session == null) ? null : (Account) session.getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return null;
        }
        if (account.getRoleId() != 2) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ tài khoản shop mới được truy cập!");
            return null;
        }
        return account;
    }

    private Shop requireApprovedShop(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {
        Shop shop = shopDAO.selectShopByOwnerId(account.getId());
        if (shop == null || !isAccepted(shop.getStatus())) {
            resp.sendRedirect(req.getContextPath() + "/shop");
            return null;
        }
        req.setAttribute("currentShop", shop);
        req.getSession().setAttribute("currentShop", shop);
        return shop;
    }

    private boolean isAccepted(String status) {
        String v = normalize(status).toLowerCase(Locale.ROOT);
        return "accept".equals(v) || "accepted".equals(v) || "approved".equals(v) || "active".equals(v);
    }

    private Long parseLong(String value) {
        try {
            String v = normalize(value);
            return v.isEmpty() ? null : Long.parseLong(v);
        } catch (Exception e) {
            return null;
        }
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(normalize(value));
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
