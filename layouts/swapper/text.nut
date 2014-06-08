// List Title
romListSurf <- fe.add_surface ( fe.layout.width, 100);
romShadow <- romListSurf.add_text( "[ListFilterName]", list_X + 5, 6, fe.layout.width - 2, 82 );
romShadow.align = Align.Centre;
romShadow.style = Style.Bold;
romShadow.set_rgb (0,0,0);
romList <- romListSurf.add_text( "[ListFilterName]", list_X, 5, fe.layout.width - 5, 82 );
romList.align = Align.Centre;
romList.style = Style.Bold;

// List Position
detailShadow <- fe.add_text( "[ListEntry]/[ListSize]", -1, 100, fe.layout.width, 33 );
detailShadow.align = Align.Centre;
detailShadow.style = Style.Bold;
detailShadow.set_rgb (0,0,0);
listPos <- fe.add_text( "[ListEntry]/[ListSize]", 0, 100, fe.layout.width, 32 );
listPos.align = Align.Centre;
listPos.style = Style.Bold;

// Game title block
gameTitleShadow <- fe.add_text( "[Title] ([Year])", title_X, title_Y, fe.layout.width, titleSize );
gameTitleShadow.align = Align.Centre;
gameTitleShadow.style = Style.Bold;
gameTitleShadow.set_rgb (0,0,0);
gameTitle <- fe.add_text( "[Title] ([Year])", (title_X - 2), (title_Y - 2), fe.layout.width, titleSize );
gameTitle.align = Align.Centre;
gameTitle.style = Style.Bold;
