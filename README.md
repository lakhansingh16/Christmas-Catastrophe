# Christmas Catastrophe!
#### About the Project

This project is a platformer game built using LOVE2D. Santa is facing some trouble this year as he is stuck in a game level.
We have to navigate him in the levels of the game so that he could go on with his present distributions. 

####Files used in the project
#####Main.lua 

This file contains the main program that uses several other components of the game to the run the game with all of the files.

#####Player.lua

This is the second most important file as it contains all the functionality of the player like movements, application of
physics to make the game look real, animations of the character sprite, damage instances, health and many more.

#####Map.lua

This file imports the maps saved in folder and load it into the game window using an open source library called 
STI(simple tile implemenatation). It loads both the level of the game depending upon the current level of the player which is stored
in the file as a variable.

#####Coin.lua

This file implements the coins in the game using the maps instead of hard coded co-ordinates in the maps. They also handle other 
functionality of coins like contact with player, animation and sound. 

#####Spike.lua

This file implements the spikes which act as obstacles for the player. They have their own functionality like instantiating the 
spikes in the maps, decreasing player health on contact.

#####cube.lua

This file implements the movable solid cubes in the maps that act as physical bodies, so that player might use them as advantage 
to jump higher or avoid landing on spikes. It has functionality like body physics and instantiating them in the maps.

#####gui.lua

This file implements visual information like the coins the player has collected so far in the game and health ponts remaining.

#####sound.lua
 
This file is a small library in itself, where we have lot of functions to implement audios in other files on different instances 
like jumping,  landing on spikes, collecting a coin, and a backgroung sound that is running in loop in a separate channel without
interruption. It has various features including channels, volume, pitch, and looping ability, all for our choice to implement.

#####camera.lua

This file is used to implement a camera that follows the character in the map, so that the becomes better visually.

#####conf.lua

This simple file configures our game to have specific features predefined like the game window dimensions, a console for displaying 
information and title of the game. 
