/** shader**/
#pragma optimize (on)
#pragma debug (off)

#define TEX2D(v) texture2D(mpass_texture, (v) )

//Normal MAME GLSL Uniforms
uniform sampler2D mpass_texture;

// Filter Variables
float maskDark = 0.4; //Sets how dark a "dark subpixel" is in the aperture pattern.
float maskLight = 1.8; //Sets how dark a "bright subpixel" is in the aperture pattern
float aperature_type = 1.0;

//------------------------------------------------------------------------
vec3 Mask(vec2 pos)
{
    // Very compressed TV style shadow mask.
    if (aperature_type == 1.0)
    {
        float line = maskLight;
        float odd = 0.0;
        if (fract(pos.x / 6.0) < 0.5)
            odd = 1.0;
        if (fract((pos.y+odd) / 2.0) < 0.5)
            line = maskDark;  
        pos.x = fract(pos.x / 3.0);
        vec3 mask = vec3(maskDark, maskDark, maskDark);
        if (pos.x < 0.333)
            mask.r = maskLight;
        else if (pos.x<0.666)
            mask.g = maskLight;
        else 
            mask.b = maskLight;
        mask *= line;
        return mask;
    }
    // Aperture-grille.
    else if (aperature_type == 2.0)
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
    // VGA style shadow mask.
    else
    {
        pos.xy = floor(pos.xy * vec2(1.0, 0.5));
        pos.x += pos.y * 3.0;
        vec3 mask = vec3(maskDark, maskDark, maskDark);
        pos.x = fract(pos.x / 6.0);
        if (pos.x<0.333)
            mask.r = maskLight;
        else if (pos.x < 0.666)
            mask.g = maskLight;
        else 
            mask.b = maskLight;
        return mask;
    }
}

// Entry.
void main(void)
{
    gl_FragColor.rgb = TEX2D(gl_TexCoord[0].xy) * Mask(gl_FragCoord.xy);
}