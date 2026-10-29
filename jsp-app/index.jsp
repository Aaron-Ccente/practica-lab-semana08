<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lab 09 | Registro JSP</title>
</head>
<body>
    <h1>Formulario de contacto (JSP)</h1>
    <form action="procesar.jsp" method="POST">
        <label for="nombre">Nombre:</label>
        <input id="nombre" type="text" name="nombre" maxlength="100" required>
        <br>
        <label for="correo">Correo:</label>
        <input id="correo" type="email" name="correo" maxlength="254" required>
        <br>
        <button type="submit">Enviar</button>
    </form>
</body>
</html>
