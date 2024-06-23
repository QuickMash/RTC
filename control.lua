local turtleID = nil
local connection = false
local status
local modem = peripheral.find("modem") or error("[Error] No modem attached", 0)
modem.open(2450) -- Open Channel 2450
term.clear()
term.setBackgroundColor(colors.blue)
term.setTextColor(colors.white)
term.setCursorPos(1,1)
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
    local request = http.get("https://example.tweaked.cc")
    print("MOTD: " .. request.readAll())
    request.close()
    print('=== Remote Control Panel ===')

    -- Menu options
    local options = {

    }

local function verify()
    if modem.isWireless() then
        -- Send verification request
        modem.transmit(2450, 2451, "verify:" .. turtleID)
        local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
        if channel == 2450 and message == "verified:" .. turtleID then
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
    term.setCursorPos(1, 15)
    print("Enter Turtle ID: ")
    term.setCursorPos(1, 16)
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
    term.setCursorPos(1, 10) -- Reset cursor position
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
    -- Handle key events
    local event, key = os.pullEvent("key")
    if key == keys.one then
        print("Mine Chunk")
        sendCommand("mine")
    elseif key == keys.nine then
        print("Connection Menu")
        promptID()
    elseif key == keys.two then
        print("Return to Start")
        sendCommand("goto_start")
    elseif key == keys.three then
        print("Locating")
        sendCommand("get location")
    elseif key == keys.four then
        print("Refuel")
        sendCommand("refuel")
    elseif key == keys.five then
        print("Shutdown Turtle")
        sendCommand("shutdown")
    elseif key == keys.e then
        print("Stop Mining")
        sendCommand("stop_mining")
    elseif key == keys.s then
        print("Settings")
        -- Add settings functionality
    elseif key == keys.c then
        -- Custom command input
        term.clear()
        displayHeader()
        term.setCursorPos(1, 15)
        print("Enter custom command: ")
        term.setCursorPos(1, 16)
        local customCmd = read()
        sendCommand("custom:" .. customCmd)
        -- Wait until command is sent (handled by the turtle program)
        os.pullEvent("modem_message") -- You may need to adjust this depending on how you handle responses
    elseif key == keys.q or key == keys.esc then
        print("Goodbye!")
        os.sleep(1)
        break
    end
end
end