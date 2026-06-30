<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Cửa Hàng</title>
    <style>
        table { border-collapse: collapse; width: 100%; margin-top: 20px; font-family: Arial, sans-serif; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #f4f4f4; }
        .btn { padding: 6px 12px; text-decoration: none; border-radius: 4px; display: inline-block; }
        .btn-add { background-color: #28a745; color: white; margin-bottom: 15px; }
        .btn-edit { background-color: #ffc107; color: black; }
        .btn-delete { background-color: #dc3545; color: white; }
    </style>
</head>
<body>

    <jsp:include page="quanLyCuaHang.jsp" />

    <div style="padding: 20px;">
        <h2>Danh Sách Cửa Hàng</h2>
        <a href="shops?action=new" class="btn btn-add">Tạo Cửa Hàng Mới</a>

        <table>
            <tr>
                <th>ID</th>
                <th>Tên Cửa Hàng</th>
                <th>Chủ Sở Hữu (Owner ID)</th>
                <th>Số Điện Thoại</th>
                <th>Địa Chỉ</th>
                <th>Trạng Thái</th>
                <th>Hành Động</th>
            </tr>
            <c:forEach var="shop" items="${listShop}">
                <tr>
                    <td><c:out value="${shop.iD}"/></td>
                    <td><strong><c:out value="${shop.shopName}"/></strong></td>
                    <td><c:out value="${shop.ownerId}"/></td>
                    <td><c:out value="${shop.shopPhone}"/></td>
                    <td><c:out value="${shop.shopAddress}"/></td>
                    <td>
                        <span style="padding:4px 8px; border-radius:4px; font-size:12px; font-weight:bold;
                            background-color: ${shop.staTus == 'APPROVED' ? '#d4edda' : '#fff3cd'};
                            color: ${shop.staTus == 'APPROVED' ? '#155724' : '#856404'};">
                            <c:out value="${shop.staTus}"/>
                        </span>
                    </td>
                    <td>
                        <a href="shops?action=edit&id=${shop.iD}" class="btn btn-edit">Sửa</a>
                        <a href="shops?action=delete&id=${shop.iD}" class="btn btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa cửa hàng này?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>
</body>
</html>