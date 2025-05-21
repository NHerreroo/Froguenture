shader_type canvas_item;
render_mode unshaded;

uniform float outline_width : hint_range(0, 10) = 2.0;
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 0.5);

void fragment() {
    // Primero muestreamos la textura original
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Calculamos el glow basado en el alpha de la textura
    float glow = tex_color.a;
    
    // Aplicamos un blur aproximado muestreando los píxeles vecinos
    float glow_amount = 0.0;
    const int samples = 8;
    const float step = 0.01;
    
    for (int i = 0; i < samples; i++) {
        float angle = (float(i) / float(samples)) * 6.28;
        vec2 offset = vec2(cos(angle), sin(angle)) * outline_width * step;
        glow_amount += texture(TEXTURE, UV + offset).a;
    }
    glow_amount /= float(samples);
    
    // Mezclamos el glow con el color original
    COLOR = mix(tex_color, color, glow_amount * color.a);
    COLOR.a = max(tex_color.a, glow_amount * color.a);
}