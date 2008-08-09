-- awesome 3 configuration file

-- Include awesome library, with lots of useful function!
require("awful")
require("tabulous")
require("io")

-- Uncomment this to activate autotabbing
-- tabulous.autotab_start()

-- {{{ Variable definitions
-- This is used later as the default terminal to run.
terminal = "xterm"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.

io.popen("uname")
if io.read == "lagoh" then
   modkey = "Mod1"
else 
   modkey = "Mod1"
end
io.close()

print modkey

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    "tile",
    "tileleft",
    "tilebottom", 
   "tiletop",
    "magnifier",
    "max",
    "spiral",
    "dwindle",
    "floating"
}

-- Color & Appearance definitions, we use these later to display things
font = "sans 8"
border_width = 1

bg_normal = "#222222"
fg_normal = "#aaaaaa"
border_normal = "#000000"

bg_focus = "#535d6c"
fg_focus = "#ffffff"
border_focus = bg_focus
border_marked = "#91231C"

awesome.font_set(font)
awesome.colors_set({ fg = fg_normal, bg = bg_normal })
awesome.resizehints_set(true)

-- }}}

-- {{{ Tags
-- Define tags table
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table
    tags[s] = {}
    -- Create 9 tags per screen
    for tagnumber = 1, 9 do
        tags[s][tagnumber] = tag.new({ name = tagnumber })
        -- Add tags to screen one by one
        tags[s][tagnumber]:mwfact_set(0.618033988769)
        tags[s][tagnumber]:add(s)
    end
    -- I'm sure you want to see at least one tag.
    tags[s][1]:view(true)
end
-- }}}

-- {{{ Statusbar
-- Create a taglist widget
mytaglist = widget.new({ type = "taglist", name = "mytaglist" })
mytaglist:mouse_add(mouse.new({}, 1, function (object, tag) awful.tag.viewonly(tag) end))
mytaglist:mouse_add(mouse.new({ modkey }, 1, function (object, tag) awful.client.movetotag(tag) end))
mytaglist:mouse_add(mouse.new({}, 3, function (object, tag) tag:view(not tag:isselected()) end))
mytaglist:mouse_add(mouse.new({ modkey }, 3, function (object, tag) awful.client.toggletag(tag) end))
mytaglist:mouse_add(mouse.new({ }, 4, awful.tag.viewnext))
mytaglist:mouse_add(mouse.new({ }, 5, awful.tag.viewprev))
mytaglist:set("text_focus", "<bg color='"..bg_focus.."'/> <span color='"..fg_focus.."'><title/></span> ")

-- Create a tasklist widget
mytasklist = widget.new({ type = "tasklist", name = "mytasklist" })
mytasklist:mouse_add(mouse.new({ }, 1, function (object, c) c:focus_set(); c:raise() end))
mytasklist:mouse_add(mouse.new({ }, 4, function () awful.client.focus(1) end))
mytasklist:mouse_add(mouse.new({ }, 5, function () awful.client.focus(-1) end))
mytasklist:set("text_focus", "<bg color='"..bg_focus.."'/> <span color='"..fg_focus.."'><title/></span> ")

-- Create a textbox widget
mytextbox = widget.new({ type = "textbox", name = "mytextbox", align = "right" })
-- Set the default text in textbox
mytextbox:set("text", "<b><small> awesome " .. AWESOME_VERSION .. " </small></b>")
mymenubox = widget.new({ type = "textbox", name = "mymenubox", align = "left" })

-- Create an iconbox widget
myiconbox = widget.new({ type = "iconbox", name = "myiconbox", align = "left" })
myiconbox:set("image", "/usr/local/share/awesome/icons/awesome16.png")

-- Create a systray
mysystray = widget.new({ type = "systray", name = "mysystray", align = "right" })

-- Create an iconbox widget which will contains an icon indicating which layout we're using.
-- We need one layoutbox per screen.
mylayoutbox = {}
for s = 1, screen.count() do
    mylayoutbox[s] = widget.new({ type = "iconbox", name = "mylayoutbox", align = "right" })
    mylayoutbox[s]:mouse_add(mouse.new({ }, 1, function () awful.layout.inc(layouts, 1) end))
    mylayoutbox[s]:mouse_add(mouse.new({ }, 3, function () awful.layout.inc(layouts, -1) end))
    mylayoutbox[s]:mouse_add(mouse.new({ }, 4, function () awful.layout.inc(layouts, 1) end))
    mylayoutbox[s]:mouse_add(mouse.new({ }, 5, function () awful.layout.inc(layouts, -1) end))
    mylayoutbox[s]:set("image", "/usr/local/share/awesome/icons/layouts/tilew.png")
end

-- Create a statusbar for each screen and add it
mystatusbar = {}
for s = 1, screen.count() do
    mystatusbar[s] = statusbar.new({ position = "top", name = "mystatusbar" .. s,
                                   fg = fg_normal, bg = bg_normal })
    -- Add widgets to the statusbar - order matters
    mystatusbar[s]:widget_add(mytaglist)
    mystatusbar[s]:widget_add(myiconbox)
    mystatusbar[s]:widget_add(mytasklist)
    mystatusbar[s]:widget_add(mymenubox)
    mystatusbar[s]:widget_add(mytextbox)
    mystatusbar[s]:widget_add(mylayoutbox[s])
    mystatusbar[s]:add(s)
end
mystatusbar[screen.count()]:widget_add(mysystray)
-- }}}

-- {{{ Mouse bindings
awesome.mouse_add(mouse.new({ }, 3, function () awful.spawn(terminal) end))
awesome.mouse_add(mouse.new({ }, 4, awful.tag.viewnext))
awesome.mouse_add(mouse.new({ }, 5, awful.tag.viewprev))
-- }}}

-- {{{ Key bindings

-- Bind keyboard digits
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    keybinding.new({ modkey }, i,
                   function ()
                       local screen = mouse.screen_get()
                       if tags[screen][i] then
                           awful.tag.viewonly(tags[screen][i])
                       end
                   end):add()
    keybinding.new({ modkey, "Control" }, i,
                   function ()
                       local screen = mouse.screen_get()
                       if tags[screen][i] then
                           tags[i]:view(not tags[screen][i]:isselected())
                       end
                   end):add()
    keybinding.new({ modkey, "Shift" }, i,
                   function ()
                       local screen = mouse.screen_get()
                       if tags[screen][i] then
                           awful.client.movetotag(tags[screen][i])
                       end
                   end):add()
    keybinding.new({ modkey, "Control", "Shift" }, i,
                   function ()
                       local screen = mouse.screen_get()
                       if tags[screen][i] then
                           awful.client.toggletag(tags[screen][i])
                       end
                   end):add()
end

keybinding.new({ modkey }, "Left", awful.tag.viewprev):add()
keybinding.new({ modkey }, "Right", awful.tag.viewnext):add()

-- Standard program
keybinding.new({ modkey }, "Return", function () awful.spawn(terminal) end):add()

keybinding.new({ modkey, "Control" }, "r", awesome.restart):add()
keybinding.new({ modkey, "Shift" }, "q", awesome.quit):add()

-- Client manipulation
keybinding.new({ modkey, "Shift" }, "c", function () client.focus_get():kill() end):add()
keybinding.new({ modkey }, "j", function () awful.client.focus(1); client.focus_get():raise() end):add()
keybinding.new({ modkey }, "k", function () awful.client.focus(-1);  client.focus_get():raise() end):add()
keybinding.new({ modkey, "Shift" }, "j", function () awful.client.swap(1) end):add()
keybinding.new({ modkey, "Shift" }, "k", function () awful.client.swap(-1) end):add()
keybinding.new({ modkey, "Control" }, "j", function () awful.screen.focus(1) end):add()
keybinding.new({ modkey, "Control" }, "k", function () awful.screen.focus(-1) end):add()
keybinding.new({ modkey, "Control" }, "space", awful.client.togglefloating):add()
keybinding.new({ modkey, "Control" }, "Return", function () client.focus_get():swap(awful.client.master()) end):add()
keybinding.new({ modkey }, "o", awful.client.movetoscreen):add()

-- Layout manipulation
keybinding.new({ modkey }, "l", function () awful.tag.incmwfact(0.05) end):add()
keybinding.new({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end):add()
keybinding.new({ modkey, "Shift" }, "h", function () awful.tag.incnmaster(1) end):add()
keybinding.new({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end):add()
keybinding.new({ modkey, "Control" }, "h", function () awful.tag.incncol(1) end):add()
keybinding.new({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end):add()
keybinding.new({ modkey }, "space", function () awful.layout.inc(layouts, 1) end):add()
keybinding.new({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end):add()

-- Menu
keybinding.new({ modkey }, "F1", function ()
                                     awful.menu({ prompt = "Run: ", cursor_fg = fg_focus, cursor_bg = bg_focus }, mymenubox, awful.spawn, awful.completion.bash)
                                 end):add()
keybinding.new({ modkey }, "F4", function ()
                                     awful.menu({ prompt = "Run Lua code: ", cursor_fg = fg_focus, cursor_bg = bg_focus }, mymenubox, awful.eval, awful.completion.bash)
                                 end):add()

--- Tabulous, tab manipulation
keybinding.new({ modkey, "Control" }, "y", function ()
    local tabbedview = tabulous.tabindex_get()
    local nextclient = awful.client.next(1)

    if tabbedview == nil then
        tabbedview = tabulous.tabindex_get(nextclient)

        if tabbedview == nil then
            tabbedview = tabulous.tab_create()
            tabulous.tab(tabbedview, nextclient)
        else
            tabulous.tab(tabbedview, client.focus_get())
        end
    else
        tabulous.tab(tabbedview, nextclient)
    end
end):add()

keybinding.new({ modkey, "Shift" }, "y", tabulous.untab):add()

keybinding.new({ modkey }, "y", function ()
   local tabbedview = tabulous.tabindex_get()

   if tabbedview ~= nil then
       local n = tabulous.next(tabbedview)
       tabulous.display(tabbedview, n)
   end
end):add()

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
keybinding.new({ modkey }, "t", awful.client.togglemarked):add()
keybinding.new({ modkey, 'Shift' }, "t", function ()
    local tabbedview = tabulous.tabindex_get()
    local clients = awful.client.getmarked()

    if tabbedview == nil then
        tabbedview = tabulous.tab_create(clients[1])
        table.remove(clients, 1)
    end

    for k,c in pairs(clients) do
        tabulous.tab(tabbedview, c)
    end

end):add()

for i = 1, keynumber do
    keybinding.new({ modkey, "Shift" }, "F" .. i,
                   function ()
                       local screen = mouse.screen_get()
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
function hook_focus(c)
    if not awful.client.ismarked(c) then
        c:border_set({ width = border_width, color = border_focus })
    end
end

-- Hook function to execute when unfocusing a client.
function hook_unfocus(c)
    if not awful.client.ismarked(c) then
        c:border_set({ width = border_width, color = border_normal })
    end
end

-- Hook function to execute when marking a client
function hook_marked(c)
    c:border_set({ width = border_width, color = border_marked })
end

-- Hook function to execute when unmarking a client
function hook_unmarked(c)
    c:border_set({ width = border_width, color = border_focus })
end

-- Hook function to execute when the mouse is over a client.
function hook_mouseover(c)
    -- Sloppy focus, but disabled for magnifier layout
    if awful.layout.get(c:screen_get()) ~= "magnifier" then
        c:focus_set()
    end
end

-- Hook function to execute when a new client appears.
function hook_manage(c)
    -- Add mouse bindings
    c:mouse_add(mouse.new({ }, 1, function (c) c:focus_set(); c:raise() end))
    c:mouse_add(mouse.new({ modkey }, 1, function (c) c:mouse_move() end))
    c:mouse_add(mouse.new({ modkey }, 3, function (c) c:mouse_resize() end))
    -- New client may not receive focus
    -- if they're not focusable, so set border anyway.
    c:border_set({ width = border_width, color = border_normal })
    c:focus_set()
    if c:name_get():lower():find("pinentry") then
        c:floating_set(true)
    end
    if c:name_get():find("mplayer") then
        c:floating_set(true)
    end
end

-- Hook function to execute when arranging the screen
-- (tag switch, new client, etc)
function hook_arrange(screen)
    local layout = awful.layout.get(screen)
    mylayoutbox[screen]:set("image", "/usr/local/share/awesome/icons/layouts/" .. layout .. "w.png")
end

-- Hook called every second
function hook_timer ()
   -- For unix time_t lovers
   -- mytextbox:set("text", " " .. os.time() .. " time_t ")
   -- Otherwise use:
   mytextbox:set("text", " " .. os.date() .. " ")
end

-- Set up some hooks
awful.hooks.focus(hook_focus)
awful.hooks.unfocus(hook_unfocus)
awful.hooks.marked(hook_marked)
awful.hooks.unmarked(hook_unmarked)
awful.hooks.manage(hook_manage)
awful.hooks.mouseover(hook_mouseover)
awful.hooks.arrange(hook_arrange)
awful.hooks.timer(1, hook_timer)
-- }}}
