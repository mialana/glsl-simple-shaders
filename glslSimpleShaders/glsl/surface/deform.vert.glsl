#version 150

uniform mat4 u_Model;
uniform mat3 u_ModelInvTr;
uniform mat4 u_View;
uniform mat4 u_Proj;

uniform int u_Time;

in vec3 u_EyePos;
in vec4 vs_Pos;
in vec4 vs_Nor;
in vec2 vs_UV;

out vec3 fs_Pos;
out vec3 fs_Nor;

void deform(inout vec4 v) {
    float minY = -0.5;
    float maxY = 0.5;
    float stripY1 = sin(u_Time * 0.01f) * 5.f;
    float stripY2 = -sin(u_Time * 0.01f) * 5.f;

    float A1 = minY + stripY1;
    float A2 = minY + stripY2;
    float B1 = maxY + stripY1;
    float B2 = maxY + stripY2;

    if (v.y > A1 && v.y < B1 ||
        v.y > A2 && v.y < B2) {
        float t = 0.1f * (-v.y + 5.f) + 1.f;
        v.x *= t;
        v.z *= t;
    }
}

void main()
{
    // TODO Homework 4
    fs_Nor = normalize(u_ModelInvTr * vec3(vs_Nor));

    vec4 modelposition = u_Model * vs_Pos;

    deform(modelposition);

    fs_Pos = vec3(modelposition);

    gl_Position = u_Proj * u_View * modelposition;
}
