package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.CategoryDAO;
import org.example.daos.CategoryDAOImpl;
import org.example.models.Category;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

@WebServlet("/Category")
public class CategoryServlet extends HttpServlet {
    private final CategoryDAO dao = new CategoryDAOImpl();
    private static final String VIEW = "/taoCategory.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("edit".equals(action)) {
            Long id = parseId(req);
            if (id == null) {
                req.setAttribute("loi", "ID category khong hop le");
            } else {
                Category category = dao.findById(id);
                if (category == null) {
                    req.setAttribute("loi", "Khong tim thay category");
                } else {
                    req.setAttribute("categorySua", category);
                }
            }
        }

        forwardCategoryPage(req, resp);
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
                success = updateCategory(req, resp);
                break;
            case "delete":
                success = deleteCategory(req, resp);
                break;
            case "create":
            default:
                success = createCategory(req, resp);
                break;
        }

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/Category?success=" + action);
        }
    }

    private boolean createCategory(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Category category = readCategory(req);
        String error = validateCategory(category);
        if (error != null) {
            req.setAttribute("loi", error);
            req.setAttribute("categoryForm", category);
            forwardCategoryPage(req, resp);
            return false;
        }

        boolean created = dao.create(category);
        if (!created) {
            req.setAttribute("loi", "Loi tao Category");
            req.setAttribute("categoryForm", category);
            forwardCategoryPage(req, resp);
        }
        return created;
    }

    private boolean updateCategory(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseId(req);
        if (id == null) {
            req.setAttribute("loi", "ID category khong hop le");
            forwardCategoryPage(req, resp);
            return false;
        }

        Category category = readCategory(req);
        category.setId(id);
        String error = validateCategory(category);
        if (error != null) {
            req.setAttribute("loi", error);
            req.setAttribute("categorySua", category);
            forwardCategoryPage(req, resp);
            return false;
        }

        boolean updated = dao.update(category);
        if (!updated) {
            req.setAttribute("loi", "Loi cap nhat Category");
            req.setAttribute("categorySua", category);
            forwardCategoryPage(req, resp);
        }
        return updated;
    }

    private boolean deleteCategory(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseId(req);
        if (id == null) {
            req.setAttribute("loi", "ID category khong hop le");
            forwardCategoryPage(req, resp);
            return false;
        }

        boolean deleted = dao.delete(id);
        if (!deleted) {
            req.setAttribute("loi", "Loi xoa Category");
            forwardCategoryPage(req, resp);
        }
        return deleted;
    }

    private void forwardCategoryPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Category> categories = dao.getAll();
        req.setAttribute("danhsach", categories);
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    private Category readCategory(HttpServletRequest req) {
        Category category = new Category();
        category.setShopId(parseLong(firstPresent(req.getParameter("shopId"), req.getParameter("shopid"))));
        category.setCategoryName(firstPresent(req.getParameter("categoryName"), req.getParameter("name")));
        category.setStatus(normalizeStatus(req.getParameter("status")));
        return category;
    }

    private String validateCategory(Category category) {
        if (category.getShopId() <= 0) {
            return "Shop ID khong hop le";
        }
        if (category.getCategoryName().isBlank()) {
            return "Ten category khong duoc de trong";
        }
        return null;
    }

    private Long parseId(HttpServletRequest req) {
        try {
            String value = normalize(req.getParameter("id"));
            return value.isEmpty() ? null : Long.parseLong(value);
        } catch (Exception e) {
            return null;
        }
    }

    private long parseLong(String value) {
        try {
            String normalized = normalize(value);
            return normalized.isEmpty() ? 0 : Long.parseLong(normalized);
        } catch (Exception e) {
            return 0;
        }
    }

    private String firstPresent(String primary, String fallback) {
        String normalized = normalize(primary);
        return normalized.isEmpty() ? normalize(fallback) : normalized;
    }

    private String normalizeStatus(String value) {
        String status = normalize(value);
        return status.isBlank() ? "ACTIVE" : status.toUpperCase(Locale.ROOT);
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
