/** Shader **/
#pragma optimize (on)
#pragma debug (off)

#define TEX2D(c) texture2D(mpass_texture, (c)).rgb

uniform sampler2D mpass_texture;
uniform vec2      screen_texture_sz;      // screen texture size
uniform vec2      screen_texture_pow2_sz; // screen texture pow2 size
uniform vec2      color_texture_sz;         // size of color_texture
uniform vec2      color_texture_pow2_sz;    // size of color texture rounded up to power of 2

// Tweak this parameter for more / less distortion
varying float distortion;
varying float cornersize;
varying float cornersmooth;

vec2 radialDistortion(vec2 coord) {
    coord *= color_texture_pow2_sz / color_texture_sz;
    vec2 cc = coord - vec2(0.5);
    float dist = dot(cc, cc) * distortion;
    return (coord + cc * (1.0 + dist) * dist) * color_texture_sz / color_texture_pow2_sz;
}

float corner(vec2 coord)
{
  coord *= color_texture_pow2_sz / color_texture_sz;
  coord = (coord - vec2(0.5)) + vec2(0.5);
  coord = min(coord, vec2(1.0)-coord);
  vec2 cdist = vec2(cornersize);
  coord = (cdist - min(coord,cdist));
  float dist = sqrt(dot(coord,coord));
  return clamp((cdist.x-dist)*cornersmooth,0.0, 1.0);
}

void main(void) {
    vec2 xy = radialDistortion(gl_TexCoord[0].xy);
    float corners = corner(xy);
    
    gl_FragColor = texture2D(mpass_texture, xy );
    gl_FragColor.rgb *= vec3(corners);
}
