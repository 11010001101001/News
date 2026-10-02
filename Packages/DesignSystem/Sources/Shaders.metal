#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>

using namespace metal;

float sdRoundedBox(float2 p, float2 b, float r) {
    float2 q = abs(p) - b + r;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

// Value Noise for smooth turbulence
float hash(float2 p) {
    p = fract(p * float2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + float2(0,0)), hash(i + float2(1,0)), f.x),
               mix(hash(i + float2(0,1)), hash(i + float2(1,1)), f.x), f.y);
}

// White Core -> Cyan -> Purple Tail
half3 siriCausticPalette(float progress) {
    half3 pureWhite    = half3(1.0, 1.0, 1.0);
    half3 electricCyan = half3(0.0, 0.78, 1.0);
    half3 neonViolet   = half3(0.68, 0.15, 1.0);

    if (progress < 0.20) {
        return mix(pureWhite, electricCyan, half(progress / 0.20));
    } else {
        return mix(electricCyan, neonViolet, half((progress - 0.20) / 0.80));
    }
}

[[ stitchable ]] half4 liquidGlassLens(
    float2 position,
    SwiftUI::Layer layerToRefract,
    float time,
    float2 size,
    float cornerRadius
) {
    float2 halfSize = size * 0.5;
    float2 p = position - halfSize;

    half4 content = layerToRefract.sample(position);
    float dist = sdRoundedBox(p, halfSize, cornerRadius);

    // 1. Central island (45% of the card width)
    float centerWidth = halfSize.x * 0.45;
    float normX = p.x / centerWidth;

    // A smooth envelope with soft roll-off at the edges of the 45% zone
    float horizEnvelope = smoothstep(1.0, 0.15, abs(normX));

    float bottomY = halfSize.y;
    float heightFromBottom = max(0.0, bottomY - p.y);

    // 2. TRUE PLASMA: Vertical Convection + Domain Warping
    // We are lifting the flow from bottom to top
    float2 flowUV = float2(p.x * 0.03, heightFromBottom * 0.04 - time * 2.5);

    // Layer 1: Space Warping
    float warp = noise(flowUV);

    // Layer 2: Main plasma, accounting for distortion from the first layer
    float2 warpedUV = flowUV * 1.8 + float2(warp * 1.2, -time * 1.8);
    float plasmaNoise = noise(warpedUV);

    // We combine the layers into turbulent tongues
    float flameTurbulence = (warp * 0.4 + plasmaNoise * 0.6) * horizEnvelope;

    // Dynamic tab height (up to 42pt at the peaks)
    float maxFlameHeight = 8.0 + flameTurbulence * 34.0;

    // 3. Attenuation of vortices upwards
    float normHeight = heightFromBottom / maxFlameHeight;
    float fireIntensity = pow(clamp(1.0 - normHeight, 0.0, 1.0), 1.4) * horizEnvelope;

    // 4. Palette rendering and masking
    half3 flameColor = siriCausticPalette(clamp(normHeight, 0.0, 1.0));
    float cardMask = step(dist, 0.0);

    float alpha = fireIntensity * cardMask;

    // Saturated additive glow
    half3 finalColor = content.rgb + flameColor * half(alpha * 2.1);

    return half4(finalColor, max(content.a, half(alpha)));
}
