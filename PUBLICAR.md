# Página de descarga de Dreink

Sitio estático para GitHub Pages: una sola página, sin dependencias ni CDN.
`index.html` lleva el botón de descarga, el SHA-256 y las instrucciones de
SmartScreen.

> **Lista para publicar (16/11/2026).** La ayuda de atajos y los botones de
> personaje ya están en la app. Solo falta cambiar `user` en `index.html` y
> seguir los pasos de abajo.

## Por qué el repositorio es público

GitHub Pages exige un repositorio público en el plan Free
([documentación](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site)),
y los *assets* de un release privado no se pueden descargar sin cuenta.

Público **no** significa código público: este repositorio contiene solo la
página, el icono y el instalador como *asset* del release. El código de Dreink
(`src/`, `out/`, `app.asar`) no se copia aquí y sigue en un repositorio privado.
La licencia de `LICENSE` deja claro que no se cede ningún derecho sobre el
software.

## Publicar (primera vez)

1. Crea un repositorio **público** en GitHub, por ejemplo `dreink-web`, vacío y
   sin README (o con README, da igual).
2. Copia el contenido de esta carpeta a la raíz de ese repositorio. Desde
   `site/`:

   ```powershell
   git init -b main
   git add .
   git commit -m "Pagina de descarga de Dreink 1.0.0"
   git remote add origin https://github.com/<usuario>/dreink-web.git
   git push -u origin main
   ```

   Si prefieres no tocar la consola, arrastra los archivos a la web de GitHub.

3. En **Settings → Pages**, elige *Deploy from a branch*, rama `main`, carpeta
   `/ (root)`. La página queda en `https://<usuario>.github.io/dreink-web/`.
4. Crea un **Release** con etiqueta `v1.0.0` y adjunta como *assets*
   `Dreink-1.0.0-setup.exe` y `Dreink-1.0.0-setup.exe.blockmap` (el `.blockmap`
   no lo usa la página, pero permite actualizaciones diferenciales si algún día
   se añaden).
5. Abre `index.html` y cambia `user` por tu usuario de GitHub en el bloque
   `SITE` del final. Con eso se arreglan el botón, el enlace a *Todas las
   versiones* y el pie.

> No hace falta `gh` (GitHub CLI): todo se puede hacer desde la web de GitHub.

## Publicar una versión nueva

1. Sube `version` en `package.json`, compila (`npm.cmd run build:win`) y crea el
   release con la etiqueta `v<versión>`.
2. Actualiza los datos de la página con el instalador recién generado:

   ```powershell
   powershell -ExecutionPolicy Bypass -File site\actualizar-instalador.ps1
   ```

   El script lee `dist\Dreink-1.0.0-setup.exe` (o la ruta que le pases), calcula
   el tamaño y el SHA-256, y reescribe `version`, `file`, `size`, `shortSize` y
   `sha256` en `index.html`, incluido el texto de reserva que se ve antes de que
   corra el JavaScript.
3. Sube el cambio al repositorio de la web.

## Comprobaciones antes de dar el enlace

- El botón descarga el `.exe` correcto desde
  `https://github.com/<usuario>/dreink-web/releases/download/v<versión>/<archivo>`.
- El SHA-256 de la página coincide con el del archivo descargado.
- La página se ve bien en claro y en oscuro (botón **Tema** de la cabecera).
- La descarga funciona desde una ventana de incógnito, sin cuenta de GitHub.

## Límites de GitHub

- Pages: 1 GB de sitio y unas 100 GB/mes de tráfico. A 94 MiB por descarga son
  unas 1.000 descargas al mes.
- Cada archivo de un release admite hasta 2 GB en el plan gratuito.
- El `.exe` **no** se sube al repositorio: solo como *asset* del release.
