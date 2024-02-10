local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local gfs = gears.filesystem
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local user_settings = require("config.user_settings")

local current_layout_index = 1

return function()
    local layouts = user_settings.locale.layouts
    local layout = awful.widget.keyboardlayout()

    layout:connect_signal("button::press", function(_, _, _, button)
        if button == 1 then
            current_layout_index = current_layout_index + 1

            if layouts[current_layout_index] == nil then
                current_layout_index = 1
            end
            awful.spawn("setxkbmap " .. layouts[current_layout_index])
            layout = awful.widget.keyboardlayout()
        end
    end)

    local widget = wibox.widget {
        widget = wibox.container.margin,
        right = dpi(5),
        {
            widget = wibox.container.place,
            valign = "center",
            layout,
        }
    }

    return widget
end