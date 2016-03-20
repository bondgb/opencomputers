--Intended for use with Extra Utilities Ender-Markers to build a quarry

local _version = "0.1"
local author = "bsgb"
local site = ""

print("qmake version ".._version.." by "..author)

local component = require("component")
local shell = require("shell")
local robot = require("robot")
local turncount = 0

if not component.isAvailable("robot") then
  print("This program requires a robot.")
end

local args, options = shell.parse(...)
local right = options.r or false

if #args < 1 then
  print("Syntax: qmake [-r] [length]")
  print("")
  print("")
  print("Watch out for lava, gravel, sand. These are not supported.")
  print("To build markers on air you need the Angel upgrade..")
  print("Robot will build a cuboid, making each side [length] and placing markers at the end (e.g. Ender-markers).")
  print("")
  print("  -r")
  print("     Makes the robot go right instead of left")
  return
end

local dimension = tonumber(args[1])

if dimension == 1 then
  error("Can't make a square of size 1")
  return
end

function detect()
  while robot.detect() do
    robot.swing()
  end
end

function checkInv()
  if robot.count(1) < 4 then
    print("Not enough torches")
    os.exit(1)
    return
  else
    robot.select(1)
  end
end

function placeTorch()

if robot.place() then
  robot.place()
else
  robot.swing()
  robot.place()
    if not robot.place() then
      print("Failed to place one marker...")
    end
end

end

print(dimension)
print("Making a quarry!")

function buildRow(rowSize)
  rowSize = rowSize - 1
  for i=1, rowSize do
    detect()
    robot.forward()
  end

  turn()
  detect()
  robot.forward()
  robot.turnAround()
  placeTorch()
  robot.turnAround()

end

function turn()
  if right then
    robot.turnRight()
  else
    robot.turnLeft()
  end
  turncount = turncount + 1
end

checkInv()

size = dimension

buildRow(size)
  
buildRow(size)

buildRow(size)
 
buildRow(size)

print("All done!")
