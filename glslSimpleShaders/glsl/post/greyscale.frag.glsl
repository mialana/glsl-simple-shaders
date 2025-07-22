#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;

void main()
{
    vec4 diffuseColor = texture(u_RenderedTexture, fs_UV);

    float grey = 0.21 * diffuseColor.x + 0.72 * diffuseColor.y + 0.07 * diffuseColor.z;

    vec2 scale = fs_UV * (1.f - fs_UV);
    float vignette = scale.x * scale.y * 15.f;

    vignette *= grey;

    color = vec3(vignette);
}
