#version 330
#define PI 3.1415926535897932384626433832795

uniform sampler2D u_Texture; // The texture to be read from by this shader

in vec3 fs_Nor;
in vec3 fs_LightVec;

layout(location = 0) out vec3 out_Col;

void main()
{
    float diffuseTerm = dot(normalize(fs_Nor), normalize(fs_LightVec));
    diffuseTerm = clamp(diffuseTerm, 0, 1);

    float red = 0.5f + 0.5f * cos(2.f * radians(180.f) * (1.f * diffuseTerm + 0.8f));
    float green = 0.5f + 0.5f * cos(2.f * radians(180.f) * (1.f * diffuseTerm + 0.9f));
    float blue = 0.5f + 0.5f * cos(2.f * radians(180.f) * (0.5f * diffuseTerm + 0.3f));

    out_Col = vec3(red, green, blue);
}
