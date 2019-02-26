local mouseHover = require 'plugin.mouseHover'

-- DISPLAY GROUPS --
local backGroup = display.newGroup()         --Background assets
local uiGroup = display.newGroup()           --UI assets
local mainGroup = display.newGroup()         --Heroes, mobs etc. assets

-- UI BACKGROUND --
local background = display.newImageRect( backGroup, "ui_background.png", 1920, 1080 )
background.x = display.contentCenterX
background.y = display.contentCenterY

-- EXIT BUTTON --
local exitButton = display.newImageRect( uiGroup, "exitbutton.png", 75, 77 )
exitButton.x = 1920 - 75
exitButton.y = 73

local function exitButton_tap()
    native.requestExit()
end
exitButton:addEventListener( "tap", exitButton_tap )

-- CONTINUE BUTTON --
local continueButton = display.newImageRect( uiGroup, "continuebutton.png", 658, 180 )
continueButton.x = display.contentCenterX - 250
continueButton.y = display.contentCenterY - 200

local onMouseHover = function(event)
        if event.phase == "began" then
                event.target.isVisible = true
                event.target.alpha = 0.2
        elseif event.phase == "ended" then
                event.target.alpha = 1
        end
end
continueButton:addEventListener( "mouseHover", onMouseHover )

-- NEW GAME BUTTON --
local newButton = display.newImageRect( uiGroup, "newbutton.png", 658, 180 )
newButton.x = display.contentCenterX - 250
newButton.y = display.contentCenterY - 0

local onMouseHover2 = function(event)
        if event.phase == "began" then
                event.target.isVisible = true
                event.target.alpha = 0.2
        elseif event.phase == "ended" then
                event.target.alpha = 1
        end
end
newButton:addEventListener( "mouseHover", onMouseHover2 )

local function newButton_tap()
display.remove(backGroup)
display.remove(uiGroup)
end
newButton:addEventListener( "tap", newButton_tap )

-- MENU BUTTON --
local menuButton = display.newImageRect( uiGroup, "menubutton.png", 658, 180 )
menuButton.x = display.contentCenterX - 250
menuButton.y = display.contentCenterY + 200

local onMouseHover3 = function(event)
        if event.phase == "began" then
                event.target.isVisible = true
                event.target.alpha = 0.2
        elseif event.phase == "ended" then
                event.target.alpha = 1
        end
end
menuButton:addEventListener( "mouseHover", onMouseHover3 )

----------------------------------------------------------------------------
--GAME----------------------------------------------------------------------
----------------------------------------------------------------------------
-- GAME PHYSICS --
local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

-- VARIABLES --
local livesP = 1
local livesF = 1
local died = false
local Player

-- PLAYER PHYSICS --
local function Player()
  local Player = display.newImageRect(mainGroup,"Player.png", 100, 100)
  physics.addBody(Player, {radius=40, isSensor=true})
  Player.myName = "Player"
end

-- wall physics --
local Walls = display.newImageRect( mainGroup,"Walls.jpg", 500, 600)
Walls.x = display.contentCenterX-700
Walls.y = display.contentCenterY-400
physics.addBody(Walls, "static")
