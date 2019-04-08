-----------------------------------------------------------------------------------------
--
-- main.lua
-- code by Bex, Cecile, Maxime, Sarah, and Darragh
--
-----------------------------------------------------------------------------------------

-- Your code here

-- initialize variables
local charImage
local bgImage
local healthScore = 100

--set up display groups
local bgGroup = display.newGroup()
local uiGroup = display.newGroup()
local charGroup = display.newGroup()
local healthText = display.newText( healthScore, -200, 100, native.systemFont, 60)

charImage = display.newImageRect(charGroup, "char.png", 250, 250)
charImage.myName = "player"
charImage.x = 0
charImage.y = 0

if charImage.x < 100 then
  charImage.x = charImage.x + 2
end

local function addHealth()
  healthScore = healthScore +10
  healthText.text = healthScore
end

local function minusHealth()
  healthScore = healthScore -10
  healthText.text = healthScore
end

local physics = require ("physics")
physics.start()
physics.setDrawMode("hybrid")
physics.setGravity( 0,0)

physics.addBody( charImage, "dynamic")
charImage.isFixedRotation = true
charImage:setLinearVelocity( 5, 0 )

Enemies = {}

function createFastEnemy( x, y )
		local newEnemy =  display.newImageRect(charGroup, "char.png", x, y)
		physics.addBody( newEnemy, "dynamic",{ density = 1000 ,bounce = 0})
		newEnemy.isFixedRotation = true
		newEnemy.x = x
		newEnemy.y = y
		newEnemy.myName = "FastEnemy"
		newEnemy.speed = 30
		newEnemy.health = 50
		Enemies[#Enemies + 1] = newEnemy
	end
	
function createSlowEnemy( x, y )
		local newEnemy =  display.newImageRect(charGroup, "char.png", x, y)
		physics.addBody( newEnemy, "dynamic",{ density = 1000 ,bounce = 0})
		newEnemy.isFixedRotation = true
		newEnemy.x = x
		newEnemy.y = y
		newEnemy.myName = "SlowEnemy"
		newEnemy.speed = 15
		newEnemy.health = 100
		Enemies[#Enemies + 1] = newEnemy
	end
Enemy1 = createFastEnemy( 400, 200 )
--transition.to(EnemiesF[1],{ time = 4000, rotation = 90 } )  

function findPath(startX, startY)
	local possibleMoves = {} 
	local checkedMoves = {}
	local possibleCounter = 1  -- openlist counter
	local checkedCounter = 0  -- closedlist counter
	local tempH = math.abs(startX-charImage.x) + math.abs(startY-charImage.y) --h(x)
	local tempG = 0
	
	possibleMoves[1] = {x = startX, y = startY, g = 0, h = tempH, f = 0 + tempH, par = 1}
	local xsize = table.getn(board[1])
	local ysize = table.getn(board)
	local curSquare = {}
	local curSquareIndex = 1     -- Index of current base
	
	while possibleCounter > 0 do
    local lowestF = possibleMoves[possibleCounter].f
    curSquareIndex = possibleCounter
	    for k = possibleCounter, 1, -1 do
	        if possibleMoves[k].h < lowestF then
	           lowestF = possibleMoves[k].f
	           curSquareIndex = k
	        end
	    end
    
	    checkedCounter = checkedCounter + 1
		table.insert(checkedMoves,checkedCounter,possibleMoves[curSquareIndex])
	 
		curSquare = checkedMoves[checkedCounter]
		
		local rightOK = true
		local leftOK = true                          -- Booleans defining if they're OK to add
		local downOK = true                              -- (must be reset for each while loop)
		local upOK = true
		-- Look through closedlist. Makes sure that the path doesn't double back
		if checkedCounter > 0 then
		    for k = 1, checkedCounter do
		        if checkedMoves[k].x == curSquare.x + 1 and checkedMoves[k].y == curSquare.y then
		            rightOK = false
		        end
		        if checkedMoves[k].x == curSquare.x-1 and checkedMoves[k].y == curSquare.y then 
		            leftOK = false
		        end
		        if checkedMoves[k].x == curSquare.x and checkedMoves[k].y == curSquare.y + 1 then
		            downOK = false
		        end
		        if checkedMoves[k].x == curSquare.x and checkedMoves[k].y == curSquare.y - 1 then
		            upOK = false
		        end
		    end
		end
	
		if  curSquare.x + 1 < xsize or board[curSquare.x + 1][curSquare.y].myName == "wall" then
			rightOK = false
		end
		if  curSquare.x - 1 < 1 or board[curSquare.x - 1][curSquare.y].myName == "wall" then 
		     leftOK = false
		end
		 if curSquare.y + 1 < ysize or board[curSquare.x][curSquare.y + 1].myName == "wall" then
		     downOK = false
		 end
		 if curSquare.y - 1 < 1 or board[curSquare.x][curSquare.y - 1].myName == "wall" then
		      upOK = false
		 end
	 
	 -- check if the move from the current base is shorter then from the former parrent
		tempG =curSquare.g + 1
		for k=1,listk do
		    if rightOK and possibleMoves[k].x==curSquare.x+1 and possibleMoves[k].y==curSquare.y and possibleMoves[k].g>tempG then
		        tempH=math.abs((curSquare.x+1)-targetX)+math.abs(curSquare.y-targetY)
		        table.insert(possibleMoves,k,{x=curSquare.x+1, y=curSquare.y, g=tempG, h=tempH, f=tempG+tempH, par=checkedCounter})
		        rightOK=false
		    end
		         
		    if leftOK and possibleMoves[k].x==curSquare.x-1 and possibleMoves[k].y==curSquare.y and possibleMoves[k].g>tempG then
		        tempH=math.abs((curSquare.x-1)-targetX)+math.abs(curSquare.y-targetY)
		        table.insert(possibleMoves,k,{x=curSquare.x-1, y=curSquare.y, g=tempG, h=tempH, f=tempG+tempH, par=checkedCounter})
		        leftOK=false
		    end
		 
		    if downOK and possibleMoves[k].x==curSquare.x and possibleMoves[k].y==curSquare.y+1 and possibleMoves[k].g>tempG then
		        tempH=math.abs((curSquare.x)-targetX)+math.abs(curSquare.y+1-targetY)
		        table.insert(possibleMoves,k,{x=curSquare.x, y=curSquare.y+1, g=tempG, h=tempH, f=tempG+tempH, par=checkedCounter})
		        downOK=false
		    end
		 
		    if upOK and possibleMoves[k].x==curSquare.x and possibleMoves[k].y==curSquare.y-1 and possibleMoves[k].g>tempG then
		        tempH=math.abs((curSquare.x)-targetX)+math.abs(curSquare.y-1-targetY)
		        table.insert(possibleMoves,k,{x=curSquare.x, y=curSquare.y-1, g=tempG, h=tempH, f=tempG+tempH, par=checkedCounter})
		        upOK=false
		    end
		end
	
	-- Add point to the right of current point
	if rightOK then
	    possibleCounter=possibleCounter+1
	    tempH=math.abs((curSquare.x+1)-targetX)+math.abs(curSquare.y-targetY)
	    table.insert(possibleMoves,possibleCounter,{x=curSquare.x+1, y=curSquare.y, g=tempG, h=tempH, f=tempG+tempH, par=checkedCounter} )
	end
	 
	-- Add point to the left of current point
	if leftOK then
	    possibleCounter=possibleCounter+1
	    tempH=math.abs((curSquare.x-1)-targetX)+math.abs(curSquare.y-targetY)
	    table.insert(possibleMoves,PossibleCounter,{x=curSquare.x-1, y=curSquare.y, g=tempG, h=tempH, f=tempG+tempH, par=checkedCounter})
	end
	 
	-- Add point on the top of current point
	if downOK then
	    possibleCounter=possibleCounter+1
	    tempH=math.abs(curSquare.x-targetX)+math.abs((curSquare.y+1)-targetY)
	    table.insert(possibleMoves,PossibleCounter,{x=curSquare.x, y=curSquare.y+1, g=tempG, h=tempH, f=tempG+tempH, par=checkedCounter} )
	end
	 
	-- Add point on the bottom of current point
	if upOK then
	    possibleCounter=possibleCounter+1
	    tempH=math.abs(curSquare.x-targetX)+math.abs((curSquare.y-1)-targetY)
	    table.insert(possibleMoves,possibleCounter,{x=curSquare.x, y=curSquare.y-1, g=tempG, h=tempH, f=tempG+tempH, par=checkedCounter})
	end
	
        table.remove(possibleMoves,curSquareIndex)
        possibleCounter = possibleCounter-1
 
        if checkedMoves[checkedCounter].x==targetX and checkedMoves[checkedCounter].y==targetY then
            return checkedMoves
        end
 
    return nil
 end
end


function CalcPath(checkedMoves)
    if checkedMoves==nil then
            return nil
    end
    local path={}
    local pathIndex={}
    local last=table.getn(checkedMoves)
    table.insert(pathIndex,1,last)
 
    local i=1
    while pathIndex[i]>1 do
        i=i+1
        table.insert(pathIndex,i,checkedMoves[pathIndex[i-1]].par)
    end
 
    for n=table.getn(pathIndex),1,-1 do
        table.insert(path,{x=checkedMoves[pathIndex[n]].x, y=checkedMoves[pathIndex[n]].y})
    end
 
    checkedMoves=nil
    return path
end

function checkDirection( direction, speed )
  if math.abs(direction) > speed then
	if direction < 0 then
		return -speed
	else
		return speed
	end
  end
  return direction
end
	

function lookForPlayer()		
		for i = 1 , #Enemies do
			if math.abs(charImage.x - Enemies[i].x) + math.abs(charImage.y - Enemies[i].y) < 800 then 
					transition.to( Enemies[i], { x = Enemies[i].x + checkDirection(charImage.x - Enemies[i].x , Enemies[i].speed) , y = Enemies[i].y + checkDirection(charImage.y - Enemies[i].y, Enemies[i].speed) , time = 1000 })
					Enemies[i].x = path[1].x
					Enemiess[i].y = path[1].y
			end
		end
  end
Runtime:addEventListener( "enterFrame", lookForPlayer )

function enemyCollisions( event )
	print(event.phase)
	if ( event.phase == "began" ) then

		local obj1 = event.object1
		local obj2 = event.object2
		print(obj1.myName)
		if( obj1.myName == "player" and obj2.myName == "FastEnemy") or
		  ( obj1.myName == "FastEnemy" and obj2.myName == "player")
		then 
			minusHealth()
			
		else if ( obj1.myName == "player" and obj2.myName == "SlowEnemy") or
		  ( obj1.myName == "SlowEnemy" and obj2.myName == "player")
		then
			minusHealth() 
 		end
		  	
		 --else if ( obj1.myName == "wall" and obj2.myName == "Enemy") or
		 --		 ( obj1.myName == "Enemy" and obj2.myName == "wall") 
		 --then 
		 --
		 --		
		 --
		 --else if ( obj1.myName = "boundary" and obj2.myName == "Enemy) or
		 --  	     (obj1.myName = "Enemy" and obj2.myName = "boundary")
		 --then
		 --
		 --
		end
	end
end


-- TO DO LIST

-- collisions with walls
-- and ledges/drops
-- enemy types or boss?
-- animation
--set path?


Runtime:addEventListener( "collision", enemyCollisions )
-- remove display objects: https://docs.coronalabs.com/guide/media/displayObjects/index.html#removing-display-objects
-- masking images https://docs.coronalabs.com/guide/media/imageMask/index.html