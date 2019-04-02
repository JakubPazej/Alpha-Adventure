-- PLUGINS --
local mouseHover = require 'plugin.mouseHover' -- requiring a plugin for mouseover events

-- DISPLAY GROUPS --
local backGroup = display.newGroup()         --Background assets
local uiGroup = display.newGroup()           --UI assets
local mainGroup = display.newGroup()         --Heroes, mobs etc. assets

-- Sounds & Music --
local backgroundMusic = audio.loadStream("28_爱给网_aigei_com .mp3") --loads music in small chunks to save memory
local backgroundMusicChannel = audio.play(backgroundMusic, {channel = 1, loops = -1, fadein = 5000,}) --infinite loops, 5sec fade in
local bgVolume = 0.15
audio.setMaxVolume(bgVolume, {channel=1}) --sets max volume to bgVolume

local buttonSound = audio.loadSound("buttonSound.mp3")

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
    local widget = require("widget")

    -- Create the widget
    local slider = widget.newSlider(
        {
            x = display.contentCenterX - 450,
            y = display.contentCenterY - 200,
            width = 400,
            value = bgVolume,  -- Start slider at bgVolume
        }
    )
    --not working yet
----------------------------------------------------------------------------------------
    local function backToStart() --goes back to starting screen
        continueButton.isVisible = true
        newButton.isVisible = true
        menuButton.isVisible = true
        backButtonMenu.isVisible = false
        exitButton.isVisible = true
        soundText.isVisible = false
        soundOnBox:removeSelf()
        soundOffBox:removeSelf()
        slider:removeSelf()
    end
    backButtonMenu:addEventListener("tap", backToStart) --points to the function above
end
menuButton:addEventListener("tap", menuClicked) --points to the function that triggers menu clicked functions

-- NEW GAME PRESSED --
local chooseClass = display.newText( uiGroup,"Choose Your Class!", display.contentCenterX, display.contentCenterY - 300, native.systemFont, 80  )
    chooseClass:setFillColor(255, 0, 255) --Declaring the text, Lua uses RGB Colours
    chooseClass.isVisible = false

local mageIcon = display.newImageRect(uiGroup, "Badge_mage.png", 500, 500) --declaring the mage image
    mageIcon.x = display.contentCenterX
    mageIcon.y = display.contentCenterY
    mageIcon.isVisible = false

local mageIconHover = display.newImageRect(uiGroup, "Badge_mage.png", 550, 550) --declaring the bigger mage image
    mageIconHover.x = display.contentCenterX
    mageIconHover.y = display.contentCenterY
    mageIconHover.isVisible = false

local function newButton_tap() --goes to new game options
    continueButton.isVisible = false
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
        continueButton.isVisible = true
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
local mageSheetOptions=
{
  -- Required parameters
    width = 512,
    height = 256,
    numFrames = 8,
}
local mageSheet = graphics.newImageSheet("mageSpriteSheet.png", mageSheetOptions)

--[[local sequences_runningMage = {
    -- consecutive frames sequence
    {
        name = "normalRun",
        start = 1,
        count = 8,
        time = 400,
        loopCount = 0,
        loopDirection = "forward"
    }
}]]
--local mageRun = display.newSprite(mainGroup, mageSheet, sequences_runningMage)

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
    local player = display.newImageRect( mainGroup, "player.png",72,72) -- (72x72)pixels per box to have 400 positions on the map. 20per row.
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
    local Walls = display.newImageRect( mainGroup,"Walls.jpg", 72, 72)
    Walls.x = 36
    Walls.y =36
    physics.addBody( Walls, "static", {bounce = 0.0, friction = 50, density = 150} )
    local function addWall(coordinateX, coordinateY) --adding a function to make adding a wall easier
        Walls = display.newImageRect( mainGroup,"Walls.jpg", 72, 72)
        Walls.x = coordinateX
        Walls.y = coordinateY
        physics.addBody( Walls, "static", {bounce = 0.0, friction = 50, density = 150} )
        Walls.gravityScale =0
    end

    local function addWallsLine(X1, X2, Y1, Y2) --function to add walls in lines.
      if X1 == X2 and Y1 ~= Y2 then             --This function should be considered art.
        if Y1 > Y2 then
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
addWallsLine( 36, 36, 36+72, 504 + 36 -72 ) --left up
local breakableWall = display.newImageRect( mainGroup,"breakableWall.png", 72, 72)
breakableWall.x = 36
breakableWall.y =542.5
physics.addBody( breakableWall, "static", {bounce = 0.0, friction = 50, density = 150, filter = blueCollision} )
addWallsLine( 36, 36, 616, 976 ) --left down
addWallsLine( 1920-36, 1920-36, 36+72, 1872 + 36 -72 ) --right

  -- UI --               -- Health Bar , Armor, Mana , Items
  --[[local function addHeart(X, Y) --adding a function to make adding a wall easier
    fullHeart = display.newImageRect(mainGroup,"Heart.png",72,72, X, Y)
    fullHeart.x = X
    fullHeart.y = Y
  end
  local playerLives = 3
  addHeart(100,1045)
  addHeart(150,1045)
  addHeart(200,1045)]]
  local Heart1 = display.newImageRect(mainGroup,"Heart.png",72,72)
  local Heart2 = display.newImageRect(mainGroup,"Heart.png",72,72, 150, 1045)
  local Heart3 = display.newImageRect(mainGroup,"Heart.png",72,72, 200, 1045)
  Heart1.x = 100
  Heart2.x = 150
  Heart3.x = 200
  Heart1.y = 1045
  Heart2.y = 1045
  Heart3.y = 1045
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
  local enemy = display.newImageRect(mainGroup, "Enemy.jpg", 72, 72)
    enemy.isVisible = false
  local function addEnemy (coordinateX, coordinateY, Ex, Ey)
    enemy = display.newImageRect(mainGroup, "Enemy.jpg", 72, 72)
    enemy.x = coordinateX
    enemy.y = coordinateY
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

--If the player gets too close the enemy will fire projectiles at them.
--The close the player is to an enemy the higher the rate of fire.
  function EnemyDetectRange(event)
    if math.sqrt(math.pow((enemy.x - player.x),2) + math.pow((enemy.y - player.y),2 )) < 2500 then
      for i=0, 10, i+1 do
      timer.performWithDelay(500, EnemyAttack)
      if math.sqrt(math.pow((enemy.x - player.x),2) + math.pow((enemy.y - player.y),2 )) > 2500 then break end
    end
    if math.sqrt(math.pow((enemy.x - player.x),2) + math.pow((enemy.y - player.y),2 )) < 1250 then
      for i=0, 10, i+1 do
        timer.performWithDelay(420, EnemyAttack)
        if math.sqrt(math.pow((enemy.x - player.x),2) + math.pow((enemy.y - player.y),2 )) > 1250 then break end
      end
    end
  end
end

  local  randomMovementEnemy = function() --endless loop for generating random number for enemy to change movements
    local minus1 =1
    local minus2 =1
    if math.random() > 0.5 then minus1 = -1 end
    if math.random() > 0.5 then minus2 = -1 end
    local Ex = ((math.random() *200) +50) *minus1
    local Ey = ((math.random() *200) +50) *minus2
    enemy:setLinearVelocity(Ex,Ey)
  end
    timer.performWithDelay( 1000, randomMovementEnemy, -1)

    -- background --       -- block this with walls to make it seem like the floor --
    local floor = display.newImageRect( uiGroup, "floor.jpg", 1920, 1080 ) -- declaring continue button
    floor.x = display.contentCenterX
    floor.y = display.contentCenterY

    -- movement wasd --
    local previousLeft = 2
    local previousRight = 2

    local function onKeyEvent(event)   -- movement commands --  sets Vx and Vy independently, allowing fluid movement
    if event.keyName == "a" then
       if event.phase == "down" then
         Vx = Vx - 200
         player:setLinearVelocity(Vx,Vy)
        -- player:play()
         --previousLeft = 1
        -- if previousRight == 1 or previousRight == 2 then
           --player:scale(-1, 1)
           --previousRight = 0
         --end
         --player:applyLinearImpulse(-.5,0,player.x,player.y)
          --transition.to(player, {time = 3000, x = player.x - 1000})
        elseif event.phase == "up" then
          Vx = Vx + 200
          player:setLinearVelocity(Vx,Vy)
          --player:pause()
          --player:setFrame(1)
          --player:applyLinearImpulse(0.5,0,player.x,player.y)
          --transition.cancel()
       end
    end
    if event.keyName == "d" then
       if event.phase == "down" then
         Vx = Vx + 200
         player:setLinearVelocity(Vx,Vy)
         --player:play()
         --previousRight = 1
         --if previousLeft == 1 then
           --player:scale(-1, 1)
           --previousLeft = 0
         --end
         --player:applyLinearImpulse(.5,0,player.x,player.y)
          --transition.to(player, {time = 3000, x = player.x  + 1000})
        elseif event.phase == "up" then
          Vx = Vx - 200
          player:setLinearVelocity(Vx,Vy)
          --player:pause()
          --player:setFrame(1)
          --player:applyLinearImpulse(-.5,0,player.x,player.y)
          --transition.cancel()
       end
    end
    if event.keyName == "w" then
       if event.phase == "down" then
         Vy = Vy-200
         player:setLinearVelocity(Vx,Vy)
         --player:play()
         --player:applyLinearImpulse(0,-.5,player.x,player.y)
          --transition.to(player, {time = 3000, y = player.y  - 1000})
        elseif event.phase == "up" then
          Vy = Vy + 200
          player:setLinearVelocity(Vx,Vy)
          --player:pause()
          --player:setFrame(1)
          --player:applyLinearImpulse(0,.5,player.x,player.y)
          --transition.cancel()
       end
    end
    if event.keyName == "s" then
       if event.phase == "down" then
         Vy = Vy + 200
         player:setLinearVelocity(Vx,Vy)
         --player:play()
         --player:applyLinearImpulse(0,.5,player.x,player.y)
          --transition.to(player, {time = 3000, y = player.y  + 1000})
        elseif event.phase == "up" then
          Vy = Vy - 200
          player:setLinearVelocity(Vx,Vy)
          --player:pause()
          --player:setFrame(1)
          --player:applyLinearImpulse(0,-.5,player.x,player.y)
          --transition.cancel()
       end
    end
  end

  function ProteinProjectile(event)
    local Math1
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
  end

    Runtime:addEventListener("preCollision", EnemyDetectRange)
    Runtime:addEventListener("key", onKeyEvent)
    Runtime:addEventListener("tap", ProteinProjectile)

 --Breakable wall break --
local function wallBreak()
  --Protein.removeSelf()
  breakableWall:removeSelf()
end
breakableWall.collision = wallBreak
breakableWall:addEventListener("collision")
local reee = 1
local emptyHeart1 = display.newImageRect(mainGroup,"EmptyHeart.png",72,72)
emptyHeart1.isVisible = false
local function onLocalCollision( self, event )   -- Protein Projectile detection function
  local enemyHit = audio.loadSound("oof.mp3")       -- Loads enemy hurting sound
  if(event.target.type=="enemy" and event.other.type=="protein") then       --Makes sure its protein which is hitting it.
    if event.phase == "began" then
    local oof = audio.play(enemyHit)
  end
  end
  if(event.target.type=="player" and event.other.type=="ShittyNutrients") then
    if event.phase == "began" then
    local oof = audio.play(enemyHit)
    if reee==1 then
      Heart3.isVisible = false
      emptyHeart1.isVisible = true
      emptyHeart1.x = 200
      emptyHeart1.y = 1045
    end
  end
  end
end

enemy.collision = onLocalCollision
enemy:addEventListener( "collision" ) --Checks if enemy has been hit by anything.

player.collision = onLocalCollision
player:addEventListener("collision")





end --end for mageIconClicked
mageIcon:addEventListener( "tap", mageIconClicked )
