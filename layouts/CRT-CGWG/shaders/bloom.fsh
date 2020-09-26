//
// Bloom shader from http://wp.applesandoranges.eu/?p=14
//
// Modified by Chris Van Graas
//
uniform float     bloom_spread;
uniform float     bloom_power;

uniform sampler2D mpass_texture;

void main()
{
	vec4 sum = vec4(0);
	vec2 texcoord = vec2(gl_TexCoord[0]);
	int j;
	int i;

	for( i= -4 ;i < 4; i++)
	{
		for (j = -3; j < 3; j++)
		{
			sum += gl_Color * texture2D(mpass_texture, texcoord + vec2(j, i) * bloom_spread) * bloom_power;
		}
	}
	if (texture2D(mpass_texture, texcoord).r < 0.3)
	{
		gl_FragColor = sum*sum*0.012 + gl_Color * texture2D(mpass_texture, texcoord);
	}
	else
	{
		if (texture2D(mpass_texture, texcoord).r < 0.5)
		{
			gl_FragColor = sum*sum*0.009 + gl_Color * texture2D(mpass_texture, texcoord);
		}
		else
		{
			gl_FragColor = sum*sum*0.0075 + gl_Color * texture2D(mpass_texture, texcoord);
		}
	}
}
