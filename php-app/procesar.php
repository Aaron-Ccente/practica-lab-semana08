<?php
declare(strict_types=1);

function escapeHtml(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function renderError(int $status, string $message): void
{
    http_response_code($status);
    if ($status === 405) {
        header('Allow: POST');
    }

    echo '<!DOCTYPE html>
<html lang="es">
<head><meta charset="UTF-8"><title>Error de solicitud</title></head>
<body>
    <h1>Error ' . $status . '</h1>
    <p>' . escapeHtml($message) . '</p>
    <p><a href="index.html">Volver al formulario</a></p>
</body>
</html>';
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    renderError(405, 'Método no permitido. Envía el formulario mediante POST.');
    exit;
}

if (session_start() !== true) {
    renderError(500, 'No fue posible iniciar la sesión.');
    exit;
}

$nombre = $_POST['nombre'] ?? null;
$correo = $_POST['correo'] ?? null;

if (!is_string($nombre) || !is_string($correo)) {
    renderError(400, 'Debes proporcionar un nombre y un correo válidos.');
    exit;
}

$nombre = trim($nombre);
$correo = trim($correo);
$nombreLength = preg_match_all('/./us', $nombre);

if (
    $nombre === ''
    || $nombreLength === false
    || $nombreLength > 100
    || preg_match('/\p{Cc}/u', $nombre) !== 0
    || strlen($correo) > 254
    || filter_var($correo, FILTER_VALIDATE_EMAIL) === false
) {
    renderError(400, 'Revisa el nombre y el formato del correo electrónico.');
    exit;
}

if (!isset($_SESSION['registros']) || !is_array($_SESSION['registros'])) {
    $_SESSION['registros'] = [];
}

$_SESSION['registros'][] = [
    'nombre' => $nombre,
    'correo' => $correo,
];

$registros = $_SESSION['registros'];
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Registros | PHP</title>
</head>
<body>
    <h1>Registros almacenados</h1>
    <p>El registro se guardó en la sesión actual.</p>
    <table border="1">
        <thead>
            <tr><th>Nombre</th><th>Correo</th></tr>
        </thead>
        <tbody>
            <?php foreach ($registros as $registro): ?>
                <tr>
                    <td><?= escapeHtml((string) $registro['nombre']) ?></td>
                    <td><?= escapeHtml((string) $registro['correo']) ?></td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
    <p><a href="index.html">Registrar otro contacto</a></p>
</body>
</html>
