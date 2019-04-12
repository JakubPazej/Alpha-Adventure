-- PLUGINS --
local mouseHover = require 'plugin.mouseHover' -- requiring a plugin for mouseover events

-- DISPLAY GROUPS --
local backGroup = display.newGroup()         --Background assets
local uiGroup = display.newGroup()           --UI assets
local mainGroup = display.newGroup()         --Heroes, mobs etc. assets

-- Sounds & Music --
local backgroundMusic = audio.loadStream("28_爱给网_aigei_com .mp3") --loads music in small chunks to save memory
local backgroundMusicChannel = audio.play(backgroundMusic, {channel = 1, loops = -1, fadein = 5000,}) --infinite loops, 5sec fade in
local bgVolume = 0.15--.15
audio.setMaxVolume(bgVolume, {channel=1}) --sets max volume to bgVolume
audio.setVolume(bgVolume)

local buttonSound = audio.loadSound("buttonSound.mp3")

-- UI BACKGROUNDS --
local background = display.newImageRect( backGroup, "ui_background.png", 1920, 1080 ) --declaring background image
    background.x = display.contentCenterX
    background.y = display.contentCenterY

local backgroundtwo = display.newImageRect( backGroup, "ui_backgroundtwo.png", 1920, 1080 ) --declaring background image
    backgroundtwo.x = display.contentCenterX
    backgroundtwo.y = display.contentCenterY
    backgroundtwo.isVisible = false

local backgroundthree = display.newImageRect( backGroup, "ui_backgroundthree.png", 1920, 1080 ) --declaring background image
    backgroundthree.x = display.contentCenterX
    backgroundthree.y = display.contentCenterY
    backgroundthree.isVisible = false

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

--[[-- CONTINUE BUTTON --
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
continueButton:addEventListener( "mouseHover", onMouseHover ) -- points to the function above --]]

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
    background.isVisible = false
    backgroundtwo.isVisible = true
    --continueButton.isVisible = false
    newButton.isVisible = false
    menuButton.isVisible = false
    menuButtonLight.isVisible = false
    exitButton.isVisible = false
    soundText.isVisible = true
    local soundChannel = audio.play(buttonSound, {channel = 2})
    audio.setMaxVolume(bgVolume, {channel=2})

    local soundOnBox = display.newImageRect(uiGroup, "soundOn.png", 115, 112) --declaring the soundboxes
        soundOnBox.x = display.contentCenterX - 750
        soundOnBox.y = display.contentCenterY - 300
        soundOnBox.isVisible = false

    local soundOffBox = display.newImageRect(uiGroup, "soundOff.png", 115, 112)
        soundOffBox.x = display.contentCenterX - 750
        soundOffBox.y = display.contentCenterY - 300
        soundOffBox.isVisible = false

    if audio.isChannelActive( 1 ) == true then --channel one is bgm
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
        audio.fadeOut({channel=1, time=500 })
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
----------------------------------------------------------------------------------------
  --[[  local widget = require("widget")

    -- Create the widget
    local slider = widget.newSlider(
        {
            x = display.contentCenterX - 450,
            y = display.contentCenterY - 200,
            width = 400,
            value = bgVolume,  -- Start slider at bgVolume
        }
    )
    --not working yet --]]
----------------------------------------------------------------------------------------
    local function backToStart() --goes back to starting screen
        --continueButton.isVisible = true
        newButton.isVisible = true
        menuButton.isVisible = true
        backButtonMenu.isVisible = false
        exitButton.isVisible = true
        soundText.isVisible = false
        soundOnBox:removeSelf()
        soundOffBox:removeSelf()
        --slider:removeSelf()
        background.isVisible = true
        backgroundtwo.isVisible = false
    end
    backButtonMenu:addEventListener("tap", backToStart) --points to the function above
end
menuButton:addEventListener("tap", menuClicked) --points to the function that triggers menu clicked functions

-- NEW GAME PRESSED --
local chooseClass = display.newText( uiGroup,"Choose Your Class!", display.contentCenterX, display.contentCenterY - 300, native.systemFont, 80  )
    chooseClass:setFillColor(139 / 255, 69 / 255, 19 / 255) --Declaring the text, Lua uses RGB Colours
    chooseClass.isVisible = false

local mageIcon = display.newImageRect(uiGroup, "Badge_barbarian.png", 500, 500) --declaring the mage image
    mageIcon.x = display.contentCenterX
    mageIcon.y = display.contentCenterY
    mageIcon.isVisible = false

local mageIconHover = display.newImageRect(uiGroup, "Badge_barbarian.png", 550, 550) --declaring the bigger mage image
    mageIconHover.x = display.contentCenterX
    mageIconHover.y = display.contentCenterY
    mageIconHover.isVisible = false

local function newButton_tap() --goes to new game options
    background.isVisible = false
    backgroundthree.isVisible = true
    --continueButton.isVisible = false
    newButton.isVisible = false
    newButtonLight.isVisible = false
    menuButton.isVisible = false
    exitButton.isVisible = false
    chooseClass.isVisible = true
    mageIcon.isVisible = true
    local soundChannel = audio.play(buttonSound, {channel = 2})
    audio.setMaxVolume(bgVolume, {channel=2})

    local backButtonNew = display.newImageRect( uiGroup, "backbutton.png", 71, 101) --declaring second back button
        backButtonNew.x = 71
        backButtonNew.y = 73

    local onMouseHoverMage = function(event) --mage image gets bigger when hovered over
        if event.phase == "began" then
                  mageIconHover.isVisible = true
                  mageIcon.alpha = 0.01
        elseif event.phase == "ended" then
                  mageIconHover.isVisible = false
                  mageIcon.alpha = 1
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
        background.isVisible = true
        backgroundthree.isVisible = false
        --continueButton.isVisible = true
        newButton.isVisible = true
        menuButton.isVisible = true
        backButtonNew.isVisible = false
        mageIcon.isVisible = false
        chooseClass.isVisible = false
        exitButton.isVisible = true
        chooseClass.isVisible = false
        backButtonNew:removeSelf()
    end
    backButtonNew:addEventListener("tap", backToStart) --points to the function above
end
newButton:addEventListener( "tap", newButton_tap ) --points to the new game clicked function

----------------------------------------------------------------------------
--GAME----------------------------------------------------------------------
----------------------------------------------------------------------------
local i = 0;

local function mageIconClicked() --when the mage is clicked start new game
    mageIcon.isVisible = false
    chooseClass.isVisible = false
    background.isVisible = false

-- Collision Filters--
local blueCollision = { groupIndex = 1 }

-- Image Sheets and Sequences --
local minotaurSheetOptions=
{
  -- Required parameters
    width = 118,
    height = 90,
    numFrames = 8,
}
local minotaurSheet = graphics.newImageSheet("minotaurSpriteSheet.png", minotaurSheetOptions)

local minotaurSheetOptions=
{
  -- Required parameters
    width = 64,
    height = 64,
    numFrames = 6,
}
local ghostSheet = graphics.newImageSheet("ghostSpriteSheet.png", minotaurSheetOptions)

local sequences_runningMinotaur = {
    -- consecutive frames sequence
    {
        name = "everything",
        start = 1,
        count = 8,
        time = 400,
        loopCount = 0,
        loopDirection = "forward"
    },
}
local minotaurRun = display.newSprite(mainGroup, minotaurSheet, sequences_runningMinotaur)

local sequences_runningGhost = {
    -- consecutive frames sequence
    {
        name = "everything",
        start = 1,
        count = 6,
        time = 400,
        loopCount = 0,
        loopDirection = "forward"
    },
}
local ghostRun = display.newSprite(mainGroup, ghostSheet, sequences_runningGhost)

    -- GAME PHYSICS --
    local physics = require("physics")
        physics.start()
        physics.setGravity(0, 0)

    -- VARIABLES --
    local livesPlayer = 1
    local isPlayerDead = false
    local experience = 0
    local playerLevel = 0
    local mapLevel = 0

    -- PLAYER PHYSICS --
    local player = minotaurRun -- (72x72)pixels per box to have 400 positions on the map. 20per row.
    player.x = 190
    player.y = 180
    physics.addBody( player, "dynamic",{density =5000})
    player.isFixedRotation=true
    player.isBullet = false
    player.type = "player"
    local Vx = 0
    local Vy = 0
    player:setLinearVelocity(Vx,Vy)

    -- wall physics --
    local Walls = display.newImageRect( mainGroup,"Walls.png", 72, 72)
    Walls.x = 36
    Walls.y =36
    physics.addBody( Walls, "static", {bounce = 0.0, friction = 50, density = 150} )

    Door = display.newImageRect( mainGroup,"door.png", 72, 108)
    Door.x = 576
    Door.y = 144 +36

    local function addWall(coordinateX, coordinateY) --adding a function to make adding a wall easier
        Walls = display.newImageRect( mainGroup,"Walls.png", 72, 72)
        Walls.x = coordinateX
        Walls.y = coordinateY
        physics.addBody( Walls, "static", {bounce = 0.0, friction = 50, density = 150} )
        Walls.gravityScale =0
        Walls.type = "wall"
    end

    local function addWallsLine(X1, X2, Y1, Y2) --function to add walls in lines.
      if X1 == X2 and Y1 ~= Y2 then             --This function should be considered art.
        if Y1 > Y2 then                         --By Master painter Kubo from the far away kingdom of Slovakia
          local temp = Y2
          Y2 = Y1
          Y1 = temp
        end
        if (Y2 - math.abs(Y1)) % 72 == 0 then
          for i = Y1, Y2, i + 72
          do
            addWall(X1, i)
          end
        end
        elseif Y1 == Y2 and X1 ~= X2 then
          if X1 > X2 then
            local temp = X2
            X2 = X1
            X1 = temp
          end
          if (X2 - math.abs(X1)) % 72 == 0 then
            for i = X1, X2, i + 72
            do
              addWall(i, Y1)
            end
          end
        end
      end
addWallsLine( 36, 1872 + 36, 1044, 1044) -- bottom, working now, for loops are different than in java, notice the middle part
addWallsLine( 72+36, 1872 + 36, 36, 36) --top
local breakableWall = display.newImageRect( mainGroup,"breakableWall.png", 144+72, 144+72)
breakableWall.x = 576+144+72
breakableWall.y = 144+36
physics.addBody( breakableWall, "static", {bounce = 0.0, friction = 50, density = 150, filter = blueCollision} )
breakableWall.type ="tnt"
addWallsLine( 36, 36, 40, 976) --left down
addWallsLine( 1920-36, 1920-36, 36+72, 1872 + 36 -72 ) --right
Walls.type = "wall"


local Walls1 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls1.x = 360
Walls1.y =144
physics.addBody( Walls1, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls1.type = "wall"
local Walls2 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls2.x = 360
Walls2.y =144 + 72
physics.addBody( Walls2, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls2.type = "wall"
local Walls3 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls3.x = 360 + 72
Walls3.y =288 +72
physics.addBody( Walls3, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls3.type = "wall"
local Walls4 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls4.x = 144
Walls4.y =504 +72
physics.addBody( Walls4, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls4.type = "wall"
local Walls6 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls6.x = 360 +144+72
Walls6.y =288+72
physics.addBody( Walls6, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls6.type = "wall"
local Walls5 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls5.x = 720
Walls5.y =288+72
physics.addBody( Walls5, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls5.type = "wall"
local Walls7 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls7.x = 720+72
Walls7.y =288+72
physics.addBody( Walls7, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls7.type = "wall"
local Walls8 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls8.x = 720+144
Walls8.y =288+72
physics.addBody( Walls8, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls8.type = "wall"
local Walls9 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls9.x = 720
Walls9.y =288+144+72
physics.addBody( Walls9, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls9.type = "wall"
local Walls10 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls10.x = 720
Walls10.y =612
physics.addBody( Walls10, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls10.type = "wall"
local Walls11 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls11.x = 720 -144
Walls11.y =612
physics.addBody( Walls11, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls11.type = "wall"
local Walls12 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls12.x = 720-144
Walls12.y =612+144
physics.addBody( Walls12, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls12.type = "wall"
local Walls13 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls13.x = 720+144
Walls13.y =612+144+144+36
physics.addBody( Walls13, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls13.type = "wall"
local Walls14 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls14.x = 720+144
Walls14.y =612
physics.addBody( Walls14, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls14.type = "wall"
local Walls15 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls15.x = 720+144+144
Walls15.y =612
physics.addBody( Walls15, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls15.type = "wall"
local Walls16 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls16.x = 720+288+144
Walls16.y =612
physics.addBody( Walls16, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls16.type = "wall"
local Walls17 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls17.x = 720+288+288
Walls17.y =612
physics.addBody( Walls17, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls17.type = "wall"
local Walls18 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls18.x = 720+288+288+144
Walls18.y =612
physics.addBody( Walls18, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls18.type = "wall"
local Walls19 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls19.x = 720+288+144+36
Walls19.y =612+144
physics.addBody( Walls19, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls19.type = "wall"
local Walls20 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls20.x = 720+288+288+288+144+48
Walls20.y =612+144+36
physics.addBody( Walls20, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls20.type = "wall"
local Walls21 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls21.x = 720+288+288+144+36
Walls21.y =612+144+144+36
physics.addBody( Walls21, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls21.type = "wall"
local Walls22 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls22.x = 720+288+288+144
Walls22.y =612-144
physics.addBody( Walls22, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls22.type = "wall"
local Walls23 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls23.x = 720+288+288+144
Walls23.y =612-288
physics.addBody( Walls23, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls23.type = "wall"
local Walls24 = display.newImageRect( mainGroup,"Walls.png", 144, 144)
Walls24.x = 720+288+288
Walls24.y =612-288
physics.addBody( Walls24, "static", {bounce = 0.0, friction = 50, density = 150} )
Walls24.type = "wall"

  -- UI --               -- Health Bar , Armor, Mana , Items
--[[  local function addHeart(X, Y) --adding a function to make adding a wall easier
    local fullHeart = display.newImageRect(mainGroup,"Heart.png",72,72, X, Y)
    fullHeart.x = X
    fullHeart.y = Y
  end
  local playerLives = 3
  addHeart(100,1045)
  addHeart(150,1045)
  addHeart(200,1045)]]
  local Heart1 = display.newImageRect(mainGroup,"Heart.png",72,72)
  Heart1.x = 100
  Heart1.y = 1045
  Heart1.isVisible = true
  local emptyHeart3 = display.newImageRect(mainGroup,"EmptyHeart.png",72,72)
  emptyHeart3.x = 100
  emptyHeart3.y = 1045
  emptyHeart3.isVisible = false

function getHit(event)
end
  local function addMana(X, Y) --adding a function to make adding a wall easier
    fullMana = display.newImageRect(mainGroup,"Mana.png",72,72, X, Y)
    fullMana.x = X
    fullMana.y = Y
  end
  local playerLives = 3
  addMana(400,1045)
  addMana(450,1045)
  addMana(500,1045)

    -- enemy --
  local enemy
  local function addEnemy (coordinateX, coordinateY, Ex, Ey)
    enemy = ghostRun
    enemy.x = coordinateX
    enemy.y = coordinateY
    enemy:play()
    physics.addBody( enemy, "dynamic",{density =0, bounce =1})
    enemy.type = "enemy"
    enemy.isFixedRotation=true
    player.isBullet = false
    enemy:setLinearVelocity(Ex,Ey)
  end

  addEnemy(500,500, 0, 0)

  local function scaleUpPoint( x1, x2, m, n)
    return (((m*x2)-(n*x1))/(m-n))
  end

--Enemy attack function.
  function EnemyAttack(event)
    if enemy.isVisible == true then
      local ShittyNutrients = display.newImageRect(mainGroup,"Protein.png", 40, 40)
      local Math2
      ShittyNutrients.isVisible = true
      ShittyNutrients.isBullet = true
      ShittyNutrients.type = "ShittyNutrients"
      ShittyNutrients.x = enemy.x
      ShittyNutrients.y = enemy.y
      physics.addBody(ShittyNutrients, "dynamic", {filter=blueCollision})
      ShittyNutrients.isSensor = true
      ShittyNutrients.isFixedRotation = false
      Math2 = math.sqrt(math.pow((player.x - enemy.x),2) + math.pow((player.y - enemy.y),2 ))
        local EX = scaleUpPoint(enemy.x, player.x, 1.01, 1)
        local EY = scaleUpPoint(enemy.y, player.y, 1.01, 1)
        transition.to(ShittyNutrients, {x=EX,y=EY,time=Math2/0.002})
      end
    end
    --timer.performWithDelay( 1000, EnemyAttack, -1)

--If the player gets too close the enemy will fire projectiles at them.
--The close the player is to an enemy the higher the rate of fire.
  function EnemyDetectRange(self, event)
    if event.target.type == "enemy" and event.other.type == "player" then
      if math.sqrt(math.pow((enemy.x - player.x),2) + math.pow((enemy.y - player.y),2 )) < 10500 then
        for i=0, 10, i+1 do
          timer.performWithDelay(500, EnemyAttack)
          if math.sqrt(math.pow((enemy.x - player.x),2) + math.pow((enemy.y - player.y),2 )) > 2500 then
            break
          end
        end
        if math.sqrt(math.pow((enemy.x - player.x),2) + math.pow((enemy.y - player.y),2 )) < 1250 then
          for i=0, 10, i+1 do
            timer.performWithDelay(420, EnemyAttack)
            if math.sqrt(math.pow((enemy.x - player.x),2) + math.pow((enemy.y - player.y),2 )) > 1250 then
              break
            end
          end
        end
      end
    end
  end



  local Right = true
  local  randomMovementEnemy = function() --endless loop for generating random number for enemy to change movements
    local minus1 =1
    local minus2 =1
    if math.random() > 0.5 then minus1 = -1 end
    if math.random() > 0.5 then minus2 = -1 end
    local Ex = ((math.random() *200) +50) *minus1
    local Ey = ((math.random() *200) +50) *minus2
    enemy:setLinearVelocity(Ex,Ey)
    if (enemy.x < player.x) and (Right == false) then
        enemy:scale(-1,1)
        Right = true
      elseif (enemy.x > player.x) and (Right == true) then
        enemy:scale(-1,1)
        Right = false
      end
    end
  --  timer.performWithDelay( 1000, randomMovementEnemy, -1)

  --[[  local en = 0
    enemy = ghostRun
    enemy.x = 500
    enemy.y = 500
    enemy:play()
    physics.addBody( enemy, "dynamic",{density =0, bounce =1})
    enemy.type = "enemy"
    enemy.isFixedRotation=true
    player.isBullet = false
    enemy:setLinearVelocity(0,0)
    function EnemyAttack(event)
      if enemy.isVisible == true then
        local ShittyNutrients = display.newImageRect(mainGroup,"Protein.png", 40, 40)
        local Math2
        ShittyNutrients.isVisible = true
        ShittyNutrients.isBullet = true
        ShittyNutrients.type = "ShittyNutrients"
        ShittyNutrients.x = enemy.x
        ShittyNutrients.y = enemy.y
        physics.addBody(ShittyNutrients, "dynamic", {filter=blueCollision})
        ShittyNutrients.isSensor = true
        ShittyNutrients.isFixedRotation = false
        Math1 = math.sqrt(math.pow((player.x - enemy.x),2) + math.pow((player.y - enemy.y),2 ))
          local EX = scaleUpPoint(enemy.x, player.x, 1.01, 1)
          local EY = scaleUpPoint(enemy.y, player.y, 1.01, 1)
          transition.to(ShittyNutrients, {x=EX,y=EY,time=Math1/0.002})
        end
      end
      local Right = true
      local  randomMovementEnemy = function() --endless loop for generating random number for enemy to change movements
        local minus1 =1
        local minus2 =1
        if math.random() > 0.5 then minus1 = -1 end
        if math.random() > 0.5 then minus2 = -1 end
        local Ex = ((math.random() *200) +50) *minus1
        local Ey = ((math.random() *200) +50) *minus2
        enemy:setLinearVelocity(Ex,Ey)
        if (enemy.x < player.x) and (Right == false) then
            enemy:scale(-1,1)
            Right = true
          elseif (enemy.x > player.x) and (Right == true) then
            enemy:scale(-1,1)
            Right = false
          end
        end]]

    timer.performWithDelay( 1000, randomMovementEnemy, -1)
    timer.performWithDelay( 1000, EnemyAttack, -1)

    -- background --       -- block this with walls to make it seem like the floor --
    local floor = display.newImageRect( uiGroup, "floor.jpg", 1920, 1080 ) -- declaring continue button
    floor.x = display.contentCenterX
    floor.y = display.contentCenterY

    -- movement wasd --
    local pLeft = 0
    local pRight = 1
    local moving = 0
    local rDown = false
    local lDown = false
    local uDown = false
    local dDown = false

    local function onKeyEvent(event)   -- movement commands --  sets Vx and Vy independently, allowing fluid movement
    if event.keyName == "a" then
       if event.phase == "down" then
         Vx = Vx - 200
         player:setLinearVelocity(Vx,Vy)
         if pRight == 1 then
           player:scale(-1,1)
           pRight = 0
           pLeft = 1
         end
         player:play()
         moving = moving +1
         lDown = true
        elseif event.phase == "up" then
          Vx = Vx + 200
          player:setLinearVelocity(Vx,Vy)
          if moving-1 == 0 then
            if uDown == false and dDown == false and rDown == false then
              player:pause()
              player:setFrame(1)
            end
          end
          moving = moving -1
          lDown = false
       end
    end
    if event.keyName == "d" then
       if event.phase == "down" then
         Vx = Vx + 200
         player:setLinearVelocity(Vx,Vy)
         if pLeft == 1 then
           player:scale(-1,1)
           pLeft = 0
           pRight = 1
         end
         player:play()
         moving = moving +1
         rDown = true
        elseif event.phase == "up" then
          Vx = Vx - 200
          player:setLinearVelocity(Vx,Vy)
          if moving-1 == 0 then
            if uDown == false and dDown == false and lDown == false then
              player:pause()
              player:setFrame(1)
            end
          end
          moving = moving -1
          rDown = false
       end
    end
    if event.keyName == "w" then
       if event.phase == "down" then
         Vy = Vy-200
         player:setLinearVelocity(Vx,Vy)
         player:play()
         moving = moving +1
         uDown = true
        elseif event.phase == "up" then
          Vy = Vy + 200
          player:setLinearVelocity(Vx,Vy)
          if moving-1 == 0 then
            if rDown == false and lDown == false and dDown == false then
              player:pause()
              player:setFrame(1)
            end
          end
          moving = moving -1
          uDown = false
       end
    end
    if event.keyName == "s" then
       if event.phase == "down" then
         Vy = Vy + 200
         player:setLinearVelocity(Vx,Vy)
         player:play()
         moving = moving +1
         dDown = true
        elseif event.phase == "up" then
          Vy = Vy - 200
          player:setLinearVelocity(Vx,Vy)
          if moving-1 == 0 then
            if rDown == false and lDown == false and uDown == false then
              player:pause()
              player:setFrame(1)
            end
          end
          moving = moving -1
          dDown = false
       end
    end
  end
  local click1 = 1
  function shootyshooty (event)
    click1 = 1
  end
  local reee = 1

  function proteinProjectile(event)
    if (event.isPrimaryButtonDown and click1 == 1) then
    local Math1
    click1 = 5
    local Protein = display.newImageRect(mainGroup,"Protein.png", 70, 70)
    Protein.isVisible = true
    Protein.isBullet = true
    Protein.type = "protein"
    Protein.x = player.x
    Protein.y = player.y
    physics.addBody(Protein, "dynamic", {filter=blueCollision})
    Protein.isSensor = true
    Protein.isFixedRotation = false
    Math1 = math.sqrt(math.pow((event.x - player.x),2) + math.pow((event.y - player.y),2 ))

      local eX = scaleUpPoint(player.x, event.x, 1.01, 1)
      local eY = scaleUpPoint(player.y, event.y, 1.01, 1)
      transition.to(Protein, {x=eX,y=eY,time=Math1/0.01})

      timer.performWithDelay(1000, shootyshooty)
    --if (event.isPrimaryButtonUp)then
      --click1 = 1
    --end
  end
end

    --enemy.preCollision = EnemyDetectRange
    --enemy:addEventListener("preCollision")
    Runtime:addEventListener("key", onKeyEvent)
    Runtime:addEventListener("mouse", proteinProjectile)
    timer.performWithDelay( 1000, randomMovementEnemy, -1)

 --Breakable wall break --
  local function wallBreak(event)
      breakableWall:removeSelf()
  end
  breakableWall.collision = wallBreak
  breakableWall:addEventListener("collision")


    function wallCollision( event )
      local owo = 0
      if event.phase =="began" then
        if (event.other.type == "ShittyNutrients") then
          owo = 1
        end
        if (event.other.type =="protein") then
        owo = 2
      end
        if owo ==1 then
          display.remove(event.other)
          event.other= nil
        end
        if owo ==2 then
          display.remove(event.other)
          event.other= nil
        end
      end
    end
      --[[else
        if  (event.target.type == "wall" and event.other.type == "protein") then
          if event.phase =="began" then
            display.remove(event.other)
            event.other= nil
          end
        end
      end]]



  --  Walls.collision = wallCollision
    --Walls:addEventListener("collision")
    --[[Walls1:addEventListener("collision", wallCollision2)
      Walls2:addEventListener("collision", wallCollision2)
        Walls3:addEventListener("collision", wallCollision2)
          Walls4:addEventListener("collision", wallCollision2)
            Walls5:addEventListener("collision", wallCollision2)
              Walls6:addEventListener("collision", wallCollision2)
                Walls7:addEventListener("collision", wallCollision2)
                  Walls8:addEventListener("collision", wallCollision2)
                    Walls9:addEventListener("collision", wallCollision2)
                      Walls10:addEventListener("collision", wallCollision2)
                        Walls11:addEventListener("collision", wallCollision2)
                          Walls12:addEventListener("collision", wallCollision2)
                            Walls13:addEventListener("collision", wallCollision2)
                              Walls14:addEventListener("collision", wallCollision2)
                                Walls15:addEventListener("collision", wallCollision2)
                                  Walls16:addEventListener("collision", wallCollision2)
                                    Walls17:addEventListener("collision", wallCollision2)
                                      Walls18:addEventListener("collision", wallCollision2)
                                        Walls19:addEventListener("collision", wallCollision2)
                                          Walls20:addEventListener("collision", wallCollision2)
                                            Walls21:addEventListener("collision", wallCollision2)
                                              Walls22:addEventListener("collision", wallCollision2)
                                                Walls23:addEventListener("collision", wallCollision2)
                                                  Walls24:addEventListener("collision", wallCollision2)]]
    Walls1:addEventListener("collision", wallCollision)
      Walls2:addEventListener("collision", wallCollision)
        Walls3:addEventListener("collision", wallCollision)
          Walls4:addEventListener("collision", wallCollision)
            Walls5:addEventListener("collision", wallCollision)
              Walls6:addEventListener("collision", wallCollision)
                Walls7:addEventListener("collision", wallCollision)
                  Walls8:addEventListener("collision", wallCollision)
                    Walls9:addEventListener("collision", wallCollision)
                      Walls10:addEventListener("collision", wallCollision)
                        Walls11:addEventListener("collision", wallCollision)
                          Walls12:addEventListener("collision", wallCollision)
                            Walls13:addEventListener("collision", wallCollision)
                              Walls14:addEventListener("collision", wallCollision)
                                Walls15:addEventListener("collision", wallCollision)
                                  Walls16:addEventListener("collision", wallCollision)
                                    Walls17:addEventListener("collision", wallCollision)
                                      Walls18:addEventListener("collision", wallCollision)
                                        Walls19:addEventListener("collision", wallCollision)
                                          Walls20:addEventListener("collision", wallCollision)
                                            Walls21:addEventListener("collision", wallCollision)
                                              Walls22:addEventListener("collision", wallCollision)
                                                Walls23:addEventListener("collision", wallCollision)
                                                  Walls24:addEventListener("collision", wallCollision)


local en = 0
  local function onLocalCollision( self, event )      -- Protein Projectile detection function
    local enemyHit = audio.loadSound("oof.mp3")       -- Loads enemy hurting sound
    if(event.target.type=="enemy" and event.other.type=="protein") then       --Makes sure its protein which is hitting it.
      if event.phase == "began" then
        if enemy.isVisible == true then
          if en == 0 then
            local oof = audio.play(enemyHit)
            transition.to(enemy, {x=144,y=684, time = 1})--144,684
            en = 1

          elseif en == 1 then
            local oof = audio.play(enemyHit)
            transition.to(enemy, {x=744,y=750, time = 1})
            en = 2

          elseif en == 2 then
            local oof = audio.play(enemyHit)
            transition.to(enemy, {x=1544,y=750, time = 1})
            en = 3

          elseif en == 3 then
            local oof = audio.play(enemyHit)
            transition.to(enemy, {x=1544,y=144, time = 1})
            en = 4

          elseif en == 4 then
            local oof = audio.play(enemyHit)
            transition.to(enemy, {x=1000,y=450, time = 1})
            en = 5
          elseif en == 5 then
            local oof = audio.play(enemyHit)
            enemy.isVisible = false
          end
        end
      end
    end
    --[[if(event.target.type == "wall" and event.other.type == "protein") then
      display.remove (event.other)
      event.other = nil
    end]]
    if(event.target.type=="player" and event.other.type=="ShittyNutrients") then --who coded this abomination? -Jakub
      if event.phase == "began" then
        local oof = audio.play(enemyHit)
          display.remove(event.other)
          event.other= nil
          Heart1.isVisible = false
          emptyHeart3.isVisible = true
          emptyHeart3.x = 100
          emptyHeart3.y = 1045
          reee = reee +1
          local gameOver = display.newImageRect(mainGroup,"GameOver.png", 1920, 1080)
          gameOver.x = 1920/2
          gameOver.y = 1080/2
          enemy.isVisible = false
          player.isVisible = false

          Runtime:removeEventListener("mouse", proteinProjectile)
      end
    end
  end

  enemy.collision = onLocalCollision
  enemy:addEventListener( "collision" ) --Checks if enemy has been hit by anything.

  player.collision = onLocalCollision
  player:addEventListener("collision")

  --Walls.collision = wallCollision
  --Walls:addEventListener("collision")

end --end for mageIconClicked
mageIcon:addEventListener( "tap", mageIconClicked )
