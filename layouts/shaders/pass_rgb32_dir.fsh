/** Shader **/
#pragma optimize (on)
#pragma debug (off)


uniform vec2      screen_texture_sz;      // screen texture size
uniform vec2      screen_texture_pow2_sz; // screen texture pow2 size

uniform vec2	  color_texture_sz;       // mame-bmp tex size
uniform vec2	  color_texture_pow2_sz;  // mame-bmp pow2 tex size

uniform sampler2D mpass_texture;
void main(void)
{
	gl_FragColor = texture2D(mpass_texture, gl_TexCoord[0].st);
}