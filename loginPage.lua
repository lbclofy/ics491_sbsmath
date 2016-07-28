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
 
local users = [[CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, username, password);]]
print(users)
db:exec( users )

if file_exists(path) == false then

local tablefill =[[INSERT INTO users VALUES (NULL, ']]..'joey'..[[',']]..'password'..[['); ]]
db:exec( tablefill )
 
--Add rows with a auto index in 'id'. You don't need to specify a set of values because we're populating all of them


end
 
--print the sqlite version to the terminal
print( "version " .. sqlite3.version() )
 
--print all the table contents

for row in db:nrows("SELECT * FROM users") do
  local text = row.username .. " : " ..  row.password
  local t = display.newText(text, 800, 120 + (20 * row.id), native.systemFont, 16)
  t:setFillColor(1,0,1)
end

--setup the system listener to catch applicationExit
Runtime:addEventListener( "system", onSystemEvent )






-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local nameField = native.newTextField( centerX, _H*.40, _W*.5, _H*.1 )
    nameField.font = fontText
    sceneGroup:insert( nameField )
    local passwordField = native.newTextField( centerX, _H*.65,  _W*.5, _H*.1 )
    passwordField.font = fontText
    passwordField.isSecure = true
    sceneGroup:insert( passwordField )


    local headlineText  = display.newText( "Welcome!", centerX, _H*.15, font, _W*.05 )
    local errorText  = display.newText( "", centerX, _H*.9, font, _W*.04 )
    local userText  = display.newText( "User Name", centerX, _H*.3, font, _W*.04 )
    local passText  = display.newText( "Password", centerX, _H*.55, font, _W*.04 )
    sceneGroup:insert( headlineText )
    sceneGroup:insert( userText )
    sceneGroup:insert( passText )

    local function textListener( event )

        if ( event.phase == "began" ) then
            -- User begins editing "defaultField"

        elseif ( event.phase == "ended" or event.phase == "submitted" ) then
            -- Output resulting text from "defaultField"
            print( event.target.text )

        elseif ( event.phase == "editing" ) then
            local txt = event.text            
            if(string.len(txt)>10)then
                txt=string.sub(txt, 1, 10)
                event.text=txt
                event.target.text = txt
            end

            print( event.newCharacters )
            print( event.oldText )
            print( event.startPosition )
            print( event.text )
        end
    end

    nameField:addEventListener( "userInput", textListener )
    passwordField:addEventListener( "userInput", textListener )

      

    local login = display.newRoundedRect( _W*.35, _H*.8, _W*.2, _W*.1/phi, _W*.01 )
    login:setFillColor(137/255,  94/255,  62/255)
    sceneGroup:insert( login )
    local loginText  = display.newText( "Login", _W*.35, _H*.8, font, _W*.03 )
    sceneGroup:insert( loginText )

    local register = display.newRoundedRect( _W*.65, _H*.8, _W*.2, _W*.1/phi, _W*.01 )
    register:setFillColor(137/255,  94/255,  62/255)
    sceneGroup:insert( register )
    local registerText  = display.newText( "Register", _W*.65, _H*.8, font, _W*.03 )
    sceneGroup:insert( registerText )


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
        errorText.text = "username or password is wrong"
        print("username or password do not match our database")
    end
    login:addEventListener( "tap", loginUser )

    local function registerUser( event )
        for row in db:nrows("SELECT * FROM users") do
        local text = row.username 
        local password = row.password
            if text == nameField.text then
            print(text .. " : " .. password)
            errorText.text = "user already exits"
            do return end
            end
        end
        local tablefill =[[INSERT INTO users VALUES (NULL, ']].. nameField.text ..[[',']].. passwordField.text ..[['); ]]
        db:exec( tablefill )
        composer.gotoScene( "menu" )
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