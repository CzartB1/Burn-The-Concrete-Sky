shader_type spatial;
render_mode unshaded;

uniform vec3 albedo : source_color;
uniform sampler2D albedo_texture;
uniform vec2 scroll_direction = vec2(1.0, 0.0);
uniform float scroll_speed : hint_range(0.0, 10.0) = 0.5;

void fragment() {
    // Calculate the UV offset over time.
    vec2 offset = scroll_direction * scroll_speed * TIME;
    vec2 uv = fract(UV + offset);
    
    // Snap the UV coordinates to the texture's pixel grid to remove blurriness.
    vec2 tex_size = vec2(textureSize(albedo_texture, 0));
    uv = floor(uv * tex_size) / tex_size;
    ALBEDO = texture(albedo_texture, uv).rgb*albedo;
}
