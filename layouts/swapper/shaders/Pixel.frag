//http://www.geeks3d.com/20101029/shader-library-pixelation-post-processing-effect-glsl/
uniform sampler2D texture;
uniform float pixelDark; //0.3
void main()
{   
    float rt_w = 480.0;
    float rt_h = 360.0;
    float pixel_w = 4.0;
    float pixel_h = 2.0;
    
    vec2 uv = gl_TexCoord[0].xy;

    vec3 tc = vec3(1.0, 0.0, 0.0);
    float dx = pixel_w*(1./rt_w);
    float dy = pixel_h*(1./rt_h);
    vec2 coord = vec2(dx*floor(uv.x/dx),
                      dy*floor(uv.y/dy));
    tc = texture2D(texture, coord).rgb;
    gl_FragColor = vec4(tc, pixelDark);
}