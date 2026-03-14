# ====================================================================
# ESCÁNER  -  RED - DNS
# ====================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

$Banner = @"
 █████╗ ███╗  ██╗██████╗ ███████╗██╗   ██╗███████╗
██╔══██╗████╗  ██║██╔══██╗██╔════╝██║   ██║██╔════╝
███████║██╔██╗ ██║██║  ██║█████╗  ██║   ██║███████╗
██╔══██║██║╚██╗██║██║  ██║██╔══╝  ██║   ██║╚════██║
██║  ██║██║ ╚████║██████╔╝███████╗╚██████╔╝███████║
╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝                                 
                      
  ▀▄▀▄▀▄▀▄▀▄▀▄  ☣︎ INFECTION ☣︎  ▀▄▀▄▀▄▀▄▀▄▀▄▀                   
"@

Write-Host $Banner -ForegroundColor Red
Write-Host "_____________________________________________________" -ForegroundColor DarkRed
Write-Host "Analizando el caché de red (DNS) oculto de Windows...`n" -ForegroundColor DarkGray

# Base de datos de servidores de Hacks (De pago y Gratis)
$DominiosIlegales = @(
    "vape.gg", "manthe.industries", # Vape
    "koid.club", "koid.io",         # Koid
    "entropy.club",                 # Entropy
    "novoline.wtf",                 # Novoline
    "doomsday", "slinky", "drip.gg",
    "raw.githubusercontent.com",    # Usado por hacks gratis para descargar configs
    "api.telegram.org",             # Usado por hacks/rats para robar cuentas
    "pastebin.com"                  # Usado para inyectar código en vivo
)

try {
    # Extraer la tabla DNS viva de Windows
    $CacheDNS = Get-DnsClientCache -ErrorAction Stop
    $Detecciones = 0

    Write-Host "[i] Tabla DNS extraída exitosamente. Filtrando conexiones sospechosas...`n" -ForegroundColor Cyan

    foreach ($Registro in $CacheDNS) {
        $Dominio = $Registro.Entry.ToLower()
        
        # Filtrar basura local
        if ($Dominio -match "localhost" -or $Dominio -match "127.0.0.1" -or $Dominio -match "\.arpa") { continue }

        foreach ($Trampa in $DominiosIlegales) {
            if ($Dominio -match $Trampa) {
                $Detecciones++
                Write-Host "   [!] CONEXIÓN ILEGAL DETECTADA:" -ForegroundColor Red
                Write-Host "       => Servidor: $Dominio" -ForegroundColor Yellow
                Write-Host "       => Relacionado a: $Trampa" -ForegroundColor DarkGray
                Write-Host "       => Veredicto: El usuario se conectó a un servidor de hacks o repositorios de inyección externa.`n" -ForegroundColor Red
                break
            }
        }
    }

    if ($Detecciones -eq 0) {
        Write-Host "[i] No se encontraron conexiones a servidores de hacks conocidos en esta sesión." -ForegroundColor Green
    } else {
        Write-Host "======================================================" -ForegroundColor DarkGreen
        Write-Host "Resumen: Se detectaron $Detecciones conexiones de red sospechosas." -ForegroundColor Yellow
    }

} catch {
    Write-Host "[x] Error al leer el DNS. Asegúrate de ejecutar PowerShell como Administrador." -ForegroundColor Red
}
