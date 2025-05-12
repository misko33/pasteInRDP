pasteInRDP.ps1

- This PowerShell script reads clipboard text and sends it to the active window one character at a time using SendKeys
- It emulates real keystrokes to simulate pasting text — however, each key is duplicated in RDP sessions due to how remote input is processed

unduplicate.ps1

- This PowerShell script removes consecutive duplicate characters from each line of a text file and saves the cleaned result to a new file — meant to be used in an RDP session after pasting content that may have been duplicated
