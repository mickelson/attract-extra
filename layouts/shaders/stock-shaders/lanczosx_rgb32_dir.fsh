uniform sampler2D     mpass_texture;
uniform sampler2D     color_texture;
uniform vec2          color_texture_pow2_sz; // pow2 tex size
uniform vec4          vid_attributes;        // gamma, contrast, brightness
 
#define TEX2D(c) texture2D(mpass_texture,(c))
#define PI 3.141592653589
 
void main()
{
        vec2 xy = gl_TexCoord[0].st;
 
        vec2 uv_ratio     = fract(xy*color_texture_pow2_sz);
        vec2 one          = 1.0/color_texture_pow2_sz;
 
        vec4 col, col2;
 
        vec4 coeffs = vec4(1.0 + uv_ratio.x, uv_ratio.x, 1.0 - uv_ratio.x, 2.0 - uv_ratio.x);
        coeffs = (sin(PI * coeffs) * sin(PI * coeffs / 2.0)) / (coeffs * coeffs);
        coeffs = coeffs / (coeffs.x+coeffs.y+coeffs.z+coeffs.w);
 
        col  = clamp(coeffs.x * TEX2D(xy + vec2(-one.x,0.0)) + coeffs.y * TEX2D(xy) + coeffs.z * TEX2D(xy + vec2(one.x, 0.0)) + coeffs.w * TEX2D(xy + vec2(2 * one.x, 0.0)),0.0,1.0);
 
        gl_FragColor = col;
}