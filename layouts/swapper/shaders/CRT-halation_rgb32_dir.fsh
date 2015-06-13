//
// PUBLIC DOMAIN CRT STYLED SCAN-LINE SHADER
//
//   by Timothy Lottes
//
// This is more along the style of a really good CGA arcade monitor.
// With RGB inputs instead of NTSC.
// The shadow mask example has the mask rotated 90 degrees for less chromatic aberration.
//
// Left it unoptimized to show the theory behind the algorithm.
//
// It is an example what I personally would want as a display option for pixel art games.
// Please take and use, change, or whatever.
//
// Converted to MAME and AttractMode FE by Luke-Nukem (admin@garagearcades.co.nz)
//  http://www.garagearcades.co.nz
//
// APERATURE_TYPE
// 1 = Very compressed TV style shadow mask.
// 2 = Aperture-grille.
// 3 = Stretched VGA style shadow mask (same as prior shaders).
// 4 = VGA style shadow mask.
#define APERATURE_TYPE 2

// FOR CRT GEOM
#define FIX(c) max(abs(c), 1e-5);
#define TEX2D(c) texture2D(mpass_texture, (c)).rgb
varying vec2 texCoord;
varying vec2 aspect;
varying float R;
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
// Bloom Variables
varying float hardBloomScan;
varying float hardBloomPix;
varying float bloomAmount;

//------------------------------------------------------------------------

// sRGB to Linear.
// Assuing using sRGB typed textures this should not be needed.
float ToLinear1(float c){return(c<=0.04045)?c/12.92:pow((c+0.055)/1.055,2.4);}
vec3 ToLinear(vec3 c){return vec3(ToLinear1(c.r),ToLinear1(c.g),ToLinear1(c.b));}

// Linear to sRGB.
// Assuing using sRGB typed textures this should not be needed.
float ToSrgb1(float c){return(c<0.0031308?c*12.92:1.055*pow(c,0.41666)-0.055);}
vec3 ToSrgb(vec3 c){return vec3(ToSrgb1(c.r),ToSrgb1(c.g),ToSrgb1(c.b));}

// Nearest emulated sample given floating point position and texel offset.
// Also zero's off screen.
vec3 Fetch(vec2 pos, vec2 off)
{
  pos = (floor(pos * color_texture_pow2_sz + off) + 0.5) / color_texture_pow2_sz;
  return ToLinear(texture2D(mpass_texture, pos.xy).rgb);
}

// Distance in emulated pixels to nearest texel.
vec2 Dist(vec2 pos){pos=pos*color_texture_pow2_sz;return -((pos-floor(pos))-vec2(0.5));}
    
// 1D Gaussian.
float Gaus(float pos,float scale){return exp2(scale*pos*pos);}

// 3-tap Gaussian filter along horz line.
vec3 Horz3(vec2 pos,float off){
  vec3 b=Fetch(pos,vec2(-1.0,off));
  vec3 c=Fetch(pos,vec2( 0.0,off));
  vec3 d=Fetch(pos,vec2( 1.0,off));
  float dst=Dist(pos).x;
  // Convert distance to weight.
  float scale=hardPix;
  float wb=Gaus(dst-1.0,scale);
  float wc=Gaus(dst+0.0,scale);
  float wd=Gaus(dst+1.0,scale);
  // Return filtered sample.
  return (b*wb+c*wc+d*wd)/(wb+wc+wd);}

// 5-tap Gaussian filter along horz line.
vec3 Horz5(vec2 pos,float off){
  vec3 a=Fetch(pos,vec2(-2.0,off));
  vec3 b=Fetch(pos,vec2(-1.0,off));
  vec3 c=Fetch(pos,vec2( 0.0,off));
  vec3 d=Fetch(pos,vec2( 1.0,off));
  vec3 e=Fetch(pos,vec2( 2.0,off));
  float dst=Dist(pos).x;
  // Convert distance to weight.
  float scale=hardPix;
  float wa=Gaus(dst-2.0,scale);
  float wb=Gaus(dst-1.0,scale);
  float wc=Gaus(dst+0.0,scale);
  float wd=Gaus(dst+1.0,scale);
  float we=Gaus(dst+2.0,scale);
  // Return filtered sample.
  return (a*wa+b*wb+c*wc+d*wd+e*we)/(wa+wb+wc+wd+we);}

// 7-tap Gaussian filter along horz line.
vec3 Horz7(vec2 pos,float off){
  vec3 a=Fetch(pos,vec2(-3.0,off));
  vec3 b=Fetch(pos,vec2(-2.0,off));
  vec3 c=Fetch(pos,vec2(-1.0,off));
  vec3 d=Fetch(pos,vec2( 0.0,off));
  vec3 e=Fetch(pos,vec2( 1.0,off));
  vec3 f=Fetch(pos,vec2( 2.0,off));
  vec3 g=Fetch(pos,vec2( 3.0,off));
  float dst=Dist(pos).x;
  // Convert distance to weight.
  float scale=hardBloomPix;
  float wa=Gaus(dst-3.0,scale);
  float wb=Gaus(dst-2.0,scale);
  float wc=Gaus(dst-1.0,scale);
  float wd=Gaus(dst+0.0,scale);
  float we=Gaus(dst+1.0,scale);
  float wf=Gaus(dst+2.0,scale);
  float wg=Gaus(dst+3.0,scale);
  // Return filtered sample.
  return (a*wa+b*wb+c*wc+d*wd+e*we+f*wf+g*wg)/(wa+wb+wc+wd+we+wf+wg);}

// Return scanline weight.
float Scan(vec2 pos,float off){
  float dst=Dist(pos).y;
  return Gaus(dst+off,hardScan);}

// Return scanline weight for bloom.
float BloomScan(vec2 pos,float off){
  float dst=Dist(pos).y;
  return Gaus(dst+off,hardBloomScan);}

// Allow nearest three lines to effect pixel.
vec3 Tri(vec2 pos){
  vec3 a=Horz3(pos,-1.0);
  vec3 b=Horz5(pos, 0.0);
  vec3 c=Horz3(pos, 1.0);
  float wa=Scan(pos,-1.0);
  float wb=Scan(pos, 0.0);
  float wc=Scan(pos, 1.0);
  return a*wa+b*wb+c*wc;}

// Small bloom.
vec3 Bloom(vec2 pos){
  vec3 a=Horz5(pos,-2.0);
  vec3 b=Horz7(pos,-1.0);
  vec3 c=Horz7(pos, 0.0);
  vec3 d=Horz7(pos, 1.0);
  vec3 e=Horz5(pos, 2.0);
  float wa=BloomScan(pos,-2.0);
  float wb=BloomScan(pos,-1.0);
  float wc=BloomScan(pos, 0.0);
  float wd=BloomScan(pos, 1.0);
  float we=BloomScan(pos, 2.0);
  return a*wa+b*wb+c*wc+d*wd+e*we;}
  
#if APERATURE_TYPE == 1
// Very compressed TV style shadow mask.
vec3 Mask(vec2 pos){
  float line=maskLight;
  float odd=0.0;
  if(fract(pos.x/6.0)<0.5)odd=1.0;
  if(fract((pos.y+odd)/2.0)<0.5)line=maskDark;  
  pos.x=fract(pos.x/3.0);
  vec3 mask=vec3(maskDark,maskDark,maskDark);
  if(pos.x<0.333)mask.r=maskLight;
  else if(pos.x<0.666)mask.g=maskLight;
  else mask.b=maskLight;
  mask*=line;
  return mask;}        
#elif APERATURE_TYPE == 2
// Aperture-grille.
vec3 Mask(vec2 pos){
  pos.x=fract(pos.x/3.0);
  vec3 mask=vec3(maskDark,maskDark,maskDark);
  if(pos.x<0.333)mask.r=maskLight;
  else if(pos.x<0.666)mask.g=maskLight;
  else mask.b=maskLight;
  return mask;}        
#elif APERATURE_TYPE == 3
// Stretched VGA style shadow mask (same as prior shaders).
vec3 Mask(vec2 pos){
  pos.x+=pos.y*3.0;
  vec3 mask=vec3(maskDark,maskDark,maskDark);
  pos.x=fract(pos.x/6.0);
  if(pos.x<0.333)mask.r=maskLight;
  else if(pos.x<0.666)mask.g=maskLight;
  else mask.b=maskLight;
  return mask;}    
#elif APERATURE_TYPE == 4
// VGA style shadow mask.
vec3 Mask(vec2 pos){
  pos.xy=floor(pos.xy*vec2(1.0,0.5));
  pos.x+=pos.y*3.0;
  vec3 mask=vec3(maskDark,maskDark,maskDark);
  pos.x=fract(pos.x/6.0);
  if(pos.x<0.333)mask.r=maskLight;
  else if(pos.x<0.666)mask.g=maskLight;
  else mask.b=maskLight;
  return mask;}    
#endif


// Draw dividing bars.
float Bar(float pos,float bar){pos-=bar;return pos*pos<4.0?0.0:1.0;}

/// CRT GEOMETRY SECTION ///////////////////////////////////////////////
float intersect(vec2 xy)
{
  float A = dot(xy,xy) + 1.0;
  float B = 2.35 * -R;
  float C = 2.0 * R; /// LARGER NUMBER = SMALLER PICTURE 2.2 - 3.0
  return (-B - sqrt(B*B - 4.0 * A * C) ) / (2.0 * A);
}
vec2 bkwtrans(vec2 xy)
{
  float c = intersect(xy);
  vec2 point = vec2(c)*xy;
  point /= vec2(R);
  float a = (-sqrt(5.0)) / (2.0); // SIZE
  float r = FIX(R*acos(a));
  return point*r/sin(r/R);
}
// POSITION
vec2 transform(vec2 coord)
{
  coord *= color_texture_pow2_sz / color_texture_sz;
  coord = (coord-vec2(0.5))*aspect;
  return (bkwtrans(coord)/aspect+vec2(0.5)) * color_texture_sz / color_texture_pow2_sz;
}
float corner(vec2 coord)
{
  coord *= color_texture_pow2_sz / color_texture_sz;
  coord = (coord - vec2(0.5)) + vec2(0.5);
  coord = min(coord, vec2(1.0)-coord) * aspect;
  vec2 cdist = vec2(cornersize);
  coord = (cdist - min(coord,cdist));
  float dist = sqrt(dot(coord,coord));
  return clamp((cdist.x-dist)*cornersmooth,0.0, 1.0);
}
/// CRT GEOMETRY ENDS ///////////////////////////////////////////////

// Entry.
void main(void)
{
    vec2 pos = transform(texCoord); // Curvature
    float cval = corner(pos); // Corners
#if 1
    gl_FragColor.rgb = Tri(pos) * Mask(gl_FragCoord.xy);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, Bloom(pos), bloomAmount) * vec3(cval);
#else
    gl_FragColor.rgb = Tri(pos) * Mask(gl_FragCoord.xy);
    gl_FragColor.rgb += Bloom(pos) * bloomAmount;
    gl_FragColor.rb *= vec3(cval);
#endif
    gl_FragColor.a = 1.0;
    gl_FragColor.rgb = ToSrgb(gl_FragColor.rgb);
}