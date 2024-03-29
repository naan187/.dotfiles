local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

return function(args)
    local remove_empty_widget = args[1] == nil and
                                args.empty_widget ~= nil and true or false
                                or false

    local layout = wibox.widget {
        layout = args.orientation == "horizontal" and wibox.layout.fixed.horizontal
                                                  or wibox.layout.fixed.vertical,
        spacing = args.spacing or dpi(6),
        args[1] ~= nil and args[1] or args.empty_widget,
    }

    local container = wibox.widget {
        widget = wibox.container.margin,
        top = 0,
        layout,
    }

    container:add_button(awful.button({}, 5, function()
        if not remove_empty_widget or not #layout.children == 0 then
            container.top = container.top - 15
        end
    end))

    container:add_button(awful.button({}, 4, function()
        if container.top ~= 0 and not remove_empty_widget
                              or #layout.children == 0 then
            container.top = container.top + 15
        end
    end))

    local widget = {
        -- wrap container in a shape to prevent child widgets
        -- from being shown outside the desired area
        widget = wibox.container.background,
        shape = gears.shape.rounded_rect,
        container
    }

    function widget:remove(i)
        layout:remove(i)
        if #layout.children == 0 then
            layout:insert(1, args.empty_widget)
            remove_empty_widget = true
        end
    end

    function widget:remove_widgets(w)
        layout:remove_widgets(w)
        if #layout.children == 0 then
            layout:insert(1, args.empty_widget)
            remove_empty_widget = true
        end
    end

    function widget:get_children()
        return layout.children
    end

    function widget:num_children()
        return remove_empty_widget and 0 or #layout.children
    end

    function widget:insert(i, w)
        if remove_empty_widget then
            layout:reset()
            remove_empty_widget = false
        end
        layout:insert(i, w)
    end

    function widget:reset()
        layout:reset()

        if args.empty_widget == nil then return end

        layout:insert(1, args.empty_widget)
        remove_empty_widget = true
    end

    function widget:is_empty()
        return #layout.children == 0 or remove_empty_widget
    end

    return widget
end

