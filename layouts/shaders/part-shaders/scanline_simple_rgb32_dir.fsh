//http://glsl.heroku.com/e#15689.0
#pragma optimize (on)
#pragma debug (off)
#define TEX2D(v) texture2D(mpass_texture, (v) )

//Normal MAME GLSL Uniforms
uniform sampler2D mpass_texture;
uniform vec2      screen_texture_pow2_sz; // pow2 tex size

// Increasing line_bright will make bright lines
// gradient brighter towards the bottom.
uniform float line_bright = 3.0;
// Increasing dark_width will make the dark lines wider
uniform float dark_width = 2.0;
// Decreasing both the above amount will increase the line count
// Decreasing bright_overall less than 1.0 make scanlines darker
// increasing makes them brighter. 1.0 = normal
uniform float bright_overall = 1.0;

void main()
{
    vec4 pixel = texture2D(mpass_texture, gl_TexCoord[0].xy);
    // Smooth stepping between the values 1.0 and line_bright, with increment = to modulus.
    gl_FragColor = pixel - vec4( smoothstep(0.8, line_bright, mod(gl_FragCoord.y, dark_width) ) / bright_overall );
}