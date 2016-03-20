local bdig_version = "0.0.1"
local author = "deFENCE"
local site = "http://pls.bounceme.net/oc/programs/"

print("BDig version "..bdig_version.." by "..author)
print("Website: "..site)

local component = require("component")
local shell = require("shell")
local robot = require("robot")

if not component.isAvailable("robot") then
  print("This program must be run on a robot!")
end

local args, options = shell.parse(...)
local left = options.l or false
local leftorg = left
local up = options.u or false
local noItems = options.k or false
noItems = not noItems

function dig()
  while robot.detect() do
    robot.swing()
  end
end

function digUp()
  while robot.detectUp() do
    robot.swingUp()
  end
end

function digDown()
  while robot.detectDown() do
    robot.swingDown()
  end
end

if #args < 3 then
  print("Syntax: bdig [-luk] <up/down> <fwd> <side>")
  print("  -l")
  print("     Makes the robot go left instead of right")
  print("")
  print("  -u")
  print("     Makes the robot go up instead of down")
  print("")
  print("  -k")
  print("     NOT IMPLEMENTED Makes the robot keep items instead of throwing them out")
  os.exit()
end

local blockY = args[1]
local blockX = args[2]
local blockZ = args[3]

print(blockY)
print(blockX)
print(blockZ)

--exit(0)

function digXZ()
  for zm = 0, blockZ - 2 do
    for xm = 0, blockX - 2 do
      dig()
      robot.forward()
    end
    if left then
      robot.turnLeft()
      dig()
      robot.forward()
      robot.turnLeft()
    else
      robot.turnRight()
      dig()
      robot.forward()
      robot.turnRight()
    end
    left = not left
  end
  for xm = 0, blockX - 2 do
    dig()
    robot.forward()
  end
  if left == leftorg then
    robot.turnRight()
    robot.turnRight()
    for xm = 0, blockX - 2 do
      dig()
      robot.forward()
    end
  end
  if leftorg then
    robot.turnLeft()
  else
    robot.turnRight()
  end
  for zm = 0, blockZ - 2 do
    dig()
    robot.forward()
  end
  if leftorg then
    robot.turnLeft()
  else
    robot.turnRight()
  end
  left = leftorg
end

for ym = 0, blockY - 2 do
  digXZ()
  if up then
    digUp()
    robot.up()
  else
    digDown()
    robot.down()
  end
end
digXZ()
