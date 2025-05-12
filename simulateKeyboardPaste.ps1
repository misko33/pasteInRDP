Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Keyboard {
    [DllImport("user32.dll")]
    public static extern short VkKeyScan(char ch);

    [DllImport("user32.dll", SetLastError=true)]
    public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);

    public const int KEYEVENTF_KEYDOWN = 0x00;
    public const int VK_SHIFT  = 0x10;
    public const int VK_RETURN = 0x0D;
}
"@

function Send-Key {
    param([char]$char)

    if ($char -eq "`n") {
        [Keyboard]::keybd_event([Keyboard]::VK_RETURN, 0, [Keyboard]::KEYEVENTF_KEYDOWN, 0)
        Start-Sleep -Milliseconds 10
        return
    }

    $vkScan     = [Keyboard]::VkKeyScan($char)
    $vk         = $vkScan -band 0xFF
    $shiftState = ($vkScan -shr 8) -band 0xFF
    if ($vk -eq 0xFF) { return }

    if ($shiftState -band 1) {
        [Keyboard]::keybd_event([Keyboard]::VK_SHIFT, 0, [Keyboard]::KEYEVENTF_KEYDOWN, 0)
        Start-Sleep -Milliseconds 5
    }

    [Keyboard]::keybd_event($vk, 0, [Keyboard]::KEYEVENTF_KEYDOWN, 0)
    Start-Sleep -Milliseconds 10

    if ($shiftState -band 1) {
        [Keyboard]::keybd_event([Keyboard]::VK_SHIFT, 0, 2, 0)
        Start-Sleep -Milliseconds 5
    }
}

function Paste-ClipboardRealKeyPress {
    Start-Sleep -Seconds 2
    Add-Type -AssemblyName System.Windows.Forms

    $clipboardContent = ([System.Windows.Forms.Clipboard]::GetText()) -replace "`r`n|`r", "`n"

    foreach ($char in $clipboardContent.ToCharArray()) {
        Send-Key -char $char
        Start-Sleep -Milliseconds 10
    }
}

Paste-ClipboardRealKeyPress
