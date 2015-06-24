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
gameTitleShadow <- fe.add_text( "[Title] ([Year])", 0, fe.layout.height - 73, fe.layout.width, titleSize );
gameTitleShadow.align = Align.Centre;
gameTitleShadow.style = Style.Bold;
gameTitleShadow.set_rgb (0,0,0);
gameTitleShadow.alpha = 80;
gameTitle <- fe.add_text( "[Title] ([Year])", 0, fe.layout.height - 70, fe.layout.width, titleSize );
gameTitle.align = Align.Centre;
gameTitle.style = Style.Bold;
gameTitle.alpha = 90;

fe.add_ticks_callback( "colourCycle" );
	//
local swR = 0;
local swG = 0;
local swB = 0;
local ccRed = 0;
local ccGreen = 0;
local ccBlue = 0;
local rgbTime = 0;

function colourCycle( ttime ) {
	
	if (rgbTime == 0)
		rgbTime = ttime;
////////////// 1000 = 1 second //////////////
	if (ttime - rgbTime > 100){
		if (swR==0){
			if (ccRed < 254)
				ccRed += 1;
			if (ccRed >= 254)
				swR = 1;
		}
		else if (swR==1){
			if (ccRed > 100)
				ccRed  -= 2;
			if (ccRed <= 100)
				swR = 0;
		}
		///////////////////////////
		if (swG==0){
			if (ccGreen < 254)
				ccGreen += 2;
			if (ccGreen >= 254)
				swG = 1;
		}
		else if (swG==1){
			if (ccGreen > 100)
				ccGreen  -= 1;
			if (ccGreen <= 100)
				swG = 0;
		}
		///////////////////////////
		if (swB==0){
			if (ccBlue < 254)
				ccBlue += 1.5;
			if (ccBlue >= 254)
				swG = 1;
		}
		else if (swB==1){
			if (ccBlue > 100)
				ccBlue  -= 1.5;
			if (ccBlue <= 100)
				swG = 0;
		}
		rgbTime = 0;
	}
////////////////////////////////////////////
	romList.set_rgb(ccRed, ccGreen, ccBlue);
	gameTitle.set_rgb(ccRed, ccGreen, ccBlue);
	listPosition.set_rgb(ccRed, ccGreen, ccBlue);	
}

local pinchTime = 0;
local romListPinch = 0;
local swPinch = 0;

fe.add_ticks_callback( "textTickles" );

function textTickles( ttime ) {
	if (pinchTime == 0)
		pinchTime = ttime;
////////////// 1000 = 1 second //////////////
	if (ttime - pinchTime > 50){
		if (swPinch==0){
				romListPinch += 1;
			if (romListPinch >= 25){
				swPinch = 1;
			}
		}
		else 
		if (swPinch==1){
				romListPinch  -= 1;
			if (romListPinch <= 10)
				swPinch = 0;
		}
		pinchTime = 0;
	}
	romListSurf.pinch_x = -(romListPinch);	
}