/** Shader **/

#pragma optimize (on)
#pragma debug (off)

uniform sampler2D mpass_texture;
uniform vec2      screen_texture_pow2_sz; // pow2 tex size
//#define TEX2D(v)    texture2D(mpass_texture, (v))

uniform float blurDark = 1.2; //1.7
const float blurSize = 0.1/256.0; // 0.1 = less 0.3 = blurred
 
void main(void)
{
   vec2 texCoord = gl_TexCoord[0].st;
   vec4 sum = vec4(0.0);
   sum += texture2D(mpass_texture, vec2(texCoord.x, texCoord.y - 4.0 * blurSize)) * 0.05;
   sum += texture2D(mpass_texture, vec2(texCoord.x, texCoord.y - 3.0 * blurSize)) * 0.09;
   sum += texture2D(mpass_texture, vec2(texCoord.x, texCoord.y - 2.0 * blurSize)) * 0.12;
   sum += texture2D(mpass_texture, vec2(texCoord.x, texCoord.y -       blurSize)) * 0.15;
   sum += texture2D(mpass_texture, vec2(texCoord.x, texCoord.y                 )) * 0.16;
   sum += texture2D(mpass_texture, vec2(texCoord.x, texCoord.y +       blurSize)) * 0.15;
   sum += texture2D(mpass_texture, vec2(texCoord.x, texCoord.y + 2.0 * blurSize)) * 0.12;
   sum += texture2D(mpass_texture, vec2(texCoord.x, texCoord.y + 3.0 * blurSize)) * 0.09;
   sum += texture2D(mpass_texture, vec2(texCoord.x, texCoord.y + 4.0 * blurSize)) * 0.05;
   gl_FragColor = sum;
}