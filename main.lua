-- PLUGINS --
local mouseHover = require 'plugin.mouseHover' -- requiring a plugin for mouseover events

-- DISPLAY GROUPS --
local backGroup = display.newGroup()         --Background assets
local uiGroup = display.newGroup()           --UI assets
local mainGroup = display.newGroup()         --Heroes, mobs etc. assets

-- Sounds & Music --
local backgroundMusic = audio.loadStream("♂️ Lil Peep & XXXTENTACION - Falling Down ♂️ (RIGHT VERSION).mp3") --loads music in small chunks to save memory
local backgroundMusicChannel = audio.play(backgroundMusic, {channel = 1, loops = -1, fadein = 5000,}) --infinite loops, 5sec fade in
local bgVolume = 0.3
audio.setMaxVolume(bgVolume, {channel=1}) --sets max volume to 0.3

-- UI BACKGROUND --
local background = display.newImageRect( backGroup, "ui_background.png", 1920, 1080 ) --declaring background image
    background.x = display.contentCenterX
    background.y = display.contentCenterY

-- EXIT BUTTON --
local exitButton = display.newImageRect( uiGroup, "exitbutton.png", 75, 77 ) -- declaring exit button
    exitButton.x = 1920 - 75
    exitButton.y = 73

local function exitButton_tap() -- close the application
    native.requestExit()
end
exitButton:addEventListener( "tap", exitButton_tap ) -- when exit tapped close the application

local onMouseHoverExit = function(event) -- exit button interactable by getting bigger when hovered over
    if event.phase == "began" then
            exitButton:scale(1.1,1.1)
    elseif event.phase == "ended" then
            exitButton:scale(0.90909,0.90909)
    end
end
exitButton:addEventListener( "mouseHover", onMouseHoverExit ) -- points to the function above

-- CONTINUE BUTTON --
local continueButton = display.newImageRect( uiGroup, "continuebutton.png", 658, 180 ) -- declaring continue button
    continueButton.x = display.contentCenterX - 250
    continueButton.y = display.contentCenterY - 200

local continueButtonLight = display.newImageRect( uiGroup, "continuebuttonlight.png", 658, 180 ) --declaring the light up version
    continueButtonLight.x = display.contentCenterX - 250
    continueButtonLight.y = display.contentCenterY - 200
    continueButtonLight.isVisible = false

local onMouseHover = function(event) -- Continue lights up when hovered over
    if event.phase == "began" then
            event.target.isVisible = true
            continueButtonLight.isVisible = true
    elseif event.phase == "ended" then
            continueButtonLight.isVisible = false
    end
end
continueButton:addEventListener( "mouseHover", onMouseHover ) -- points to the function above

-- NEW GAME BUTTON --
local newButton = display.newImageRect( uiGroup, "newbutton.png", 658, 180 ) -- declaring new game button
    newButton.x = display.contentCenterX - 250
    newButton.y = display.contentCenterY - 0

local newButtonLight = display.newImageRect( uiGroup, "newbuttonlight.png", 658, 180 ) --declaring light up version
    newButtonLight.x = display.contentCenterX - 250
    newButtonLight.y = display.contentCenterY - 0
    newButtonLight.isVisible = false

local onMouseHover2 = function(event) --button lights up when hovered over
    if event.phase == "began" then
            event.target.isVisible = true
            newButtonLight.isVisible = true
    elseif event.phase == "ended" then
            newButtonLight.isVisible = false
    end
end
newButton:addEventListener( "mouseHover", onMouseHover2 ) -- points to the function above

-- MENU BUTTON --
local menuButton = display.newImageRect( uiGroup, "menubutton.png", 658, 180 ) --declaring menu button
    menuButton.x = display.contentCenterX - 250
    menuButton.y = display.contentCenterY + 200

local menuButtonLight = display.newImageRect( uiGroup, "menubuttonlight.png", 658, 180 ) --declaring light up version
    menuButtonLight.x = display.contentCenterX - 250
    menuButtonLight.y = display.contentCenterY + 200
    menuButtonLight.isVisible = false

local soundText = display.newText( uiGroup,"Background Music", display.contentCenterX - 450, display.contentCenterY - 300, native.systemFont, 50  )
    soundText:setFillColor(255, 0, 255) --Declaring the text, Lua uses RGB Colours
    soundText.isVisible = false

local onMouseHover3 = function(event) -- Button lights up when hovered over
    if event.phase == "began" then
            event.target.isVisible = true
            menuButtonLight.isVisible = true
    elseif event.phase == "ended" then
            menuButtonLight.isVisible = false
    end
end
menuButton:addEventListener( "mouseHover", onMouseHover3 ) --Points to the function above

local function menuClicked() --When menu is clicked
    continueButton.isVisible = false
    newButton.isVisible = false
    menuButton.isVisible = false
    menuButtonLight.isVisible = false
    exitButton.isVisible = false
    soundText.isVisible = true

    local soundOnBox = display.newImageRect(uiGroup, "soundOn.png", 115, 112)
        soundOnBox.x = display.contentCenterX - 750
        soundOnBox.y = display.contentCenterY - 300
        soundOnBox.isVisible = false

    local soundOffBox = display.newImageRect(uiGroup, "soundOff.png", 115, 112)
        soundOffBox.x = display.contentCenterX - 750
        soundOffBox.y = display.contentCenterY - 300
        soundOffBox.isVisible = false

    if audio.isChannelActive( 1 ) == true then
      soundOnBox.isVisible = true
      soundOffBox.isVisible = false
    elseif audio.isChannelActive( 1 ) == false then
      soundOnBox.isVisible = false
      soundOffBox.isVisible = true
    end

    local backButtonMenu = display.newImageRect( uiGroup, "backbutton.png", 71, 101) --declaring back button
        backButtonMenu.x = 71 -- I declared two separate back buttons for new game and menu because
        backButtonMenu.y = 73 -- There was a bug where the button would just get smaller and smaller
                              -- when switching from new game to meanu and back -Jakub
    local onMouseHoverBack = function(event) --Back button gets bigger when hovered over
        if event.phase == "began" then
               backButtonMenu:scale(1.1,1.1)
        elseif event.phase == "ended" then
               backButtonMenu:scale(0.90909,0.90909)
        end
    end
    backButtonMenu:addEventListener( "mouseHover", onMouseHoverBack ) --points to the function above

    local function muteBgmButton() --mutes and unmutes bgm when clicked
      if audio.isChannelActive( 1 ) == true then
        audio.fadeOut({channel=1, time=1000 })
        soundOnBox.isVisible = false
        soundOffBox.isVisible = true
      elseif audio.isChannelActive( 1 ) == false then
        audio.setVolume(bgVolume, {channel=1})
        audio.play(backgroundMusic, {channel = 1, loops = -1, fadein = 5000,})
        soundOnBox.isVisible = true
        soundOffBox.isVisible = false
      end
    end
    soundOnBox:addEventListener("tap", muteBgmButton)
    soundOffBox:addEventListener("tap", muteBgmButton)

--http://docs.coronalabs.com/api/library/widget/newSlider.html
    local function backToStart() --goes back to starting screen
        continueButton.isVisible = true
        newButton.isVisible = true
        menuButton.isVisible = true
        backButtonMenu.isVisible = false
        exitButton.isVisible = true
        soundText.isVisible = false
        soundOnBox:removeSelf()
        soundOffBox:removeSelf()

    end
    backButtonMenu:addEventListener("tap", backToStart) --points to the function above
end
menuButton:addEventListener("tap", menuClicked) --points to the function that triggers menu clicked functions

-- NEW GAME PRESSED --
local chooseClass = display.newText( uiGroup,"Choose Your Class!", display.contentCenterX, display.contentCenterY - 300, native.systemFont, 80  )
    chooseClass:setFillColor(255, 0, 255) --Declaring the text, Lua uses RGB Colours
    chooseClass.isVisible = false

local function newButton_tap() --goes to new game options
    continueButton.isVisible = false
    newButton.isVisible = false
    newButtonLight.isVisible = false
    menuButton.isVisible = false
    exitButton.isVisible = false
    chooseClass.isVisible = true

    local mageIcon = display.newImageRect(uiGroup, "Badge_mage.png", 500, 500) --declaring the mage image
    mageIcon.x = display.contentCenterX
    mageIcon.y = display.contentCenterY

    local backButtonNew = display.newImageRect( uiGroup, "backbutton.png", 71, 101) --declaring second back button
        backButtonNew.x = 71
        backButtonNew.y = 73

    local onMouseHoverMage = function(event) --mage image gets bigger when hovered over
        if event.phase == "began" then
                  mageIcon:scale(1.1,1.1)
        elseif event.phase == "ended" then
                      mageIcon:scale(0.90909,0.90909)
        end
    end
    mageIcon:addEventListener( "mouseHover", onMouseHoverMage ) --Points to the function above

    local onMouseHoverBack = function(event) --button gets bigger when hovered over
        if event.phase == "began" then
               backButtonNew:scale(1.1,1.1)
        elseif event.phase == "ended" then
               backButtonNew:scale(0.90909,0.90909)
        end
    end
     backButtonNew:addEventListener("mouseHover", onMouseHoverBack) --Points to the function above

    local function backToStart() --goes back to the start screen
        continueButton.isVisible = true
        newButton.isVisible = true
        menuButton.isVisible = true
        backButtonNew.isVisible = false
        mageIcon.isVisible = false
        chooseClass.isVisible = false
        exitButton.isVisible = true
        mageIcon:removeSelf()
        chooseClass.isVisible = false
        backButtonNew:removeSelf()
    end
    backButtonNew:addEventListener("tap", backToStart) --points to the function above
end
newButton:addEventListener( "tap", newButton_tap ) --points to the new game clicked function

----------------------------------------------------------------------------
--GAME----------------------------------------------------------------------
----------------------------------------------------------------------------

local function mageIconClicked() --when the mage is clicked start new game
    mageIcon.isVisible = false
    chooseClass.isVisible = false
    background.isVisible = false
    backButtonNew.isVisible = false

    -- GAME PHYSICS --
    local physics = require("physics")
        physics.start()
        physics.setGravity(0, 0)


    -- VARIABLES --
    local livesPlayer = 1
    local livesEnemy = 1
    local isPlayerDead = false
    local experience = 0
    local playerLevel = 0
    local mapLevel = 0

    -- PLAYER PHYSICS --
    local player = display.newImageRect(mainGroup,"Player.png", 72, 72) -- (72x72)pixels per box to have 400 positions on the map. 20per row.
    player.x = display.contentCenterX
    player.y = display.contentCenterY

    -- wall physics --
    local Walls = display.newImageRect( mainGroup,"Walls.jpg", 72, 72)
    Walls.x = display.contentCenterX-700
    Walls.y = display.contentCenterY-400


    -- enemy --
    local enemy = display.newImageRect(mainGroup, "Enemy.jpg", 72, 72)
    enemy.x = display.contentCenterX+700
    enemy.y = display.contentCenterY-400

    -- background --       -- block this with walls to make it seem like the floor --
    local floor = display.newImageRect( uiGroup, "FLOORBACK.jpg", 1920, 1080 ) -- declaring continue button
    floor.x = display.contentCenterX
    floor.y = display.contentCenterY

    local function move()
      character= display.newImage("Player.png", 72,72)
    character.x = display.contentCenterX
    character.y = display.contentCenterY
    transition.moveTo( character, { x=0, y=0, time=50000 } )

      end

    local function onKeyEvent(event)
      if(event.keyName =="w") then
      while(event.phase == "began") do
          transition.moveTo( player, { x=player.x, y=player.y-72, time=200 } )
        end
      end
      if(event.keyName =="a") then
        transition.moveTo( player, { x=player.x-72, y=player.y, time=500 } )
      end
      if(event.keyName =="s") then
        transition.moveTo( player, { x=player.x, y=player.y+72, time=500 } )
      end
      if(event.keyName =="d") then
        transition.moveTo( player, { x=player.x+72, y=player.y, time=500 } )
      end
      if(event.keyName =="e") then
        transition.moveTo( player, { x=player.x+72, y=player.y-72, time=500 } )
      end
    end
    Runtime:addEventListener("key", onKeyEvent)


end --end for mageIconClicked
mageIcon:addEventListener( "tap", mageIconClicked )
