// List Title
romListSurf <- fe.add_surface ( fe.layout.width, 200);
romShadow <- romListSurf.add_text( "[ListFilterName]", 5, 6, fe.layout.width - 2, 82 );
romShadow.align = Align.Centre;
romShadow.style = Style.Bold;
romShadow.set_rgb (0,0,0);
romList <- romListSurf.add_text( "[ListFilterName]", 0, 5, fe.layout.width - 5, 82 );
romList.align = Align.Centre;
romList.style = Style.Bold;

// List Position
listShadow <- romListSurf.add_text( "[ListEntry]/[ListSize]", -1, 100, fe.layout.width, 33 );
listShadow.align = Align.Centre;
listShadow.style = Style.Bold;
listShadow.set_rgb (0,0,0);
listPosition <- romListSurf.add_text( "[ListEntry]/[ListSize]", 0, 100, fe.layout.width, 32 );
listPosition.align = Align.Centre;
listPosition.style = Style.Bold;

// Game title block
gameTitleShadow <- fe.add_text( "[Title] ([Year])", title_X, title_Y, fe.layout.width, titleSize );
gameTitleShadow.align = Align.Centre;
gameTitleShadow.style = Style.Bold;
gameTitleShadow.set_rgb (0,0,0);
gameTitleShadow.alpha = 80;
gameTitle <- fe.add_text( "[Title] ([Year])", (title_X - 2), (title_Y - 2), fe.layout.width, titleSize );
gameTitle.align = Align.Centre;
gameTitle.style = Style.Bold;
gameTitle.alpha = 90;

///////////// function cycleValue /////////////
// This function should be pretty self explanatory;
// cycleValue( ttime, this is the tick time.
// cnV, this keeps track of time passed since last call.
// swV, this keeps track of weather to increment or decrement.
// wkV, this is the value that is passed to the function, worked on and returned.
// minV and maxV are the min/max to decrement or increment up to.
// BY, is the amount to increase or decrease workVakue by.
// speed is the length of time to wait to run again. 500 = half second.
////
// This function does require the table to work correctly.

cycleVTable <-{
	"cnListPinch" : 0,	"swListPinch" : 0,	"wkListPinch" : 0,
	"cnListRed" : 0,	"swListRed" : 0,	"wkListRed" : 0,
	"cnListGreen" : 0,	"swListGreen" : 0,	"wkListGreen" : 0,
	"cnListBlue" : 0,	"swListBlue" : 0,	"wkListBlue" : 0,
}
function cycleValue( ttime, cnV, swV, wkV,
					  minV, maxV, BY, speed ) {
	if (cycleVTable[cnV] == 0)
		cycleVTable[cnV] = ttime;
	if (ttime - cycleVTable[cnV] > speed){
		if (cycleVTable[swV]==0){
			cycleVTable[wkV] += BY;
			if (cycleVTable[wkV] >= maxV)
				cycleVTable[swV] = 1;
		}
		else 
		if (cycleVTable[swV]==1){
			cycleVTable[wkV]  -= BY;
			if (cycleVTable[wkV] <= minV)
				cycleVTable[swV] = 0;
		} 
		cycleVTable[cnV] = 0;
	} 
	return cycleVTable[wkV];	
}

fe.add_ticks_callback( "textTickles" );
function textTickles( ttime ) {		
	//To get a negative, need to use a temporary var and - it.
	local temp = cycleValue(ttime, "cnListPinch", "swListPinch", "wkListPinch", 10, 25, 1, 20);
	romListSurf.pinch_x = -temp;
	local RED = cycleValue(ttime,"cnListRed","swListRed","wkListRed",100,254,1,20);
	local GREEN = cycleValue(ttime,"cnListGreen","swListGreen","wkListGreen",100,254,1.5,20);
	local BLUE = cycleValue(ttime,"cnListBlue","swListBlue","wkListBlue",100,254,2,20);
	romList.set_rgb(RED, GREEN, BLUE);
	gameTitle.set_rgb(RED, GREEN, BLUE);
	listPosition.set_rgb(RED, GREEN, BLUE);
}

