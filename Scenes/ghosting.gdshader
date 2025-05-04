shader_type spatial;

uniform vec2 dir = vec2(0.0, 0.0);
uniform int quality = 4;
uniform sampler2D albedo_texture;

float insideUnitSquare(vec2 v) {
    vec2 s = step(vec2(0.0), v) - step(vec2(1.0), v);
    return s.x * s.y;   
}

void fragment() {
    vec2 stepSize = dir / float(quality);
    vec2 uv = UV;
    
    float inSquare = insideUnitSquare(uv);
    float numSamples = inSquare;
    vec4 color = texture(albedo_texture, uv) * inSquare;

    for (int i = 1; i <= quality; i++) {
        vec2 offset = stepSize * float(i);
        
        vec2 uv1 = uv + offset;
        inSquare = insideUnitSquare(uv1);
        numSamples += inSquare;
        color += texture(albedo_texture, uv1) * inSquare;

        vec2 uv2 = uv - offset;
        inSquare = insideUnitSquare(uv2);
        numSamples += inSquare;
        color += texture(albedo_texture, uv2) * inSquare;
    }

    ALBEDO = (color.rgb / numSamples);
    ALPHA = color.a / (float(quality) * 2.0 + 1.0);
}
