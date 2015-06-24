/** Shader **/

varying vec2 texCoord;

void main()
{
    // transform the texture coordinates
    gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
    // Do the standard vertex processing.
    gl_Position     = ftransform();
    // Texture coords.
    texCoord = gl_TexCoord[0].xy;
}