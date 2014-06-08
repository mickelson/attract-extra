//BlurH.frag

uniform sampler2D screenColorBuffer;
uniform float blurDark; //1.7
const float blurSize = 0.7/256.0;
 
void main(void)
{
   vec2 vTexCoord = gl_TexCoord[0].st;
   vec4 sum = vec4(0.0);
   sum += texture2D(screenColorBuffer, vec2(vTexCoord.x - 4.0*blurSize, vTexCoord.y)) * 0.05;
   sum += texture2D(screenColorBuffer, vec2(vTexCoord.x - 3.0*blurSize, vTexCoord.y)) * 0.09;
   sum += texture2D(screenColorBuffer, vec2(vTexCoord.x - 2.0*blurSize, vTexCoord.y)) * 0.12;
   sum += texture2D(screenColorBuffer, vec2(vTexCoord.x - blurSize, vTexCoord.y)) * 0.15;
   sum += texture2D(screenColorBuffer, vec2(vTexCoord.x, vTexCoord.y)) * 0.16;
   sum += texture2D(screenColorBuffer, vec2(vTexCoord.x + blurSize, vTexCoord.y)) * 0.15;
   sum += texture2D(screenColorBuffer, vec2(vTexCoord.x + 2.0*blurSize, vTexCoord.y)) * 0.12;
   sum += texture2D(screenColorBuffer, vec2(vTexCoord.x + 3.0*blurSize, vTexCoord.y)) * 0.09;
   sum += texture2D(screenColorBuffer, vec2(vTexCoord.x + 4.0*blurSize, vTexCoord.y)) * 0.05;
   gl_FragColor = sum / blurDark;
}