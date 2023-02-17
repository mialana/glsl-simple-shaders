#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;
uniform int u_Time;
uniform ivec2 u_Dimensions;

const mat3 horizontal = mat3(3.f, 0.f, -3.f,
                             10.f, 0.f, -10.f,
                             3.f, 0.f, -3.f);

const mat3 vertical = mat3(3.f, 10.f, 3.f,
                           0.f, 0.f, 0.f,
                           -3.f, -10.f, -3.f);

void main()
{
    vec2 pixelUV = 1.f / u_Dimensions;

    vec3 horGrad = vec3(0, 0, 0);
    vec3 vertGrad = vec3(0, 0, 0);

    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            int xDist = i - 1;
            int yDist = j - 1;
            vec2 texCoord = fs_UV + vec2(float(xDist) * pixelUV.x, float(yDist) * pixelUV.y);
            vec3 color = vec3(texture(u_RenderedTexture, texCoord));
            horGrad += horizontal[i][j] * color;
            vertGrad += vertical[i][j] * color;
        }
    }

    float x = distance(horGrad.x, vertGrad.x);
    float y = distance(horGrad.y, vertGrad.y);
    float z = distance(horGrad.z, vertGrad.z);

    color = sqrt((horGrad * horGrad) + (vertGrad * vertGrad));
}
