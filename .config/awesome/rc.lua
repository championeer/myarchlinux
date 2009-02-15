-- Standard awesome library
require("awful")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Wicked library
require("wicked")
-- Load my widget functions
require("functions")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
theme_path = "/home/qianli/.config/awesome/themes/qianli"

-- Actually load theme
beautiful.init(theme_path)

-- Apps
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
browser = "firefox"
fileManager = "pcmanfm"

-- Volume
cardid = 0
channel = "Master"

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}

-- Table of clients that should be set floating. 
floatapps =
{
    ["gimp"] = true,
    ["smplayer"] = true,
    ["stardict"] = true,
    ["skype"] = true,
    ["qq"] = true,
    ["feh"] = true,
    ["emesene"] = true,
    ["sonata"] = true,
    ["VirtualBox"] = true,
    ["Mirage"] = true,
    ["MPlayer"] = true,
    ["gcalctool"] = true,
    -- FireFox windows
    ["Saved Passwords"] = true,
    ["Cookies"] = true,
    ["Browser"] = true,
    ["Downloads"] = true,
    ["Download"] = true,
    ["Library"] = true,
    ["Places"] = true,
    ["Greasemonkey"] = true,
    ["Add-ons"] = true
}

-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
    ["Firefox"] = { screen = 1, tag = 2 },
    ["firefox"] = { screen = 1, tag = 2 },
    ["Gran Paradiso"] = { screen = 1, tag = 2 },
    ["transmission"] = { screen = 1, tag = 2 },
    --["pcmanfm"] = { screen = 1, tag = 1 },
    ["smplayer"] = { screen = 1, tag = 4 },
    ["Emacs"] = { screen = 1, tag = 3 },
    ["pidgin"] = { screen = 1, tag = 5 },
    ["OpenOffice.org 3.0"] = { screen = 1, tag = 6 }
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

-- {{{ Tags

tag_properties = { { name = "term"
                   , layout = layouts[3]
                   , mwfact = 0.618033988769
                   }
                 , { name = "www"
                   , layout = layouts[1]
                   , mwfact = 0.65
                   , nmaster = 1
                   }
                 , { name = "code"
                   , layout = layouts[5]
                   , ncols = 2
                   }
                 , { name = "media"
                   , layout = layouts[10]
                   }
                 , { name = "im"
                   , layout = layouts[10]
                   }
                 , { name = "6"
                   , layout = layouts[10]
                   }
                 }

-- Define tags table.
tags = {}
for s = 1, screen.count() do
    tags[s] = { }
    for i, v in ipairs(tag_properties) do
        tags[s][i] = tag(v.name)
        tags[s][i].screen = s
        awful.tag.setproperty(tags[s][i], "layout", v.layout)
        awful.tag.setproperty(tags[s][i], "mwfact", v.mwfact)
        awful.tag.setproperty(tags[s][i], "nmaster", v.nmaster)
        awful.tag.setproperty(tags[s][i], "ncols", v.ncols)
    end
    tags[s][1].selected = true
end

-- }}}

-- {{{ Wibox
-- Please note the functions feeding some of the widgets are found in functions.lua

-- Create a laucher widget and a main menu
awesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

-- Main menu
mainmenu = 
awful.menu.new({ 
    items = { 
                { "Term"        , terminal },
                { "FF"          , browser },
                { "PCManFM"     , fileManager },
                { "Cal"        , "gcalctool" },
                { "Gimp"        , "gimp" },
                { "Screen"      , terminal.." -e screen -RR -A -a" },
                { "Awesome"     , awesomemenu },
                { "Reboot"     , "sudo reboot" },
                { "ShutDown"     , "sudo halt" }
            },
            border_width = beautiful.border_width_menu
})

-- Launcher menu
launcher = 
awful.widget.launcher({ 
    image = image(beautiful.awesome_icon),
    menu = mainmenu,
    align = "left" 
})
launcher.resize = true

-- Create a systray
systray = widget({ type = "systray", align = "right" })

-- Simple spacer we can use to get cleaner code
spacer = " "

-- Separator icon
separatorR = widget({ type = "imagebox", align = "right" })
separatorR.image = image(beautiful.sepic)

separatorL = widget({ type = "imagebox", align = "left" })
separatorL.image = image(beautiful.sepic)

-- Create the clock widget
clockwidget = widget({ type = "textbox", align = "right" })
-- Run it once so we don't have to wait for the hooks to see our clock
clockInfo("%Y/%m/%d - %H:%M")

datewidget = widget({
    type = 'textbox',
    name = 'datewidget',
    align = 'right'
})
wicked.register(datewidget, wicked.widgets.date,
    ' %A, %Y/%m/%d - %H:%M ')

-- Create the wifi widget
wifiic = widget({ type = "imagebox", align = "left" })
wifiic.image = image(beautiful.wifiic)
wifiic.resize = false
wifiwidget = widget({ type = "textbox", align = "left" })
-- Run it once so we don't have to wait for the hooks to see our signal strength
wifiInfo("wlan0")

-- Create the battery widget
batic = widget({ type = "imagebox", align = "right" })
batic.image = image(beautiful.batic)
batic.resize = false
batterywidget = widget({ type = "textbox", align = "right" })
-- Run it once so we don't have to wait for the hooks to see our percentage
batteryInfo("BAT0")

-- Create the memory widget
memic = widget({ type = "imagebox", align = "left" })
memic.image = image(beautiful.memic)
memic.resize = false
memwidget = widget({ type = "textbox", align = "left" })
-- Run it once so we don't have to wait for the hooks to see our memory usage
memInfo()

-- Create the CPU Usage widget
cpuic = widget({ type = "imagebox", align = "left" })
cpuic.image = image(beautiful.cpuic)
cpuic.resize = false
usgwidget = widget({ type = "textbox", align = "left" })
wicked.register(usgwidget, wicked.widgets.cpu, cpuUsg, 5, nil, 2)

-- Create CPU Temps, GPU Temp widget
tempic = widget({ type = "imagebox", align = "left" })
tempic.image = image(beautiful.tempic)
tempic.resize = false
get_cputemp = 'acpi -t | grep Thermal\\ 0: | awk \'{print $4}\''
--get_gputemp = 'nvidia-settings -q gpucoretemp |grep \'):\' | awk \'{print $4}\''
-- cpu temp
cputempwidget = widget({type = 'textbox',name = 'tempwidget',align = "left"})
wicked.register(cputempwidget, 'function', function (widget,args)
		local f = io.popen(get_cputemp)
		local l = f:read()
		f:close()
        l = setFg(beautiful.fg_widg,tonumber(l).."°C")..spacer
		return  l
	end, 4)
-- gpu temp
--gputempwidget = widget({type = 'textbox',name = 'gputempwidget',align = "left"})
--wicked.register(gputempwidget, 'function', function (widget,args)
--		local f = io.popen(get_gputemp)
--		local l = f:read()
--		f:close()
--		return  ' '..l..'°C'
--	end, 4)

--tempwidget = widget({ type = "textbox", align = "left" })
--wicked.register(tempwidget, sysInfo, "$1", 35)

-- Create the File Sys Usage widget
fsic = widget({ type = "imagebox", align = "left" })
fsic.image = image(beautiful.fsic)
fsic.resize = false
fswidget = widget({ type = "textbox", align = "left" })
wicked.register(fswidget, wicked.widgets.fs, 
    setFg(beautiful.fg_focus, "/:")..setFg(beautiful.fg_widg, '${/ usep}').."%"..spacer..setFg(beautiful.fg_focus, "~:")..setFg(beautiful.fg_widg, '${/home usep}').."%"..spacer..setFg(beautiful.fg_focus, "/var:")..setFg(beautiful.fg_widg, '${/var usep}').."%"..spacer, 
30)

-- Create the volume widget
volic = widget({ type = "imagebox", align = "right" })
volic.image = image(beautiful.volic)
volic.resize = false
volumewidget = widget({ type = "textbox", align = "right" })
wicked.register(volumewidget, getVol, "$1", 30)

-- Create net widget
netupic = widget({ type = "imagebox", algin = "left" })
netupic.image = image(beautiful.netupic)
netupic.resize = false
netupwidget = widget({ type = "textbox", align = "left" })
wicked.register(netupwidget, wicked.widgets.net, 
    setFg(beautiful.fg_widg, ' ${wlan0 up_kb}kbps / ${wlan0 tx} '), nil, nil, 3)

netdnic = widget({ type = "imagebox", algin = "left" })
netdnic.image = image(beautiful.netdnic)
netdnic.resize = false
netdnwidget = widget({ type = "textbox", align = "left" })
wicked.register(netdnwidget, wicked.widgets.net, 
    setFg(beautiful.fg_widg, ' ${wlan0 down_kb}kbps / ${wlan0 rx} '),
nil, nil, 3)

--TODO:
-- Create the Pacman Upgrade Query widget
--pacic = widget({ type = "imagebox", align = "right" })
--pacic.image = image(beautiful.pacic)
--pacic.resize = false
--pacwidget = widget({ type = "textbox", name = "pacwidget", align = "right" })
--wicked.register(pacwidget, pacinfo, "$1", 1800)

-- Create a wibox for each screen and add it
mywibox_top = {}
mywibox_bottom = {}
promptbox = {}
mylayoutbox = {}
taglist = {}
taglist = {}
taglist.buttons =   { button({ }, 1, awful.tag.viewonly),
                      button({ modkey }, 1, awful.client.movetotag),
                      button({ }, 3, function (tag) tag.selected = not tag.selected end),
                      button({ modkey }, 3, awful.client.toggletag),
                      button({ }, 4, awful.tag.viewnext),
                      button({ }, 5, awful.tag.viewprev) }
tasklist = {}
tasklist.buttons =  { button({ }, 1, function (c) client.focus = c; c:raise() end),
                      button({ }, 3, function () if instance then instance:hide() end instance = awful.menu.clients({ width=250 }) end),
                      button({ }, 4, function () awful.client.focus.byidx(1) end),
                      button({ }, 5, function () awful.client.focus.byidx(-1) end) }

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    promptbox[s] = widget({ type = "textbox", align = "left" })
    
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = widget({ type = "imagebox", align = "right" })
    mylayoutbox[s]:buttons({ button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 5, function () awful.layout.inc(layouts, -1) end) })
                             
    -- Create a taglist widget
    taglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, taglist.buttons)

    -- Create a tasklist widget
    -- Mod: Only display currently focused client in tasklist
    tasklist[s] = awful.widget.tasklist.new(
                      function(c)
                        if c == client.focus and c ~= nil then
                            return setFg(beautiful.fg_focus, c.name)
                        end
                        --return awful.widget.tasklist.label.currenttags(c, s)
                      end, tasklist.buttons)

    -- Create the top wibox
   mywibox_top[s] = wibox({ 
        position = "top", 
        height = 25, 
        fg = beautiful.fg_normal, 
        bg = beautiful.bg_normal, 
        border_color = beautiful.border_wibox, 
        border_width = beautiful.border_width_wibox
    })
    
    -- Add widgets to the wibox - order matters
   mywibox_top[s].widgets = {launcher,
                            taglist[s],
                            tasklist[s],
                            promptbox[s],
                            s == 1 and systray or nil,
                            mylayoutbox[s]
                        }
   mywibox_top[s].screen = s
end

    -- Create the bottom wibox
for s = 1, screen.count() do
   mywibox_bottom[s] = wibox({ 
        position = "bottom", 
        height = 14.8, 
        fg = beautiful.fg_normal, 
        bg = beautiful.bg_normal, 
        border_color = beautiful.border_wibox, 
        border_width = beautiful.border_width_wibox
    })
    
    -- Add widgets to the wibox - order matters
   mywibox_bottom[s].widgets = {   --launcher,
                            cpuic,
                            usgwidget,
                            tempic,
                            cputempwidget,                            
                            --gputempwidget,                            
                            memic,
                            memwidget,
                            fsic,
                            fswidget,
                            wifiic,
                            wifiwidget,
                            netupic,
                            netupwidget,
                            netdnic,
                            netdnwidget,
                            batic,
                            batterywidget,
                            volic,
                            volumewidget,
                            separatorR,
                            --clockwidget
                            datewidget
                        }
   mywibox_bottom[s].screen = s
end
-- }}}

-- {{{ Mouse bindings
root.buttons({
    button({ }, 3, function () mainmenu:toggle() end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}

-- {{{ Key bindings
-- Bind keyboard digits
-- Compute the maximum number of digit we need, limited to 6
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(6, math.max(#tags[s], keynumber));
end

globalkeys = {}
clientkeys = {}

for i = 1, keynumber do
    table.insert(globalkeys,
        key({ modkey }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    awful.tag.viewonly(tags[screen][i])
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Control" }, i,
            function ()
                local screen = mouse.screen
                if tags[screen][i] then
                    tags[screen][i].selected = not tags[screen][i].selected
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][i] then
                    awful.client.movetotag(tags[client.focus.screen][i])
                end
            end))
    table.insert(globalkeys,
        key({ modkey, "Control", "Shift" }, i,
            function ()
                if client.focus and tags[client.focus.screen][i] then
                    awful.client.toggletag(tags[client.focus.screen][i])
                end
            end))
end

table.insert(globalkeys, key({ modkey }, "Left", awful.tag.viewprev))
table.insert(globalkeys, key({ modkey }, "Right", awful.tag.viewnext))
table.insert(globalkeys, key({ modkey }, "Escape", awful.tag.history.restore))

table.insert(globalkeys, key({ modkey }, "j", function () awful.client.focus.byidx(1); if client.focus then client.focus:raise() end end))
table.insert(globalkeys, key({ modkey }, "k", function () awful.client.focus.byidx(-1);  if client.focus then client.focus:raise() end end))
table.insert(globalkeys, key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1) end))
table.insert(globalkeys, key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end))

table.insert(globalkeys, key({ modkey, "Control" }, "j", function () awful.screen.focus(1) end))
table.insert(globalkeys, key({ modkey, "Control" }, "k", function () awful.screen.focus(-1) end))

table.insert(globalkeys, key({ modkey }, "Tab", function () awful.client.focus.history.previous(); if client.focus then client.focus:raise() end end))

table.insert(globalkeys, key({ modkey }, "u", awful.client.urgent.jumpto))

-- Standard program
table.insert(globalkeys, key({ modkey }, "Return", function () awful.util.spawn(terminal) end))
table.insert(globalkeys, key({ modkey }, "x", function () awful.util.spawn(terminal) end))
table.insert(globalkeys, key({ modkey }, "f", function () awful.util.spawn(browser) end))
table.insert(globalkeys, key({ modkey }, "s", function () awful.util.spawn("smplayer") end))
table.insert(globalkeys, key({ modkey }, "g", function () awful.util.spawn("gvim") end))
table.insert(globalkeys, key({ modkey }, "e", function () awful.util.spawn("emacs") end))
table.insert(globalkeys, key({ modkey }, "d", function () awful.util.spawn("stardict") end))
table.insert(globalkeys, key({ modkey }, "c", function () awful.util.spawn("gcalctool") end))
table.insert(globalkeys, key({	      }, "Print", function () awful.util.spawn("scrot  -e 'mv $f ~/Pictures/shots/' ") end))

table.insert(globalkeys, key({ modkey, "Control" }, "r", function ()
                                                             mypromptbox[mouse.screen].text =
                                                                 awful.util.escape(awful.util.restart())
                                                          end))
table.insert(globalkeys, key({ modkey, "Shift" }, "q", awesome.quit))

-- Client manipulation
table.insert(clientkeys, key({ modkey }, "m", function (c) c.maximized_horizontal = not c.maximized_horizontal
                                                           c.maximized_vertical = not c.maximized_vertical end))
table.insert(clientkeys, key({ modkey, "Shift" }, "f", function (c) c.fullscreen = not c.fullscreen end))
table.insert(clientkeys, key({ modkey, "Shift" }, "c", function (c) c:kill() end))
table.insert(clientkeys, key({ modkey }, "w", function (c) c:kill() end))
table.insert(clientkeys, key({ modkey, "Control" }, "space", awful.client.floating.toggle))
table.insert(clientkeys, key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end))
table.insert(clientkeys, key({ modkey }, "o", awful.client.movetoscreen))
table.insert(clientkeys, key({ modkey, "Shift" }, "r", function (c) c:redraw() end))

-- Layout manipulation
table.insert(globalkeys, key({ modkey }, "l", function () awful.tag.incmwfact(0.05) end))
table.insert(globalkeys, key({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end))
table.insert(globalkeys, key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end))
table.insert(globalkeys, key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end))
table.insert(globalkeys, key({ modkey, "Control" }, "h", function () awful.tag.incncol(1) end))
table.insert(globalkeys, key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end))
table.insert(globalkeys, key({ modkey }, "space", function () awful.layout.inc(layouts, 1) end))
table.insert(globalkeys, key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end))

-- Prompt
table.insert(globalkeys, key({ modkey }, "r", function ()
                                                    awful.prompt.run({ prompt = "Run: " },
                                                                     promptbox[mouse.screen],
                                                                     awful.util.spawn, awful.completion.bash,
                                                                     awful.util.getdir("cache") .. "/history")
                                               end))
table.insert(globalkeys, key({ modkey }, "F4", function ()
                                                   awful.prompt.run({ prompt = "Run Lua code: " },
                                                                    promptbox[mouse.screen],
                                                                    awful.util.eval, awful.prompt.bash,
                                                                    awful.util.getdir("cache") .. "/history_eval")
                                               end))

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
table.insert(clientkeys, key({ modkey }, "t", awful.client.togglemarked))

for i = 1, keynumber do
    table.insert(globalkeys, key({ modkey, "Shift" }, "F" .. i,
                 function ()
                     local screen = mouse.screen
                     if tags[screen][i] then
                         for k, c in pairs(awful.client.getmarked()) do
                             awful.client.movetotag(tags[screen][i], c)
                         end
                     end
                 end))
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Hooks
-- Hook function to execute when focusing a client.
awful.hooks.focus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function (c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- Hook function to execute when marking a client
awful.hooks.marked.register(function (c)
    c.border_color = beautiful.border_marked
end)

-- Hook function to execute when unmarking a client.
awful.hooks.unmarked.register(function (c)
    c.border_color = beautiful.border_focus
end)

-- Hook function to execute when the mouse enters a client.
awful.hooks.mouse_enter.register(function (c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c, startup)
    -- If we are not managing this application at startup,
    -- move it to the screen where the mouse is.
    -- We only do it for filtered windows (i.e. no dock, etc).
    if not startup and awful.client.focus.filter(c) then
        c.screen = mouse.screen
    end

    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, awful.mouse.client.move),
        button({ modkey }, 3, awful.mouse.client.resize)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        awful.client.floating.set(c, floatapps[cls])
    elseif floatapps[inst] then
        awful.client.floating.set(c, floatapps[inst])
    end

    -- Check application->screen/tag mappings.
    local target
    if apptags[cls] then
        target = apptags[cls]
    elseif apptags[inst] then
        target = apptags[inst]
    end
    if target then
        c.screen = target.screen
        awful.client.movetotag(tags[target.screen][target.tag], c)
    end

    -- Do this after tag mapping, so you don't see it on the wrong tag for a split second.
    client.focus = c

    -- Set key bindings
    c:keys(clientkeys)

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    -- c.size_hints_honor = false
end)

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.getname(awful.layout.get(screen))
    if layout and beautiful["layout_" ..layout] then
        mylayoutbox[screen].image = image(beautiful["layout_" .. layout])
    else
        mylayoutbox[screen].image = nil
    end

    -- Give focus to the latest client in history if no window has focus
    -- or if the current window is a desktop or a dock one.
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)

-- Hook called every second
--awful.hooks.timer.register(1, function ()
    -- For unix time_t lovers
--    mytextbox.text = " " .. os.time() .. " time_t "
    -- Otherwise use:
    -- mytextbox.text = " " .. os.date() .. " "
--end)

-- Hooks for Naughty Calendar
clockwidget.mouse_enter = function()
    add_calendar(0)
end
clockwidget.mouse_leave = remove_calendar

clockwidget:buttons({
    button({ }, 4, function()
        add_calendar(-1)
    end),
    button({ }, 5, function()
        add_calendar(1)
    end),
})

-- Timed hooks for the widget functions
-- 1 minute/30 seconds
awful.hooks.timer.register(30, function ()
    clockInfo("%Y/%m/%d - %H:%M")
end)

-- 35 seconds
awful.hooks.timer.register(35, function()
    wifiInfo("wlan0")
end)

-- 20 seconds
awful.hooks.timer.register(20, function()
    memInfo()
    batteryInfo("BAT0")
end)
-- }}}
