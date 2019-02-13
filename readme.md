# Analyzing your 

## The Magic
in "The Magic" folder, you'll find the dll that my colleague created (I was only an "inspiration" at that point ;-)).

The use of the dll is free, but you have to request a license key in order to make it work.  Place the license fee in "The Magic" folder, and you're good to go!

### To request a license.key
Open the "RequestLicense.ps1" script, and execute.  You will:
- load the "NavModelToolsAPI.dll" as a PowerShell Module
- Run Check-License

This will check if you have a valid license.  If not, it will open a browser.  
Fill in your details and a valid email, and the license key will be sent to you.

Place the license key in the same folder as the "NavModelToolsAPI.dll".

Run "Check-License" again to validate your license.  The output should be something like this:
```
Licensed to:
  COMPANY : waldo
  NAME : waldo
  EMAIL : me@you.we
  COMPUTER : WALDOHOME

License:
  VERSION : 1
  TYPE : Trial
  SERIAL : 852bbd4c-c9b2-4325-af35-92053cc2s2e8
  GENERATED : 2019-02-13T17:37:00
  FREEUPGRADEUNTIL : 2019-05-13T00:00:00
  CHECKSUM : ef04c1eb3a2e313c66e01385ea345g2e
  EXPIRES : 2019-05-13T00:00:00
  KEY : p8nM1aVMZN9qV/8ArGw9/uwFblG2UJvD84dPuu8+Sug=
```
