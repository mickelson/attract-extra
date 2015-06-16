/** Shader **/
#pragma optimize (on)
#pragma debug (off)

varying float distortion;
varying float cornersize;
varying float cornersmooth;

void main()
{
    // transform the texture coordinates
    gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;
    // Do the standard vertex processing.
    gl_Position     = ftransform();
    
    distortion = 0.2;
    cornersize = 0.038;
    cornersmooth = 400.0;
}
