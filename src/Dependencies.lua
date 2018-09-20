--[[
	Library and Object dependencies for the application
]]


--push is a library to display the application at a virtual resolution
push = require 'lib/push'

--class library allows us to create objects for use in our application
Class = require 'lib/class'

--explicitly stating the global constants used in the application
require 'src/constants'


--[[
	Add objects created for the application here
]]

--A basic StateMachine class to transition from one state to another
require 'src/StateMachine'

--Word that is displayed to the user
require 'src/Word'

--Listener which listens to the words read by the user and checks if it is correct
require 'src/Listener'

--Score which keeps the number of correct words read by the user
require 'src/Score'


--each individual state in the game
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/DisplayState'
require 'src/states/ListenState'
require 'src/states/FeedbackState'
require 'src/states/ScoreState'
require 'src/states/HelpState'
