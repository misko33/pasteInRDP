Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Keyboard {
    [DllImport("user32.dll", SetLastError=true)]
    public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);

    public const int KEYEVENTF_KEYDOWN = 0x0000;
    public const int KEYEVENTF_KEYUP = 0x0002;
}
"@

function Escape-ForSendKeys {
    param (
        [string]$text
    )

    $escaped = $text -replace '(\{)', '{{}' `
                        -replace '(\})', '{}}' `
                        -replace '(\+)', '{+}' `
                        -replace '(\^)', '{^}' `
                        -replace '(\%)', '{%}' `
                        -replace '(\~)', '{~}' `
                        -replace '(\()','{(}' `
                        -replace '(\))','{)}'
    return $escaped
}

function Send-Char {
    param (
        [char]$char
    )

    $safeChar = Escape-ForSendKeys -text $char
    [System.Windows.Forms.SendKeys]::SendWait($safeChar)
    Start-Sleep -Milliseconds 10
}

function Paste-ClipboardRealKeys {
    # Wait 2 seconds
    Start-Sleep -Seconds 2

    # Load clipboard
    Add-Type -AssemblyName System.Windows.Forms
    $clipboardContent = [System.Windows.Forms.Clipboard]::GetText()

    foreach ($char in $clipboardContent.ToCharArray()) {
        Send-Char -char $char
    }
}

Paste-ClipboardRealKeys
