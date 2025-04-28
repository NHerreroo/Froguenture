shader_type spatial;

uniform sampler2D albedo_texture : source_color;
uniform vec4 flash_color : source_color;
uniform float flash_value : hint_range(0.0, 1.0);

void fragment() {
    vec4 tex_color = texture(albedo_texture, UV);
    vec4 final_color = mix(tex_color, flash_color, flash_value);

    ALBEDO = final_color.rgb;
    ALPHA = tex_color.a;
}
