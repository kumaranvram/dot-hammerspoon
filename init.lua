-- DO NOT EDIT THIS FILE DIRECTLY
-- This is a file generated from a literate programing source file located at
-- https://github.com/zzamboni/dot-hammerspoon/blob/master/init.org.
-- You should make any changes there and regenerate it from Emacs org-mode using C-c C-v t

hs.logger.defaultLogLevel="info"

hyper = {"cmd","alt","ctrl"}
shift_hyper = {"cmd","alt","ctrl","shift"}

col = hs.drawing.color.x11
amphetamine = require "amphetamine"
work_logo = hs.image.imageFromPath(hs.configdir .. "/files/work_logo_2x.png")

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall.repos.zzspoons = {
  url = "https://github.com/zzamboni/zzSpoons",
  desc = "zzamboni's spoon repository",
}

spoon.SpoonInstall.use_syncinstall = true

Install=spoon.SpoonInstall

Install:andUse("WindowHalfsAndThirds",
               {
                 config = {
                   use_frame_correctness = true
                 },
                 hotkeys =  {
                  left_half   = { {"ctrl",        "cmd"}, "Left" },
                  right_half  = { {"ctrl",        "cmd"}, "Right" },
                  top_half    = { {"ctrl",        "cmd"}, "Up" },
                  bottom_half = { {"ctrl",        "cmd"}, "Down" },
                  third_left  = { {"ctrl", "alt"       }, "Left" },
                  third_right = { {"ctrl", "alt"       }, "Right" },
                  third_up    = { {"ctrl", "alt"       }, "Up" },
                  third_down  = { {"ctrl", "alt"       }, "Down" },
                  top_left    = { {"ctrl",        "cmd"}, "1" },
                  top_right   = { {"ctrl",        "cmd"}, "2" },
                  bottom_left = { {"ctrl",        "cmd"}, "3" },
                  bottom_right= { {"ctrl",        "cmd"}, "4" },
                  max_toggle  = { {"ctrl", "alt", "cmd"}, "f" },
                  max         = { {"ctrl", "alt", "cmd"}, "Up" },
                  larger      = { {        "alt", "cmd", "shift"}, "Right" },
                  smaller     = { {        "alt", "cmd", "shift"}, "Left" },
               }
               }
)

Install:andUse("WindowScreenLeftAndRight",
               {
                 hotkeys = 'default'
               }
)

Install:andUse("WindowGrid",
               {
                 disable = false,
                 config = { gridGeometries = { { "6x4" } } },
                 hotkeys = {show_grid = {hyper, "g"}},
                 start = true
               }
)

Install:andUse("ToggleScreenRotation",
               {
                 hotkeys = { first = {hyper, "f15"} }
               }
)


Install:andUse("TextClipboardHistory",
               {
                 disable = false,
                 hist_size = 40,
                 config = {
                   show_in_menubar = false
                 },
                 hotkeys = {
                   toggle_clipboard = { { "cmd", "shift" }, "v" } },
                 start = true,
               }
)

Install:andUse("MouseCircle",
               {
                 disable = false,
                 config = {
                   color = hs.drawing.color.x11.rebeccapurple
                 },
                 hotkeys = {
                   show = { hyper, "m" }
                 }
               }
)

Install:andUse("ColorPicker",
               {
                 disable = false,
                 hotkeys = {
                   show = { shift_hyper, "z" }
                 },
                 config = {
                   show_in_menubar = false,
                 },
                 start = true,
               }
)


Install:andUse("ToggleSkypeMute",
               {
                 hotkeys = {
                   toggle_skype = { shift_hyper, "v" },
                   toggle_skype_for_business = { shift_hyper, "f" }
                 }
               }
)

Install:andUse("HeadphoneAutoPause",
               {
                 start = true
               }
)

Install:andUse("WiFiTransitions",
               {
                 config = {
                   actions = {
                     -- { -- Test action just to see the SSID transitions
                     --    fn = function(_, _, prev_ssid, new_ssid)
                     --       hs.notify.show("SSID change",
                     --          string.format("From '%s' to '%s'",
                     --          prev_ssid, new_ssid), "")
                     --    end
                     -- },
                     { -- Enable proxy config when joining corp network
                       to = "corpnet01",
                       fn = {hs.fnutils.partial(reconfigSpotifyProxy, true),
                             hs.fnutils.partial(reconfigAdiumProxy, true),
                             hs.fnutils.partial(forceKillProcess, "Dropbox"),
                             hs.fnutils.partial(stopApp, "Evernote"),
                       }
                     },
                     { -- Disable proxy config when leaving corp network
                       from = "corpnet01",
                       fn = {hs.fnutils.partial(reconfigSpotifyProxy, false),
                             hs.fnutils.partial(reconfigAdiumProxy, false),
                             hs.fnutils.partial(startApp, "Dropbox"),
                       }
                     },
                   }
                 },
                 start = true,
               }
)

local wm=hs.webview.windowMasks
Install:andUse("PopupTranslateSelection",
               {
                 config = {
                   popup_style = wm.utility|wm.HUD|wm.titled|
                     wm.closable|wm.resizable,
                 },
                 hotkeys = {
                   translate_to_en = { hyper, "e" },
                   translate_to_de = { hyper, "d" },
                   translate_to_es = { hyper, "s" },
                   translate_to_ta = { hyper, "t" },
                 }
               }
)

Install:andUse("DeepLTranslate",
               {
                 disable = true,
                 config = {
                   popup_style = wm.utility|wm.HUD|wm.titled|
                     wm.closable|wm.resizable,
                 },
                 hotkeys = {
                   translate = { hyper, "e" },
                 }
               }
)

local localfile = hs.configdir .. "/init-local.lua"
if hs.fs.attributes(localfile) then
  dofile(localfile)
end

Install:andUse("FadeLogo",
               {
                 config = {
                   default_run = 1.0,
                 },
                 start = true
               }
)

Install:andUse("CircleClock", {})

local previousPowerSource = hs.battery.powerSource()

function minutesToHours(minutes)
  if minutes <= 0 then
    return "0:00";
  else
    hours = string.format("%d", math.floor(minutes / 60))
    mins = string.format("%02.f", math.floor(minutes - (hours * 60)))
    return string.format("%s:%s", hours, mins)
  end
end

function showBatteryStatus()
  local message

  if hs.battery.isCharging() then
    local pct = hs.battery.percentage()
    local untilFull = hs.battery.timeToFullCharge()
    local charger = hs.battery.psuSerialString()
    message = "Charging:"

    if charger == 'C04905407TGGW85B0' or charger == '' then
    else
      hs.alert.show("Looks like you are not using your charger")
    end

    if untilFull == -1 then
      message = string.format("%s %.0f%% (calculating...) with charger %s", message, pct, charger);
    else
      local watts = hs.battery.watts()
      message = string.format("%s %.0f%% (%s remaining @ %.1fW) with charger %s", message, pct, minutesToHours(untilFull), watts, charger)
    end
  elseif hs.battery.powerSource() == "Battery Power" then
    local pct = hs.battery.percentage()
    local untilEmpty = hs.battery.timeRemaining()
    message = "Battery:"

    if untilEmpty == -1 then
      message = string.format("%s %.0f%% (calculating...)", message, pct)
    else
      local watts = hs.battery.watts()
      message = string.format("%s %.0f%% (%s remaining @ %.1fW)", message, pct, minutesToHours(untilEmpty), watts)
    end
  else
    message = "Fully charged"
  end

  hs.alert.show(message)
end

function batteryChangedCallback()
  local powerSource = hs.battery.powerSource()

  if powerSource ~= previousPowerSource then
    showBatteryStatus()
    previousPowerSource = powerSource;
  end
end

hs.battery.watcher.new(batteryChangedCallback):start()

hs.hotkey.bind(hyper, "B", showBatteryStatus)

local applicationHotkeys = {
  g = 'Google Chrome',
  i = 'iTerm',
  s = 'Slack',
  c = 'Calendar',
  r = 'RubyMine',
  q = 'Visual Studio Code',
  l = 'Logseq',
}

for key, app in pairs(applicationHotkeys) do
  hs.hotkey.bind(shift_hyper, key, function()
    hs.application.launchOrFocus(app)
  end)
end

hs.hotkey.bind(hyper, 'w', function()
  hs.urlevent.openURL("https://shopify.workplace.com")
end)

hs.hotkey.bind({"cmd", "shift"}, "0", function()
  caffeineClicked()
end)

hs.hotkey.bind(hyper, ';', function()
  local chargingMark = hs.battery.isCharging() and " Charging: " .. hs.battery.timeToFullCharge() .. "min until fully charged. " or ""
  local batteryPercentage = hs.battery.percentage()
  local powerSource = "Running on " .. hs.battery.powerSource()
  local battery =  batteryPercentage .. "% (" .. chargingMark .. powerSource ..")"
  hs.alert.show(os.date("%a %b %d - %H:%M | ") .. battery, 4)
end)

function reloadConfig(files)
  doReload = false
  for _, file in pairs(files) do
      if file:sub(-4) == ".lua" then
          doReload = true
      end
  end
  if doReload then
      hs.reload()
  end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

hs.notify.show("Welcome to Hammerspoon", "Have fun!", "")
