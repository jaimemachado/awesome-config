-- Standard awesome library
awful = require("awful")
awful.rules = require("awful.rules")
awful.autofocus = require("awful.autofocus")
-- Widget and layout library
wibox = require("wibox")
-- Theme handling library
beautiful = require("beautiful")
-- Notification library
naughty = require("naughty")
menubar = require("menubar")
-- User libraries
local vicious = require("vicious") -- ./vicious
local helpers = require("helpers") -- helpers.lua
local revelation=require("revelation") -- revelation
local titlebar = require("titlebar")
require("spotify")
-- local lain = require("lain")
-- }}}

-- Load Debian menu entries
require("debian.menu")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--Jaime Problem theme
beautiful.init(awful.util.getdir("config") .. "/themes/zhongguo/zhongguo.lua")



_awesome_quit = awesome.quit
awesome.quit = function()
    if os.getenv("DESKTOP_SESSION") == "awesome-gnome" then
       os.execute("pkill -9 gnome-session") -- I use this on Ubuntu 16.04
    else
    _awesome_quit()
    end
end



-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
-- This is used later as the default terminal and editor to run.
terminal = whereis_app('urxvtcd') and 'urxvtcd' or 'x-terminal-emulator' -- also accepts full path
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

wallpaper_app = "feh" -- if you want to check for app before trying
wallpaper_dir = os.getenv("HOME") .. "/Pictures/Wallpaper" -- wallpaper dir

-- taglist numerals
--- arabic, chinese, {east|persian}_arabic, roman, thai, random
taglist_numbers = "arabic" -- we support arabic (1,2,3...),

opacity_enable = true -- Show CPU graph

cpugraph_enable = true -- Show CPU graph
cputext_format = " $1%" -- %1 average cpu, %[2..] every other thread individually

membar_enable = true -- Show memory bar
memtext_format = " $1%" -- %1 percentage, %2 used %3 total %4 free

date_format = "%a %m/%d/%Y %l:%M%p" -- refer to http://en.wikipedia.org/wiki/Date_(Unix) specifiers

networks = {'eth0'} -- add your devices network interface here netwidget, only shows first one thats up.

require_safe('personal')
modkey = "Mod4"
-- Create personal.lua in this same directory to override these defaults


-- }}}


-- {{{ Variable definitions
local wallpaper_cmd = "find " .. wallpaper_dir .. " -type f -name '*.jpg'  -print0 | shuf -n1 -z | xargs -0 feh --bg-scale"
local home   = os.getenv("HOME")
local exec   = awful.util.spawn
local sexec  = awful.util.spawn_with_shell

-- Beautiful theme
beautiful.init(awful.util.getdir("config") .. "/themes/zhongguo/zhongguo.lua")

--Init revelations plugins
revelation.init() 


-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
      awful.layout.suit.tile,
      awful.layout.suit.tile.left,
      awful.layout.suit.tile.bottom,
      awful.layout.suit.tile.top,
      awful.layout.suit.fair,
      awful.layout.suit.fair.horizontal,
      awful.layout.suit.spiral,
      awful.layout.suit.spiral.dwindle,
      awful.layout.suit.max,
      awful.layout.suit.max.fullscreen,
      awful.layout.suit.magnifier,
      awful.layout.suit.floating,      
      -- awful.layout.suit.corner.nw,
      -- awful.layout.suit.corner.ne,
      -- awful.layout.suit.corner.sw,
      -- awful.layout.suit.corner.se
}
-- }}}

-- {{{ Wallpaper

-- }}}

-- {{{ Tags
-- Taglist numerals
taglist_numbers_langs = { 'arabic', 'chinese', 'traditional_chinese', 'east_arabic', 'persian_arabic', }
taglist_numbers_sets = {
  arabic={ 1, 2, 3, 4, 5, 6, 7, 8, 9 },
  chinese={"一", "二", "三", "四", "五", "六", "七", "八", "九", "十"},
  traditional_chinese={"壹", "貳", "叄", "肆", "伍", "陸", "柒", "捌", "玖", "拾"},
  east_arabic={'١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'}, -- '٠' 0
  persian_arabic={'٠', '١', '٢', '٣', '۴', '۵', '۶', '٧', '٨', '٩'},
  roman={'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X'},
  thai={'๑', '๒', '๓', '๔', '๕', '๖', '๗', '๘', '๙', '๑๐'},
}
-- }}}

tags = {}
for s = 1, screen.count() do
  -- Each screen has its own tag table.
    --tags[s] = awful.tag({"一", "二", "三", "四", "五", "六", "七", "八", "九", "十"}, s, layouts[1])
    --tags[s] = awful.tag(taglist_numbers_sets[taglist_numbers], s, layouts[1])
  if taglist_numbers == 'random' then
    math.randomseed(os.time())
    local taglist = taglist_numbers_sets[taglist_numbers_langs[math.random(table.getn(taglist_numbers_langs))]]
    tags[s] = awful.tag(taglist, s, layouts[1])
  else
    tags[s] = awful.tag(taglist_numbers_sets[taglist_numbers], s, layouts[1])
  end
  --tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()


-- {{{ Reusable separator
separator = wibox.widget.imagebox()
separator:set_image(beautiful.widget_sep)

spacer = wibox.widget.textbox()
spacer.width = 3
-- }}}

-- {{{ CPU usage

-- cpu icon
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)

-- check for cpugraph_enable == true in config
if cpugraph_enable then
  -- Initialize widget
  cpugraph  = awful.widget.graph()

  -- Graph properties
  cpugraph:set_width(40):set_height(16)
  cpugraph:set_background_color(beautiful.fg_off_widget)
  cpugraph:set_color({
          type= "linear", from = { 0, 0 }, to = { 0, 20 }, stops = {
            { 0, beautiful.fg_end_widget },
            { 0.5, beautiful.fg_center_widget },
            { 1, beautiful.fg_widget}
         }
  })

  -- Register graph widget
  vicious.register(cpugraph,  vicious.widgets.cpu,      "$1")
end
-- cpu text widget
cpuwidget = wibox.widget.textbox() -- initialize
vicious.register(cpuwidget, vicious.widgets.cpu, cputext_format, 3) -- register

-- temperature
tzswidget = wibox.widget.textbox()
vicious.register(tzswidget, vicious.widgets.thermal,
  function (widget, args)
    if args[1] > 0 then
      tzfound = true
      return " " .. args[1] .. "C°"
    else return "" 
    end
  end
  , 19, "thermal_zone0")

-- }}}


-- {{{ Battery state

-- Initialize widget
batwidget = wibox.widget.textbox()
baticon = wibox.widget.imagebox()

-- Register widget
vicious.register(batwidget, vicious.widgets.bat,
  function (widget, args)
    if args[2] == 0 then return ""
    else
      baticon:set_image(beautiful.widget_bat)
      return "<span color='white'>".. args[2] .. "%</span>"
    end
  end, 61, "BAT0"
)
-- }}}


-- {{{ Memory usage

-- icon
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)

if membar_enable then
  -- Initialize widget
  membar = awful.widget.progressbar()
  -- Pogressbar properties
  membar:set_vertical(true):set_ticks(true)
  membar:set_height(16):set_width(8):set_ticks_size(2)
  membar:set_background_color(beautiful.fg_off_widget)
  membar:set_color({
          type = "linear", from = {0,0}, to= {0, 20},
          stops= {
            { 0, beautiful.fg_widget },
            { 0.5, beautiful.fg_center_widget },
            { 1, beautiful.fg_end_widget }
          }
  }) -- Register widget
  vicious.register(membar, vicious.widgets.mem, "$1", 13)
end



-- {{{ Disk I/O
local ioicon = wibox.widget.imagebox()
ioicon:set_image(beautiful.widget_fs)
ioicon.visible = true
local iowidgetSDA = wibox.widget.textbox()
vicious.register(iowidgetSDA, vicious.widgets.dio, "HDSDA ${sda read_mb}/${sda write_mb}MB", 2)
local iowidgetSDB = wibox.widget.textbox()
vicious.register(iowidgetSDB, vicious.widgets.dio, "HDSDB ${sdb read_mb}/${sdb write_mb}MB", 2)
-- Register buttons
iowidgetSDA:buttons( awful.button({ }, 1, function () awful.util.spawn(terminal .. " -e sudo iotop -oP") end) )
iowidgetSDB:buttons( awful.button({ }, 1, function () awful.util.spawn(terminal .. " -e sudo iotop -oP") end) )
-- }}}



-- mem text output
memtext = wibox.widget.textbox()
vicious.register(memtext, vicious.widgets.mem, memtext_format, 13)
-- }}}

-- {{{ File system usage
fsicon = wibox.widget.imagebox()
fsicon:set_image(beautiful.widget_fs)
-- Initialize widgets
fs = {
  r = awful.widget.progressbar(), s = awful.widget.progressbar()
}
-- Progressbar properties
for _, w in pairs(fs) do
  w:set_vertical(true):set_ticks(true)
  w:set_height(16):set_width(5):set_ticks_size(2)
  w:set_border_color(beautiful.border_widget)
  w:set_background_color(beautiful.fg_off_widget)
  w:set_color({
    type = "linear", from = {0,0}, to= {0, 20},
    stops= {
      { 0, beautiful.fg_widget },
      { 0.5, beautiful.fg_center_widget },
      { 1, beautiful.fg_end_widget }
    }
  }) -- Register buttons
  w:buttons(awful.util.table.join(
    awful.button({ }, 1, function () exec("dolphin", false) end)
  ))
end -- Enable caching
vicious.cache(vicious.widgets.fs)
-- Register widgets
vicious.register(fs.r, vicious.widgets.fs, "${/ used_p}",            599)
vicious.register(fs.s, vicious.widgets.fs, "${/media/files used_p}", 599)
-- }}}

-- {{{ Volume level
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)
-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = wibox.widget.textbox()
-- Progressbar properties
volbar:set_vertical(true):set_ticks(true)
volbar:set_height(16):set_width(8):set_ticks_size(2)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_color({
  type= "linear", from = { 0, 0 }, to = { 0, 20 }, stops = {
    { 0, beautiful.fg_end_widget },
    { 0.5, beautiful.fg_center_widget },
    { 1, beautiful.fg_widget}
  }
}) -- Enable caching

vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register(volbar,    vicious.widgets.volume,  "$1",  2, "PCM")
vicious.register(volwidget, vicious.widgets.volume, " $1%", 2, "PCM")
-- Register buttons
volbar:buttons(awful.util.table.join(
   awful.button({ }, 1, function () exec("kmix") end),
   awful.button({ }, 4, function () exec("amixer -q set PCM 2dB+", false) vicious.force({volbar, volwidget}) end),
   awful.button({ }, 5, function () exec("amixer -q set PCM 2dB-", false) vicious.force({volbar, volwidget}) end)
)) -- Register assigned buttons
volwidget:buttons(volbar:buttons())
-- }}}

-- {{{ Date and time
dateicon = wibox.widget.imagebox()
dateicon:set_image(beautiful.widget_date)
-- Initialize widget
datewidget = wibox.widget.textbox()
-- Register widget
vicious.register(datewidget, vicious.widgets.date, date_format, 61)
-- }}}

-- {{{ mpd
mpdwidget = wibox.widget.textbox()
if whereis_app('curl') and whereis_app('mpd') then
  vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
      if args["{state}"] == "Stop" or args["{state}"] == "Pause" or args["{state}"] == "N/A"
        or (args["{Artist}"] == "N/A" and args["{Title}"] == "N/A") then return ""
      else return '<span color="white">музыка:</span> '..
           args["{Artist}"]..' - '.. args["{Title}"]
      end
    end
  )
end

-- }}}


-- {{{ System tray
systray = wibox.widget.systray()
-- }}}

-- Create a wibox for each screen and add it
-- {{{ Wibox initialisation
mywibox     = {}
mypromptbox = {}
layoutbox = {}
taglist   = {}
taglist.buttons = awful.util.table.join(
    awful.button({ },        1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ },        3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ },        4, awful.tag.viewnext),
    awful.button({ },        5, awful.tag.viewprev
))




mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

systrayScreen = 1
if screen.count() > 2 then
    systrayScreen = 2
end

for s = 1, screen.count() do
    -- Create a promptbox
    mypromptbox[s] = awful.widget.prompt()
    -- Create a layoutbox
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts,  1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts,  1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))

    -- Create the taglist
    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)


    -- Create the wibox
    mywibox[s] = awful.wibox({      screen = s,
        fg = beautiful.fg_normal, height = 16,
        bg = beautiful.bg_normal, position = "top",
        border_color = beautiful.border_normal,
        border_width = beautiful.border_width
    })
    -- Add widgets to the wibox
    mywibox[s].widgets = {
        {   taglist[s], layoutbox[s], separator, 
            mpdwidget and spacer, mpdwidget or nil,
        },
        --s == screen.count() and systray or nil, -- show tray on last screen
        s == systrayScreen and systray or nil, -- only show tray on first screen
        s == systrayScreen and separator or nil, -- only show on first screen
        datewidget, dateicon,
        baticon.image and separator, batwidget, baticon or nil,
        separator, volwidget,  volbar.widget, volicon,
        separator, fs.r.widget, fs.s.widget, fsicon, separator, ioicon,
        separator, memtext, membar_enable and membar.widget or nil, memicon,
        separator, tzfound and tzswidget or nil,
        cpugraph_enable and cpugraph.widget or nil, cpuwidget, cpuicon,
    }



  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:fill_space(true)
  left_layout:add(taglist[s])
  left_layout:add(mypromptbox[s])

  local middle_layout = wibox.layout.fixed.horizontal()
  middle_layout:add(mytasklist[s], mpdwidget and spacer, mpdwidget or nil)


  local right_layout = wibox.layout.fixed.horizontal()

  right_layout:add(spotify_widget)

  if cpugraph_enable and cpugraph then
    if separator then right_layout:add(separator) end
    right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(cpugraph)
  end

  if tzfound and tzwidth then
    if separator then right_layout:add(separator) end
    right_layout:add(tzfound)
    right_layout:add(tzswidget)
  end

  
  if membar_enable and memtext and membar then
    if separator then right_layout:add(separator) end
    right_layout:add(memicon)
    right_layout:add(memtext)
    right_layout:add(membar)
  end


  if fs.r and fs.s and fsicon then
    if separator then right_layout:add(separator) end
    right_layout:add(fsicon)
    right_layout:add(fs.r)
    right_layout:add(fs.s)
  end

  if ioicon then
    if separator then right_layout:add(separator) end
    right_layout:add(ioicon)
    right_layout:add(iowidgetSDA)
    right_layout:add(separator)
    right_layout:add(iowidgetSDB)
  end


  if dnicon and upicon and netwidget then
    if separator then right_layout:add(separator) end
    right_layout:add(dnicon)
    right_layout:add(netwidget)
    right_layout:add(upicon)
  end


  if volwidget and volbar then
    if separator then right_layout:add(separator) end
    right_layout:add(volicon)
    right_layout:add(volbar)
    right_layout:add(volwidget)
  end


  if baticon and batwidget then
    if separator then right_layout:add(separator) end
    right_layout:add(baticon)
    right_layout:add(batwidget)
  end
  

  if separator then right_layout:add(separator) end
  right_layout:add(dateicon)
  right_layout:add(datewidget)

  if s == systrayScreen then
    if separator then right_layout:add(separator) end
    right_layout:add(s == systrayScreen and systray or nil)
  end

  right_layout:add(layoutbox[s])

  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(middle_layout)
  layout:set_right(right_layout)
  mywibox[s]:set_widget(layout)



end
-- }}}
-- }}}






-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- Client bindings
clientbuttons = awful.util.table.join(
    awful.button({ },        1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "`", awful.tag.history.restore),
    awful.key({ modkey,           }, "e",      revelation),
    awful.key({ modkey,           }, "d", function()
            revelation({rule={class="URxvt"}})
         end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    awful.key({ modkey, "Shift",  }, "F2",    function ()
                        awful.prompt.run({ prompt = "Rename tab: ", text = awful.tag.selected().name, },
                        mypromptbox[mouse.screen].widget,
                        function (s)
                            awful.tag.selected().name = s
                        end)
                end),

    awful.key({modkey,            }, "c",     function () awful.util.spawn("compton-inverter.py -t", false) end),
    --spotify
    awful.key({modkey,            }, "F12",     function () awful.util.spawn("sp stop", false) end),
    awful.key({modkey,            }, "F11",     function () awful.util.spawn("sp play", false) end),
    awful.key({modkey,            }, "F10",     function () awful.util.spawn("sp next", false) end),
    awful.key({modkey,            }, "F9",     function () awful.util.spawn("sp prev", false) end),
    awful.key({modkey,            }, "F8",     function () awful.util.spawn("amixer -q sset Master 2+", false) end),
    awful.key({modkey,            }, "F7",     function () awful.util.spawn("amixer -q sset Master 2-", false) end),
    awful.key({ }, "XF86AudioRaiseVolume",     function () awful.util.spawn("amixer set Master 2%+", false) end),
    awful.key({ }, "XF86AudioLowerVolume",     function () awful.util.spawn("amixer set Master 2%-", false) end),
    awful.key({ }, "XF86AudioMute",            function () awful.util.spawn("amixer -q -D pulse sset Master toggle", false) end),
    awful.key({                   }, "XF86AudioPlay", function () awful.util.spawn("sp play", false) end),
    awful.key({                   }, "XF86AudioStop", function () awful.util.spawn("sp stop", false) end),
    awful.key({                   }, "XF86AudioNext", function () awful.util.spawn("sp next", false) end),
    awful.key({                   }, "XF86AudioPrev", function () awful.util.spawn("sp prev", false) end),


    --lock Screen
    awful.key({ modkey }, "l", function () awful.util.spawn("xscreensaver-command -lock") end),
    awful.key({ modkey, "Shift" }, "l", function () awful.util.spawn("lock_sleep") end),

    --Sleep and lock
    awful.key({ modkey, "Shift" }, "l", function () awful.util.spawn("lock_sleep") end),

    
    -- Change Monitor Focus
    awful.key({modkey,            }, "F1",     function () awful.screen.focus(1) end),
    awful.key({modkey,            }, "F2",     function () awful.screen.focus(2) end),
    awful.key({modkey,            }, "F3",     function () awful.screen.focus(3) end),
    awful.key({modkey,            }, "q",      function () opacity_enable = not opacity_enable end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, ".",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, ",",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, ".",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, ",",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, ".",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, ",",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    awful.key({ modkey }, "b", function ()
         wibox[mouse.screen].visible = not wibox[mouse.screen].visible
    end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "i",      
      function (c) 
          awful.client.movetoscreen(c, c.screen-1)
      end),


    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
    end),
    awful.key({ modkey,           }, "h",
       function (c)
          for _, w in ipairs(client.get()) do
             if w.class == c.class then
                w.minimized = true
             end
          end
          c.minimized = true
    end),
    awful.key({ modkey, "Shift"  }, "h",
       function (c)
          for _, w in ipairs(client.get()) do
             if w.class == c.class then
                w.minimized = false
             end
          end
          c.minimized = false
    end)
    
    
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "sky" }, properties = { floating = true } },
    { rule = { class = "omestools" }, properties = { floating = true } },
    { rule = { class = "Omestools" }, properties = { floating = true } },
    { rule = { class = "kyber" }, properties = { floating = true } },
    { rule = { class = "Kyber" }, properties = { floating = true } },    
    { rule = { class = "Sky" }, properties = { floating = true } },
    { rule = { class = "galculator" }, properties = { floating = true } },
    { rule = { class = "Galculator" }, properties = { floating = true } },
    { rule = { class = "ROX-Filer" },   properties = { floating = true } },
    { rule = { class = "Chromium-browser" },   properties = { floating = false } },
    { rule = { class = "Google-chrome" },   properties = { floating = false } },
    { rule = { class = "Firefox" },   properties = { floating = false } },
--setup project
    { rule = { class = "setupGUI" },   properties = { floating = true } },
--Atlas
    { rule = { class = "ae_describe_commit" },   properties = { floating = true } },
    
    {
       rule = { class = "lfpServer" },
       properties = { floating = true },
       callback = function( c )
          c:geometry( { width = 800 , height = 615 } )
       end
    },

    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    elseif not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count change
        awful.placement.no_offscreen(c)
    end

    local titlebars_enabled = true
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        titlebar.add_titlebar(c)
    end

end)

client.connect_signal("focus", function(c) 
					c.border_color = beautiful.border_focus 
					c.opacity = 1
			       end)
client.connect_signal("unfocus", function(c) 
					c.border_color = beautiful.border_normal 
					if opacity_enable then
                                           c.opacity = 0.7
                                        else
                                           c.opacity = 1
   					end
				 end)

-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))

    for _, c in pairs(clients) do -- Floaters are always on top
        if   awful.client.floating.get(c) or layout == "floating"
        then if not c.fullscreen then c.above       =  true  end
        else                          c.above       =  false end
    end
  end)
end
-- }}}
-- }}}

x = 0

-- setup the timer
mytimer = timer { timeout = x }
mytimer:connect_signal("timeout", function()

  -- tell awsetbg to randomly choose a wallpaper from your wallpaper directory
  if file_exists(wallpaper_dir) and whereis_app('feh') then
    os.execute(wallpaper_cmd)
  end
 -- stop the timer (we don't need multiple instances running at the same time)
  mytimer:stop()

  -- define the interval in which the next wallpaper change should occur in seconds
  -- (in this case anytime between 10 and 20 minutes)
  x = math.random( 600, 1200)

   --restart the timer
  mytimer.timeout = x
  mytimer:start()
end)

-- initial start when rc.lua is first run
mytimer:start()

require_safe('autorun')
