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
out vec2 fs_UV;
out vec4 fs_LightVec;

void main()
{
    // TODO Homework 4
    fs_UV = vs_UV;
    fs_Nor = normalize(u_ModelInvTr * vec3(vs_Nor));

    vec4 modelposition = u_Model * vs_Pos;

//    float t = cos(float(u_Time) * 0.1f);
//    t *= length(modelposition.xz) * 0.25;

    float minY = -0.5;
    float maxY = 0.5;
    float stripY1 = sin(u_Time * 0.01f) * 5.f;
    float stripY2 = -sin(u_Time * 0.01f) * 5.f;

    float A1 = minY + stripY1;
    float A2 = minY + stripY2;
    float B1 = maxY + stripY1;
    float B2 = maxY + stripY2;

    if (modelposition.y > A1 && modelposition.y < B1 ||
        modelposition.y > A2 && modelposition.y < B2) {
        float t = 0.1f * (-modelposition.y + 5.f) + 1.f;
        modelposition.x *= t;
        modelposition.z *= t;
    }

    fs_LightVec = vec4(u_EyePos, 1) - modelposition;

//    vec4 modelposition = u_Model * vs_Pos;
//    float t = (sin(float(u_Time) * 0.05f) + 1.f) * 0.5f;

//    vec4 normalized = normalize(modelposition);

//    modelposition.x = mix(modelposition.x, normalized.x, t);
//    modelposition.y = mix(modelposition.y, normalized.y, t);
//    modelposition.z = mix(modelposition.z, normalized.z, t);


//    fs_Pos = vec3(modelposition);

    gl_Position = u_Proj * u_View * modelposition;
}
