io.stderr:write("\n\n\r::: Awesome Loaded :::\r\n\n")

-- Include awesome libraries, with lots of useful function!
require("awful")
require("beautiful")
require("naughty")
require("wicked")

-- {{{ Variable definitions
-- This is a file path to a theme file which will defines colors.
theme_path = "/home/qianli/.config/awesome/themes/my"

-- {{ Define volume control function
 cardid  = 0
 channel = "Master"
 function volume (mode, widget)
 	if mode == "update" then
 		local status = io.popen("amixer -c " .. cardid .. " -- sget " .. channel):read("*all")
 		
 		local volume = string.match(status, "(%d?%d?%d)%%")
 		volume = string.format("% 3d", volume)
 
 		status = string.match(status, "%[(o[^%]]*)%]")
 
 		if string.find(status, "on", 1, true) then
-- 			volume = volume .. "%"
            pb_volume:bar_properties_set("vol", {["bg"] = "#000000"})
 		else
-- 			volume = volume .. "M"
            pb_volume:bar_properties_set("vol", {["bg"] = "#cc3333"})
 		end
-- 		widget.text = volume
        pb_volume:bar_data_add("vol", volume)
 	elseif mode == "up" then
 		awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%+")
 		volume("update", widget)
 	elseif mode == "down" then
 		awful.util.spawn("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%-")
 		volume("update", widget)
 	else
 		awful.util.spawn("amixer -c " .. cardid .. " sset " .. channel .. " toggle")
 		volume("update", widget)
 	end
 end
-- }}

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
filemanager = "rox" or "thunar"
browser = "firefox" or "opera"
txt_editor = "emacs" or "gvim"
dict = "stardict"
lock = "xscreensaver-command -lock"
menu = "`dmenu_path | dmenu -fn '-*-terminus-*-r-normal-*-*-160-*-*-*-*-iso8859-*' -nb '#000000' -nf '#ffffff' -sb '#0066ff'`"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    "tile",
    "tileleft",
    "tilebottom",
    "tiletop",
    "fairh",
    "fairv",
    "magnifier",
    "max",
    "fullscreen",
    "spiral",
    "dwindle",
    "floating"
}

-- Table of clients that should be set floating. The index may be either
-- the application class or instance. The instance is useful when running
-- a console app in a terminal like (Music on Console)
--    xterm -name mocp -e mocp
floatapps =
{
    -- by class
    ["MPlayer"] = true,
    ["smplayer"] = true,
    ["stardict"] = true,
    ["skype"] = true,
    ["emesene"] = true,
    ["pidgin"] = true,
    ["qq"] = true,
    ["feh"] = true,
    ["tsclient"] = true,
    ["sonata"] = true,
    ["VirtualBox"] = true,
    ["Inkscape"] = true,
    ["gimp"] = true,
    ["Mirage"] = true,
    -- by instance
    ["mocp"] = true
}

-- Applications to be moved to a pre-defined tag by class or instance.
-- Use the screen and tags indices.
apptags =
{
     ["Firefox"] = { screen = 1, tag = 2 },
     ["firefox"] = { screen = 1, tag = 2 },
     ["Gran Paradiso"] = { screen = 1, tag = 2 },
     --
     ["Emacs"] = { screen = 1, tag = 3 },
     --
     ["smplayer"] = { screen = 1, tag = 4 },
     ["sonata"] = { screen = 1, tag = 4 },
     --
     ["skype"] = { screen = 1, tag = 5 },
     ["pidgin"] = { screen = 1, tag = 5 },
     ["emesene"] = { screen = 1, tag = 5 },
     ["qq"] = { screen = 1, tag = 5 },
}

-- Define if we want to use titlebar on all applications.
use_titlebar = false
-- }}}

-- {{{ Initialization
-- Initialize theme (colors).
beautiful.init(theme_path)

-- Register theme in awful.
-- This allows to not pass plenty of arguments to each function
-- to inform it about colors we want it to draw.
--awful.beautiful.register(beautiful)
-- }}}

-- {{{ Tags
-- Define tags table.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = {}
    -- Create 9 tags per screen.
    for tagnumber = 1, 9 do
        tags[s][tagnumber] = tag({ name = tagnumber, layout = layouts[1] })
        -- Add tags to screen one by one
        tags[s][tagnumber].screen = s
    end
    -- I'm sure you want to see at least one tag.
    tags[s][1].selected = true
    tags[s][1].selected = true
    tags[s][1].mwfact = 0.55
    tags[1][1].name = "1-term"
    tags[1][2].name = "2-web"
    tags[1][3].name = "3-coding"
    tags[1][4].name = "4-media"
    tags[1][5].name = "5-im"
    tags[1][1].layout = "tilebottom"
    tags[1][4].layout = "floating"
    tags[1][5].layout = "floating"
    tags[1][8].layout = "floating"
    tags[1][9].layout = "floating"
end
-- }}}

-- {{{ Wibox
-- Create a textbox widget
mytextbox = widget({ type = "textbox", align = "right" })
-- Set the default text in textbox
mytextbox.text = "<b><small> " .. AWESOME_RELEASE .. " </small></b>"

-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu.new({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                        { "open terminal", terminal },
                                        { "OpenOffice", "soffice" },
                                        { "Gimp", "gimp" },
                                        { "Inkscape", "inkscape" },
                                        { "Pcmanfm", "pcmanfm" },
                                        { "SciTE", "scite" },
                                        { "Reboot", "sudo reboot" },
                                        { "Shutdown", "sudo halt" }
                                      }
                            })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Create a systray
mysystray = widget({ type = "systray", align = "right" })

-- {{ Create my widgets
-- Separator widgets
bar = widget({type = "textbox", name = "bar", align = "left"})
bar.text = " - "
--
space = widget({type = "textbox", name = "space", align = "left"})
space.text = " "
--
spacerr = " "
--
spacer = widget({type = "textbox", name = "spacer", align = "right"})
spacer.text = " "
-- Command
get_battery = 'acpi | cut -f 2 -d ,'
get_temp = 'acpi -t | grep Thermal\\ 1: | awk \'{print $4}\''
get_gpu_temp = 'nvidia-settings -q gpucoretemp |grep \'):\' | awk \'{print $4}\''
get_music = 'mpc | grep -v %'
get_sound = 'amixer get Master'
-- Date widget
datewidget = widget({type = 'textbox', name = 'datewidget', align = 'right'})
wicked.register(datewidget, 'date', '[ %a | %R ] - %Y/%m/%d')
-- Battery widget
baticonbox = widget({type = "textbox", name = "baticonbox", align = "left"})
--baticonbox.text = "<bg image=\"/home/qianli/.config/awesome/bat.png\" resize=\"false\" />"
baticonbox.text = "<span color=\"white\">BAT: </span>"
battextwidget = widget({type = "textbox", name = "battextwidget", align = "left"})
wicked.register(battextwidget, 'function', function (widget,args)
    local f = io.popen(get_battery)
    local l = f:read()
    f:close()
    return l
end, 10)
--Temp widget
tempiconbox = widget({ type = "textbox", name = "tempiconbox",align = "left" })
	tempiconbox.text = "<span color=\"white\">TEMP: </span>" 
	tempwidget = widget({type = 'textbox',name = 'tempwidget',align = "left"})
	
	wicked.register(tempwidget, 'function', function (widget,args)
		local f = io.popen(get_temp)
		local l = f:read()
		f:close()
		return  ' '..l..'°C'
	end, 4)
--GPU Temp widget
gputempiconbox = widget({ type = "textbox", name = "gputempiconbox",align = "left" })
	gputempiconbox.text = "<span color=\"white\">GPU TEMP: </span>" 
	gputempwidget = widget({type = 'textbox',name = 'gputempwidget',align = "left"})
	
	wicked.register(gputempwidget, 'function', function (widget,args)
		local f = io.popen(get_gpu_temp)
		local l = f:read()
		f:close()
		return  ' '..l..'°C'
	end, 4)
--CPU text widget
cpuwidget = widget({
    type = 'textbox',
    name = 'cpuwidget'
})
cpuwidget:buttons({
    button({ }, 1, function ()awful.util.spawn("urxvt -e htop") end)
    })
wicked.register(cpuwidget, 'cpu',
    ' <span color="white">CPU:</span> $1%')
--CPU widget
cpuiconbox = widget({ type = "textbox", name = "cpuiconbox", align = "left" })
cpuiconbox.text = "<span color=\"white\">CPU: </span>" 
cpugraphwidget = widget({type = 'graph',name = 'cpugraphwidget',align = 'left'	})
cpugraphwidget.height = "0.8"
cpugraphwidget.width = "30"
cpugraphwidget.border_color = '#999999'
cpugraphwidget.grow = 'left'
cpugraphwidget:plot_properties_set('cpu',{fg = '#ff6600'})
cpugraphwidget:buttons ({
    button({ }, 1, function ()awful.util.spawn("urxvt -e htop") end)
})
wicked.register(cpugraphwidget, 'cpu', '$1', 1, 'cpu')
--MPD widget
--MPD Widget 2
mpdswidget = widget({
    type = 'textbox',
        name = 'mpdswidget'
        })
wicked.register(mpdswidget, wicked.widgets.mpd, 
    function (widget, args)
       if args[1]:find("volume:") == nil then
          return ' <span color="white"> - Now Playing:</span> '..args[1]
           else
         return ''
        end
        end)
-- mpd widget 3
--mpdwidget = widget({ type="textbox", name = "mpdwidget", align = "right" })
--mpdwidget:buttons({ button({ }, 1, function () awful.util.spawn("ncmpcpp toggle") end)}) 
--function mpdInfo()
--    local mpdFile = io.popen("ncmpcpp")
--    local song = mpdFile:read()
--    local state = mpdFile:read()
--    local show_info = true
--    if not state then 
--    	show_info = false
--    elseif state:match("playing") then
--        txt = ">>:"..spacerr
--    elseif state:match("paused") then
--        txt = "||:"..spacerr
--    end
--    if show_info then
--        mpdwidget.text = spacerr.."MPD:"..spacerr..txt..song..spacerr
--    else
--        mpdwidget.text = spacerr.."MPD:"..spacerr.."[]: not playing"..spacerr
--    end
--    mpdFile:close()
--end

--Volume widget
voliconbox = widget({ type = "textbox", name = "voliconbox", align = "left" })
	voliconbox.text = "<bg image=\"/home/qianli/.config/awesome/sound.png\" resize=\"false\" />"
	voliconbox:buttons ({
        button({ }, 4, function ()awful.util.spawn("amixer set Master 2dB+ unmute") end),
	    button({ }, 5, function ()awful.util.spawn("amixer set Master 2dB- unmute") end),
	    button({ }, 1, function ()awful.util.spawn("amixer set Master mute") end),
	    button({ modkey }, 1, function ()awful.util.spawn("amixer set Master unmute") end)
    })
volumewidget = widget({
    type = 'textbox',
    name = 'volumewidget'
})

wicked.register(volumewidget, 'function', function (widget, args)
   local f = io.popen(get_sound)
   local l = f:lines()
   local v = ''

   for line in l do
       if line:find('Front Left:') ~= nil then
            pend = line:find('%]', 0, true)
            pstart = line:find('[', 0, true)
            v = line:sub(pstart+1, pend)
       end
   end

   f:close()

   return ''..v
end, 4)
	volumewidget:buttons ({
        button({ }, 4, function ()awful.util.spawn("amixer set Master 2dB+ unmute") end),
	    button({ }, 5, function ()awful.util.spawn("amixer set Master 2dB- unmute") end)
    })
---- second volume widget
pb_volume =  widget({ type = "progressbar", name = "pb_volume", align = "left" })
 pb_volume.width = 12
 pb_volume.height = 0.80
 pb_volume.border_padding = 1
 pb_volume.ticks_count = 0
 pb_volume.vertical = true
 
 pb_volume:bar_properties_set("vol", 
 { 
   ["bg"] = "#000000",
   ["fg"] = "#6666cc",
   ["fg_center"] = "#cc3300",
   ["fg_end"] = "#ff6600",
   ["fg_off"] = "#000000",
   ["border_color"] = "#444444"
 })
pb_volume:buttons({
 	button({ }, 4, function () volume("up", pb_volume) end),
 	button({ }, 5, function () volume("down", pb_volume) end),
 	button({ }, 1, function () volume("mute", pb_volume) end)
 })
 volume("update", pb_volume)

-- Filesystem widget
fswidget = widget({
    type = 'textbox',
    name = 'fswidget'
})

wicked.register(fswidget, 'fs',
    ' <span color="white">FS:</span> ${/home usep}% used', 120)
-- Network monitor widget
netwidget = widget({
    type = 'textbox',
    name = 'netwidget',

})

wicked.register(netwidget, 'net', 
    ' <span color="white">NET</span>: ${wlan0 down} / ${wlan0 up}')
-- Net text widget
nettextwidget = widget({
    type = 'textbox',
    name = 'nettextwidget',
    })
nettextwidget.text = "<span color=\"white\">NET: </span>"
-- {{{ Net Widget UP
netupgraphwidget = widget ({
  type = 'graph',
  name = 'netupgraphwidget',
  align = 'left'
})
netupgraphwidget.height = 0.80
netupgraphwidget.width = 30
--netupgraphwidget.bg = '333333'
netupgraphwidget.border_color = '#999999'
netupgraphwidget.grow = 'left'
netupgraphwidget:plot_properties_set('net', {
  fg = '#ff0000',
  vertical_gradient = true
})
wicked.register(netupgraphwidget, 'net', function (widget, args)
  return ((args['{wlan0 up_kb}']/120)*100) end, 2, 'net')
-- }}}

-- {{{ Net Widget DN
netdngraphwidget = widget ({
  type = 'graph',
  name = 'netdngraphwidget',
  align = 'left'
})
netdngraphwidget.height = 0.80
netdngraphwidget.width = 30
--netdngraphwidget.bg = '333333'
netdngraphwidget.border_color = '#999999'
netdngraphwidget.grow = 'left'
netdngraphwidget:plot_properties_set('net', {
  fg = '#00ff00',
  vertical_gradient = true
})
wicked.register(netdngraphwidget, 'net', function (widget, args)
  return ((args['{wlan0 down_kb}']/120)*100) end, 2, 'net')

-- }}}
-- Memory widget
memwidget = widget({
    type = 'textbox',
    name = 'memwidget'
})

wicked.register(memwidget, 'mem',
    ' <span color="white">MEM:</span> $1% ($2Mb/$3Mb)')

-- Memory bar widget
memiconbox = widget({ type = "textbox", name = "memiconbox", align = "left" })
	memiconbox.text = "<span color=\"white\">MEM: </span>" 
	membarw = widget({type = 'progressbar', name = 'membarw', align = 'left'})
	membarw.width = 30
	membarw.height = 0.50
	membarw.gap = 0
	membarw.border_padding = 0
	membarw.border_width = 1
	membarw.ticks_count = 0
	membarw.ticks_gap = 0
	membarw:bar_properties_set('mem', {border_color = '#999999',fg = '#ff0000',reverse = false,min_value = 0,max_value = 100})
membarw:buttons ({
    button({ }, 1, function ()awful.util.spawn("urxvt -e htop") end)
    })
	wicked.register(membarw, 'mem', '$1',10,'mem')

-- Shutdown and Reboot widget
shuticonbox = widget({ type = "textbox", name = "shuticonbox", align = "right"})
shuticonbox.text = "<bg image=\"/home/qianli/.config/awesome/closeW.png\" resize=\"false\" />"
shuticonbox:buttons ({
    button({ }, 1, function ()awful.util.spawn("sudo halt") end),
    button({ }, 3, function ()awful.util.spawn("sudo reboot") end)
    })

-- }}

-- Create a wibox for each screen and add it
mywibox_top = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = { button({ }, 1, awful.tag.viewonly),
                      button({ modkey }, 1, awful.client.movetotag),
                      button({ }, 3, function (tag) tag.selected = not tag.selected end),
                      button({ modkey }, 3, awful.client.toggletag),
                      button({ }, 4, awful.tag.viewnext),
                      button({ }, 5, awful.tag.viewprev) }
mytasklist = {}
mytasklist.buttons = { button({ }, 1, function (c) client.focus = c; c:raise() end),
                       button({ }, 3, function () awful.menu.clients({ width=250 }) end),
                       button({ }, 4, function () awful.client.focus.byidx(1) end),
                       button({ }, 5, function () awful.client.focus.byidx(-1) end) }

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = widget({ type = "textbox", align = "left" })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = widget({ type = "imagebox", align = "right" })
    mylayoutbox[s]:buttons({ button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             button({ }, 5, function () awful.layout.inc(layouts, -1) end) })
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist.new(function(c)
                                                  return awful.widget.tasklist.label.currenttags(c, s)
                                              end, mytasklist.buttons)

    -- Create the wibox
    mywibox_top[s] = wibox({ position = "top", height = 20, fg = beautiful.fg_normal, bg = beautiful.bg_normal })
    -- Add widgets to the wibox - order matters
    mywibox_top[s].widgets = { mylauncher,
                           mytaglist[s],
                           space,
                           pb_volume,
                           space,
                           mytasklist[s],
                           mypromptbox[s],
                           --mytextbox,
                           mylayoutbox[s],
                           s == 1 and mysystray or nil }
    mywibox_top[s].screen = s
end

--  Create a bottom wibox
mywibox_bottom = {}
for s = 1, screen.count() do
    mywibox_bottom[s] = wibox({ position = "bottom",  height = 20, fg = beautiful.fg_normal, bg = beautiful.bgb_normal })
    -- Add widgets to the statusbar - order matters
    mywibox_bottom[s].widgets = { 
        space,
        baticonbox,
        battextwidget,
        bar,
        tempiconbox,
        tempwidget,
        bar,
        gputempiconbox,
        gputempwidget,
        bar,
        fswidget,
        bar,
        cpuiconbox,
        cpugraphwidget,
        bar,
        memiconbox,
        membarw,
        bar,
        nettextwidget,
        netdngraphwidget,
        space,
        netupgraphwidget,
        mpdswidget,
        datewidget,
        spacer,
        shuticonbox
        --bar,
        --mpdiconbox,
        --mpdwidget,
--        mysystray
        --s == screen.count() and mysystray or nil
    }
    mywibox_bottom[s].screen = s
end

-- }}}

-- {{{ Mouse bindings
awesome.buttons({
    button({ }, 3, function () mymainmenu:toggle() end),
    button({ }, 4, awful.tag.viewnext),
    button({ }, 5, awful.tag.viewprev)
})
-- }}}

-- {{{ Key bindings

-- Bind keyboard digits
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    keybinding({ modkey }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           awful.tag.viewonly(tags[screen][i])
                       end
                   end):add()
    keybinding({ modkey, "Control" }, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           tags[screen][i].selected = not tags[screen][i].selected
                       end
                   end):add()
    keybinding({ modkey, "Shift" }, i,
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.movetotag(tags[client.focus.screen][i])
                           end
                       end
                   end):add()
    keybinding({ modkey, "Control", "Shift" }, i,
                   function ()
                       if client.focus then
                           if tags[client.focus.screen][i] then
                               awful.client.toggletag(tags[client.focus.screen][i])
                           end
                       end
                   end):add()
end

keybinding({ modkey }, "Left", awful.tag.viewprev):add()
keybinding({ modkey }, "Right", awful.tag.viewnext):add()
keybinding({ modkey }, "Escape", awful.tag.history.restore):add()

-- Standard program
keybinding({ modkey }, "Return", function () awful.util.spawn(terminal) end):add()
keybinding({ modkey }, "f", function () awful.util.spawn(browser) end):add()
keybinding({ modkey }, "s", function () awful.util.spawn("smplayer") end):add()
keybinding({ modkey }, "e", function () awful.util.spawn(txt_editor) end):add()
keybinding({ modkey }, "g", function () awful.util.spawn("gvim") end):add()
keybinding({ modkey }, "r", function () awful.util.spawn(filemanager.." /home/qianli") end):add()
keybinding({ modkey }, "p", function () awful.util.spawn(menu) end):add()
keybinding({ modkey }, "v", function () awful.util.spawn("VirtualBox") end):add()
keybinding({ modkey }, "d", function () awful.util.spawn(dict) end):add()
keybinding({ modkey }, "i", function () awful.util.spawn("pidgin") end):add()
keybinding({ modkey }, "F2", function () awful.util.spawn(lock) end):add()
keybinding({	}, "Print",	function () awful.util.spawn("scrot  -e 'mv $f ~/Pictures/shots/' ") end):add()

keybinding({ modkey, "Control" }, "r", function ()
                                           mypromptbox[mouse.screen].text =
                                               awful.util.escape(awful.util.restart())
                                        end):add()
keybinding({ modkey, "Shift" }, "q", awesome.quit):add()

-- Client manipulation
keybinding({ modkey }, "m", awful.client.maximize):add()
keybinding({ modkey, "Shift" }, "f", function () client.focus.fullscreen = not client.focus.fullscreen end):add()
keybinding({ modkey }, "w", function () client.focus:kill() end):add()
keybinding({ modkey }, "j", function () awful.client.focus.byidx(1); client.focus:raise() end):add()
keybinding({ modkey }, "k", function () awful.client.focus.byidx(-1);  client.focus:raise() end):add()
keybinding({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1) end):add()
keybinding({ modkey, "Shift" }, "k", function () awful.client.swap(-1) end):add()
keybinding({ modkey, "Control" }, "j", function () awful.screen.focus(1) end):add()
keybinding({ modkey, "Control" }, "k", function () awful.screen.focus(-1) end):add()
keybinding({ modkey, "Control" }, "space", awful.client.togglefloating):add()
keybinding({ modkey, "Control" }, "Return", function () client.focus:swap(awful.client.getmaster()) end):add()
keybinding({ modkey }, "o", awful.client.movetoscreen):add()
keybinding({ modkey }, "Tab", awful.client.focus.history.previous):add()
keybinding({ modkey }, "u", awful.client.urgent.jumpto):add()
keybinding({ modkey, "Shift" }, "r", function () client.focus:redraw() end):add()

-- Layout manipulation
keybinding({ modkey }, "l", function () awful.tag.incmwfact(0.05) end):add()
keybinding({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end):add()
keybinding({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end):add()
keybinding({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end):add()
keybinding({ modkey, "Control" }, "h", function () awful.tag.incncol(1) end):add()
keybinding({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end):add()
keybinding({ modkey }, "space", function () awful.layout.inc(layouts, 1) end):add()
keybinding({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end):add()

-- Prompt
keybinding({ modkey }, "F1", function ()
                                 awful.prompt.run({ prompt = "Run: " }, mypromptbox[mouse.screen], awful.util.spawn, awful.completion.bash,
                                                  awful.util.getdir("cache") .. "/history")
                             end):add()
keybinding({ modkey }, "F4", function ()
                                 awful.prompt.run({ prompt = "Run Lua code: " }, mypromptbox[mouse.screen], awful.util.eval, awful.prompt.bash,
                                                  awful.util.getdir("cache") .. "/history_eval")
                             end):add()

keybinding({ modkey, "Ctrl" }, "i", function ()
                                        local s = mouse.screen
                                        if mypromptbox[s].text then
                                            mypromptbox[s].text = nil
                                        else
                                            mypromptbox[s].text = nil
                                            if client.focus.class then
                                                mypromptbox[s].text = "Class: " .. client.focus.class .. " "
                                            end
                                            if client.focus.instance then
                                                mypromptbox[s].text = mypromptbox[s].text .. "Instance: ".. client.focus.instance .. " "
                                            end
                                            if client.focus.role then
                                                mypromptbox[s].text = mypromptbox[s].text .. "Role: ".. client.focus.role
                                            end
                                        end
                                    end):add()

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
keybinding({ modkey }, "t", awful.client.togglemarked):add()

for i = 1, keynumber do
    keybinding({ modkey, "Shift" }, "F" .. i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           for k, c in pairs(awful.client.getmarked()) do
                               awful.client.movetotag(tags[screen][i], c)
                           end
                       end
                   end):add()
end
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
    if awful.layout.get(c.screen) ~= "magnifier"
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Hook function to execute when a new client appears.
awful.hooks.manage.register(function (c)
    if use_titlebar then
        -- Add a titlebar
        awful.titlebar.add(c, { modkey = modkey })
    end
    -- Add mouse bindings
    c:buttons({
        button({ }, 1, function (c) client.focus = c; c:raise() end),
        button({ modkey }, 1, function (c) c:mouse_move() end),
        button({ modkey }, 3, function (c) c:mouse_resize() end)
    })
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal
    client.focus = c

    -- Check if the application should be floating.
    local cls = c.class
    local inst = c.instance
    if floatapps[cls] then
        c.floating = floatapps[cls]
    elseif floatapps[inst] then
        c.floating = floatapps[inst]
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

    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    awful.client.setslave(c)

    -- Honor size hints: if you want to drop the gaps between windows, set this to false.
    -- c.honorsizehints = false
end)

-- Hook function to execute when arranging the screen.
-- (tag switch, new client, etc)
awful.hooks.arrange.register(function (screen)
    local layout = awful.layout.get(screen)
    if layout then
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

    -- Uncomment if you want mouse warping
    --[[
    if client.focus then
        local c_c = client.focus:fullgeometry()
        local m_c = mouse.coords()

        if m_c.x < c_c.x or m_c.x >= c_c.x + c_c.width or
            m_c.y < c_c.y or m_c.y >= c_c.y + c_c.height then
            if table.maxn(m_c.buttons) == 0 then
                mouse.coords({ x = c_c.x + 5, y = c_c.y + 5})
            end
        end
    end
    ]]
end)

-- Hook called every second
awful.hooks.timer.register(1, function ()
    -- For unix time_t lovers
    mytextbox.text = " " .. os.time() .. " time_t "
    -- Otherwise use:
    -- mytextbox.text = " " .. os.date() .. " "
end)

-- Add volume timer
awful.hooks.timer.register(10, function () volume("update", pb_volume) end)

-- }}}
