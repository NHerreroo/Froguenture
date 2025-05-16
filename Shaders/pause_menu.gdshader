shader_type canvas_item;

// Textura de pantalla para capturar lo que hay detrás
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Parámetros ajustables
uniform float blur_amount : hint_range(0.0, 5.0) = 2.0;
uniform float blur_quality : hint_range(1.0, 20.0) = 8.0; // Mayor = mejor calidad pero más costoso
uniform float brightness : hint_range(0.0, 2.0) = 1.0;
uniform float saturation : hint_range(0.0, 2.0) = 1.0;

// Función para el desenfoque gaussiano
vec4 gaussian_blur(sampler2D screen_tex, vec2 uv, float blur, float steps) {
    // Vector para acumular el color
    vec4 color_total = vec4(0.0);
    float weight_total = 0.0;

    // Radio máximo para el blur
    float radius = blur * 0.05;

    // Para un blur de calidad, usamos un patrón circular en lugar de cuadrado
    for (float angle = 0.0; angle < 6.28; angle += 6.28 / steps) {
        for (float dist = 1.0/steps; dist <= 1.0; dist += 1.0/steps) {
            // Calcular desplazamiento para este punto del blur
            vec2 offset = vec2(cos(angle), sin(angle)) * radius * dist;

            // El peso decrece con la distancia del centro
            float weight = 1.0 - dist;

            // Muestrear el color y añadirlo al total
            vec4 sample_color = texture(screen_tex, uv + offset);
            color_total += sample_color * weight;
            weight_total += weight;
        }
    }

    // Normalizar el resultado
    return color_total / weight_total;
}

// Función para ajustar la saturación
vec3 adjust_saturation(vec3 color, float adjustment) {
    // Calculamos la luminancia (gris)
    float luminance = dot(color, vec3(0.299, 0.587, 0.114));
    // Mezclamos entre el color y la luminancia basado en el ajuste
    return mix(vec3(luminance), color, adjustment);
}

void fragment() {
    // Aplicar el desenfoque gaussiano
    vec4 blurred = gaussian_blur(SCREEN_TEXTURE, SCREEN_UV, blur_amount, blur_quality);

    // Ajustar brillo
    blurred.rgb *= brightness;

    // Ajustar saturación
    blurred.rgb = adjust_saturation(blurred.rgb, saturation);

    // Asignar el color resultante
    COLOR = blurred;
}