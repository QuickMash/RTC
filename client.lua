local turtleID = os.getComputerID()
local status = false
local log
local stopmine
local startPos = gps.locate()
if status == false then
    status = "Disconnected, my ID is " .. turtleID .. "!"
else
    status = "Connected"
end
local function moveTo(x, y, z)
    local currentX, currentY, currentZ = gps.locate()  -- Get current position
    if currentX and currentY and currentZ then
        local deltaX, deltaY, deltaZ = x - currentX, y - currentY, z - currentZ
        if deltaX ~= 0 then
            turtle.forward(deltaX)
        end
        if deltaY ~= 0 then
            turtle.up(deltaY)
        end
        if deltaZ ~= 0 then
            turtle.forward(deltaZ)
        end
    else
        print("Cannot Get GPS Location. Try again later")
    end
end
local function mine()
    while true do
        print("Mining...")
        if stopmine == true then
            print("Stopping Mining")
            stopmine = false
            break
        else 
            for i = 1, 16 do
                turtle.forward()
            end
        end
    end
end
local function displayHeader()
    print([[
______ _____ _____ 
| ___ \_   _/  __ \
| |_/ / | | | /  \/
|    /  | | | |    
| |\ \  | | | \__/\
\_| \_| \_/  \____/
Remote Turtle Control
Version 1 by QuickMash
       ]])
    print(status)
    print('=== Turtle Functional Client ===')
    print("Turtle is not managable locally, maybe update...")
    end
while true do
    displayHeader()
    local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if channel == 2451 then
        if message == "mine" then
            mine()
        elseif message == "goto_start" then
            moveTo(startPos)
            print("Returning to start...")
        elseif message == "get location" then
            
        elseif message == "view_inventory" then
            -- Implement view inventory functionality
            print("Viewing inventory...")
        elseif message == "refuel" then
            print("Searching for refuel")
            for i = 1, 16 do -- loop through the slots
                turtle.select(i) -- change to the slot
                if turtle.refuel(0) then -- if it's valid fuel
                   turtle.refuel(1) -- consume half the stack as fuel
                end
              end
        elseif message == "shutdown" then
            os.shutdown()
            print("Shutting down...")
            os.shutdown()
        elseif message == "stop_mining" then
            stopmine = true
            print("Stopping mining...")
        elseif message:match("^custom:") then
            -- Custom command
            local customCmd = message:sub(8) -- Remove "custom:" prefix
            print("Executing custom command: " .. customCmd)
            -- IDK how to do this
        end
    end
end
