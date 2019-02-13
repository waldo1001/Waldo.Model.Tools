# Analyzing C/AL Text Files
This library is a series of scripts and dlls to make it  possible to **analyze** your C/AL objects.  We chose to do this with **PowerShell** to be able to integrate it in build scenarios and such - basically to **automate** the analysis of whatever we commit to Source Control.

The repository consists of:
- the **PowerShell Module** (aka "The Magic"), which
  - can build an object model from your text-files
  - lets you query that object model
- An growing **collection of scripts** for you to use, modify or get inspiration from

## The Magic
in "The Magic" folder, you'll find the dll (which is a PowerShell module) that a fellow nerd created (I was only useful as a "source of inspiration" ;-)).

The use of the dll is free, but you have to request a **license key** in order to make it work.  Place the license fee in "The Magic" folder, and you're good to go!

### To request a license.key
Open the "RequestLicense.ps1" script (in the root of this repo), and execute.  You will:
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

## Getting Started
In the folder "Getting Started", you can find some scripts to - uhm - get started :-).  You'll always start with loading your object model into a PowerShell variable, which you can use from then on to query your application.

## Feedback
If you have any feedback, requests, questions, ... please use the "issues" section in this repo.  Though, read the disclamer to set expectations!  We'll do our best to answer and help where possible, and if time permits.

# Disclaimer
Because all of this is free, it means: no support, no guarantee, no bug support, no ... .  We deliver this "as is" and should be treated as such.  That was the short version, here is the long version:

```
There are inherent dangers in the use of any software available for download on the Internet, and we caution you to make sure that you completely understand the potential risks before downloading any of the software.

The Software and code samples available on this website are provided "as is" without warranty of any kind, either express or implied. Use at your own risk.

The use of the software and scripts downloaded on this site is done at your own discretion and risk and with agreement that you will be solely responsible for any damage to your computer system or loss of data that results from such activities. You are solely responsible for adequate protection and backup of the data and equipment used in connection with any of the software, and we will not be liable for any damages that you may suffer in connection with using, modifying or distributing any of this software. No advice or information, whether oral or written, obtained by you from us or from this website shall create any warranty for the software.

We make makes no warranty that
- the software will meet your requirements
- the software will be uninterrupted, timely, secure or error-free
- the results that may be obtained from the use of the software will be effective, accurate or reliable
- the quality of the software will meet your expectations
- any errors in the software obtained from us will be corrected.

The software, code sample and their documentation made available on this website:
- could include technical or other mistakes, inaccuracies or typographical errors. We may make changes to the software or documentation made available on its web site at any time without prior-notice.
- may be out of date, and we make no commitment to update such materials.

We assume no responsibility for errors or omissions in the software or documentation available.

In no event shall we be liable to you or any third parties for any special, punitive, incidental, indirect or consequential damages of any kind, or any damages whatsoever, including, without limitation, those resulting from loss of use, data or profits, and on any theory of liability, arising out of or in connection with the use of this software.
```
