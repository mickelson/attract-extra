//
// PUBLIC DOMAIN CRT STYLED SCAN-LINE SHADER
//
//   by Timothy Lottes
//
// This is more along the style of a really good CGA arcade monitor.
// With RGB inputs instead of NTSC.
// The shadow mask example has the mask rotated 90 degrees for less chromatic aberration.
//
// Converted to MAME and AttractMode FE by Luke-Nukem (admin@garagearcades.co.nz)
//  http://www.garagearcades.co.nz
//
//Comment these out to disable the corresponding effect.
#define CURVATURE // CRT Screen Shape
#define YUV // Saturation and Tint
#define GAMMA_CONTRAST_BOOST //Expands contrast and makes image brighter but causes clipping.
//#define ORIGINAL_SCANLINES //Enable to use the original scanlines.
#define ORIGINAL_HARDPIX //Enable to use the original hardPix calculation.  But systems rendered in lower res textures will be much blurrier than systems in higher resolution textures (compare NES and TG16...)

#pragma optimize (on)
#pragma debug (off)

// FOR CRT GEOM
#define FIX(c) max(abs(c), 1e-5);
#define TEX2D(c) texture2D(mpass_texture, (c)).rgb
varying vec2 texCoord;
varying float distortion;
varying float cornersize;
varying float cornersmooth;

//Normal MAME GLSL Uniforms
uniform sampler2D mpass_texture;
uniform vec2      color_texture_sz;         // size of color_texture
uniform vec2      color_texture_pow2_sz;    // size of color texture rounded up to power of 2

// Filter Variables
varying float hardScan;
varying float maskDark;
varying float maskLight;
varying float hardPix;
// YUV Variables
varying float saturation;
varying float tint;
// GAMMA Variables
varying float blackClip;
varying float brightMult;
const vec3 gammaBoost = vec3(1.0/1.2, 1.0/1.2, 1.0/1.2);//An extra per channel gamma adjustment applied at the end.

//Here are the Tint/Saturation/GammaContrastBoost Variables.  Comment out "#define YUV" and "#define GAMMA_CONTRAST_BOOST" to disable these altogether.
const float PI = 3.1415926535;
float U = cos(tint*PI/180.0);
float W = sin(tint*PI/180.0);
vec3  YUVr=vec3( 0.701 * saturation * U + 0.16774 * saturation * W + 0.299,0.587 - 0.32931 * saturation * W - 0.587 * saturation * U, -0.497 * saturation * W - 0.114 * saturation * U + 0.114);
vec3  YUVg=vec3(-0.3281* saturation * W - 0.299 * saturation * U + 0.299,0.413 * saturation * U + 0.03547 * saturation * W + 0.587, 0.114 + 0.29265 * saturation * W - 0.114 * saturation * U);
vec3  YUVb=vec3( 0.299 + 1.24955 * saturation * W - 0.299 * saturation * U, -1.04634 * saturation * W - 0.587 * saturation * U + 0.587, 0.886 * saturation * U - 0.20321 * saturation * W + 0.114);

// sRGB to Linear.
// Assuing using sRGB typed textures this should not be needed.
float ToLinear1(float c)
{
    return(c <= 0.04045) ? c / 12.92 : pow((c+0.055) / 1.055,2.4);
}
vec3 ToLinear(vec3 c)
{
    return vec3( ToLinear1(c.r), ToLinear1(c.g), ToLinear1(c.b) );
}

// Linear to sRGB.
// Assuing using sRGB typed textures this should not be needed.
float ToSrgb1(float c)
{
    return( c < 0.0031308 ? c * 12.92 : 1.055 * pow(c,0.41666) - 0.055);
}
vec3 ToSrgb(vec3 c)
{
    return vec3(ToSrgb1(c.r), ToSrgb1(c.g), ToSrgb1(c.b));
}

// Nearest emulated sample given floating point position and texel offset.
// Also zero's off screen.
vec3 Fetch(vec2 pos, vec2 off)
{
  pos = (floor(pos * color_texture_pow2_sz + off) + 0.5) / color_texture_pow2_sz;
  //if(max(abs(pos.x-0.5),abs(pos.y-0.5))>0.5)return vec3(0.0,0.0,0.0);
  return ToLinear(texture2D(mpass_texture, pos.xy).rgb);
}

// Distance in emulated pixels to nearest texel.
vec2 Dist(vec2 pos)
{
    pos = pos * color_texture_pow2_sz;
    return -((pos - floor(pos)) - vec2(0.5));
}
    
// 1D Gaussian.
float Gaus(float pos,float scale)
{
    return exp2(scale * pos * pos);
}

// 3-tap Gaussian filter along horz line.
vec3 Horz3(vec2 pos,float off)
{
  vec3 b = Fetch(pos, vec2(-1.0, off));
  vec3 c = Fetch(pos, vec2( 0.0, off));
  vec3 d = Fetch(pos, vec2( 1.0, off));
  float dst = Dist(pos).x;
  // Convert distance to weight.
#ifdef ORIGINAL_HARDPIX
  float scale = hardPix;
#else
  float scale = hardPix * max(0.0, 2.0 - color_texture_sz.x / 512.0);//Modified to keep sharpness somewhat comparable across drivers.
#endif
  float wb = Gaus(dst - 1.0, scale);
  float wc = Gaus(dst + 0.0, scale);
  float wd = Gaus(dst + 1.0, scale);
  // Return filtered sample.
  return (b * wb + c * wc + d * wd) / (wb + wc + wd);}

// 5-tap Gaussian filter along horz line.
vec3 Horz5(vec2 pos,float off)
{
  vec3 a = Fetch(pos, vec2(-2.0, off));
  vec3 b = Fetch(pos, vec2(-1.0, off));
  vec3 c = Fetch(pos, vec2( 0.0, off));
  vec3 d = Fetch(pos, vec2( 1.0, off));
  vec3 e = Fetch(pos, vec2( 2.0, off));
  float dst = Dist(pos).x;
  // Convert distance to weight.
#ifdef ORIGINAL_HARDPIX
  float scale = hardPix;
#else
  float scale = hardPix * max(0.0, 2.0 - color_texture_sz.x / 512.0);//Modified to keep sharpness somewhat comparable across drivers.
#endif
  float wa = Gaus(dst - 2.0, scale);
  float wb = Gaus(dst - 1.0, scale);
  float wc = Gaus(dst + 0.0, scale);
  float wd = Gaus(dst + 1.0, scale);
  float we = Gaus(dst + 2.0, scale);
  // Return filtered sample.
  return (a * wa + b * wb + c * wc + d * wd + e * we) / (wa + wb + wc + wd + we);
}

// Return scanline weight.
float Scan(vec2 pos,float off)
{
  float dst = Dist(pos).y;
  vec3 col = Fetch(pos,vec2(0.0));
#ifdef ORIGINAL_SCANLINES
  return Gaus(dst + off, hardScan);
}
#else
  return Gaus( dst + off, hardScan / (dot(col, col) * 0.1667 + 1.0) );
} //Modified to make scanline respond to pixel brightness
#endif

// Allow nearest three lines to effect pixel.
vec3 Tri(vec2 pos)
{
  vec3 a = Horz3(pos, -1.0);
  vec3 b = Horz5(pos, 0.0);
  vec3 c = Horz3(pos, 1.0);
  float wa = Scan(pos, -1.0);
  float wb = Scan(pos, 0.0);
  float wc = Scan(pos, 1.0);
  return a * wa + b * wb + c * wc;
}
	
// Shadow mask.
vec3 Mask(vec2 pos)
{
  pos.x += pos.y * 3.0;
  vec3 mask = vec3(maskDark);
  pos.x = fract(pos.x / 6.0);
  if (pos.x < 0.333)
      mask.r = maskLight;
  else if (pos.x < 0.666)
      mask.g = maskLight;
  else 
      mask.b = maskLight;
  return mask;
}    
///////////////////////////////////////////////////////////////
/// CRT GEOM FUNCTIONS ///
// GIVES THE CURVE
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
///////////////////////////////////////////////////////////////
void main(void)
{
#ifdef CURVATURE
  vec2 pos = radialDistortion(texCoord);//CURVATURE
  //FINAL//
  gl_FragColor.rgb = Tri(pos) * Mask(gl_FragCoord.xy) * vec3(corner(pos));
#else
  vec2 pos = gl_TexCoord[0].xy;
  gl_FragColor.rgb = Tri(pos) * Mask(gl_FragCoord.xy);
#endif
  
#ifdef YUV
  gl_FragColor.rgb = vec3(dot(YUVr,gl_FragColor.rgb), dot(YUVg,gl_FragColor.rgb), dot(YUVb,gl_FragColor.rgb));
  gl_FragColor.rgb = clamp(ToSrgb(gl_FragColor.rgb), 0.0, 1.0);
#endif
  
#ifdef GAMMA_CONTRAST_BOOST
  gl_FragColor.rgb=brightMult*pow(gl_FragColor.rgb,gammaBoost )-vec3(blackClip);
#endif
}
