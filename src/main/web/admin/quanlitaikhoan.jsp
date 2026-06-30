 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
 <%@ page contentType="text/html;charset=UTF-8" language="java" %>
 <c:forEach var="acc" items="${danhsach}">
        <tr>
            <td>${acc.id}</td><td>${acc.username}</td><td>${acc.fullname}</td><td>${acc.email}</td><td>${acc.phone}</td>
        </tr>
    </c:forEach>