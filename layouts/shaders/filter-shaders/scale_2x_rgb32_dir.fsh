#pragma optimize (on)
#pragma debug (off)
#define TEX2D(v) texture2D(mpass_texture, (v) )

//Normal MAME GLSL Uniforms
uniform sampler2D mpass_texture;

uniform vec2 color_texture_sz;

void main() {
    vec4 colD, colF, colB, colH, col, tmp;
    vec2 sel;

    col  = texture2DProj(mpass_texture, gl_TexCoord[0]);  //central (can be E0-E3)
    colD = texture2DProj(mpass_texture, gl_TexCoord[1]);  //D (left)
    colF = texture2DProj(mpass_texture, gl_TexCoord[2]);  //F (right)
    colB = texture2DProj(mpass_texture, gl_TexCoord[3]);  //B (top)
    colH = texture2DProj(mpass_texture, gl_TexCoord[4]);  //H (bottom)

    sel = fract(gl_TexCoord[0].xy * color_texture_sz.xy);       //where are we (E0-E3)? 
                                                                //E0 is default
    if(sel.y >= 0.5) { tmp = colB; colB = colH; colH = tmp; }  //E1 (or E3): swap B and H
    if(sel.x >= 0.5) { tmp = colF; colF = colD; colD = tmp; }  //E2 (or E3): swap D and F 

    if(colB == colD && colB != colF && colD != colH) {  //do the Scale2x rule
    col = colD;
    }

    gl_FragColor = col;
}