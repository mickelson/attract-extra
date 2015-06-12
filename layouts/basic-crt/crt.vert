/*  CRT shader
 *
 *  Copyright (C) 2010, 2011 cgwg, Themaister and DOLLS
 *
 *  This program is free software; you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License as published by the Free
 *  Software Foundation; either version 2 of the License, or (at your option)
 *  any later version.
 */

uniform vec2 rubyInputSize;
uniform vec2 rubyOutputSize;
uniform vec2 rubyTextureSize;

// Define some calculations that will be used in fragment shader.
varying vec2 texCoord;
varying vec2 one;
varying float mod_factor;

void main()
{
	// Do the standard vertex processing.
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

	// transform the texture coordinates
	gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;

	// forward the vertex color
	gl_FrontColor = gl_Color;

	// Precalculate a bunch of useful values we'll need in the fragment
	// shader.

	// Texture coords.
	texCoord = gl_TexCoord[0].xy;

	// The size of one texel, in texture-coordinates.
	one = 1.0 / rubyTextureSize;

	// Resulting X pixel-coordinate of the pixel we're drawing.
	mod_factor = texCoord.x * rubyTextureSize.x * rubyOutputSize.x / rubyInputSize.x;
}
