/** Shader **/
//Normal MAME GLSL Uniforms
#pragma optimize (on)
#pragma debug (off)

#define TEX2D(v)    texture2D(mpass_texture,(v)).rgb
uniform sampler2D mpass_texture;

uniform vec2      color_texture_sz;         // size of color_texture
uniform vec2      color_texture_pow2_sz;    // size of color texture rounded up to power of 2

void main() {
    float x = 0.5 * (1.0 / color_texture_pow2_sz.x);
    float y = 0.5 * (1.0 / color_texture_pow2_sz.y);
    vec2 dg1 = vec2( x, y);
    vec2 dg2 = vec2(-x, y);
    vec2 dx = vec2(x, 0.0);
    vec2 dy = vec2(0.0, y);

    gl_Position = ftransform();
    gl_TexCoord[0] = gl_MultiTexCoord0;
    gl_TexCoord[1].xy = gl_TexCoord[0].xy - dg1;
    gl_TexCoord[1].zw = gl_TexCoord[0].xy - dy;
    gl_TexCoord[2].xy = gl_TexCoord[0].xy - dg2;
    gl_TexCoord[2].zw = gl_TexCoord[0].xy + dx;
    gl_TexCoord[3].xy = gl_TexCoord[0].xy + dg1;
    gl_TexCoord[3].zw = gl_TexCoord[0].xy + dy;
    gl_TexCoord[4].xy = gl_TexCoord[0].xy + dg2;
    gl_TexCoord[4].zw = gl_TexCoord[0].xy - dx;
}