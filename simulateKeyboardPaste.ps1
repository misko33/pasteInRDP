Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Keyboard {
    [DllImport("user32.dll")]
    public static extern short VkKeyScan(char ch);

    [DllImport("user32.dll", SetLastError=true)]
    public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);

    public const int KEYEVENTF_KEYDOWN = 0x00;
    public const int VK_SHIFT = 0x10;
}
"@

function Send-Key {
    param(
        [char]$char
    )

    $vkScan = [Keyboard]::VkKeyScan($char)
    $vk = $vkScan -band 0xFF
    $shiftState = ($vkScan -shr 8) -band 0xFF

    if ($vk -eq 0xFF) {
        Write-Host "Cannot map character: $char"
        return
    }

    # Press Shift if needed
    if ($shiftState -band 1) {
        [Keyboard]::keybd_event([Keyboard]::VK_SHIFT, 0, [Keyboard]::KEYEVENTF_KEYDOWN, 0)
        Start-Sleep -Milliseconds 5
    }

    # Key Down (ONLY, no KeyUp!)
    [Keyboard]::keybd_event($vk, 0, [Keyboard]::KEYEVENTF_KEYDOWN, 0)
    Start-Sleep -Milliseconds 10

    # Release Shift if needed
    if ($shiftState -band 1) {
        [Keyboard]::keybd_event([Keyboard]::VK_SHIFT, 0, 2, 0)  # KeyUp for Shift only
        Start-Sleep -Milliseconds 5
    }
}

function Paste-ClipboardRealKeyPress {
    Start-Sleep -Seconds 2

    Add-Type -AssemblyName System.Windows.Forms
    $clipboardContent = [System.Windows.Forms.Clipboard]::GetText()

    foreach ($char in $clipboardContent.ToCharArray()) {
        Send-Key -char $char
        Start-Sleep -Milliseconds 10
    }
}

# Run
Paste-ClipboardRealKeyPress
