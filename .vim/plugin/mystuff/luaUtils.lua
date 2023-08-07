
-- function get_last_friday()
--     local current_day = os.date("%A")
--     local current_date = os.date("%Y-%m-%d")

--     if current_day == "Friday" then
--         return current_date
--     else
--         local days_to_subtract = os.date("*t").wday - 6  -- Subtract the number of days to the previous Friday
--         local last_friday = os.date("%Y-%m-%d", os.time() - days_to_subtract * 24 * 60 * 60)
--         return last_friday
--     end
-- end

function get_last_friday()
    local current_date = os.date("*t")

    -- Subtract one day (86400 seconds) until it's Friday (wday 6)
    while current_date.wday ~= 6 do
        current_date = os.date("*t", os.time(current_date) - 86400)
    end

    local last_friday = os.date("%Y-%m-%d", os.time(current_date))
    return last_friday
end

function get_next_thursday()
    local current_date = os.date("*t")

    -- Add days (86400 seconds per day) until it's Thursday (wday 5)
    while current_date.wday ~= 5 do
        current_date = os.date("*t", os.time(current_date) + 86400)
    end

    local next_thursday = os.date("%Y-%m-%d", os.time(current_date))
    return next_thursday
end



return {
    get_last_friday = get_last_friday,
    get_next_thursday = get_next_thursday
}
