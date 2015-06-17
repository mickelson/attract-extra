// List Title
// Create a surface to keep the text on.
local romListSurf = fe.add_surface (300, 150);
romList <- romListSurf.add_text( "[ListFilterName]", 2, 2, 280, 50 );
romList.style = Style.Bold;
romList.set_rgb (255,255,255);
// List Position
listPosition <- romListSurf.add_text( "[ListEntry]/[ListSize]", 65, 60, 120, 16 );
listPosition.style = Style.Bold;
listPosition.set_rgb (255,255,255);
///////////////////////////////////////////////////
// Left side:
local title = fe.add_text( "[Title]", 30, 424, 320, 16 );
title.set_rgb( 200, 200, 70 );
title.align = Align.Left;

local year = fe.add_text( "[Year] [Manufacturer]", 30, 441, 320, 16 );
year.set_rgb( 200, 200, 70 );
year.align = Align.Left;

local cat = fe.add_text( "[Category]", 30, 458, 320, 16 );
cat.set_rgb( 200, 200, 70 );
cat.align = Align.Left;

///////////////////////////////////////////////////
// Right side
local listEntry = fe.add_text( "[ListEntry]/[ListSize]", 320, 424, 290, 16 );
listEntry.set_rgb( 200, 200, 70 );
listEntry.align = Align.Right;

local filterName = fe.add_text( "[FilterName]", 320, 441, 290, 16 );
filterName.set_rgb( 200, 200, 70 );
filterName.align = Align.Right;

///////////////////////////////////////////////////
local gameList = fe.add_listbox( 32, 64, 262, 352 );
//gameList.charsize = 26;
gameList.charsize = (overlay.height / 18.6);
gameList.set_selbg_rgb( 255, 255, 255 );
gameList.set_sel_rgb( 0, 0, 0 );
gameList.sel_style = Style.Bold;

function textUpdate()
{
    romListSurf.width = (overlay.width / 2);
    romListSurf.height = (overlay.height / 4.5);
    romListSurf.x = (overlay.x + (overlay.width / 32));
    romListSurf.y = (overlay.y);
    
    gameList.width = (overlay.width / 2.44);
    gameList.height = (overlay.height / 1.36);
    gameList.x = (overlay.x + (overlay.width / 20));
    gameList.y = (overlay.y + (overlay.height / 7.5));
    
    local left_X = (overlay.x + (overlay.width / 21));
    local left_W = (overlay.width / 2);
    local left_H = (overlay.height / 30);
    local pos1_Y = (overlay.y + (overlay.height / 1.13));
    local pos2_Y = (overlay.y + (overlay.height / 1.08));
    
    title.width = left_W;
    title.height = left_H;
    title.x = left_X;
    title.y = pos1_Y;
    
    year.width = left_W;
    year.height = left_H;
    year.x = left_X;
    year.y = pos2_Y;

    cat.width = left_W;
    cat.height = left_H;    
    cat.x = left_X;
    cat.y = (overlay.y + (overlay.height / 1.04));
    
    local right_X = (overlay.x + (overlay.width / 2));
    local right_W = (overlay.width / 2.2);
    
    listEntry.width = right_W;
    listEntry.height = left_H;
    listEntry.x = right_X;
    listEntry.y = pos1_Y;
    
    filterName.width = right_W;
    filterName.height = left_H;
    filterName.x = right_X;
    filterName.y = pos2_Y;
    
}