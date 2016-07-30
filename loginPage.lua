local composer = require( "composer" )
local openssl = require( "plugin.openssl" )

local scene = composer.newScene()
local cipher = openssl.get_cipher ( "aes-256-cbc" )

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
_G.db = sqlite3.open( path )   
 
--Handle the applicationExit event to close the db
local function onSystemEvent( event )
        if( event.type == "applicationExit" ) then              
            db:close()
        end
end

 
local users = [[CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, username, password, lesson1, lesson2, lesson3, lesson4, lesson5, lesson6, lesson7, lesson8, lesson9, lesson10, lesson11);]]
db:exec( users )

local i = 0 
for row in db:nrows("SELECT * FROM users") do
    i = i + 1
end

if i == 0 then
    local tablefill =[[INSERT INTO users VALUES (NULL, ']].. 'default' ..[[',']].. 'password' ..[[',']]..'0'..[[',']]..'0'..[[',']]..'0'..[[',']]..'0'..[[',']]..'0'..[[',']]..'0'..[[',']]..'0'..[[',']]..'0'..[[',']]..'0'..[[',']]..'0'..[[',']]..'0'..[['); ]]
    db:exec( tablefill )
end

local text = "5" --numCorr .. "/" .. (numCorr + numWrong)
local textData = cipher:encrypt ( text, "sbs_math_key" )
local userData = cipher:decrypt ( "jarrod", "sbs_math_key" )
  local stmt = [[ UPDATE users SET lesson5 = ']] .. textData ..[[' WHERE username = ']] .. userData .. [['; ]]
   db:exec( stmt )





--print the sqlite version to the terminal
print( "version " .. sqlite3.version() )
 
--print all the table contents

for row in db:nrows("SELECT * FROM users") do
  local userData = cipher:decrypt ( row.username, "sbs_math_key" )  
  local passData = cipher:decrypt ( row.password, "sbs_math_key" )
  local text =  userData .. " : " .. passData .. " : " ..  row.password .. " 3: " .. cipher:decrypt ( row.lesson3, "sbs_math_key" ) ..
  " 4: " .. cipher:decrypt ( row.lesson4, "sbs_math_key" ) .. " 5: " .. cipher:decrypt ( row.lesson5, "sbs_math_key" ) .. " 6: " .. cipher:decrypt ( row.lesson6, "sbs_math_key" ) ..
  " 7: " .. cipher:decrypt ( row.lesson7, "sbs_math_key" ) .. " 8: " .. cipher:decrypt ( row.lesson8, "sbs_math_key" ) .. " 9: " .. cipher:decrypt ( row.lesson9, "sbs_math_key" ) ..
  " 10: " .. cipher:decrypt ( row.lesson10, "sbs_math_key" ) .. " 11: " .. cipher:decrypt ( row.lesson11, "sbs_math_key" ) 
  print(text)

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
    sceneGroup:insert( errorText )
    sceneGroup:insert( userText )
    sceneGroup:insert( passText )

    local function textListener( event )

        if ( event.phase == "began" ) then
            -- User begins editing "defaultField"

        elseif ( event.phase == "ended" or event.phase == "submitted" ) then
            -- Output resulting text from "defaultField"


        elseif ( event.phase == "editing" ) then
            local txt = event.text            
            if(string.len(txt)>10)then
                txt=string.sub(txt, 1, 10)
                event.text=txt
                event.target.text = txt
            end

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

    local options =
    {
        params = {
            username = "",
        }
    }


    local function loginUser( event )
        for row in db:nrows("SELECT * FROM users") do
        local text = row.username 
        local password = row.password
        local userData = cipher:decrypt ( text, "sbs_math_key" )  
        local passData = cipher:decrypt ( password, "sbs_math_key" )
            if userData == nameField.text  and passData == passwordField.text then
                options.params.username = nameField.text
                currentUser = options.params.username
                currentID = row.id
                composer.gotoScene( "menu" , options)
                do return end
            end
        end
        errorText.text = "username or password is wrong"

    end
    login:addEventListener( "tap", loginUser )

    local function registerUser( event )
        for row in db:nrows("SELECT * FROM users") do
        local text = row.username 
        local password = row.password
            if text == nameField.text then
            errorText.text = "user already exits"
            do return end
            end
        end

        local nameData = cipher:encrypt ( nameField.text, "sbs_math_key" )
        local passData = cipher:encrypt ( passwordField.text, "sbs_math_key" )
        local defaultData = cipher:encrypt ( '0/0', "sbs_math_key" )


        local tablefill =[[INSERT INTO users VALUES (NULL, ']].. nameData ..[[',']].. passData ..[[',']]..defaultData..[[',']]..defaultData..[[',']]..defaultData..[[',']]..defaultData..[[',']]..defaultData..[[',']]..defaultData..[[',']]..defaultData..[[',']]..defaultData..[[',']]..defaultData..[[',']]..defaultData..[[',']]..defaultData..[['); ]]
        db:exec( tablefill )
        options.params.username = nameField.text
        currentUser = options.params.username

        for row in db:nrows("SELECT * FROM users") do
        local text = row.username 
        local userData = cipher:decrypt ( text, "sbs_math_key" )  
            if userData == nameField.text then
                currentID = row.id
                composer.gotoScene( "menu" , options)
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