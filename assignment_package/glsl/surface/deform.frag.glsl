#version 330

uniform sampler2D u_Texture; // The texture to be read from by this shader
uniform int u_Time;

in vec3 fs_Pos;
in vec3 fs_Nor;

layout(location = 0) out vec3 out_Col;

float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

float noise(in vec3 p) {
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = vec4(a.x, a.x, a.y, a.y) + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + vec4(a.z, a.z, a.z, a.z);
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}

float fbm(vec3 x) {
        float v = 0.0;
        float a = 0.5;
        vec3 shift = vec3(100);
        for (int i = 0; i < 8; ++i) {
                v += a * noise(x);
                x = x * 2.f + shift;
                a *= 0.5;
        }
        return v;

}

void main()
{
    float diffuseTerm = fbm(fs_Nor);
    diffuseTerm = smoothstep(0.f, 1.f, diffuseTerm);

    float t = sin(u_Time * 0.01f);

    float red1 = 0.5f + 0.5f * cos(2.f * radians(180.f) * (1.f * diffuseTerm + 0.5f));
    float green1 = 0.5f + 0.5f * cos(2.f * radians(180.f) * (1.f * diffuseTerm + 0.7f));
    float blue1 = 0.5f + 0.5f * cos(2.f * radians(180.f) * (1.f * diffuseTerm + 0.9f));

    float red2 = 0.5f + 0.5f * cos(2.f * radians(180.f) * (1.f * diffuseTerm + 0.3f));
    float green2 = 0.5f + 0.5f * cos(2.f * radians(180.f) * (1.f * diffuseTerm + 0.5f));
    float blue2 = 0.5f + 0.5f * cos(2.f * radians(180.f) * (1.f * diffuseTerm + 0.4f));

    float red = mix(red1, red2, t);
    float green = mix(green1, green2, t);
    float blue = mix(blue1, blue2, t);

    // Compute final shaded color
    out_Col = vec3(red, green, blue);
}
