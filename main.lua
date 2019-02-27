-- PLUGINS --
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

local onMouseHoverExit = function(event)
        if event.phase == "began" then
                exitButton:scale(1.1,1.1)
        elseif event.phase == "ended" then
                exitButton:scale(0.90909,0.90909)
        end
end
exitButton:addEventListener( "mouseHover", onMouseHoverExit )

-- CONTINUE BUTTON --
local continueButton = display.newImageRect( uiGroup, "continuebutton.png", 658, 180 )
    continueButton.x = display.contentCenterX - 250
    continueButton.y = display.contentCenterY - 200

local continueButtonLight = display.newImageRect( uiGroup, "continuebuttonlight.png", 658, 180 )
    continueButtonLight.x = display.contentCenterX - 250
    continueButtonLight.y = display.contentCenterY - 200
    continueButtonLight.isVisible = false

local onMouseHover = function(event)
        if event.phase == "began" then
                event.target.isVisible = true
                continueButtonLight.isVisible = true
        elseif event.phase == "ended" then
                continueButtonLight.isVisible = false
        end
end
continueButton:addEventListener( "mouseHover", onMouseHover )

-- NEW GAME BUTTON --
local newButton = display.newImageRect( uiGroup, "newbutton.png", 658, 180 )
    newButton.x = display.contentCenterX - 250
    newButton.y = display.contentCenterY - 0

local newButtonLight = display.newImageRect( uiGroup, "newbuttonlight.png", 658, 180 )
    newButtonLight.x = display.contentCenterX - 250
    newButtonLight.y = display.contentCenterY - 0
    newButtonLight.isVisible = false

local onMouseHover2 = function(event)
        if event.phase == "began" then
                event.target.isVisible = true
                newButtonLight.isVisible = true
        elseif event.phase == "ended" then
                newButtonLight.isVisible = false
        end
end
newButton:addEventListener( "mouseHover", onMouseHover2 )

-- MENU BUTTON --
local menuButton = display.newImageRect( uiGroup, "menubutton.png", 658, 180 )
    menuButton.x = display.contentCenterX - 250
    menuButton.y = display.contentCenterY + 200

local menuButtonLight = display.newImageRect( uiGroup, "menubuttonlight.png", 658, 180 )
    menuButtonLight.x = display.contentCenterX - 250
    menuButtonLight.y = display.contentCenterY + 200
    menuButtonLight.isVisible = false

local onMouseHover3 = function(event)
        if event.phase == "began" then
                event.target.isVisible = true
                menuButtonLight.isVisible = true
        elseif event.phase == "ended" then
                menuButtonLight.isVisible = false
        end
end
menuButton:addEventListener( "mouseHover", onMouseHover3 )

local function menuClicked()
    continueButton.isVisible = false
    newButton.isVisible = false
    menuButton.isVisible = false
    menuButtonLight.isVisible = false

    local backButton = display.newImageRect( uiGroup, "backbutton.png", 71, 101)
        backButton.x = 71
        backButton.y = 73

   local onMouseHoverBack = function(event)
        if event.phase == "began" then
                backButton:scale(1.1,1.1)
        elseif event.phase == "ended" then
                backButton:scale(0.90909,0.90909)
        end
    end
    backButton:addEventListener( "mouseHover", onMouseHoverBack )

    local function backToStart()
      continueButton.isVisible = true
      newButton.isVisible = true
      menuButton.isVisible = true
      backButton.isVisible = false
    end
backButton:addEventListener("tap", backToStart)
end
menuButton:addEventListener("tap", menuClicked)

-- NEW GAME PRESSED --
local function newButton_tap()
  continueButton.isVisible = false
  newButton.isVisible = false
  newButtonLight.isVisible = false
  menuButton.isVisible = false
  exitButton.isVisible = false
  --menuButton.isVisible = false
      local chooseClass = display.newText( uiGroup,"Choose Your Class!", display.contentCenterX, display.contentCenterY - 300, native.systemFont, 80  )
      chooseClass:setFillColor(255, 0, 255) --Lua uses RGB Colours
      local mageIcon = display.newImageRect(uiGroup, "Badge_mage.png", 500, 500)
      mageIcon.x = display.contentCenterX
      mageIcon.y = display.contentCenterY
end
newButton:addEventListener( "tap", newButton_tap )
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
    Walls.isVisible = false --hiding this to work on UI -Kubo
