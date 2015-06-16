//      4xBR shader
// 
//      Copyright (C) 2011 Hyllian.
// 
//      This program is free software; you can redistribute it and/or modify it
//      under the terms of the GNU General Public License as published by the Free
//      Software Foundation; either version 2 of the License, or (at your option)
//      any later version.
// 
//      This program is distributed in the hope that it will be useful, but
//      WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
//      or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//      for more details.
// 
//      (justification for applying the GPLv2:
//      http://board.byuu.org/viewtopic.php?p=32616#p32616

//Normal MAME GLSL Uniforms
#pragma optimize (on)
#pragma debug (off)

#define TEX2D(v)    texture2D(mpass_texture,(v)).rgb
uniform sampler2D mpass_texture;

uniform vec2      screen_texture_sz;      // screen texture size
uniform vec2      screen_texture_pow2_sz; // screen texture pow2 size
uniform vec2      color_texture_sz;         // size of color_texture
uniform vec2      color_texture_pow2_sz;    // size of color texture rounded up to power of 2

const vec3 dtt = vec3(65536.0, 255.0, 1.0);

float reduce(vec3 color)
{ 
    return dot(color, dtt);
}

void main()
{

    vec2 ps = 1.0 / color_texture_pow2_sz;
    vec2 dx = vec2(ps.x, 0.0);
    vec2 dy = vec2(0.0, ps.y);

    vec2 pixcoord = gl_TexCoord[0].xy/ps;
    vec2 fp	= fract(pixcoord);
    vec2 d11	= gl_TexCoord[0].xy - fp * ps;

    // Reading the texels

    vec3 A = texture2D(mpass_texture, d11-dx-dy).xyz;
    vec3 B = texture2D(mpass_texture, d11   -dy).xyz;
    vec3 C = texture2D(mpass_texture, d11+dx-dy).xyz;
    vec3 D = texture2D(mpass_texture, d11-dx   ).xyz;
    vec3 E = texture2D(mpass_texture, d11      ).xyz;
    vec3 F = texture2D(mpass_texture, d11+dx   ).xyz;
    vec3 G = texture2D(mpass_texture, d11-dx+dy).xyz;
    vec3 H = texture2D(mpass_texture, d11+dy   ).xyz;
    vec3 I = texture2D(mpass_texture, d11+dx+dy).xyz;

    vec3 E0 = E;
    vec3 E1 = E;
    vec3 E2 = E;
    vec3 E3 = E;
    vec3 E4 = E;
    vec3 E5 = E;
    vec3 E6 = E;
    vec3 E7 = E;
    vec3 E8 = E;
    vec3 E9 = E;
    vec3 E10 = E;
    vec3 E11 = E;
    vec3 E12 = E;
    vec3 E13 = E;
    vec3 E14 = E;
    vec3 E15 = E;

    float a = reduce(A);
    float b = reduce(B);
    float c = reduce(C);
    float d = reduce(D);
    float e = reduce(E);
    float f = reduce(F);
    float g = reduce(G);
    float h = reduce(H);
    float i = reduce(I);


    if ((h == f)&&(h != e))
    {
    if (
    ((e == g) && ((i == h) || (e == d)))
    ||
    ((e == c) && ((i == h) || (e == b)))
    )
    {
        E11 = mix(E11, F,  0.5);	
        E14 = E11;
        E15 = F;
    }
    }

    if ((f == b)&&(f != e))
    {
    if (
    ((e == i) && ((f == c) || (e == h)))
    ||
    ((e == a) && ((f == c) || (e == d)))
    )
    {
        E2 = mix(E2, B,  0.5);	
        E7 = E2;
        E3 = B;
    }
    }

    if ((b == d)&&(b != e))
    {
    if (
    ((e == c) && ((b == a) || (e == f)))
    ||
    ((e == g) && ((b == a) || (e == h)))
    )                        
    {
        E1 = mix(E1, D,  0.5);	
        E4 = E1;
        E0 = D;
    }
    }

    if ((d == h)&&(d != e))
    {
    if (
    ((e == a) && ((d == g) || (e == b)))
    ||
    ((e == i) && ((d == g) || (e == f)))
    )
    {
        E8 = mix(E8, H,  0.5);	
        E13 = E8;
        E12 = H;
    }
    }

    vec3 res;

    if (fp.x < 0.25)
    { 
    if (fp.y < 0.25) res = E0;
    else if ((fp.y > 0.25) && (fp.y < 0.50)) res = E4;
    else if ((fp.y > 0.50) && (fp.y < 0.75)) res = E8;
    else res = E12;
    }
    else if ((fp.x > 0.25) && (fp.x < 0.50))
    {
    if (fp.y < 0.25) res = E1;
    else if ((fp.y > 0.25) && (fp.y < 0.50)) res = E5;
    else if ((fp.y > 0.50) && (fp.y < 0.75)) res = E9;
    else res = E13;
    }
    else if ((fp.x > 0.50) && (fp.x < 0.75))
    {
    if (fp.y < 0.25) res = E2;
    else if ((fp.y > 0.25) && (fp.y < 0.50)) res = E6;
    else if ((fp.y > 0.50) && (fp.y < 0.75)) res = E10;
    else res = E14;
    }
    else
    {
    if (fp.y < 0.25) res = E3;
    else if ((fp.y > 0.25) && (fp.y < 0.50)) res = E7;
    else if ((fp.y > 0.50) && (fp.y < 0.75)) res = E11;
    else res = E15;
    }

    gl_FragColor = vec4(res, 1.0); 
}