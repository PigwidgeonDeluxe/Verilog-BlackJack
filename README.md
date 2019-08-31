# Verilog-BlackJack
Verilog implementation of a basic two player game of Blackjack

Details in projectplanningupdates.txt

## a note on drawui.v modules:
  If you wish to use these modules please cite them properly.
  ### drawcharacter module:
      -the general gist of this module to is to take in a x coordinate, y coordinate, colour value, and character value, and use it to draw the given character at the given x,y coordinate with the given colour.
      -it draws each pixel one by one from the hardcoded register values -> looping 2x 1D arrays (one for x and one for y) which go through each x,y coordinate set and pass them to the VGA on each clock cycle

  ### drawui module
      -drawui module would use the above module to draw the proper GUI elements at a x,y coordinate and update those elements. 
      -drawing these UI elements would be done in a loop, beginning with drawing them, and then immediately resetting them afterwards (its simpler than reseting on the beginning of the next loop because then we would require a register for storing previous values)
        - updating would be drawing a UI element in white, and then redrawing in black (ie DRAW_CARD_INFO, and then RESET_CARD_INFO)
      -each case would in theory draw each element of that part of the GUI (NOTE: it may be necessary to split apart the components of a single case so that we dont accidentally set more than one value for x and y per state - depends on how verilog works, dont know)


## CSCB58 Project File: Summer 2017

### Team Member A
-------------
First Name: Jeff	
Last Name: L

### Team Member B
-------------
First Name: Jeff
Last Name: X

## Project Details
---------------
Project Title: Two player blackjack

Project Description:
The game sets two player against each other in five rounds of blackjack, with an automated dealer that responds to the players' commands.
Dealer commands:
	- "stand" (not ask for another card)
	- "hit" (ask for another card in an attempt to get closer to a count of 21, or even hit 21 exactly)
Notable Scenarios:
	- "bust" (if total cards' face value is over 21): the player loses and does not collect points

Ace will represent 1 instead of standard blackjack rules
Each round of black jack would have players being able to choose to stand or hit.
With those options, when the player stands the current sum for the round gets added to your points total
however if the player hits and busts(going over 21) the player would get 0 points
When we draw a card that card is removed from a standard deck (IE there would be only 4 #1s in the deck 4 #2s in the deck...)
Therefore, a round ends when both players decide to stand the round or when that round busts.
After 5 rounds, the person with most points wins!

The plan is to display on a VGA screen:
	- Both players current score
	- The value(1-10,J,Q,K) of the card drawn (Ace will represent 1)
	- The total sum of the cards drawn for the round (34 max)
	- The round number
	- How many cards are in the deck(maybe)

Each round will have participating players choose to stand or hit; after participating players have decided
there will be a key to press that will check what players decided and either draw a card or go to the next round.
Video URL:

Code URL (please upload a copy of this file to your repository at the end of the project as well, it will
serve as a useful resource for future development):
https://github.com/PigwidgeonDeluxe/Verilog-BlackJack

## Proposal
--------

What do you plan to have completed by the end of the first lab session?:

We plan to have finished the backend logic of how the blackjack game operates, such as the selection of the cards, a finite state machine to register 5 rounds,
a scoring system, and a fit resourced "deck" to draw from, and we can test certain elements by displaying them on a HEX display for now.

What do you plan to have completed by the end of the second lab session?:

By this session we hope to be able to display the game onto the VGA screen which includes
	- Both players current score
	- The value(1-10,J,Q,K) of the card drawn
	- The total sum of the cards drawn for the round (34 max)
	- The round number
	- How many cards are in the deck(maybe)

What do you plan to have completed by the end of the third lab session?:

We plan to fix any bugs/glitches and test out the game and make any fine tuning adjustments that can make the user experience better.
What is your backup plan if things don't work out as planned?

Assuming that we can get the back end to work, and if we cannot make the VGA display do what we want
then we will plan to cut some elements from the VGA board and then display the necessary elements such as player score and totals from the HEX display.

If the back end cannot work properly we may have to create a simpler game where players compete against each other with the highest card face value.
What hardware will you need beyond the DE2 board
VGA monitor
## Motivations
-----------
How does this project relate to the material covered in CSCB58?:
This project will demonstrate good usage and understanding of materials taught in class such as adders, registers, and flip-flops, including being able to create a good FSM
that will allows the game to progress smoothly.
Why is this project interesting/cool (for CSCB58 students, and for non CSCB58 students?):
It is interesting because it implements pseudo-randomness to this project and graphics that no one else seems to have done too much of.
Why did you personally choose this project?:
This projects seems to be of optimal difficulty but will be really compelling to complete as it feels like a really fun proeject to 
## Attributions
------------
Provide a complete list of any external resources your project used (attributions should also be included in your
code).  

## Updates
-------

<Example update. Delte this and add your own updates after each lab session>
Week 1: We built the hardware and tested the sensors. The distance sensor we had intended to use didn't work as
expected (wasn't precise enough at further distances, only seems to work accurately within 5-10cm), so instead
we've decided to change the project to use a light sensor instead. Had trouble getting the FSM to work (kept
getting stuck in state 101, took longer to debug than expected), so we may not be able to add the
high score feature, have updated that in the project description as (optional).
