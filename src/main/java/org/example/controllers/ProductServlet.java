package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.CategoryDAO;
import org.example.daos.CategoryDAOImpl;
import org.example.daos.ProductDAO;
import org.example.daos.ProductDAOImpl;
import org.example.daos.ShopDAO;
import org.example.daos.ShopDAOImpl;
import org.example.models.Product;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Locale;

@WebServlet("/product")
public class ProductServlet extends HttpServlet {
    private final ProductDAO dao = new ProductDAOImpl();
    private final ShopDAO shopDAO = new ShopDAOImpl();
    private final CategoryDAO categoryDAO = new CategoryDAOImpl();
    private static final String VIEW = "/taoProduct.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("edit".equals(action)) {
            Long id = parseId(req);
            if (id == null) {
                req.setAttribute("loi", "ID san pham khong hop le");
            } else {
                Product product = dao.findById(id);
                if (product == null) {
                    req.setAttribute("loi", "Khong tim thay san pham");
                } else {
                    req.setAttribute("productSua", product);
                }
            }
        }

        forwardProductPage(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null || action.isBlank()) {
            action = "create";
        }

        boolean success;
        switch (action) {
            case "update":
                success = updateProduct(req, resp);
                break;
            case "delete":
                success = deleteProduct(req, resp);
                break;
            case "create":
            default:
                success = createProduct(req, resp);
                break;
        }

        if (success) {
            // Thêm param success để JSP hiển thị thông báo thành công
            resp.sendRedirect(req.getContextPath() + "/product?success=" + action);
        }
    }

    private boolean createProduct(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Product product = readProduct(req);
        String error = validateProduct(product);
        if (error != null) {
            return fail(req, resp, error, product, false);
        }

        boolean created = dao.create(product);
        if (!created) {
            return fail(req, resp, "Loi tao san pham", product, false);
        }
        return true;
    }

    private boolean updateProduct(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseId(req);
        if (id == null) {
            return fail(req, resp, "ID san pham khong hop le", null, true);
        }

        Product existing = dao.findById(id);
        if (existing == null) {
            return fail(req, resp, "Khong tim thay san pham", null, true);
        }

        Product product = readProduct(req);
        product.setId(id);

        String error = validateProduct(product);
        if (error != null) {
            return fail(req, resp, error, product, true);
        }

        boolean updated = dao.update(product);
        if (!updated) {
            return fail(req, resp, "Loi cap nhat san pham", product, true);
        }
        return true;
    }

    private boolean deleteProduct(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseId(req);
        if (id == null) {
            return fail(req, resp, "ID san pham khong hop le", null, true);
        }

        boolean deleted = dao.delete(id);
        if (!deleted) {
            return fail(req, resp, "Loi xoa san pham", null, true);
        }
        return true;
    }

    private void forwardProductPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Product> products = dao.getAll();

        req.setAttribute("danhsach", products);
        req.setAttribute("tongSanPham", products.size());
        req.setAttribute("sanPhamDangBan", countActiveProducts(products));
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    private int countActiveProducts(List<Product> products) {
        int count = 0;
        for (Product product : products) {
            if (isActive(product.getStaTus())) {
                count++;
            }
        }
        return count;
    }

    private Product readProduct(HttpServletRequest req) {
        Product product = new Product();
        product.setShopId(parseLong(req.getParameter("shopid")));
        product.setCategoryId(parseLong(req.getParameter("categoryid")));
        product.setProductName(normalize(req.getParameter("productname")));
        product.setDescription(normalize(req.getParameter("description")));
        product.setPrice(parseDecimal(req.getParameter("price")));
        product.setStockQuantity(parseInt(req.getParameter("stock_quantity")));
        product.setSoldCount(parseInt(req.getParameter("soldCount")));
        product.setStaTus(normalizeStatus(req.getParameter("status")));
        return product;
    }

    private String validateProduct(Product product) {
        if (product.getProductName().isBlank()) {
            return "Ten san pham khong duoc de trong";
        }

        if (product.getShopId() <= 0) {
            return "Shop khong hop le";
        }

        if (product.getCategoryId() <= 0) {
            return "Category khong hop le";
        }

        if (product.getPrice() == null || product.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
            return "Gia san pham phai lon hon 0";
        }

        if (product.getStockQuantity() < 0) {
            return "So luong ton khong hop le";
        }

        if (product.getSoldCount() < 0) {
            return "So luong da ban khong hop le";
        }

        if (shopDAO.selectShopById(product.getShopId()) == null) {
            return "Khong tim thay shop";
        }

        if (categoryDAO.findById(product.getCategoryId()) == null) {
            return "Khong tim thay category";
        }

        return null;
    }

    private boolean fail(HttpServletRequest req, HttpServletResponse resp, String message, Product productForm, boolean editing)
            throws ServletException, IOException {
        req.setAttribute("loi", message);
        if (productForm != null) {
            if (editing) {
                req.setAttribute("productSua", productForm);
            } else {
                req.setAttribute("productForm", productForm);
            }
        }
        forwardProductPage(req, resp);
        return false;
    }

    private Long parseId(HttpServletRequest req) {
        try {
            String value = normalize(req.getParameter("id"));
            return value.isEmpty() ? null : Long.parseLong(value);
        } catch (Exception e) {
            return null;
        }
    }

    private Long parseLong(String value) {
        try {
            String normalized = normalize(value);
            return normalized.isEmpty() ? 0L : Long.parseLong(normalized);
        } catch (Exception e) {
            return 0L;
        }
    }

    private Integer parseInt(String value) {
        try {
            String normalized = normalize(value);
            return normalized.isEmpty() ? 0 : Integer.parseInt(normalized);
        } catch (Exception e) {
            return 0;
        }
    }

    private BigDecimal parseDecimal(String value) {
        try {
            String normalized = normalize(value);
            return normalized.isEmpty() ? null : new BigDecimal(normalized);
        } catch (Exception e) {
            return null;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }

    private String normalizeStatus(String value) {
        String status = normalize(value);
        return status.isBlank() ? "ACTIVE" : status.toUpperCase(Locale.ROOT);
    }

    private boolean isActive(String status) {
        if (status == null) {
            return false;
        }

        String value = status.trim().toUpperCase(Locale.ROOT);
        return "ACTIVE".equals(value) || "AVAILABLE".equals(value) || "PUBLISHED".equals(value);
    }
}