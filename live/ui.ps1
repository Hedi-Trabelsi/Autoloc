# live/ui.ps1 - tiny GUI control toolkit for the pi agent (Windows PowerShell 5.1)
# usage:
#   powershell -NoProfile -File live/ui.ps1 shot  out.png [windowTitle]
#   powershell -NoProfile -File live/ui.ps1 wins                      # list visible windows
#   powershell -NoProfile -File live/ui.ps1 focus "Notepad"
#   powershell -NoProfile -File live/ui.ps1 click 640 400 [left|right|double]
#   powershell -NoProfile -File live/ui.ps1 move  640 400
#   powershell -NoProfile -File live/ui.ps1 type  "hello world"
#   powershell -NoProfile -File live/ui.ps1 key   "^s"                # SendKeys syntax
#   powershell -NoProfile -File live/ui.ps1 pos                       # cursor position
#   powershell -NoProfile -File live/ui.ps1 drag  100 100 400 400

param(
  [Parameter(Mandatory=$true, Position=0)][string]$Verb,
  [Parameter(Position=1)][string]$A1,
  [Parameter(Position=2)][string]$A2,
  [Parameter(Position=3)][string]$A3,
  [Parameter(Position=4)][string]$A4
)

Add-Type -AssemblyName System.Windows.Forms, System.Drawing

$sig = @'
using System;
using System.Runtime.InteropServices;
public class W {
  [DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
  [DllImport("user32.dll")] public static extern void mouse_event(uint f, uint dx, uint dy, uint d, IntPtr e);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int c);
  [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
  [StructLayout(LayoutKind.Sequential)] public struct RECT { public int L,T,R,B; }
}
'@
if (-not ("W" -as [type])) { Add-Type -TypeDefinition $sig -ReferencedAssemblies System.Windows.Forms }

function Save-Shot([string]$path, $rect) {
  if (-not $rect) {
    $rect = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $x=$rect.X; $y=$rect.Y; $w=$rect.Width; $h=$rect.Height
  } else { $x=$rect.L; $y=$rect.T; $w=$rect.R-$rect.L; $h=$rect.B-$rect.T }
  $bmp = New-Object System.Drawing.Bitmap $w, $h
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.CopyFromScreen($x, $y, 0, 0, (New-Object System.Drawing.Size $w, $h))
  $dir = Split-Path -Parent $path
  if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
  Write-Output "saved $path ${w}x${h} at $x,$y"
}

function Find-Win([string]$t) {
  $p = Get-Process | Where-Object { $_.MainWindowHandle -ne 0 -and $_.MainWindowTitle -like "*$t*" }
  if (-not $p) { Write-Error "no window matching '$t'"; exit 1 }
  return $p | Select-Object -First 1
}

switch ($Verb.ToLower()) {
  'shot' {
    $target = $A2
    if ($target) {
      $p = Find-Win $target
      [W]::ShowWindow($p.MainWindowHandle, 9) | Out-Null
      [W]::SetForegroundWindow($p.MainWindowHandle) | Out-Null
      Start-Sleep -Milliseconds 350
      $r = New-Object W+RECT
      [W]::GetWindowRect($p.MainWindowHandle, [ref]$r) | Out-Null
      Save-Shot $A1 $r
    } else { Save-Shot $A1 $null }
  }
  'wins' {
    Get-Process | Where-Object { $_.MainWindowHandle -ne 0 } |
      ForEach-Object { "{0,-8} {1}" -f $_.Id, $_.MainWindowTitle } | Sort-Object
  }
  'focus' {
    $p = Find-Win $A1
    [W]::ShowWindow($p.MainWindowHandle, 9) | Out-Null
    [W]::SetForegroundWindow($p.MainWindowHandle) | Out-Null
    Write-Output "focused: $($p.MainWindowTitle)"
  }
  'move' {
    [W]::SetCursorPos([int]$A1, [int]$A2) | Out-Null
    Write-Output "cursor $A1,$A2"
  }
  'click' {
    [W]::SetCursorPos([int]$A1, [int]$A2) | Out-Null
    Start-Sleep -Milliseconds 120
    $mode = if ($A3) { $A3.ToLower() } else { 'left' }
    if ($mode -eq 'right') {
      [W]::mouse_event(0x0008,0,0,0,[IntPtr]::Zero)
      [W]::mouse_event(0x0010,0,0,0,[IntPtr]::Zero)
    } else {
      $n = if ($mode -eq 'double') { 2 } else { 1 }
      for ($i=0; $i -lt $n; $i++) {
        [W]::mouse_event(0x0002,0,0,0,[IntPtr]::Zero)
        [W]::mouse_event(0x0004,0,0,0,[IntPtr]::Zero)
        Start-Sleep -Milliseconds 80
      }
    }
    Write-Output "clicked $mode at $A1,$A2"
  }
  'drag' {
    [W]::SetCursorPos([int]$A1, [int]$A2) | Out-Null
    Start-Sleep -Milliseconds 100
    [W]::mouse_event(0x0002,0,0,0,[IntPtr]::Zero)
    Start-Sleep -Milliseconds 100
    [W]::SetCursorPos([int]$A3, [int]$A4) | Out-Null
    Start-Sleep -Milliseconds 150
    [W]::mouse_event(0x0004,0,0,0,[IntPtr]::Zero)
    Write-Output "dragged $A1,$A2 -> $A3,$A4"
  }
  'type' {
    [System.Windows.Forms.SendKeys]::SendWait($A1)
    Write-Output "typed $($A1.Length) chars"
  }
  'key' {
    [System.Windows.Forms.SendKeys]::SendWait($A1)
    Write-Output "sent keys: $A1"
  }
  'pos' {
    $p = [System.Windows.Forms.Cursor]::Position
    Write-Output "$($p.X) $($p.Y)"
  }
  default { Write-Error "unknown verb '$Verb'"; exit 1 }
}
