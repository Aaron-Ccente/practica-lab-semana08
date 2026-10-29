# Laboratorio: registro de contactos con PHP y JSP

Las dos aplicaciones reciben un formulario por `POST`, validan nombre y correo, conservan los contactos en la sesión HTTP y responden con una tabla HTML. El escape de salida evita que los datos se interpreten como HTML o JavaScript.

## PHP en local

Desde la raíz del proyecto, inicia el servidor integrado en la carpeta de la aplicación:

```powershell
cd .\php-app
php -S localhost:8001
```

Abre <http://localhost:8001/>. También se puede iniciar desde la raíz con `php -S localhost:8001 -t php-app`.

El servidor integrado muestra en la terminal los métodos, rutas y códigos HTTP de las solicitudes; esa terminal sirve como evidencia de los logs. Pruebas HTTP manuales desde otra terminal:

```powershell
curl.exe -i -X POST -d "nombre=Ana&correo=ana%40example.com" http://localhost:8001/procesar.php
curl.exe -i -X POST -d "nombre=Ana&correo=ana%40example.com" http://localhost:8001/procesar.php
curl.exe -i -X POST -d "nombre=Ana&correo=no-es-correo" http://localhost:8001/procesar.php
curl.exe -i http://localhost:8001/procesar.php
```

La segunda solicitud válida debe responder `200 OK` con una fila para Ana; los datos inválidos responden `400 Bad Request` y el acceso GET al procesador responde `405 Method Not Allowed` con `Allow: POST`. Para comprobar que la lista permanece en la misma sesión, envía varias solicitudes POST desde el mismo navegador (que conserva la cookie de sesión). Para evidencia visual, captura la terminal con los logs y el navegador mostrando tanto el formulario como la respuesta con la tabla.

## Aplicación JSP

`jsp-app` contiene el formulario (`index.jsp`) y su procesador (`procesar.jsp`). Requiere un contenedor compatible con JSP/Servlets, que debe ejecutar los JSP; abrir los archivos como HTML estático no procesa JSP. El formulario envía `POST` al procesador. Las respuestas previstas son `200` al guardar, `400` ante datos inválidos y `405` para otros métodos. La sesión mantiene los registros mientras el cliente conserva su cookie de sesión.


## Estructura

```text
.
├── php-app
│   ├── index.html       # Formulario de contacto
│   └── procesar.php     # Validación, sesión y respuesta HTML
├── jsp-app
│   ├── index.jsp        # Formulario de contacto
│   └── procesar.jsp     # Validación, HttpSession y respuesta HTML
└── README.md
```
