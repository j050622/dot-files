-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Generated XDG menu
-- require ("xdgmenu")

-- AutoStartUp
function run_once(cmd)
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    awful.util.spawn_with_shell("ps aux | grep " .. findme .. " | grep -v grep > /dev/null || (" .. cmd .. ")")
end

run_once("conky")
run_once("xcompmgr &")
run_once("volwheel")
-- run_once("nm-applet")
run_once("sudo fstrim -v /")
-- run_once("xfce4-panel")

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
-- Themes define colours, icons, and wallpapers
beautiful.init("~/.config/awesome/themes/zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal -e 'tmux -2'"
editor = "vim"
editor_cmd = editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
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
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end

-- theme.wallpaper_cmd = { "awsetbg -f ~/.config/awesome/images/liveatpompeii.png" }
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "Firefox", 2, "Emacs", 4, 5, 6, 7, 8, "VBox" }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "Restart", awesome.restart },
   { "Quit", awesome.quit }
}

freegatemenu = {
    { "Freegate", "freegate", "/usr/share/icons/gnome/16x16/apps/arts.png" },
    { "UtraSerf", "u1303", "/usr/share/icons/gnome/16x16/apps/arts.png" },
    { "Kill US", "killall u1303.exe", "/usr/share/icons/gnome/16x16/apps/access.png" },
    { "Heroku", "heroku",  "/usr/share/icons/gnome/16x16/apps/arts.png" }
}

emacsmenu = {
    { "Emacs", "emacs", "/usr/share/icons/hicolor/16x16/apps/emacs.png" }
}

tencentmenu = {
    { "TM", "tm", "/usr/share/icons/gnome/16x16/apps/arts.png" },
    { "Kill TM", "killall TM.exe", "/usr/share/icons/gnome/16x16/apps/arts.png" }
}

mymainmenu = awful.menu({ items = { { "Awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Terminal(&T)", terminal },
                                    { "Emacs(&E)", emacsmenu },
                                    { "Gate", freegatemenu },
                                    { "TM", tencentmenu }
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

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
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
                                                  instance = awful.menu.clients({ width=250 })
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

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey, "Shift"   }, "Left",
        function (c)
            local curidx = awful.tag.getidx()
            if curidx == 1 then
                awful.client.movetotag(tags[client.focus.screen][#tags[client.focus.screen]])
            else
                awful.client.movetotag(tags[client.focus.screen][curidx - 1])
            end
            awful.tag.viewidx(-1)
        end),
    awful.key({ modkey, "Shift"   }, "Right",
        function (c)
            local curidx = awful.tag.getidx()
            if curidx == #tags[client.focus.screen] then
                awful.client.movetotag(tags[client.focus.screen][1])
            else
                awful.client.movetotag(tags[client.focus.screen][curidx + 1])
            end
            awful.tag.viewidx(1)
        end),

    awful.key({ modkey,           }, "Escape",
        function ()
            awful.tag.history.restore()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
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

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    --awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey, "Control" }, "n",
            function ()
                awful.client.restore()
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end),
    awful.key({ modkey, "Shift"   }, "n",
            function ()
                local tag = awful.tag.selected()
                for i=1, #tag:clients() do
                    tag:clients()[i].minimized = false
                end
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end),
    awful.key({ modkey            }, "d",
            function ()
                local tag = awful.tag.selected()
                for i=1, #tag:clients() do
                    if getPanel(tag:clients()[i]) then
                    else
                        tag:clients()[i].minimized = not tag:clients()[i].minimized
                    end
                end
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
    awful.key({ modkey,           }, "F12",    function () awful.util.spawn("xlock")         end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            local panel = getPanel(c)
            if panel then
                return
            else
                c.minimized = true
            end
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            local panel = getPanel(c)
            if panel then
                return
            else
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical   = not c.maximized_vertical
            end
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
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
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = 1,
                     border_color = "#00ff00",
                     -- border_width = beautiful.border_width,
                     -- border_color = beautiful.border_normal,
                     -- remove gaps between windows
                     size_hints_honor = false,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    -- Centered
    { rule = { },
      except_any = { instance = { "xfce4-terminal", "TM.exe", "gimp","gnome-mplayer" } },
      properties = { callback = awful.placement.centered } },
    -- xfce4-terminal
    { rule = { instance = "xfce4-terminal" },
      properties = { geometry = { x = 150, y = 150 } } },
    --
    -- { rule_any = { class = { "MPlayer", "Evince", "Gimp" } },
    --       properties = { floating = true } },
    -- Case with Xfce4-panel
    { rule = { instance = "xfce4-panel" },
          properties = { minimized = false, sticky = true } },
    -- Set Firefox to always map on tags number 1 of screen 1.
    { rule = { class = "Firefox" },
          properties = { tag = tags[1][1] } },
    --
    { rule_any = { class = { "Google-chrome", "Google-chrome-stable", "Chromium" } },
          properties = { tag = tags[1][1] } },
    --
    { rule = { class = "Uget-gtk" },
          properties = { tag = tags[1][7] } },
    --
    --{ rule = { class = "Emacs" },
    --      properties = { tag = tags[1][3], maximized_horizontal = true, maximized_vertical = true } },
    --
    { rule = { instance = "sun-awt-X11-XFramePeer" },
          properties = { tag = tags[1][5] } },
    --
    { rule_any = { instance = { "fg742p.exe", "u1303.exe", "IEXPLORE.EXE" } },
          properties = { tag = tags[1][8] } },
    { rule_any = { class = { "VirtualBox" } },
          properties = { tag = tags[1][9] } },
    --
    { rule_any = { instance = {'TM.exe', 'QQ.exe'} },
          properties = {
              -- This, together with myfocus_filter, make the popup menus flicker taskbars less
              -- Non-focusable menus may cause TM2013preview1 to not highlight menu
              -- items on hover and crash.
              -- use our functions
              focus = myfocus_filter,
              focusable = true,
              floating = true,
              -- drop window edge
              border_width = 0,
              tag = tags[1][9]
          }
     },
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
        --  awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

-- client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus c.opacity = 1 end)
-- client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal c.opacity = 0.7 end)
client.connect_signal("focus", function(c) c.border_color = "#21A675" c.opacity = 1 end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal c.opacity = 0.7 end)

-- Voice Functional

function volume_toggle ()
    awful.util.spawn ("amixer set Master toggle" )
end

function volume_up ()
    awful.util.spawn ("amixer set Master 5%+" )
end

function volume_down ()
    awful.util.spawn ("amixer set Master 5%-" )
end

-- Xfce4-panel Control
function getPanel (c)
    return awful.rules.match(c, {class = "Xfce4-panel"})
end

-- Tencent QQ
function myfocus_filter(c)
    if awful.client.focus.filter(c) then
        -- This works with tooltips and some popup-menus
        if c.class == 'Wine' and c.above == true then
            return nil
        elseif c.class == 'Wine'
            and c.type == 'dialog'
            and c.skip_taskbar == true
            and c.size_hints.max_width and c.size_hints.max_width < 160
        then
            -- for popup item menus of Photoshop CS5
            return nil
        else
            return c
        end
     end
end

function bind_alt_switch_tab_keys(client)
    client:keys(awful.util.table.join(client:keys(), alt_switch_keys))
end

client.connect_signal("manage", function (c, startup)
    -- other configurations
    if c.instance == "explorer.exe" then
        c:kill()
    end
    if c.instance == 'TM.exe' then
        -- Alt + n support
        bind_alt_switch_tab_keys(c)
        -- close news window
        if c.name and c.name:match('^Tencent') and c.above then
            c:kill()
        end
    end
end)
-- }}}
