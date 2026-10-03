shader_type canvas_item;

void fragment() {
    vec2 uv = UV;
    
    // Red on left, blue on right
    COLOR = vec4(uv.x, 0.0, 1.0 - uv.x, 1.0);
}