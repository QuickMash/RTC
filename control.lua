local turtleID = nil
local connection = false
local status = "Disconnected"
local modem = peripheral.find("modem") or error("[Error] No modem attached", 0)
modem.open(2450) -- Open Channel 2450

local function displayHeader()
    term.clear()
    term.setBackgroundColor(colors.blue)
    term.setTextColor(colors.white)
    term.setCursorPos(1,1)
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
    verify()
    print(status)
    
    local request, err = http.get("https://raw.githubusercontent.com/QuickMash/RTC/main/motd.txt")
    if request then
        print("MOTD: " .. request.readAll())
        request.close()
    else
        print("MOTD: Failed to retrieve message (" .. (err or "unknown error") .. ")")
    end
    
    print('=== Remote Control Panel ===')
end

local function verify()
    if modem.isWireless() then
        -- Send verification request
        sendCommand(2450, 2451, {action="verify", value=turtleID})
        local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        if channel == 2450 and message == "verified:" .. turtleID then -- Fix this to work with new "protocol"
            connection = true
            status = "Connected to " .. turtleID
        else
            connection = false
            status = "Verification failed"
        end
    else
        term.setTextColor(colors.red)
        print("Modem has to be wireless\nPlease put a wireless modem on the computer then run this program.")
    end
end

local function sendCommand(cmd)
    modem.transmit(2450, 2451, cmd)
end

local function promptID()
    term.clear()
    displayHeader()
    term.setCursorPos(1, 13)
    print("Enter Turtle ID: ")
    term.setCursorPos(1, 14)
    turtleID = read()
    verify()
end

term.clear()
displayHeader()

if connection == false then
    term.setTextColor(colors.red)
    status = "You are currently Disconnected"
    os.sleep(0.01)
    term.setTextColor(colors.white)
    promptID()
else
    term.setTextColor(colors.green)
    status = "Connected to " .. turtleID
    os.sleep(0.01)
    term.setTextColor(colors.white)
end

while true do
    term.clear()
    displayHeader()
    print([[
++ MAIN MENU ++
[1] Mine Chunk
[2] Return to Start
[3] Locate Turtle
[4] Refuel
[5] Shutdown Turtle
[E] Stop Mining
[S] Settings
[C] Custom Command
[Q ESC] Quit Program
]])
    term.setCursorPos(1, 14) -- Adjust as necessary

    local event, key = os.pullEvent("key")
    if key == keys.one then
        sendCommand("mine")
    elseif key == keys.two then
        sendCommand({action="mine"})
    elseif key == keys.three then
        sendCommand({action="locate"})
    elseif key == keys.four then
        sendCommand({action="refuel"})
    elseif key == keys.five then
        sendCommand({action="shutdown"})
    elseif key == keys.e then
        sendCommand({action="quit"})
    elseif key == keys.s then
        print("Settings")
        -- Add settings functionality here
    elseif key == keys.c then
        term.clear()
        displayHeader()
        term.setCursorPos(1, 15)
        print("Enter custom command: ")
        term.setCursorPos(1, 16)
        local customCmd = read()
        sendCommand({acti, })
        os.pullEvent("modem_message") -- Adjust this as necessary
    elseif key == keys.q or key == keys.esc then
        print("Goodbye! Turtle Program will stay running.")
        os.sleep(1)
        break
    end
end
