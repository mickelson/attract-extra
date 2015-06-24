/** shader**/
#pragma optimize (on)
#pragma debug (off)

#define TEX2D(v) texture2D(mpass_texture, (v) )

//Normal MAME GLSL Uniforms
uniform sampler2D mpass_texture;

// Filter Variables
float maskDark = 0.4; //Sets how dark a "dark subpixel" is in the aperture pattern.
float maskLight = 1.8; //Sets how dark a "bright subpixel" is in the aperture pattern
//------------------------------------------------------------------------
vec3 Mask(vec2 pos)
{
    pos.x = fract(pos.x / 3.0);
    vec3 mask = vec3(maskDark, maskDark, maskDark);
    if (pos.x < 0.333)
        mask.r = maskLight;
    else if (pos.x < 0.666)
        mask.g = maskLight;
    else 
        mask.b = maskLight;
    return mask;
}
// Entry.
void main(void)
{
    gl_FragColor.rgb = TEX2D(gl_TexCoord[0].xy) * Mask(gl_FragCoord.xy);
}