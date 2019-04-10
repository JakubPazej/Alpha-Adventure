local composer = require( "composer" )

local scene = composer.newScene()


-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

        -- DISPLAY GROUPS --
        local backGroup = display.newGroup()         --Background assets
        local uiGroup = display.newGroup()           --UI assets
        local mainGroup = display.newGroup()         --Heroes, mobs etc. assets

        local i = 0;

        -- Collision Filters--
        local blueCollision = { groupIndex = 1 }

        -- Image Sheets and Sequences --
        local mageSheetOptions=
        {
          -- Required parameters
            width = 72,
            height = 72,
            numFrames = 25,
        }
        local mageSheet = graphics.newImageSheet("mageSpriteSheet.png", mageSheetOptions)

        local sequences_runningMage = {
            -- consecutive frames sequence
            {
                name = "everything",
                start = 1,
                count = 25,
                time = 400,
                loopCount = 0,
                loopDirection = "forward"
            },
            {
                name = "leftRun",
                frames = { 21,22,23 },
                time = 400,
                loopCount = 0
            },
            {
              name = "rightRun",
              frames = { 16,17,18 },
              time = 400,
              loopCount = 0
            },
            {
              name = "upRun",
              frames = { 4,5 },
              time = 400,
              loopCount = 0
            },
            {
              name = "downRun",
              frames = { 1,2,3 },
              time = 400,
              loopCount = 0
            },
            {
              name = "upLeftRun",
              frames = { 1,2,3 },
              time = 400,
              loopCount = 0
            },
            {
              name = "upRightRun",
              frames = { 1,2,3 },
              time = 400,
              loopCount = 0
            },
            {
              name = "downLeftRun",
              frames = { 1,2,3 },
              time = 400,
              loopCount = 0
            },
            {
              name = "downRightRun",
              frames = { 1,2,3 },
              time = 400,
              loopCount = 0
            }
        }
        local mageRun = display.newSprite(mainGroup, mageSheet, sequences_runningMage)

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
            local player = mageRun -- (72x72)pixels per box to have 400 positions on the map. 20per row.
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
        addWallsLine( 36, 36, 36+72, 504 + 36 -72 ) --left up
        local breakableWall = display.newImageRect( mainGroup,"breakableWall.png", 72, 72)
        breakableWall.x = 36
        breakableWall.y =542.5
        physics.addBody( breakableWall, "static", {bounce = 0.0, friction = 50, density = 150, filter = blueCollision} )
        addWallsLine( 36, 36, 616, 976 ) --left down
        addWallsLine( 1920-36, 1920-36, 36+72, 1872 + 36 -72 ) --right
        addWall(300,800)
        addWall(700,900)
        Walls.type = "wall"

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
          local Heart2 = display.newImageRect(mainGroup,"Heart.png",72,72)
          local Heart3 = display.newImageRect(mainGroup,"Heart.png",72,72)
          Heart1.x = 100
          Heart2.x = 150
          Heart3.x = 200
          Heart1.y = 1045
          Heart2.y = 1045
          Heart3.y = 1045
          Heart1.isVisible = true
          Heart2.isVisible = true
          Heart3.isVisible = true
          local emptyHeart1 = display.newImageRect(mainGroup,"EmptyHeart.png",72,72)
          local emptyHeart2 = display.newImageRect(mainGroup,"EmptyHeart.png",72,72)
          local emptyHeart3 = display.newImageRect(mainGroup,"EmptyHeart.png",72,72)
          emptyHeart1.x = 200
          emptyHeart2.x = 150
          emptyHeart3.x = 100
          emptyHeart1.y = 1045
          emptyHeart2.y = 1045
          emptyHeart3.y = 1045
          emptyHeart1.isVisible = false
          emptyHeart2.isVisible = false
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
                 player:setSequence( "leftRun" )
                 player:play()
                elseif event.phase == "up" then
                  Vx = Vx + 200
                  player:setLinearVelocity(Vx,Vy)
                  player:setSequence( "everything" )
                  player:pause()
                  player:setFrame(1)
               end
            end
            if event.keyName == "d" then
               if event.phase == "down" then
                 Vx = Vx + 200
                 player:setLinearVelocity(Vx,Vy)
                 player:setSequence( "rightRun" )
                 player:play()
                elseif event.phase == "up" then
                  Vx = Vx - 200
                  player:setLinearVelocity(Vx,Vy)
                  player:setSequence( "everything" )
                  player:pause()
                  player:setFrame(1)
               end
            end
            if event.keyName == "w" then
               if event.phase == "down" then
                 Vy = Vy-200
                 player:setLinearVelocity(Vx,Vy)
                 player:setSequence( "upRun" )
                 player:play()
                elseif event.phase == "up" then
                  Vy = Vy + 200
                  player:setLinearVelocity(Vx,Vy)
                  player:setSequence( "everything" )
                  player:pause()
                  player:setFrame(1)
               end
            end
            if event.keyName == "s" then
               if event.phase == "down" then
                 Vy = Vy + 200
                 player:setLinearVelocity(Vx,Vy)
                 player:setSequence( "downRun" )
                 player:play()
                elseif event.phase == "up" then
                  Vy = Vy - 200
                  player:setLinearVelocity(Vx,Vy)
                  player:setSequence( "everything" )
                  player:pause()
                  player:setFrame(1)
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


            Runtime:addEventListener("preCollision", EnemyDetectRange)
            Runtime:addEventListener("key", onKeyEvent)
            Runtime:addEventListener("mouse", proteinProjectile)
            timer.performWithDelay( 1000, randomMovementEnemy, -1)

         --Breakable wall break --
          local function wallBreak()
            breakableWall:removeSelf()
          end
          breakableWall.collision = wallBreak
          breakableWall:addEventListener("collision")


          local function wallCollision( self, event )
              if  (event.target.type == "wall" and event.other.type == "protein") then
                if event.phase =="began" then
                display.remove(event.other)
                event.other= nil
              end
            end
          end
            Walls.collision = wallCollision
            Walls:addEventListener("collision")

          local function onLocalCollision( self, event )      -- Protein Projectile detection function
            local enemyHit = audio.loadSound("oof.mp3")       -- Loads enemy hurting sound
            if(event.target.type=="enemy" and event.other.type=="protein") then       --Makes sure its protein which is hitting it.
              if event.phase == "began" then
                if enemy.isVisible == true then
                  local oof = audio.play(enemyHit)
                  enemy.isVisible = false
                end
              end
            end
            --[[if(event.target.type == "wall" and event.other.type == "protein") then
              display.remove (event.other)
              event.other = nil
            end]]
            if(event.target.type=="player" and event.other.type=="ShittyNutrients") then
              if event.phase == "began" then
              local oof = audio.play(enemyHit)
              if reee==1 then
                Heart3.isVisible = false
                emptyHeart1.isVisible = true
                emptyHeart1.x = 200
                emptyHeart1.y = 1045
                reee = reee +1
              end

              else if reee == 2 then
                Heart2.isVisible = false
                emptyHeart2.isVisible = true
                emptyHeart2.x = 150
                emptyHeart2.y = 1045
                reee = reee +1
              end
            end
              else if reee == 3 then
                composer.gotoScene("gameOver")
              end
            end
            end

          --[[local function onLocalCollision( self, event )   -- Protein Projectile detection function
            local enemyHit = audio.loadSound("oof.mp3")       -- Loads enemy hurting sound
            if(event.target.type=="enemy" and event.other.type=="protein") then       --Makes sure its protein which is hitting it.
              if event.phase == "began" then
                local oof = audio.play(enemyHit)
              end
            end
            if(event.target.type=="player" and event.other.type=="ShittyNutrients") then
              if event.phase == "began" then
                local oof = audio.play(enemyHit)
              end
            end
          end]]

          enemy.collision = onLocalCollision
          enemy:addEventListener( "collision" ) --Checks if enemy has been hit by anything.

          player.collision = onLocalCollision
          player:addEventListener("collision")

          --Walls.collision = wallCollision
          --Walls:addEventListener("collision")

          local teleportWall = display.newImageRect( mainGroup,"Walls.jpg", 72, 72)
          teleportWall.x = -72
          teleportWall.y = 550
          physics.addBody( teleportWall, "static", {bounce = 0.0, friction = 50, density = 150} )
          teleportWall.gravityScale =0
          teleportWall.type = "wall"

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
