
local turtleID = nil
local status
term.clear()
term.setBackgroundColor(color.blue)
term.setTextColor(color.white)
if turtleID==nil then
    term.setTextColour(colours.red)
    local status = "You are currently Disconnected"
    os.sleep(.01)
    term.setTextColour(colours.white)
else
    term.setTextColour(colours.green)
    local status = "Connected to ", turtleID
    os.sleep(.01)
    term.setTextColour(colours.white)
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
    print('=== Remote Control Panel ===')
end
displayHeader()
local modem = peripheral.find("modem") or error("[Error] No modem attached", 0)

while true do
    term.clear()
    print("[1] Mine Chunk")
    print("[2] Return to Start")
    print("[3] View Inventory")
    print("[4] Refuel")
    print("[5] Shutdown Turtle")
    print("[S] Stop Mining")
    print("[Q] Quit Program")
    os.sleep(60)
-- Run the main function
main()
