//http://glsl.heroku.com/e#15689.0
#pragma optimize (on)
#pragma debug (off)

#define TEX2D(v) texture2D(mpass_texture, (v) )

//Normal MAME GLSL Uniforms
uniform sampler2D mpass_texture;

uniform vec2      screen_texture_pow2_sz; // pow2 tex size
#define lutTex2D(v) pow(texture2D(mpass_texture, (v)),2.2)

void main()
{
    vec2 texCoord = gl_TexCoord[0].xy;
    vec4 sum   = vec4(0.0);

    float wid=1.2;
    float c1 = exp(-1.0/wid/wid);
    float c2 = exp(-4.0/wid/wid);
    float c3 = exp(-9.0/wid/wid);
    float c4 = exp(-16.0/wid/wid);

    sum += TEX2D(texCoord + vec2(0.0,  -4.0)/screen_texture_pow2_sz) * c4;
    sum += TEX2D(texCoord + vec2(0.0,  -3.0)/screen_texture_pow2_sz) * c3;
    sum += TEX2D(texCoord + vec2(0.0,  -2.0)/screen_texture_pow2_sz) * c2;
    sum += TEX2D(texCoord + vec2(0.0,  -1.0)/screen_texture_pow2_sz) * c1;
    sum += TEX2D(texCoord + vec2(0.0,   0.0)/screen_texture_pow2_sz);
    sum += TEX2D(texCoord + vec2(0.0,  +1.0)/screen_texture_pow2_sz) * c1;
    sum += TEX2D(texCoord + vec2(0.0,  +2.0)/screen_texture_pow2_sz) * c2;
    sum += TEX2D(texCoord + vec2(0.0,  +3.0)/screen_texture_pow2_sz) * c3;
    sum += TEX2D(texCoord + vec2(0.0,  +4.0)/screen_texture_pow2_sz) * c4;

    gl_FragColor = pow(sum/(1+2*(c1+c2+c3+c4)),1.0/2.2);
}