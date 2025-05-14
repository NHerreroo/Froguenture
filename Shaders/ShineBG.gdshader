shader_type canvas_item;

uniform float shine_num = 8;
uniform float rotation_speed = 3;
uniform float light_magnitude = 2;

uniform float filter_distence: hint_range(0, 1) = 1.0;
uniform float filter_magnitude: hint_range(0, 1) = 1.0;
uniform float filter_minv: hint_range(0, 1) = 0.75;
uniform float cut_inner_radius: hint_range(0, 1) = 0.1;

uniform vec4 color : source_color = vec4(1,1,1,1);
uniform sampler2D NOISE : source_color;
uniform sampler2D NOISE2 : source_color;
uniform vec2 NOISE_speed = vec2(0,0);
uniform float NOISE_magnitude: hint_range(0, 1) = 0.0;

void vertex() {}

void fragment() {
	
	float ang = atan((UV.x-0.5)/(UV.y-0.5));

	vec4 mixa = vec4(1,1,1,1);

	vec2 pos = vec2(UV.x + NOISE_speed.x*TIME - floor(UV.x + NOISE_speed.x*TIME),UV.y + NOISE_speed.y*TIME - floor(UV.y + NOISE_speed.y*TIME));

	mixa = smoothstep(0.0,1.0,texture(NOISE, pos).rgba);

	COLOR.rgba = color*vec4(abs(sin(ang*shine_num*0.5 + TIME*rotation_speed)))*(1.0-NOISE_magnitude) + NOISE_magnitude*mixa;

	COLOR.a = ((1.0 - filter_distence*0.5) - distance(UV, vec2(0.5,0.5))*filter_magnitude)*light_magnitude;

	if ((distance(UV, vec2(0.5,0.5)) > 1.0/2.0) || (distance(UV, vec2(0.5,0.5)) < cut_inner_radius) || (COLOR.r < filter_minv) && (COLOR.g < filter_minv) && (COLOR.b < filter_minv)) {

		COLOR.rgba = vec4(0.0);
	}
}