/** Shader **/
void main()
{
    // transform the texture coordinates
    gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
    // Do the standard vertex processing.
    gl_Position     = ftransform();
}


