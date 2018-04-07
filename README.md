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


  
