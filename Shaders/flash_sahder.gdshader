shader_type spatial;
render_mode blend_mix, depth_prepass_alpha, cull_back;

uniform sampler2D albedo_texture : source_color;
uniform vec4 flash_color : source_color;
uniform float flash_value : hint_range(0.0, 1.0);
uniform float alpha_threshold : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 tex_color = texture(albedo_texture, UV);
    
    // Alpha discard
    ALPHA_SCISSOR_THRESHOLD = alpha_threshold;
    
    vec4 final_color = mix(tex_color, flash_color, flash_value);
    ALBEDO = final_color.rgb;
    EMISSION = flash_color.rgb * flash_value;
    ALPHA = tex_color.a;
}