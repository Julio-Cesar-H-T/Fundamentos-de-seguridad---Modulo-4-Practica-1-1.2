<#
.SYNOPSIS
    Monitor y Bloqueador Reactivo para ataques HID (Digispark ATtiny85).

.DESCRIPTION
    Este script se ejecuta en segundo plano monitoreando los eventos de conexión USB (WMI).
    Si detecta el Hardware ID específico de un Digispark (VID_16C0&PID_05DF), 
    intenta deshabilitar la instancia del dispositivo inmediatamente para prevenir 
    la inyección de pulsaciones de teclado (Keystroke Injection).

.NOTES
    Autor: Julio César Hernández Tibrey
    Requisito: Debe ejecutarse con privilegios de Administrador.
#>

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Este script requiere privilegios de Administrador para deshabilitar dispositivos hardware."
    Write-Warning "Por favor, reinicie PowerShell como Administrador."
    Break
}

$SuspectVID = "16C0"
$SuspectPID = "05DF"
$TargetHardwareID = "*VID_$SuspectVID&PID_$SuspectPID*"

Write-Host "[+] Monitor de Defensa HID Iniciado." -ForegroundColor Green
Write-Host "[+] Monitoreando conexiones USB en busca del VID: $SuspectVID y PID: $SuspectPID..." -ForegroundColor Yellow

$Query = "SELECT * FROM __InstanceCreationEvent WITHIN 2 WHERE TargetInstance ISA 'Win32_PnPEntity'"
$Watcher = New-Object System.Management.ManagementEventWatcher $Query

try {
    while ($true) {
        $Event = $Watcher.WaitForNextEvent()
        $Device = $Event.TargetInstance

        if ($Device.PNPDeviceID -like $TargetHardwareID) {
            
            $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Write-Host "`n[!] ALERTA CRÍTICA: Dispositivo sospechoso detectado a las $Timestamp" -ForegroundColor Red
            Write-Host "    Dispositivo: $($Device.Name)" -ForegroundColor Red
            Write-Host "    ID de Hardware: $($Device.PNPDeviceID)" -ForegroundColor Red

            Write-Host "[*] Intentando aislar el dispositivo..." -ForegroundColor Yellow
            
            try {
                Disable-PnpDevice -InstanceId $Device.PNPDeviceID -Confirm:$false -ErrorAction Stop
                Write-Host "[+] ÉXITO: El dispositivo fue deshabilitado antes de inyectar el payload." -ForegroundColor Green
                
                Write-EventLog -LogName "Application" -Source "HIDDefender" -EventID 9999 -EntryType Warning -Message "Ataque HID prevenido. Digispark deshabilitado: $($Device.PNPDeviceID)"
                
            } catch {
                Write-Host "[-] ERROR: No se pudo deshabilitar el dispositivo de forma automática." -ForegroundColor Red
                Write-Host "[-] Detalles: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
} finally {
    $Watcher.Stop()
    $Watcher.Dispose()
    Write-Host "`n[-] Monitor de Defensa HID Detenido." -ForegroundColor DarkGray
}
