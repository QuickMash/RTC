local turtleID = os.getComputerID() -- Not gonna update, very static...
local status = false
local location = nil
local stopmine
local startPos = gps.locate()
if status == false then
    status = "Disconnected, my ID is " .. turtleID .. "!" -- This looks cool.
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
        if type(message) == "table" and message.action == "mine" then -- before publish, add id to messages to secure them, beta not secure-ish
            if stopmine then
                stopmine = false
                mine()
            elseif stopmine == false then
                mine()
            else
                print("Error, Variable true nor false at Stopmine")
                return nil
            end
        elseif type(message) == "table" and message.action == "stopmine" then
            if stopmine == false then
                stopmine = true
            elseif stopmine then
                return "Cannot Stopmine if aready true."
            else
                print("Error, Variable true nor false at Stopmine")
            end
        elseif type(message) == "table" and message.action = "quit" then
            -- Default shutdown
            print("Goodbye!")
            os.sleep(1)
            os.shutdown()
        elseif type(message) == "table" and message.action == "locate" then
            location = gps.locate()
            if location == nil then
                print("Error, Variable is nil at location")
            else
                modem.transmit(2450, 2451, {action="return" value=location})
            end
        elseif type(message) == "table" and message.action == "verify" then
            if message.value == turtleID then
                modem.transmit(2450, 2451, {action="verify" value="allow"})
            end -- other users may try to connect, just ignore others
        end
    end
end
