/** shader **/
uniform sampler2D     mpass_texture;
uniform vec2          screen_texture_pow2_sz;
uniform vec2          color_texture_pow2_sz; // pow2 tex size
uniform vec2          screen_texture_sz;
uniform vec2          color_texture_sz;
 
#define TEX2D(c) texture2D(mpass_texture,(c))
#define PI 3.141592653589
 
void main()
{
        vec2 xy = gl_TexCoord[0].st;
 
        vec2 screen_pos = xy * screen_texture_pow2_sz;
        vec2 tex_pos = xy * screen_texture_pow2_sz /screen_texture_sz*color_texture_sz;
        float line_y = floor(tex_pos.y) * screen_texture_sz.y/color_texture_sz.y;
        float line_y2 = ceil(tex_pos.y) * screen_texture_sz.y/color_texture_sz.y;
        float x1 = screen_pos.y - line_y;
        float x2 = line_y2 - screen_pos.y;
 
        xy = xy + vec2(0.0,0.5)*screen_texture_sz/color_texture_sz/screen_texture_pow2_sz;
 
        if (x1 < 1.0)
          gl_FragColor = TEX2D(xy) * pow(1.0 - x1, 1.0 / 2.2);
        else if(x2 < 1.0)
          gl_FragColor = TEX2D(xy) * pow(1.0 - x2, 1.0 /2.2);
        else
          gl_FragColor = vec4(0.0);
 
}