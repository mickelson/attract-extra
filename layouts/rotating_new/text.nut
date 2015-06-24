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
gameList.charsize = (overlay_horz.height / 18.6);
gameList.set_selbg_rgb( 255, 255, 255 );
gameList.set_sel_rgb( 0, 0, 0 );
gameList.sel_style = Style.Bold;

function textUpdate_Horz()
{
    romListSurf.width = (overlay_horz.width / 2);
    romListSurf.height = (overlay_horz.height / 4.5);
    romListSurf.x = (overlay_horz.x + (overlay_horz.width / 32));
    romListSurf.y = (overlay_horz.y);
    
    gameList.width = (overlay_horz.width / 2.44);
    gameList.height = (overlay_horz.height / 1.36);
    gameList.x = (overlay_horz.x + (overlay_horz.width / 20));
    gameList.y = (overlay_horz.y + (overlay_horz.height / 7.5));
    gameList.charsize = 36;
    
    local left_X = (overlay_horz.x + (overlay_horz.width / 21));
    local left_W = (overlay_horz.width / 2);
    local left_H = (overlay_horz.height / 30);
    local pos1_Y = (overlay_horz.y + (overlay_horz.height / 1.13));
    local pos2_Y = (overlay_horz.y + (overlay_horz.height / 1.08));
    
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
    cat.y = (overlay_horz.y + (overlay_horz.height / 1.04));
    
    local right_X = (overlay_horz.x + (overlay_horz.width / 2));
    local right_W = (overlay_horz.width / 2.2);
    
    listEntry.width = right_W;
    listEntry.height = left_H;
    listEntry.x = right_X;
    listEntry.y = pos1_Y;
    
    filterName.width = right_W;
    filterName.height = left_H;
    filterName.x = right_X;
    filterName.y = pos2_Y;
    
}

function textUpdate_Vert()
{
    romListSurf.width = (overlay_vert.width / 2);
    romListSurf.height = (overlay_vert.height / 4.5);
//     romListSurf.x = (overlay_vert.x + (overlay_vert.width / 32));
    romListSurf.x = (overlay_vert.width + 50);
    romListSurf.y = (overlay_vert.y);
    
    gameList.width = (overlay_vert.width / 3.92);
    gameList.height = (overlay_vert.height / 1.83);
    gameList.x = (overlay_vert.x + (overlay_vert.width / 1.45));
    gameList.y = (overlay_vert.y + (overlay_vert.height / 5.8));
    gameList.charsize = 26;
    
    local left_X = (overlay_vert.x + (overlay_vert.width / 6.7));
    local left_W = (overlay_vert.width / 2);
    local left_H = (overlay_vert.height / 30);
    local pos1_Y = (overlay_vert.y + (overlay_vert.height / 1.23));
    local pos2_Y = (overlay_vert.y + (overlay_vert.height / 1.18));
    local pos3_Y = (overlay_vert.y + (overlay_vert.height / 1.13));
    
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
    cat.y = pos3_Y;
    
    local right_X = (overlay_vert.x + (overlay_vert.width / 2.6));
    local right_W = (overlay_vert.width / 2.2);
    
    listEntry.width = right_W;
    listEntry.height = left_H;
    listEntry.x = right_X;
    listEntry.y = pos2_Y;
    
    filterName.width = right_W;
    filterName.height = left_H;
    filterName.x = right_X;
    filterName.y = pos3_Y;
    
}