/** Shader **/
uniform float time;

uniform vec2      screen_texture_sz;      // screen texture size
uniform vec2      screen_texture_pow2_sz; // screen texture pow2 size
uniform vec2      color_texture_sz;         // size of color_texture
uniform vec2      color_texture_pow2_sz;    // size of color texture rounded up to power of 2

void main() {
    vec4 offsetx;
    vec4 offsety;

    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

    offsetx.x = 1.0 / color_texture_sz.x;
    offsetx.y = 0.0;
    offsetx.w = 0.0;
    offsetx.z = 0.0;
    offsety.y = 1.0 / color_texture_sz.y;
    offsety.x = 0.0;
    offsety.w = 0.0;
    offsety.z = 0.0;

    gl_TexCoord[0] = gl_MultiTexCoord0;         //center
    gl_TexCoord[1] = gl_TexCoord[0] - offsetx;  //left
    gl_TexCoord[2] = gl_TexCoord[0] + offsetx;  //right
    gl_TexCoord[3] = gl_TexCoord[0] - offsety;  //top
    gl_TexCoord[4] = gl_TexCoord[0] + offsety;  //bottom
}