#define YUV
#define GAMMA_CONTRAST_BOOST
#pragma optimize (on)
#pragma debug (off)

// FOR CRT GEOM
#define FIX(c) max(abs(c), 1e-5);
#define TEX2D(c) texture2D(mpass_texture, (c)).rgb
varying vec2 texCoord;
varying vec2 overscan;
varying vec2 aspect;

varying float d;
varying float R;

varying float cornersize;
varying float cornersmooth;

varying vec3 stretch;
varying vec2 sinangle;
varying vec2 cosangle;

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
varying float bloomAmount;
// YUV Variables
varying float saturation;
varying float tint;
// GAMMA Variables
varying float blackClip;
varying float brightMult;

varying float aperature_type;
varying float bloom_on;

const vec3 gammaBoost = vec3(1.0/1.2, 1.0/1.2, 1.0/1.2);//An extra per channel gamma adjustment applied at the end.

//Here are the Tint/Saturation/GammaContrastBoost Variables.  Comment out "#define YUV" and "#define GAMMA_CONTRAST_BOOST" to disable these altogether.
const float PI = 3.1415926535;
float U = cos(tint*PI/180.0);
float W = sin(tint*PI/180.0);
vec3  YUVr=vec3( 0.701 * saturation * U + 0.16774 * saturation * W + 0.299,0.587 - 0.32931 * saturation * W - 0.587 * saturation * U, -0.497 * saturation * W - 0.114 * saturation * U + 0.114);
vec3  YUVg=vec3(-0.3281* saturation * W - 0.299 * saturation * U + 0.299,0.413 * saturation * U + 0.03547 * saturation * W + 0.587, 0.114 + 0.29265 * saturation * W - 0.114 * saturation * U);
vec3  YUVb=vec3( 0.299 + 1.24955 * saturation * W - 0.299 * saturation * U, -1.04634 * saturation * W - 0.587 * saturation * U + 0.587, 0.886 * saturation * U - 0.20321 * saturation * W + 0.114);

//------------------------------------------------------------------------
// Linear to sRGB.
// Assuing using sRGB typed textures this should not be needed.
float ToSrgb1(float c)
{
    return (c < 0.0031308 ? c * 12.92 : 1.055 * pow(c, 0.41666) - 0.055);
}
vec3 ToSrgb(vec3 c)
{
    return vec3(ToSrgb1(c.r), ToSrgb1(c.g), ToSrgb1(c.b));
}


// sRGB to Linear.
// Assuing using sRGB typed textures this should not be needed.
float ToLinear1(float c)
{
    return (c <= 0.04045) ? c / 12.92 : pow((c+0.055)/1.055,2.4);
}
vec3 ToLinear(vec3 c)
{
    return vec3(ToLinear1(c.r), ToLinear1(c.g), ToLinear1(c.b));
}
// Nearest emulated sample given floating point position and texel offset.
// Also zero's off screen.
vec3 Fetch(vec2 pos, vec2 off)
{
  pos = (floor(pos * color_texture_pow2_sz + off)) / color_texture_pow2_sz;
  return ToLinear(texture2D(mpass_texture, pos.xy).rgb);
}
// Distance in emulated pixels to nearest texel.
vec2 Dist(vec2 pos)
{
    pos = pos * color_texture_pow2_sz;
    return -((pos - floor(pos)) - vec2(0.5));
}
    
// 1D Gaussian.
float Gaus(float pos, float scale)
{
    return exp2(scale * pos * pos);
}

// Return scanline weight.
float preGaus(vec2 pos, float off, float scanf)
{
  float dst = Dist(pos).y;
  return Gaus(dst + off, scanf);
}

// 3-tap Gaussian filter along horz line.
vec3 Horz3(vec2 pos,float off)
{
  vec3 a = Fetch(pos, vec2(-2.0, off));
  vec3 b = Fetch(pos, vec2(-1.0, off));
  vec3 c = Fetch(pos, vec2( 0.0, off));
  vec3 d = Fetch(pos, vec2( 1.0, off));
  vec3 e = Fetch(pos, vec2(-2.0, off));
  float dst = Dist(pos).x;
  // Convert distance to weight.
  float wa = Gaus(dst - 2.0, hardPix);
  float wb = Gaus(dst - 1.0, hardPix);
  float wc = Gaus(dst + 0.0, hardPix);
  float wd = Gaus(dst + 1.0, hardPix);
  float we = Gaus(dst - 2.0, hardPix);
  // Return filtered sample.
  //return (b * wb + c * wc + d * wd);
  return (a*wa+b*wb+c*wc+d*wd+e*we)/(wa+wb+wc+wd+we);
}

// Allow nearest three lines to affect pixel.
vec3 Tri(vec2 pos)
{
  vec3 a = Horz3(pos,-1.0);
  vec3 b = Horz3(pos, 0.0);
  vec3 c = Horz3(pos, 1.0);
  float wa = preGaus(pos, -1.0, hardScan);
  float wb = preGaus(pos,  0.0, hardScan);
  float wc = preGaus(pos,  1.0, hardScan);
  return a*wa+b*wb+c*wc;
}

// Small bloom.
vec3 Bloom(vec2 pos)
{
  vec3 a = Horz3(pos,-2.0);
  vec3 b = Horz3(pos,-1.0);
  vec3 c = Horz3(pos, 0.0);
  vec3 d = Horz3(pos, 1.0);
  vec3 e = Horz3(pos, 2.0);
  float wa = preGaus(pos, -2.0, hardBloomScan);
  float wb = preGaus(pos, -1.0, hardBloomScan);
  float wc = preGaus(pos,  0.0, hardBloomScan);
  float wd = preGaus(pos,  1.0, hardBloomScan);
  float we = preGaus(pos,  2.0, hardBloomScan);
  return a*wa+b*wb+c*wc+d*wd+e*we;}

vec3 Mask(vec2 pos)
{
    // Very compressed TV style shadow mask.
    if (aperature_type == 1.0)
    {
        float line = maskLight;
        float odd = 0.0;
        if (fract(pos.x / 6.0) < 0.5)
            odd = 1.0;
        if (fract((pos.y+odd) / 2.0) < 0.5)
            line = maskDark;  
        pos.x = fract(pos.x / 3.0);
        vec3 mask = vec3(maskDark, maskDark, maskDark);
        if (pos.x < 0.333)
            mask.r = maskLight;
        else if (pos.x<0.666)
            mask.g = maskLight;
        else 
            mask.b = maskLight;
        mask *= line;
        return mask;
    }
    // Aperture-grille.
    else if (aperature_type == 2.0)
    {
        pos.x = fract(pos.x / 3.0);
        vec3 mask = vec3(maskDark, maskDark, maskDark);
        if (pos.x < 0.333)
            mask.r = maskLight;
        else if (pos.x < 0.666)
            mask.g = maskLight;
        else 
            mask.b = maskLight;
        return mask;
    }
    // VGA style shadow mask.
    else
    {
        pos.xy = floor(pos.xy * vec2(1.0, 0.5));
        pos.x += pos.y * 3.0;
        vec3 mask = vec3(maskDark, maskDark, maskDark);
        pos.x = fract(pos.x / 6.0);
        if (pos.x<0.333)
            mask.r = maskLight;
        else if (pos.x < 0.666)
            mask.g = maskLight;
        else 
            mask.b = maskLight;
        return mask;
    }
}

/// CRT GEOMETRY SECTION ///////////////////////////////////////////////
float intersect(vec2 xy)
{
  float A = dot(xy,xy)+d*d;
  float B = 2.0*(R*(dot(xy,sinangle)-d*cosangle.x*cosangle.y)-d*d);
  float C = d*d + 2.0*R*d*cosangle.x*cosangle.y;
  return (-B-sqrt(B*B-4.0*A*C))/(2.0*A);
}

vec2 bkwtrans(vec2 xy)
{
  float c = intersect(xy);
  vec2 point = vec2(c)*xy;
  point -= vec2(-R)*sinangle;
  point /= vec2(R);
  vec2 tang = sinangle/cosangle;
  vec2 poc = point/cosangle;
  float A = dot(tang,tang)+1.0;
  float B = -2.0*dot(poc,tang);
  float C = dot(poc,poc)-1.0;
  float a = (-B+sqrt(B*B-4.0*A*C))/(2.0*A);
  vec2 uv = (point-a*sinangle)/cosangle;
  float r = FIX(R*acos(a));
  return uv*r/sin(r/R);
}

vec2 transform(vec2 coord)
{
  coord *= color_texture_pow2_sz / color_texture_sz;
  coord = (coord-vec2(0.5))*aspect*stretch.z+stretch.xy;
  return (bkwtrans(coord)/overscan/aspect+vec2(0.5)) * color_texture_sz / color_texture_pow2_sz;
}

float corner(vec2 coord)
{
  coord *= color_texture_pow2_sz / color_texture_sz;
  coord = (coord - vec2(0.5)) * overscan + vec2(0.5);
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
    float cval = corner(pos);
    gl_FragColor.rgb = Tri(pos) * Mask(gl_FragCoord.xy) * vec3(cval);
    if (bloom_on == 1.0){
        gl_FragColor.rgb += Bloom(pos) * bloomAmount;
    }
    
    gl_FragColor.a = 1.0;
    gl_FragColor.rgb = ToSrgb(gl_FragColor.rgb);
#ifdef YUV
    gl_FragColor.rgb = vec3(dot(YUVr,gl_FragColor.rgb), dot(YUVg,gl_FragColor.rgb), dot(YUVb,gl_FragColor.rgb));
    gl_FragColor.rgb = clamp(ToSrgb(gl_FragColor.rgb), 0.0, 1.0);
#endif
#ifdef GAMMA_CONTRAST_BOOST
  gl_FragColor.rgb=brightMult*pow(gl_FragColor.rgb,gammaBoost )-vec3(blackClip);
#endif
}