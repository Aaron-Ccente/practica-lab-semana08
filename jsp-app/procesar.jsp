<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.ArrayList,java.util.HashMap,java.util.List,java.util.Map,java.util.regex.Pattern" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    private static final Pattern EMAIL_PATTERN =
        Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
%>
<%
    request.setCharacterEncoding("UTF-8");

    if (!"POST".equals(request.getMethod())) {
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        response.setHeader("Allow", "POST");
%>
<!DOCTYPE html>
<html lang="es">
<head><meta charset="UTF-8"><title>Error 405</title></head>
<body>
    <h1>Error 405</h1>
    <p>Método no permitido. Envía el formulario mediante POST.</p>
    <p><a href="index.jsp">Volver al formulario</a></p>
</body>
</html>
<%
        return;
    }

    String nombre = request.getParameter("nombre");
    String correo = request.getParameter("correo");

    if (nombre != null) {
        nombre = nombre.trim();
    }
    if (correo != null) {
        correo = correo.trim();
    }

    boolean nombreInvalido = nombre == null || nombre.isEmpty()
        || nombre.codePointCount(0, nombre.length()) > 100
        || nombre.matches(".*[\\p{Cntrl}].*");
    boolean correoInvalido = correo == null || correo.length() > 254
        || !EMAIL_PATTERN.matcher(correo).matches();

    if (nombreInvalido || correoInvalido) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
%>
<!DOCTYPE html>
<html lang="es">
<head><meta charset="UTF-8"><title>Error 400</title></head>
<body>
    <h1>Error 400</h1>
    <p>Revisa el nombre y el formato del correo electrónico.</p>
    <p><a href="index.jsp">Volver al formulario</a></p>
</body>
</html>
<%
        return;
    }

    HttpSession userSession = request.getSession();
    List<Map<String, String>> registros =
        (List<Map<String, String>>) userSession.getAttribute("registros");
    if (registros == null) {
        registros = new ArrayList<Map<String, String>>();
    }

    Map<String, String> registro = new HashMap<String, String>();
    registro.put("nombre", nombre);
    registro.put("correo", correo);
    registros.add(registro);
    userSession.setAttribute("registros", registros);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Registros | JSP</title>
</head>
<body>
    <h1>Registros almacenados</h1>
    <p>El registro se guardó en la sesión actual.</p>
    <table border="1">
        <thead>
            <tr><th>Nombre</th><th>Correo</th></tr>
        </thead>
        <tbody>
            <% for (Map<String, String> item : registros) { %>
                <tr>
                    <td><%= escapeHtml(item.get("nombre")) %></td>
                    <td><%= escapeHtml(item.get("correo")) %></td>
                </tr>
            <% } %>
        </tbody>
    </table>
    <p><a href="index.jsp">Registrar otro contacto</a></p>
</body>
</html>
