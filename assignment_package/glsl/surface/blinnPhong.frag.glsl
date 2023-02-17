#version 330

//This is a fragment shader. If you've opened this file first, please open and read lambert.vert.glsl before reading on.
//Unlike the vertex shader, the fragment shader actually does compute the shading of geometry.
//For every pixel in your program's output screen, the fragment shader is run for every bit of geometry that particular pixel overlaps.
//By implicitly interpolating the position data passed into the fragment shader by the vertex shader, the fragment shader
//can compute what color to apply to its pixel based on things like vertex position, light position, and vertex color.

uniform sampler2D u_Texture; // The texture to be read from by this shader

//These are the interpolated values out of the rasterizer, so you can't know
//their specific values without knowing the vertices that contributed to them
in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec2 fs_UV;

in vec4 fs_CameraPos;
in vec4 fs_Pos;

const float ambientTerm = 0.3;

layout(location = 0) out vec3 out_Col;//This is the final output color that you will see on your screen for the pixel that is currently being processed.

float doLambertShading() {
    float diffuseTerm = dot(normalize(fs_Nor), normalize(fs_LightVec));
    diffuseTerm = clamp(diffuseTerm, 0, 1);

    return diffuseTerm + ambientTerm;
}

void main()
{
    vec4 diffuseColor = texture(u_Texture, fs_UV);

    vec4 avgVec = (normalize(fs_LightVec) + normalize(fs_CameraPos)) / 2;

    float specularIntensity = max(pow(dot(normalize(avgVec), normalize(fs_Nor)), 64.f), 0.f);

    float lightIntensity = doLambertShading() + specularIntensity;

    out_Col = vec3(diffuseColor.rgb * lightIntensity);
}
