shader_type canvas_item;

uniform float alpha_tresh : hint_range(0.0, 1.0, 0.01) = 0.8;
uniform float shrink = 2.0;
uniform float offset_mul = 2.0;
uniform float coff_angle = 0.0;
uniform float coff_mul = 0.5;
uniform float coff_std:hint_range(0.0, 3.0, 0.1) = 0.2;
uniform float amp1 = 0.125;
uniform float freq1 = 4;
uniform float speed1 = 5.0;
uniform float amp2 = 0.125;
uniform float freq2 = 9;
uniform float speed2 = 1.46;
uniform float corner_radius : hint_range(0.0, 0.5, 0.01) = 0.1;
uniform sampler2D cols;
uniform sampler2D base_offset;

void vertex() {
    UV *= shrink;
    UV -= vec2((shrink - 1.0) / 2.0);
}

void fragment() {
    if (COLOR.a <= alpha_tresh) {
        float angle = atan(UV.y - 0.5, UV.x - 0.5);
        if (angle < 0.0) {
            angle += 2.0 * PI;
        }
        float h = amp1 * sin(angle * freq1 + TIME * speed1) + amp2 * sin(angle * freq2 + TIME * speed2);
        h += amp1 + amp2;
        float b_off = texture(base_offset, vec2(1.0 - angle / (2.0 * PI), 0)).r;
        h += b_off * offset_mul;
        float c_diff1 = angle - mod(coff_angle, 2.0 * PI);
        float c_diff = min(min(abs(c_diff1), abs(c_diff1 - 2.0 * PI)), abs(c_diff1 + 2.0 * PI));
        float c_off = exp(-c_diff * c_diff / (2.0 * coff_std * coff_std));
        h += c_off * coff_mul;
        h /= 2.0 * (amp1 + amp2) + offset_mul;

        // Usamos solo distancia euclidiana para esquinas redondeadas
        vec2 centered_uv = UV - vec2(0.5);
        float r = length(centered_uv) * 2.0 / shrink;
        
        // Aplicamos el redondeado en todas las esquinas
        vec2 abs_uv = abs(centered_uv);
        float corner_dist = length(max(abs_uv - vec2(0.5 - corner_radius), vec2(0.0)));
        
        // Mezclamos entre la forma principal y las esquinas redondeadas
        float final_r = min(r, corner_dist * (1.0/corner_radius));

        if (final_r < h) {
            COLOR = texture(cols, vec2(final_r / h));
        } else {
            discard; // Mejor que usar alpha=0 para performance
        }
    }
}