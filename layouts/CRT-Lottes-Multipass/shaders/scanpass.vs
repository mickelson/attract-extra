#version 130

varying vec2 vTexCoord;

uniform vec2 sourceSize;

void main() {
    // transform the texture coordinates
    gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
    // Do the standard vertex processing.
    gl_Position     = ftransform();
    // Texture coords.
    vTexCoord = gl_TexCoord[0].xy;
}
