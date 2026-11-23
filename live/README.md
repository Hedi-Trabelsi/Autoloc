# live/ — GUI control for the pi agent

pi has no native screen control. These scripts give it eyes and hands via PowerShell.
Everything is driven through the agent's `bash` tool, one turn at a time
(perceive → act → verify).

## Requires

Always call with `-ExecutionPolicy Bypass` (script execution is disabled on this box).

    P="powershell -NoProfile -ExecutionPolicy Bypass -File live/ui.ps1"

## Verbs

| command | effect |
|---|---|
| `$P shot out/a.png` | full desktop screenshot (all monitors) |
| `$P shot out/a.png "Chrome"` | bring window matching title to front, capture just that window |
| `$P wins` | list visible windows + titles (pid + title) |
| `$P focus "Notepad"` | bring window to front |
| `$P move 640 400` | move cursor |
| `$P click 640 400` | left click |
| `$P click 640 400 right` / `double` | right / double click |
| `$P drag 100 100 400 400` | press-drag-release |
| `$P type "hello"` | send keystrokes (SendKeys syntax) |
| `$P key "^s"` | ctrl+s — see SendKeys table below |
| `$P pos` | current cursor x y |

SendKeys: `^`=Ctrl, `%`=Alt, `+`=Shift, `{ENTER}` `{TAB}` `{ESC}` `{F1}`.., `{DEL}`, `{BS}`.
Literal `+ ^ % ~ ( ) { } [ ]` must be wrapped in `{}`.

## Screen recording (true live capture)

    ffmpeg -y -f gdigrab -framerate 15 -i desktop live/out/rec.mp4     # Ctrl-C to stop
    ffmpeg -y -f gdigrab -framerate 15 -t 10 -i desktop live/out/rec.mp4   # 10s fixed

    # extract stills from a recording for inspection
    ffmpeg -y -i live/out/rec.mp4 -vf fps=1 live/out/frame_%03d.png

Window-only recording: `-i title="Chrome"` instead of `-i desktop`.
(Both `ddagrab`/`gdigrab` and `title=` are in the installed 9.0.2 build.)

## Agent loop

1. `$P shot live/out/1.png` → read the PNG
2. decide the target coordinates (read them off the image)
3. `$P click X Y` / `$P type "..."` / `$P key "{ENTER}"`
4. `$P shot live/out/2.png` → read it and verify the result
5. repeat from 1

## Notes / limits

- Coordinates are absolute desktop pixels, origin top-left of the primary monitor.
  Take the coords straight from a full-desktop `shot`; windowed captures are offset.
- Screenshots capture whatever is on screen, including private windows.
- `focus`/`shot "title"` steal foreground focus — do not type until the shot confirms
  the right window is in front.
- No UAC elevation (scripts run at the agent's privilege). Admin windows accept clicks
  but not keystrokes.
- Prefer the CLI over the GUI when both exist: `git`, `npm`, `ffmpeg`, an app's own
  `--do-thing` flag are far more reliable than pixels. GUI control is the fallback.
