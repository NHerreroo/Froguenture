shader_type spatial;

// Outline color.
uniform vec4 color : source_color = vec4(1.0);
// Outline thickness.
uniform float thickness : hint_range(0.0, 100.0) = 1.0;
// Used to compensate for alpha values.
uniform float tolerance : hint_range(0.0, 0.999) = 0.0;
// If on, will draw at diagonals. Off is mainly for pixel art but you do you.
uniform bool diagonals = true;
// If diagonals are checked, will check for half pixels so it rounds the outline a bit more.
uniform bool rounded = true;

// Declaración de la textura del material.
uniform sampler2D albedo_texture;

// Compensar UV para el contorno.
void vertex() {
    VERTEX = VERTEX * (1.0 + thickness * 0.001);
}

// Verifica si el fragmento está en el borde de la UV.
bool border(vec2 uv) {
    vec2 uvBorder = abs(uv - vec2(0.5));
    return max(step(0.5, uvBorder.x), step(0.5, uvBorder.y)) > 0.0;
}

// Obtiene el alfa del fragmento si no está cerca del borde.
float get_alpha(sampler2D tex, vec2 uv) {
    float res = 0.0;
    if (!border(uv)) {
        res = texture(tex, uv).a;
    }
    return res;
}

// Verifica los píxeles vecinos.
float in_range(vec2 size, sampler2D tex, vec2 uv) {
    float res = 0.0;
    for (float i = -1.0; i < 2.0; i += 2.0) {
        res += get_alpha(tex, uv + vec2(i * size.x, 0.0));
        res += get_alpha(tex, uv + vec2(0.0, i * size.y));
        if (diagonals) {
            for (float j = -1.0; j < 2.0; j += 2.0) {
                res += get_alpha(tex, uv + vec2(i * size.x, j * size.y));
                if (rounded) {
                    res += get_alpha(tex, uv + vec2(i * size.x, j * size.y * 0.5));
                }
            }
        }
    }
    return res;
}

void fragment() {
    if (thickness > 0.0) {
        vec2 uv = UV;
        float edge = thickness * 0.001;

        // Aplica el contorno.
        vec4 newColor = texture(albedo_texture, uv);
        if (newColor.a == 0.0 || border(uv)) {
            float outline = in_range(vec2(edge), albedo_texture, uv);
            vec4 finalColor = step(1.0 - tolerance, outline) * color;
            newColor = finalColor;
        }

        ALBEDO = newColor.rgb;
        ALPHA = newColor.a;
    }
}
