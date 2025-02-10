shader_type fog;

uniform float density = 3.;
uniform sampler2D noise_tex : repeat_enable;
uniform float noise_scale = .5;
uniform float falloff = 3.;

float Noise(vec2 uv){
	return texture(noise_tex, uv).r;
}

void fog(){
	vec2 uv = UVW.xz * noise_scale + vec2(TIME * .2, 0);
	float noise = Noise(uv + Noise(uv));
	DENSITY = mix(1., noise, UVW.y * falloff) * density;
	ALBEDO = vec3(0);
}