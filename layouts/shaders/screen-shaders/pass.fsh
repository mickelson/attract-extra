/** Shader **/
#pragma optimize (on)
#pragma debug (off)
uniform sampler2D mpass_texture;
uniform vec2      screen_texture_sz;      // screen texture size
uniform vec2      screen_texture_pow2_sz; // screen texture pow2 size
uniform vec2	  color_texture_sz;       // mame-bmp tex size
uniform vec2	  color_texture_pow2_sz;  // mame-bmp pow2 tex size

void main(void)
{
	gl_FragColor.rgb = texture2D(mpass_texture, gl_TexCoord[0].st).rgb;
}