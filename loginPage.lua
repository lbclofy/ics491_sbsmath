local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
--
-- Project: SQLite demo
--
-- Date: August 24, 2010
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Shows how to create and read a SQLite database
--
-- Demonstrates: database create and read APIs
--
-- File dependencies: none
--
-- Target devices: Simulator (results onscreen and in Console) and on Device
--
-- Limitations: none
--
-- Update History:
--
-- Comments: 
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
--  Supports Graphics 2.0
---------------------------------------------------------------------------------------

--Include sqlite
require "sqlite3"
--Open data.db.  If the file doesn't exist it will be created
local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path )   
 
--Handle the applicationExit event to close the db
local function onSystemEvent( event )
        if( event.type == "applicationExit" ) then              
            db:close()
        end
end

local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
 

if file_exists(path) == false then


local users = [[CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, username, password);]]
print(users)
db:exec( users )

local tablefill =[[INSERT INTO users VALUES (NULL, ']]..'joey'..[[',']]..'password'..[['); ]]
db:exec( tablefill )
 
--Add rows with a auto index in 'id'. You don't need to specify a set of values because we're populating all of them


end
 
--print the sqlite version to the terminal
print( "version " .. sqlite3.version() )
 
--print all the table contents
--[[
for row in db:nrows("SELECT * FROM users") do
  local text = row.username 
  local t = display.newText(text, 20, 120 + (20 * row.id), native.systemFont, 16)
  t:setFillColor(1,0,1)
end
 ]]
--setup the system listener to catch applicationExit
Runtime:addEventListener( "system", onSystemEvent )






-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local nameField = native.newTextField( 150, 150, 180, 30 )
    sceneGroup:insert( nameField )
    local passwordField = native.newTextField( 600, 150, 180, 30 )
    passwordField.isSecure = true
    sceneGroup:insert( passwordField )

    local function textListener( event )

        if ( event.phase == "began" ) then
            -- User begins editing "defaultField"

        elseif ( event.phase == "ended" or event.phase == "submitted" ) then
            -- Output resulting text from "defaultField"
            print( event.target.text )

        elseif ( event.phase == "editing" ) then
            print( event.newCharacters )
            print( event.oldText )
            print( event.startPosition )
            print( event.text )
        end
    end

    nameField:addEventListener( "userInput", textListener )
    passwordField:addEventListener( "userInput", textListener )

      

    local login = display.newCircle(  0,0, 40 )
    login:setFillColor(0,0,1)
    login.x, login.y = 100, 50
    sceneGroup:insert( login )

    local register = display.newCircle(  0,0, 40 )
    register:setFillColor(0,1,0)
    register.x, register.y = 600, 50
    sceneGroup:insert( register )

    local function loginUser( event )
        for row in db:nrows("SELECT * FROM users") do
        local text = row.username 
        local password = row.password
            if text == nameField.text  and password == passwordField.text then
                print(text .. " : " .. password)
                composer.gotoScene( "menu" )
                do return end
            end
        end
        print("username or password do not match our database")
    end
    login:addEventListener( "tap", loginUser )

    local function registerUser( event )
        for row in db:nrows("SELECT * FROM users") do
        local text = row.username 
        local password = row.password
            if text == defaultField.text then
            print(text .. " : " .. password)
            end
        end
    end
    register:addEventListener( "tap", registerUser )

end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

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