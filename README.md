# Dreink — página de descarga

Página estática de descarga de **Dreink 1.0.0**, la aplicación de escritorio para
escribir y organizar libros.

- Descarga: <https://github.com/dreinkapp/dreinkapp.github.io/releases/latest>
- Página publicada: `https://dreinkapp.github.io/`

Este repositorio contiene **solo la página** (`index.html`, `icon.png`) y el
instalador como *asset* de un release. El código fuente de Dreink no está aquí:
es software propietario y se distribuye únicamente como instalador. Consulta
`LICENSE`.

## Estructura

| Archivo | Para qué |
| --- | --- |
| `index.html` | La página completa, autocontenida (sin CDN). |
| `icon.png` | Icono de la pestaña y de la cabecera. |
| `.nojekyll` | Evita que Pages procese el sitio con Jekyll. |
| `LICENSE` | Licencia propietaria. |
| `PUBLICAR.md` | Cómo publicar la página y las versiones nuevas. |
| `actualizar-instalador.ps1` | Reescribe versión, tamaño y SHA-256 desde el `.exe`. |

## Verificar una descarga

```powershell
Get-FileHash .\Dreink-1.0.0-setup.exe -Algorithm SHA256
```

El resultado debe coincidir con el SHA-256 que muestra la página.
