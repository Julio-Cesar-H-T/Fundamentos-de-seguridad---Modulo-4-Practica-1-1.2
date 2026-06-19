# ⚡ Digispark HID Attack & Blue Team Defense PoC

> **Materia:** Fundamentos de Seguridad

> **Institución:** Instituto Tecnológico de Las Américas (ITLA)  

> **Autor:** Julio César Hernández Tibrey  

> **Lista de reproducción:** https://www.youtube.com/playlist?list=PL1bMSHFyMPr7kB4MPrFcAFucOFrtLWahD

---

## ⚠️ Aviso Legal / Disclaimer

> Este proyecto fue desarrollado en un entorno de laboratorio controlado con fines estrictamente académicos y de investigación en seguridad. No se autoriza el uso de estas técnicas en sistemas de producción sin el consentimiento explícito de los propietarios.

---

## 📋 Descripción General

Este repositorio documenta un Prueba de Concepto (PoC) sobre un ataque de Inyección de Comandos por Dispositivo de Interfaz Humana (HID utilizando el microcontrolador de bajo costo Digispark ATtiny85. 

A diferencia de los análisis tradicionales que solo muestran la fase ofensiva, este proyecto adopta un enfoque de **Blue Team**, documentando las firmas de eventos generadas, los métodos de detección y las contramedidas para mitigar este vector de ataque en entornos corporativos.

## 🛠️ Herramientas Utilizadas
* **Hardware:** Digispark ATtiny85 (Emulador de teclado HID).
* **Entorno del Atacante:** Arduino IDE (Desarrollo del Payload en lenguaje C++ / DigiKeyboard).
* **Entorno de la Víctima:** Windows 10/11 Workstation.
* **Herramientas de Análisis/Defensa:** PowerShell, Windows Event Viewer, Sysmon.

---

## 🎯 1. Escenario Ofensivo (The Attack)

El microcontrolador Digispark se programa para que, al ser conectado a un puerto USB, el sistema operativo de la víctima lo reconozca inmediatamente como un teclado genérico estándar (burlando restricciones habituales de políticas de almacenamiento masivo USB).

### Flujo del Payload:
1. **Reconocimiento:** Retraso de inicialización de 5000ms para asegurar la carga de drivers en la víctima.
2. **Evasión Inicial:** Invocación del cuadro de diálogo "Ejecutar" (`GUI + R`).
3. **Ejecución:** Apertura de una terminal de PowerShell en modo silencioso o bypass.
4. **Exfiltración/Acceso:** Descarga y ejecución asíncrona de un script secundario en memoria.

> 📂 *Los códigos fuentes del ataque se encuentran en la carpeta [Payloads](./Payloads).*

---

## 🛡️ 2. Perspectiva Defensiva (Blue Team Mitigations)

Como analistas de seguridad, el foco principal es neutralizar el impacto de un dispositivo HID no autorizado. Se implementaron y probaron tres capas de mitigación:

### Capa 1: Restricción por ID de Instancia de Dispositivo (GPO)
La defensa más robusta a nivel empresarial es bloquear la instalación de dispositivos USB que no estén explícitamente aprobados en una lista blanca.
* **Ruta de Directiva:** `Configuración del equipo -> Plantillas administrativas -> Sistema -> Instalación de dispositivos -> Restricciones de instalación de dispositivos`.
* **Acción:** Bloquear la instalación de dispositivos que coincidan con el Hardware ID del Digispark (`USB\VID_16C0&PID_05DF`).

### Capa 2: Auditoría y Detección de Procesos Anómalos
Si un ataque HID logra ejecutarse, dejará rastros claros en los logs del sistema que un **SIEM (como Wazuh)** puede alertar:
* **Padre Anómalo:** Detección de procesos `powershell.exe` o `cmd.exe` cuyo proceso padre sea `explorer.exe` pero que hayan sido lanzados sin interacción real del usuario (monitoreo de tiempos de tipeo inhumanos).
* **ID de Evento Sysmon 1:** Creación de procesos con argumentos sospechosos como `-ExecutionPolicy Bypass -WindowStyle Hidden`.

### Capa 3: Script de Mitigación Automatizado
> 📂 *En la carpeta [Mitigations](./Mitigations) se incluye un script en PowerShell diseñado para deshabilitar puertos o alertar ante la conexión de IDs de proveedor (VID) sospechosos del ecosistema Digispark.*

---

## 📌 Conclusiones del Laboratorio

1. **La confianza implícita es una vulnerabilidad:** Los sistemas operativos confían por defecto en cualquier dispositivo que se identifique como un teclado.
2. **Defensa en profundidad:** Las restricciones físicas y las GPOs de bloqueo de hardware deben complementarse con reglas de monitoreo en el SOC para identificar la ejecución de scripts maliciosos de forma inmediata.

---
