//
// Bloom shader from myheroics: http://myheroics.wordpress.com/2008/09/04/glsl-bloom-shader/
//
//Normal MAME GLSL Uniforms
#pragma optimize (on)
#pragma debug (off)

#define TEX2D(v)    texture2D(mpass_texture,(v)).rgb
uniform sampler2D mpass_texture;

void main()
{
    float bloom_spread = 0.003;
    float bloom_power  = 0.35;

    vec2 texCoord = gl_TexCoord[0].xy;
    vec3 sum = vec3(0);
    int j;
    int i;

    for( i= -4 ;i < 4; i++)
    {
        for (j = -4; j < 4; j++)
            {
                sum += TEX2D(texCoord + vec2(j, i) * bloom_spread) * bloom_power;
            }
    }
    if (TEX2D(texCoord).r < 0.3)
    {
        gl_FragColor.rgb = sum*0.012 + TEX2D(texCoord) * TEX2D(texCoord);
    }
    else
    {
        if (TEX2D(texCoord).r < 0.5)
        {
            gl_FragColor.rgb = sum*sum*0.009 + TEX2D(texCoord) * TEX2D(texCoord);
        }
        else
        {
            gl_FragColor.rgb = sum*sum*0.0075 + TEX2D(texCoord) * TEX2D(texCoord);
        }
    }
}
