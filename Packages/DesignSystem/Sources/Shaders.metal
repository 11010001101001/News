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

// =============================================================================
// MARK: - ELITE 5 QUANTUM & COSMIC LOADERS
// =============================================================================

// MARK: - Advanced Mathematical Utilities

inline float fastHash(float2 p) {
    p = fract(p * float2(443.897, 441.423));
    p += dot(p, p.yx + 19.19);
    return fract((p.x + p.y) * p.x);
}

inline float fastNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    float2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(fastHash(i + float2(0.0, 0.0)),
                   fastHash(i + float2(1.0, 0.0)), u.x),
               mix(fastHash(i + float2(0.0, 1.0)),
                   fastHash(i + float2(1.0, 1.0)), u.x), u.y);
}

inline float fbm(float2 p) {
    float v = 0.0;
    float a = 0.5;
    float2 shift = float2(100.0);
    float2x2 rot = float2x2(cos(0.5), sin(0.5), -sin(0.5), cos(0.5));
    for (int i = 0; i < 4; ++i) {
        v += a * fastNoise(p);
        p = rot * p * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

inline float3 rotate3DX(float3 p, float a) {
    float c = cos(a), s = sin(a);
    return float3(p.x, p.y * c - p.z * s, p.y * s + p.z * c);
}

inline float3 rotate3DY(float3 p, float a) {
    float c = cos(a), s = sin(a);
    return float3(p.x * c + p.z * s, p.y, -p.x * s + p.z * c);
}

inline float3 rotate3DZ(float3 p, float a) {
    float c = cos(a), s = sin(a);
    return float3(p.x * c - p.y * s, p.x * s + p.y * c, p.z);
}

inline float2 mod2(float2 a, float2 b) {
    return a - b * floor(a / b);
}

inline float4 hexCoords(float2 uv) {
    float2 r = float2(1.0, 1.7320508);
    float2 h = r * 0.5;
    float2 a = mod2(uv, r) - h;
    float2 b = mod2(uv - h, r) - h;
    float2 gv = dot(a, a) < dot(b, b) ? a : b;
    float2 id = uv - gv;
    return float4(gv.x, gv.y, id.x, id.y);
}

inline float hexDist(float2 p) {
    p = abs(p);
    float c = dot(p, normalize(float2(1.0, 1.7320508)));
    return max(c, p.x);
}

inline float distToSegment2D(float2 p, float2 a, float2 b) {
    float2 pa = p - a;
    float2 ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

inline float3 iridescencePalette(float t) {
    return 0.5 + 0.5 * cos(6.2831853 * (float3(1.0, 1.0, 1.0) * t + float3(0.0, 0.33, 0.67)));
}

// MARK: - 1. Cosmic Singularity & Relativistic Event Horizon
[[ stitchable ]] half4 singularityLoader(
    float2 position,
    SwiftUI::Layer layer,
    float time,
    float2 size
) {
    if (size.x <= 0.0 || size.y <= 0.0) return half4(0.0);

    float minDim = min(size.x, size.y);
    float2 uv = (position - 0.5 * size) / minDim;

    float r = length(uv);

    // 1. Relativistic Schwarzschild / Kerr Deflection
    float rs = 0.20;

    // Seamless boiling boundary noise (Cartesian domain, no atan2 branch-cut seam)
    float edgeNoise = fbm(uv * 6.0 + float2(cos(time * 1.4), sin(time * 1.4)) * 0.5);
    float radialMelt = (edgeNoise - 0.5) * 0.07;
    float meltedR = r + radialMelt;

    // 2. Accretion Disk Coordinates with 3D Volumetric Scale Height
    float tiltAngle = 0.38;
    float cosT = cos(tiltAngle);
    float sinT = sin(tiltAngle);
    // Warped disk domain for organic fluid melting
    float2 warpOffset = float2(
        fbm(uv * 3.5 + float2(time * 0.6, -time * 0.4)) - 0.5,
        fbm(uv * 3.5 + float2(-time * 0.5, time * 0.7)) - 0.5
    ) * 0.08;
    float2 warpedUV = uv + warpOffset;

    float2 diskP = float2(warpedUV.x, (warpedUV.y * cosT) / max(0.1, 1.0 - warpedUV.y * sinT * 0.5));
    float diskR = length(diskP);

    // Volumetric scale-height: prevents flat horizontal razor cut, gives soft 3D torus feel
    float scaleHeight = 0.12 + 0.15 * diskR;
    float diskThickness = exp(-pow(diskP.y / scaleHeight, 2.0));

    // Keplerian differential rotation in seamless Cartesian frame (eliminates atan2 seam completely)
    float omega = 2.0 / (pow(diskR + 0.06, 0.75));
    float rotAngle = -omega * time * 1.6;
    float cRot = cos(rotAngle);
    float sRot = sin(rotAngle);
    float2 rotatedP = float2(
        diskP.x * cRot - diskP.y * sRot,
        diskP.x * sRot + diskP.y * cRot
    );

    // Smooth spiral logarithmic winding
    float spiralTwist = 1.4 * log(diskR + 0.05);
    float cSp = cos(spiralTwist);
    float sSp = sin(spiralTwist);
    float2 spiralP = float2(
        rotatedP.x * cSp - rotatedP.y * sSp,
        rotatedP.x * sSp + rotatedP.y * cSp
    );

    // Multi-scale turbulent plasma tendrils
    float turbulence = fbm(spiralP * 5.2 + float2(time * 0.35, -time * 0.25));

    // Outer edge melting: plasma dissolution instead of hard cutoff
    float isco = rs * 1.10;
    float outerRim = 0.70 + (turbulence - 0.5) * 0.18;
    float diskRadialMask = smoothstep(isco, isco + 0.06, diskR) * smoothstep(outerRim, outerRim - 0.42, diskR);
    float diskGas = pow(diskRadialMask * (0.55 + 0.9 * turbulence) * diskThickness, 1.35);

    // Relativistic Doppler Beaming: softened gradient to avoid harsh clipping on the left
    float vDotR = -diskP.x / (diskR + 0.001);
    float dopplerFactor = pow(clamp(1.0 + vDotR * 0.55, 0.35, 2.0), 2.2);

    // Disk color gradients: smoothly blended cyan/azure on left into molten gold/crimson on right
    float3 colBlueShift = float3(0.18, 0.82, 1.0);
    float3 colRedShift = float3(1.0, 0.38, 0.05);
    float blendFactor = smoothstep(-0.8, 0.8, vDotR);
    float3 colDisk = mix(colRedShift, colBlueShift, blendFactor);
    colDisk *= diskGas * dopplerFactor * 2.6;

    // Outer plasma corona melt: soft wisps dissolving into black space
    float coronaFilament = pow(fbm(spiralP * 3.8 - float2(time * 0.6, time * 0.5)), 2.0);
    float3 colCorona = mix(colRedShift, colBlueShift, blendFactor) * coronaFilament * smoothstep(0.4, 0.75, diskR) * smoothstep(0.85, 0.55, diskR) * 0.8;
    colDisk += colCorona;

    // 3. Photon Sphere Einstein Ring (breathing, undulating relativistic ring)
    float photonR = rs * 1.35;
    float ringWarp = (fbm(uv * 8.0 + time * 1.8) - 0.5) * 0.018;
    float photonRing = 0.014 / (abs(meltedR - photonR + ringWarp) + 0.007);
    float3 colPhoton = float3(0.92, 0.96, 1.0) * photonRing * (0.75 + 0.25 * sin(time * 4.5));

    // 4. Relativistic Polar Jets (soft synchrotron core)
    float jetWidth = 0.05 + abs(uv.y) * 0.09;
    float jetDist = abs(uv.x) / jetWidth;
    float jetSwirl = sin(uv.y * 16.0 - time * 5.0);
    float jetCore = exp(-jetDist * 2.2) * smoothstep(0.06, 0.45, abs(uv.y)) * (0.7 + 0.3 * jetSwirl);
    float3 colJet = float3(0.45, 0.12, 1.0) * jetCore * 1.4 + float3(0.05, 0.85, 1.0) * pow(jetCore, 2.8) * 1.8;

    // 5. Relativistic Ejecta Particles: expanded to 32 pulsating spherical embers
    float3 colParticles = float3(0.0);
    const int NUM_PARTICLES = 32;
    for (int i = 0; i < NUM_PARTICLES; i++) {
        float pIdx = float(i);
        float pSeed = fastHash(float2(pIdx * 1.43, 8.17));
        float pSpeed = 0.22 + pSeed * 0.36;
        float pLife = fract(time * pSpeed + pSeed);

        // Outward radial ejection with spiral deflection
        float pDist = rs * 0.92 + pLife * 0.62;
        float pTheta = pSeed * 6.2831853 + time * (0.35 * (pSeed - 0.5)) + pLife * 1.1;
        float2 pCenter = float2(cos(pTheta), sin(pTheta)) * pDist;

        // Spherical SDF
        float dParticle = length(uv - pCenter);

        // Pulsating size & glow
        float pulse = sin(time * 6.5 + pSeed * 30.0) * 0.5 + 0.5;
        float pRadius = 0.005 + 0.006 * pulse;
        float pGlow = (pRadius * 0.042) / (dParticle * dParticle + 0.00018);
        float pAlpha = sin(pLife * 3.14159265);

        // Chromatic variation between stellar white, cyan, and gold
        float3 baseCol = (pSeed > 0.5) ? float3(0.85, 0.96, 1.0) : float3(1.0, 0.92, 0.75);
        float3 pColor = mix(baseCol, float3(1.0, 1.0, 1.0), pulse);
        colParticles += pColor * pGlow * pAlpha;
    }

    // 6. Event Horizon Pure Black Void with relativistic boundary boiling
    float horizonDistort = (noise(uv * 12.0 + float2(time * 1.5, -time * 1.2)) - 0.5) * 0.022;
    float horizonMask = smoothstep(rs + horizonDistort, rs + horizonDistort + 0.02, r);

    // Compose layers with smooth dissolved rim vignette
    float3 finalColor = (colDisk + colPhoton + colJet + colParticles) * horizonMask;
    finalColor *= smoothstep(0.92 + radialMelt, 0.40, r);

    return half4(half3(finalColor), 1.0);
}

// MARK: - 2. Superconducting Quantum Gyroscope & Atomic Orbitals
[[ stitchable ]] half4 quantumOrbitLoader(
    float2 position,
    SwiftUI::Layer layer,
    float time,
    float2 size
) {
    if (size.x <= 0.0 || size.y <= 0.0) return half4(0.0);

    float minDim = min(size.x, size.y);
    float2 uv = (position - 0.5 * size) / minDim;

    float t = time * 1.4;

    // Camera setup in 3D perspective space
    float3 ro = float3(0.0, 0.0, -1.8);
    float3 rd = normalize(float3(uv, 1.25));

    // 3 Harmonic Gyroscopic Quantum Rings Parameters
    const float radii[3] = {0.21, 0.31, 0.41};
    const float tubeRadii[3] = {0.017, 0.019, 0.021};
    const float speeds[3] = {1.0, 1.55, -1.25};
    const float3 ringColors[3] = {
        float3(0.0, 0.92, 1.0),   // Electric Cyan
        float3(0.96, 0.12, 0.82), // High-energy Magenta
        float3(1.0, 0.76, 0.20)   // Superconducting Gold
    };

    // Precalculate rotation angles for each ring
    float3 rotAngles[3];
    rotAngles[0] = float3(t * 0.85, t * 1.30 + 0.40, t * 0.65);
    rotAngles[1] = float3(t * 1.35 + 1.20, t * 0.80 + 2.10, -t * 1.10 + 0.90);
    rotAngles[2] = float3(-t * 0.80 + 2.40, t * 1.45 + 0.80, t * 1.15 + 3.14);

    // Closest approach to central quantum core
    float tCoreCPA = -dot(ro, rd);
    float rCorePerp = length(cross(ro, rd));

    // Raymarching True 3D Volumetric Torus Rings
    float tDist = 0.6;
    float maxDist = 2.6;
    int hitRingIdx = -1;
    float3 hitPoint = float3(0.0);
    float3 hitLocPoint = float3(0.0);
    float3 glowAccum = float3(0.0);

    for (int step = 0; step < 30; ++step) {
        float3 p = ro + rd * tDist;

        // Evaluate SDF for all 3 gyroscopic tori
        float minDist = 100.0;
        int closestIdx = -1;
        float3 closestLoc = float3(0.0);

        for (int i = 0; i < 3; ++i) {
            float3 pLoc = rotate3DZ(rotate3DY(rotate3DX(p, -rotAngles[i].x), -rotAngles[i].y), -rotAngles[i].z);
            float dTube = length(float2(length(pLoc.xz) - radii[i], pLoc.y)) - tubeRadii[i];

            // Volumetric quantum aura around each ring
            glowAccum += ringColors[i] * (0.00030 / (dTube * dTube + 0.0016));

            if (dTube < minDist) {
                minDist = dTube;
                closestIdx = i;
                closestLoc = pLoc;
            }
        }

        if (minDist < 0.0018) {
            hitRingIdx = closestIdx;
            hitPoint = p;
            hitLocPoint = closestLoc;
            break;
        }

        tDist += minDist * 0.88;
        if (tDist > maxDist) break;
    }

    float3 colAccum = glowAccum;

    // Surface shading if a 3D torus was intersected
    if (hitRingIdx >= 0) {
        int i = hitRingIdx;
        float R = radii[i];
        float3 pLoc = hitLocPoint;

        // Exact analytical 3D normal in local torus space
        float xzLen = max(0.0001, length(pLoc.xz));
        float3 spinePoint = float3(pLoc.x / xzLen * R, 0.0, pLoc.z / xzLen * R);
        float3 nLoc = normalize(pLoc - spinePoint);

        // Transform normal to world space
        float3 nWorld = rotate3DX(rotate3DY(rotate3DZ(nLoc, rotAngles[i].z), rotAngles[i].y), rotAngles[i].x);

        float3 V = -rd;
        float NdotV = max(0.0, dot(nWorld, V));

        // Core light (radiating from origin)
        float3 LCore = normalize(-hitPoint);
        float diffCore = max(0.0, dot(nWorld, LCore));
        float3 HCore = normalize(LCore + V);
        float specCore = pow(max(0.0, dot(nWorld, HCore)), 28.0);

        // Front-facing key light (gimbal illumination)
        float3 LKey = normalize(float3(0.35, 0.75, -0.85));
        float diffKey = max(0.0, dot(nWorld, LKey));
        float3 HKey = normalize(LKey + V);
        float specKey = pow(max(0.0, dot(nWorld, HKey)), 36.0);

        // High-tech Fresnel rim glow (volumetric glass/metallic edge)
        float fresnel = pow(1.0 - NdotV, 2.6);

        // Toroidal coordinates for superconducting features
        float phi = atan2(pLoc.z, pLoc.x);
        float theta = atan2(pLoc.y, xzLen - R);

        // Meissner helical winding coils
        float coil = sin(phi * 18.0 + theta * 3.0 - t * speeds[i] * 5.0);
        float coilGlow = pow(max(0.0, coil), 4.0);

        // Relativistic electron wave packet racing along the tube
        float packetPhase = phi - t * speeds[i] * 3.2;
        float packet = pow(max(0.0, cos(packetPhase * 0.5)), 24.0);

        // Material composition
        float3 baseCol = ringColors[i];
        float3 torusCol = baseCol * (0.25 + 0.65 * diffCore + 0.45 * diffKey);
        torusCol += float3(1.0, 1.0, 1.0) * specCore * 1.8;
        torusCol += baseCol * specKey * 1.2;
        torusCol += mix(baseCol, float3(1.0, 1.0, 1.0), 0.5) * fresnel * 1.5;
        torusCol += baseCol * coilGlow * 1.4;
        torusCol += float3(1.0, 1.0, 1.0) * packet * 2.8;

        colAccum += torusCol;
    }

    // Central Quantum Core: Pulsating spherical hydrogen orbital cloud
    float corePulse = sin(t * 5.0) * 0.15 + 0.85;
    float coreNoise = (fbm(uv * 9.0 + float2(cos(t * 1.8), sin(t * 1.8))) - 0.5) * 0.08;
    float rCoreEff = rCorePerp + coreNoise;

    float coreDensity = exp(-rCoreEff * 10.0) * 2.2 * corePulse;
    float coreHotSpot = exp(-rCoreEff * 26.0) * 4.0;
    float3 colCore = float3(0.08, 0.82, 1.0) * coreDensity + float3(1.0, 1.0, 1.0) * coreHotSpot;

    // Natural 3D depth occlusion between central core and foreground torus
    if (hitRingIdx >= 0 && tDist < tCoreCPA) {
        // Torus is IN FRONT of the core: core light behind is partially occluded
        colAccum += colCore * 0.28;
    } else {
        // Torus is BEHIND the core (or ray missed tori): core radiates freely in foreground
        colAccum += colCore;
    }

    // Quantum tunneling micro-arcs
    float arcAngle = atan2(uv.y, uv.x);
    float arcWave = sin(arcAngle * 8.0 - t * 9.0) * cos(rCorePerp * 30.0 + t * 6.0);
    float arcMask = pow(max(0.0, arcWave), 12.0) * smoothstep(0.12, 0.24, rCorePerp) * smoothstep(0.42, 0.28, rCorePerp);
    colAccum += float3(0.65, 0.35, 1.0) * arcMask * 2.2;

    // Outer smooth vignette
    float rScreen = length(uv);
    colAccum *= smoothstep(0.85, 0.42, rScreen);

    return half4(half3(colAccum), 1.0);
}

// MARK: - 3. Cyberpunk Prismatic Hexagonal Matrix
[[ stitchable ]] half4 cyberpunkPrismaLoader(
    float2 position,
    SwiftUI::Layer layer,
    float time,
    float2 size
) {
    if (size.x <= 0.0 || size.y <= 0.0) return half4(0.0);

    float minDim = min(size.x, size.y);
    float2 uv = (position - 0.5 * size) / minDim;

    float t = time * 2.2;
    float r = length(uv);

    // Dynamic rotation & subtle breathing
    float rotA = sin(t * 0.3) * 0.2;
    float cA = cos(rotA), sA = sin(rotA);
    float2 rotUV = float2(uv.x * cA - uv.y * sA, uv.x * sA + uv.y * cA);

    // Digital glitch displacement
    float glitchTrigger = step(0.92, fastHash(float2(floor(t * 8.0), 1.0)));
    float glitchLine = step(0.85, sin(uv.y * 80.0 + t * 20.0)) * glitchTrigger;
    rotUV.x += glitchLine * (fastHash(float2(uv.y, floor(t * 12.0))) - 0.5) * 0.12;

    // Hexagonal tiling
    float scale = 9.0;
    float4 hex = hexCoords(rotUV * scale);
    float2 gv = hex.xy;
    float2 id = hex.zw;

    float dHex = hexDist(gv);
    float hexEdge = abs(dHex - 0.5);

    // Cell hash and state
    float cellId = fastHash(id);
    float cellDist = length(id / scale);

    // Concentric digital energy shockwaves
    float wavePhase = cellDist * 4.5 - t * 3.5 + cellId * 0.5;
    float shockwave = sin(wavePhase);
    float activeCell = smoothstep(0.4, 0.95, shockwave);

    // Wireframe glowing laser borders
    float borderGlow = 0.015 / (hexEdge + 0.02);

    // Prismatic Dispersion (Chromatic Aberration split)
    float dispFactor = 0.035 * (0.8 + 0.4 * sin(t * 2.0));
    float redWave   = sin(wavePhase - dispFactor * 5.0);
    float greenWave = sin(wavePhase);
    float blueWave  = sin(wavePhase + dispFactor * 5.0);

    float3 chromaticPulse = float3(
        smoothstep(0.3, 0.9, redWave),
        smoothstep(0.3, 0.9, greenWave),
        smoothstep(0.3, 0.9, blueWave)
    );

    // Neon Cyberpunk Palette: Laser Cyan, Acid Hot Pink, Digital Gold
    float3 colCyan = float3(0.0, 0.95, 1.0);
    float3 colPink = float3(1.0, 0.05, 0.65);
    float3 colGold = float3(1.0, 0.85, 0.1);

    float3 cellColor = mix(colPink, colCyan, activeCell);
    cellColor += colGold * pow(activeCell, 4.0);

    // Edge laser illumination
    float3 edgeColor = mix(colCyan, colPink, chromaticPulse);
    float3 finalColor = edgeColor * borderGlow * (0.5 + 0.5 * activeCell);

    // Inner hex fill pulse
    float innerFill = smoothstep(0.48, 0.1, dHex) * activeCell * 0.35;
    finalColor += cellColor * innerFill;

    // Central Self-Contained Cybernetic Reactor Hub
    float coreGlow = 0.016 / (r * r + 0.005);
    float coreSingularity = exp(-r * 28.0) * 3.5;

    // Tight micro-hex containment collar hugging the core
    float microHex = hexDist(rotUV * 26.0);
    float containmentRing = smoothstep(0.08, 0.02, abs(microHex - 1.0)) * (0.8 + 0.2 * sin(t * 6.0));

    finalColor += colCyan * coreGlow * 1.3;
    finalColor += float3(1.0, 1.0, 1.0) * coreSingularity;
    finalColor += mix(colPink, colCyan, 0.5 + 0.5 * sin(t * 4.0)) * containmentRing * 1.8;

    // Holographic horizontal scanlines
    float scanline = sin(position.y * 3.14159) * 0.08;
    finalColor -= scanline;

    finalColor *= smoothstep(0.85, 0.45, r);

    return half4(half3(finalColor), 1.0);
}

// MARK: - 4. Magnetospheric Aurora Borealis & Solar Storm
[[ stitchable ]] half4 auroraBorealisLoader(
    float2 position,
    SwiftUI::Layer layer,
    float time,
    float2 size
) {
    if (size.x <= 0.0 || size.y <= 0.0) return half4(0.0);

    float minDim = min(size.x, size.y);
    float2 uv = (position - 0.5 * size) / minDim;

    float t = time * 0.85;

    // 1. Noticeably larger, luminous cosmic stars with stellar diffraction & halos
    float starGrid = 46.0;
    float2 starCell = floor(uv * starGrid);
    float2 starFrac = fract(uv * starGrid) - 0.5;
    float2 starJitter = (float2(fastHash(starCell), fastHash(starCell + float2(13.7, 71.1))) - 0.5) * 0.68;
    float2 starDiff = starFrac - starJitter;
    float dStar = length(starDiff);

    float starDensity = pow(fastHash(starCell + float2(5.1, 9.3)), 16.0);
    float starTwinkle = starDensity * (0.65 + 0.35 * sin(t * 3.2 + fastHash(starCell) * 6.28318));

    // Noticeably larger cores with varied radius for celestial depth
    float starRadius = mix(0.16, 0.30, fastHash(starCell + float2(88.3, 14.2)));
    float starCore = smoothstep(starRadius, 0.0, dStar) * starTwinkle * 3.5;
    float starHalo = exp(-dStar * 7.0) * starTwinkle * 1.4;

    // Subtle 4-point stellar diffraction spike on bright stars
    float spike = (exp(-abs(starDiff.x) * 22.0 - abs(starDiff.y) * 4.0) +
                   exp(-abs(starDiff.y) * 22.0 - abs(starDiff.x) * 4.0)) * starTwinkle * 0.45;

    // Rich star color variety (crisp diamond white-blue and warm stellar amber)
    float colSeed = fastHash(starCell + float2(33.1, 44.2));
    float3 starTint = mix(float3(0.85, 0.94, 1.0), float3(1.0, 0.92, 0.78), step(0.75, colSeed));

    float3 colNight = float3(0.008, 0.015, 0.04) + starTint * (starCore + starHalo + spike);

    // 2. Realistic Falling Meteorite / Shooting Star (Downward Atmospheric Entry)
    float meteorPeriod = 4.0;
    float cycle = floor(time / meteorPeriod);
    float tInCycle = fmod(time, meteorPeriod);
    float duration = 0.85;

    float3 colMeteor = float3(0.0);
    if (tInCycle < duration) {
        float progress = tInCycle / duration;
        float seedX = fastHash(float2(cycle, 11.7));
        float seedY = fastHash(float2(cycle, 23.4));
        float seedDir = fastHash(float2(cycle, 77.1));

        // Start strictly in the upper night sky (-Y is up in SwiftUI coordinates)
        bool fromLeft = (seedDir > 0.5);
        float startX = fromLeft ? (-0.45 + seedX * 0.22) : (0.45 - seedX * 0.22);
        float startY = -0.42 + seedY * 0.16;
        float2 startPos = float2(startX, startY);

        // Natural downward trajectory (+Y is down towards Earth horizon)
        float downwardAngle = 0.48 + seedX * 0.38;
        float dirX = fromLeft ? cos(downwardAngle) : -cos(downwardAngle);
        float dirY = sin(downwardAngle); // Strictly positive = downward fall only!
        float2 dir = normalize(float2(dirX, dirY));

        float travelDist = 0.78;
        float tailLen = 0.34;

        float2 headPos = startPos + dir * (progress * travelDist);
        float2 tailEnd = headPos - dir * tailLen;

        float2 ba = headPos - tailEnd;
        float2 pa = uv - tailEnd;
        float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
        float dSeg = length(pa - ba * h);

        // Atmospheric burn lifecycle envelope
        float lifeEnvelope = sin(progress * 3.14159265);

        // Incandescent ablation head
        float dHead = length(uv - headPos);
        float headCore = exp(-dHead * 55.0) * 3.6 * lifeEnvelope;
        float headHalo = (0.002 / (dHead * dHead + 0.001)) * lifeEnvelope;

        // Ionized plasma trail: dense core filament + glowing ionization bloom
        float tailCore = smoothstep(0.0055, 0.0007, dSeg) * pow(h, 1.1) * 2.8 * lifeEnvelope;
        float tailGlow = (0.0028 / (dSeg + 0.0035)) * pow(h, 1.3) * 1.8 * lifeEnvelope;

        // Spectroscopic ionization gradient along meteor train
        // Head: White-hot -> Cyan/Emerald (O2/Mg) -> Golden Amber (Na) -> Purple/Crimson dissipation
        float3 colHead = float3(1.0, 1.0, 1.0);
        float3 colIon  = float3(0.25, 0.96, 0.86);
        float3 colWarm = float3(1.0, 0.75, 0.32);
        float3 colFade = float3(0.70, 0.20, 0.85);

        float3 tailColor = mix(colFade, colWarm, smoothstep(0.0, 0.45, h));
        tailColor = mix(tailColor, colIon, smoothstep(0.45, 0.82, h));
        tailColor = mix(tailColor, colHead, smoothstep(0.82, 1.0, h));

        colMeteor += tailColor * (tailCore + tailGlow);
        colMeteor += colHead * headCore + colIon * headHalo * 0.45;
    }
    // 3. Atmospheric Aurora Ribbon synthesis (silky, fluid geomagnetic plasma sheets)
    float3 colAuroraAccum = float3(0.0);

    for (int i = 0; i < 3; ++i) {
        float fi = float(i);
        float speed = 0.5 + fi * 0.22;
        float layerT = t * speed + fi * 2.1;

        // Broad, continuous harmonic folds (silky drapery undulations)
        float fold1 = sin(uv.x * 2.4 + layerT * 0.9) * 0.14;
        float fold2 = cos(uv.x * 4.8 - layerT * 0.6) * 0.06;

        // Fluid solar wind domain warping without high-frequency cuts
        float2 warpCoord = float2(uv.x * 1.6 + layerT * 0.35, uv.y * 2.2 + fi * 0.4);
        float windTurbulence = (fbm(warpCoord) - 0.5) * 0.12;

        // Grounded curtain baseline to preserve open celestial sky above
        float curtainBaseY = -0.02 + fi * 0.13 + fold1 + fold2 + windTurbulence;
        float dy = uv.y - curtainBaseY;

        // Smooth, organic plasma density breathing (zero vertical knife slices)
        float plasmaDensity = 0.88 + 0.12 * sin(uv.x * 5.0 + layerT * 1.1);
        plasmaDensity *= (0.85 + 0.15 * fastNoise(float2(uv.x * 3.5 + layerT * 0.4, uv.y * 2.0)));

        if (dy > 0.0) {
            // Altitude envelope: ultra-smooth top entrance and gentle downward ionisation decay
            float heightNorm = clamp(dy / 0.52, 0.0, 1.0);
            float topFade = smoothstep(0.0, 0.12, dy);
            float verticalProfile = exp(-dy * 2.9) * topFade;

            // Spectroscopic altitude gradient:
            // Top (sky): ethereal polar cyan-teal blending softly into the dark cosmos
            // Mid: pure vibrant atomic oxygen 557.7nm emerald green
            // Lower underbelly: majestic deep violet & purple ionisation
            float3 colSkyCyan      = float3(0.02, 0.88, 0.94);
            float3 colOxygenGreen  = float3(0.05, 0.98, 0.55);
            float3 colLowerViolet  = float3(0.55, 0.08, 0.80);
            float3 colDeepPurple   = float3(0.40, 0.03, 0.68);

            float3 ribbonColor;
            if (heightNorm < 0.22) {
                ribbonColor = mix(colSkyCyan, colOxygenGreen, heightNorm / 0.22);
            } else if (heightNorm < 0.52) {
                ribbonColor = colOxygenGreen;
            } else {
                float bottomT = smoothstep(0.52, 1.0, heightNorm);
                ribbonColor = mix(colOxygenGreen, mix(colLowerViolet, colDeepPurple, bottomT), bottomT);
            }

            float intensity = verticalProfile * plasmaDensity * (1.1 - fi * 0.18);
            colAuroraAccum += ribbonColor * intensity * 1.6;
        }
    }

    // Soft organic polar zenith glow (no sharp flower or spokes)
    float r = length(uv);
    float zenithAura = exp(-r * 3.8) * 0.25;
    colAuroraAccum += float3(0.05, 0.45, 0.4) * zenithAura;

    float3 finalColor = colNight + colAuroraAccum + colMeteor;
    finalColor *= smoothstep(0.9, 0.35, r);

    return half4(half3(finalColor), 1.0);
}

// MARK: - 5. 4D Tesseract Gyroscope & Calabi-Yau Wormhole Portal
[[ stitchable ]] half4 holographicLoader(
    float2 position,
    SwiftUI::Layer layer,
    float time,
    float2 size
) {
    if (size.x <= 0.0 || size.y <= 0.0) return half4(0.0);

    float minDim = min(size.x, size.y);
    float2 uv = (position - 0.5 * size) / minDim;

    float t = time * 1.1;
    float r = length(uv);

    // 1. Double SO(4) Clifford / Isoclinic Rotation
    // Smooth, hypnotic 4D rotation across orthogonal planes
    float angXW = t * 0.88;
    float angYZ = t * 1.22;
    float angXZ = t * 0.38;

    float cXW = cos(angXW), sXW = sin(angXW);
    float cYZ = cos(angYZ), sYZ = sin(angYZ);
    float cXZ = cos(angXZ), sXZ = sin(angXZ);

    // Projected 2D coordinates and 4D metrics for 16 Tesseract vertices
    float2 projVerts[16];
    float vertW[16];
    float vertDepth[16];

    for (int i = 0; i < 16; ++i) {
        float4 v = float4(
            (i & 1) ? 1.0 : -1.0,
            (i & 2) ? 1.0 : -1.0,
            (i & 4) ? 1.0 : -1.0,
            (i & 8) ? 1.0 : -1.0
        ) * 0.65;

        // SO(4) rotation in XW
        float x1 = v.x * cXW - v.w * sXW;
        float w1 = v.x * sXW + v.w * cXW;

        // SO(4) rotation in YZ
        float y1 = v.y * cYZ - v.z * sYZ;
        float z1 = v.y * sYZ + v.z * cYZ;

        // Subtle precession in XZ
        float x2 = x1 * cXZ - z1 * sXZ;
        float z2 = x1 * sXZ + z1 * cXZ;

        // Stereographic 4D -> 3D projection
        float d4 = 2.15;
        float s4 = 1.0 / max(0.25, d4 - w1);
        float3 p3 = float3(x2, y1, z2) * s4;

        // Perspective 3D -> 2D projection
        float d3 = 2.4;
        float s3 = 1.0 / max(0.25, d3 - p3.z);
        projVerts[i] = p3.xy * s3 * 1.45;
        vertW[i] = w1;
        vertDepth[i] = p3.z;
    }

    // Smooth gravitational space-time lensing toward center (zero angular modulation)
    float gravDist = max(0.06, r);
    float gravDeflect = 0.012 / (gravDist * gravDist + 0.08);
    float2 warpedUV = uv - uv * (gravDeflect / gravDist);

    float3 colAccum = float3(0.0);

    // 2. Render 32 Tesseract Edges with Volumetric Photonic Neural Pulses
    for (int i = 0; i < 16; ++i) {
        for (int bit = 0; bit < 4; ++bit) {
            int j = i ^ (1 << bit);
            if (i < j) {
                float2 a = projVerts[i];
                float2 b = projVerts[j];
                float2 pa = warpedUV - a;
                float2 ba = b - a;
                float baLenSq = max(1e-5, dot(ba, ba));
                float h = clamp(dot(pa, ba) / baLenSq, 0.0, 1.0);
                float dEdge = length(pa - ba * h);

                // 4D metrics along edge
                float edgeW = mix(vertW[i], vertW[j], h);
                float edgeZ = mix(vertDepth[i], vertDepth[j], h);

                // 4D Depth-of-Field: front edges crisp, rear edges soft volumetric blur
                float wFocus = smoothstep(-0.8, 0.8, edgeW);

                // Organic iridescent chromatic spectrum
                float colorPhase = edgeW * 0.7 + edgeZ * 0.35 + t * 0.35 + float(bit) * 0.22;
                float3 edgePalette = iridescencePalette(colorPhase);

                // Volumetric Waveguide Filament (continuous glowing optical fiber)
                float coreDecay = mix(35.0, 65.0, wFocus);
                float haloDecay = mix(12.0, 22.0, wFocus);
                float filamentCore = exp(-dEdge * coreDecay) * mix(0.6, 1.2, wFocus);
                float filamentHalo = exp(-dEdge * haloDecay) * 0.35;

                // Neural Action Potential: 3D traveling plasma droplet / soliton
                // Travels smoothly from node A to node B
                float pulseTime = t * 1.4 + float(i + bit * 4) * 0.18;
                float pulsePos = fract(pulseTime);
                float2 pulseCenter = mix(a, b, pulsePos);
                float dPulse = length(warpedUV - pulseCenter);

                // Volumetric plasma droplet profile (warm, solid core with soft spherical corona)
                float dropletCore = exp(-dPulse * 48.0) * 2.4;
                float dropletHalo = exp(-dPulse * 16.0) * 0.8;
                float dropletVolumetric = (dropletCore + dropletHalo) * mix(0.7, 1.3, wFocus);

                // Chromatic dispersion for the droplet & filament
                float3 dropletColor = mix(edgePalette, float3(1.0, 1.0, 1.0), 0.55);
                float3 filamentColor = edgePalette;

                // Accumulate volumetric lighting along this segment
                colAccum += filamentColor * (filamentCore * 0.45 + filamentHalo * 0.25);
                colAccum += dropletColor * dropletVolumetric * 0.55;
            }
        }
    }

    // 3. Render 16 Quantum Nodal Gems (Spherical Volumetric Glow - Zero Needle Spikes)
    for (int i = 0; i < 16; ++i) {
        float2 dv = warpedUV - projVerts[i];
        float dVert = length(dv);
        float wNode = vertW[i];
        float wFocus = smoothstep(-0.8, 0.8, wNode);

        // Nodal spectral hue
        float3 vertPalette = iridescencePalette(wNode * 0.85 + t * 0.5 + float(i) * 0.05);

        // Volumetric triple-shell spherical halo (cream-smooth, zero sharp rays)
        float coreNode = exp(-dVert * mix(38.0, 75.0, wFocus)) * 1.6;
        float midHalo = exp(-dVert * mix(14.0, 26.0, wFocus)) * 0.65;
        float outerAtmosphere = exp(-dVert * 7.0) * 0.2;

        float3 nodeColor = mix(vertPalette, float3(1.0, 1.0, 1.0), 0.65);
        colAccum += (nodeColor * coreNode + vertPalette * (midHalo + outerAtmosphere)) * mix(0.55, 1.35, wFocus);
    }

    // 4. Central Hyperspace Singularity (Pure Smooth Radial Lensing - NO Petals / NO Spikes)
    float corePulse = sin(t * 2.2) * 0.12 + 0.88;
    float centerHalo = exp(-r * 7.5) * corePulse;
    float3 centerPalette = iridescencePalette(t * 0.3 - r * 1.8);

    // Deep luminous gravitational center point
    float centerWhiteCore = exp(-r * 28.0) * 2.2;
    colAccum += (centerPalette * centerHalo * 0.6) + (float3(1.0, 1.0, 1.0) * centerWhiteCore * 0.45);

    // 5. Clean Atmospheric Cosmic Mist (Pure Radial Gaussian Fog - NO Petals)
    float cosmicMist = exp(-r * 3.2) * 0.06;
    colAccum += iridescencePalette(t * 0.15 + 0.5) * cosmicMist;

    // Cinematic Soft Vignette to gracefully fade into the dark canvas
    colAccum *= smoothstep(0.92, 0.48, r);

    // High-Dynamic-Range Tone-mapping for silky highlights and deep contrasts
    float3 toneMapped = colAccum / (1.0 + colAccum * 0.32);

    return half4(half3(toneMapped), 1.0);
}


// MARK: - 6. The Matrix: Neural Code Rain & Procedural Katakana Stream
static float matrixSegmentSDF(float2 p, float2 a, float2 b) {
    float2 pa = p - a;
    float2 ba = b - a;
    float h = clamp(dot(pa, ba) / max(1e-5, dot(ba, ba)), 0.0, 1.0);
    return length(pa - ba * h);
}

// Procedural Katakana / Cyber-Glyph Morphological Generator
static float matrixGlyphSDF(float2 p, float seed) {
    float2 box = abs(p);
    if (box.x > 0.95 || box.y > 0.95) return 1.0;

    uint n = uint(abs(seed) * 16384.0) + 1u;
    n ^= (n << 13);
    n ^= (n >> 17);
    n ^= (n << 5);

    float d = 1e5;

    // Stroke 0: Top Horizontal Bar (Roof)
    if ((n & 1u) != 0u) {
        d = min(d, matrixSegmentSDF(p, float2(-0.55, 0.62), float2(0.55, 0.62)));
    }
    // Stroke 1: Middle Crossbar
    if ((n & 2u) != 0u) {
        d = min(d, matrixSegmentSDF(p, float2(-0.45, 0.05), float2(0.45, 0.05)));
    }
    // Stroke 2: Bottom Foot
    if ((n & 4u) != 0u) {
        d = min(d, matrixSegmentSDF(p, float2(-0.55, -0.62), float2(0.55, -0.62)));
    }
    // Stroke 3: Central Spine
    if ((n & 8u) != 0u) {
        d = min(d, matrixSegmentSDF(p, float2(0.0, 0.62), float2(0.0, -0.62)));
    }
    // Stroke 4: Left Vertical Pillar
    if ((n & 16u) != 0u) {
        d = min(d, matrixSegmentSDF(p, float2(-0.50, 0.55), float2(-0.50, -0.40)));
    }
    // Stroke 5: Right Vertical Pillar / Drop
    if ((n & 32u) != 0u) {
        d = min(d, matrixSegmentSDF(p, float2(0.50, 0.55), float2(0.50, -0.40)));
    }
    // Stroke 6: Sweeping Katakana Slash
    if ((n & 64u) != 0u) {
        d = min(d, matrixSegmentSDF(p, float2(0.35, 0.58), float2(-0.45, -0.58)));
    }
    // Stroke 7: Dynamic Katakana Wing / Backslash
    if ((n & 128u) != 0u) {
        d = min(d, matrixSegmentSDF(p, float2(-0.35, 0.48), float2(0.45, -0.52)));
    }
    // Stroke 8: Accent Dakuten / Micro-Dot
    if ((n & 256u) != 0u) {
        d = min(d, length(p - float2(0.42, 0.52)) - 0.05);
    }
    // Stroke 9: Low Anchor Bar
    if ((n & 512u) != 0u) {
        d = min(d, matrixSegmentSDF(p, float2(-0.25, -0.28), float2(0.40, -0.28)));
    }

    if (d > 1e4) {
        d = min(matrixSegmentSDF(p, float2(-0.4, 0.4), float2(0.4, -0.4)),
                matrixSegmentSDF(p, float2(-0.4, -0.4), float2(0.4, 0.4)));
    }
    return d;
}

static float3 matrixLayerEvaluation(
    float2 pos,
    float time,
    float colW,
    float rowH,
    float speedMultiplier,
    float depthBrightness,
    float strokeThickness
) {
    float col = floor(pos.x / colW);
    float row = floor(pos.y / rowH);

    float2 cellUV = (fract(pos / float2(colW, rowH)) - 0.5) * 2.0;

    float colSeed = hash(float2(col * 12.9898, 78.233));
    // Film-accurate speed: calibrated between original high speed (14-32) and slow (3.5-7.5).
    // Exactly 7.5 to 14.0 rows/sec (~2-3 cinema frames per glyph advance in 24fps film).
    float speed = mix(7.5, 14.0, colSeed) * speedMultiplier;
    float trailLen = mix(9.0, 20.0, hash(float2(col * 5.31, 17.89)));
    float cycleRows = 32.0 + hash(float2(col * 31.4, 9.17)) * 18.0;

    float cycleProgress = fract((time * speed + colSeed * 100.0) / cycleRows);
    float headRow = cycleProgress * cycleRows;

    float distBehind = headRow - row;
    if (distBehind < 0.0) {
        distBehind += cycleRows;
    }

    if (distBehind > trailLen) {
        return float3(0.0);
    }

    bool isHead = (distBehind < 0.85);

    // Film authenticity: most tail glyphs stay static (fixed character left behind).
    // Only ~15% mutate subtly, while the leading head decrypts at ~5.0 Hz.
    float cellBaseSeed = hash(float2(col * 19.17 + 3.1, row * 37.43 + 7.9));
    float glyphSeed;

    if (isHead) {
        float headStep = floor(time * 5.0 + hash(float2(col * 7.1, 11.3)) * 8.0);
        glyphSeed = hash(float2(col * 3.1 + row * 7.7, headStep * 0.23));
    } else {
        float mutateChance = hash(float2(col * 5.71, row * 11.23));
        if (mutateChance > 0.85) {
            float tailStep = floor(time * 0.7 + mutateChance * 10.0);
            glyphSeed = hash(float2(cellBaseSeed * 13.7, tailStep * 0.19));
        } else {
            glyphSeed = cellBaseSeed;
        }
    }

    float d = matrixGlyphSDF(cellUV, glyphSeed);

    float glyphCore = smoothstep(strokeThickness + 0.03, strokeThickness - 0.015, d);
    float glyphHalo = exp(-max(0.0, d - strokeThickness) * 11.0) * 0.42;

    float normDist = clamp(distBehind / trailLen, 0.0, 1.0);
    float3 colRamp;

    if (isHead) {
        colRamp = float3(1.4, 1.7, 1.45);
        glyphHalo *= 2.2;
    } else {
        float p = pow(normDist, 0.82);
        if (p < 0.22) {
            colRamp = mix(float3(0.45, 1.35, 0.65), float3(0.12, 1.05, 0.40), p / 0.22);
        } else if (p < 0.65) {
            colRamp = mix(float3(0.12, 1.05, 0.40), float3(0.03, 0.62, 0.18), (p - 0.22) / 0.43);
        } else {
            colRamp = mix(float3(0.03, 0.62, 0.18), float3(0.005, 0.14, 0.04), (p - 0.65) / 0.35);
        }
    }

    float intensity = (glyphCore * 1.5 + glyphHalo) * depthBrightness;
    return colRamp * intensity;
}

[[ stitchable ]] half4 matrixRainLoader(
    float2 position,
    SwiftUI::Layer layer,
    float time,
    float2 size
) {
    if (size.x <= 0.0 || size.y <= 0.0) return half4(0.0);

    float2 uvNorm = position / size - 0.5;
    float rSq = dot(uvNorm, uvNorm);
    float2 warpedPos = position + uvNorm * (rSq * 12.0);

    // Multi-plane volumetric parallax streams
    float3 bgStream = matrixLayerEvaluation(
        warpedPos + float2(4.5, 0.0),
        time,
        9.0,   // colW
        12.0,  // rowH
        0.65,  // speedMultiplier
        0.35,  // depthBrightness
        0.08   // strokeThickness
    );

    float3 fgStream = matrixLayerEvaluation(
        warpedPos,
        time,
        15.0,  // colW
        20.0,  // rowH
        1.0,   // speedMultiplier
        1.0,   // depthBrightness
        0.095  // strokeThickness
    );

    float3 colAccum = bgStream * float3(0.4, 0.8, 0.5) + fgStream;

    // CRT Phosphor Scanline Texture & Grid Shadow
    float scanline = 0.90 + 0.10 * sin(warpedPos.y * 1.8);
    colAccum *= scanline;

    // Ambient Phosphor Atmospheric Fog
    float ambientHaze = (bgStream.y * 0.18 + fgStream.y * 0.12);
    colAccum += float3(0.005, 0.04, 0.015) * ambientHaze;

    // Cinematic Vignette
    float rEdge = length(uvNorm * float2(1.0, size.y / size.x));
    float vignette = smoothstep(0.78, 0.35, rEdge);
    colAccum *= mix(0.75, 1.0, vignette);

    // Filmic Tone-Mapping
    float3 toneMapped = colAccum / (1.0 + colAccum * 0.28);

    return half4(half3(toneMapped), 1.0);
}


// ============================================================================
// Half-Life 2: Zero-Point Energy Lambda Core Shader
// Masterpiece Homage to Valve: Gordon Freeman, City 17 & Gravity Gun Singularity
// ============================================================================

constant float2 kValveLambdaVertices[12] = {
    float2(-0.10169, -0.19000), // top-left serif top
    float2(-0.10169, -0.12935), // top-left serif bottom
    float2(-0.05176, -0.12935), // top inner neck
    float2(-0.03124, -0.06601), // stem fork upper
    float2(-0.18377,  0.17039), // left foot bottom-left
    float2(-0.10883,  0.17039), // left foot bottom-right
    float2( 0.00000,  0.00980), // crotch / inner junction
    float2( 0.07136,  0.19000), // right foot inner base
    float2( 0.18377,  0.15432), // right foot bottom-right corner
    float2( 0.16591,  0.09903), // right foot outer edge
    float2( 0.11419,  0.11506), // right foot top notch
    float2(-0.00714, -0.19000)  // top stem right
};

inline float valveLambdaSDF(float2 p) {
    float d = dot(p - kValveLambdaVertices[0], p - kValveLambdaVertices[0]);
    float s = 1.0;
    for (int i = 0, j = 11; i < 12; j = i++) {
        float2 e = kValveLambdaVertices[j] - kValveLambdaVertices[i];
        float2 w = p - kValveLambdaVertices[i];
        float2 b = w - e * clamp(dot(w, e) / max(0.00001, dot(e, e)), 0.0, 1.0);
        d = min(d, dot(b, b));
        bool c1 = (p.y >= kValveLambdaVertices[i].y);
        bool c2 = (p.y < kValveLambdaVertices[j].y);
        bool c3 = (e.x * w.y > e.y * w.x);
        if ((c1 && c2 && c3) || (!c1 && !c2 && !c3)) {
            s = -s;
        }
    }
    return s * sqrt(d);
}

inline float hlSegmentSDF(float2 p, float2 a, float2 b) {
    float2 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / max(0.00001, dot(ba, ba)), 0.0, 1.0);
    return length(pa - ba * h);
}

// Procedural high-voltage lightning arc with jagged fractal displacement
inline float hlLightningBolt(float2 uv, float2 pA, float2 pB, float seed, float time) {
    float2 ab = pB - pA;
    float len = length(ab);
    if (len < 0.001) return 10.0;
    float2 dir = ab / len;
    float2 n = float2(-dir.y, dir.x);

    float t = clamp(dot(uv - pA, dir) / len, 0.0, 1.0);
    float env = sin(t * 3.14159);

    float frame = floor(time * 28.0) + seed * 17.13;
    float n1 = (fastNoise(float2(t * 7.0 + frame * 0.43, seed * 3.1)) - 0.5);
    float n2 = (fastNoise(float2(t * 22.0 - frame * 0.81, seed * 8.7)) - 0.5);
    float n3 = (fastNoise(float2(t * 54.0 + frame * 1.57, seed * 19.3)) - 0.5);
    float disp = (n1 * 0.045 + n2 * 0.020 + n3 * 0.009) * env;

    float2 arcPt = pA + dir * (t * len) + n * disp;
    return length(uv - arcPt);
}

[[ stitchable ]] half4 halfLifeLambdaLoader(
    float2 position,
    SwiftUI::Layer layer,
    float time,
    float2 size
) {
    if (size.x <= 0.0 || size.y <= 0.0) return half4(0.0);

    float minDim = min(size.x, size.y);
    float2 uvNorm = position / size - 0.5;
    float2 uv = (position - size * 0.5) / minDim;

    // Atmospheric CRT barrel distortion
    float rDist = dot(uvNorm, uvNorm);
    uv += uvNorm * (rDist * 0.12);

    // Deep Combine Citadel Dark Industrial Environment
    float vigBase = 1.0 - length(uvNorm) * 0.95;
    float3 bg = float3(0.035, 0.016, 0.006) * vigBase;

    // Zero-Point Energy Singularity Breathing Flux
    float breath = 1.0 + 0.025 * sin(time * 2.8) + 0.008 * sin(time * 11.4);
    float2 pCore = uv / breath;

    // --- 1. Official Valve Lambda Glyph ---
    float dLambda = valveLambdaSDF(pCore);
    
    // Core fill and superheated inner bevel
    float lambdaFill = smoothstep(0.003, -0.003, dLambda);
    float lambdaDepth = clamp(-dLambda / 0.035, 0.0, 1.0);
    
    // Internal micro-energy flow inside glyph
    float flow = fastNoise(pCore * 16.0 + float2(0.0, time * 1.4));
    float3 lambdaBody = mix(
        float3(1.0, 0.46, 0.05),
        float3(1.9, 1.45, 0.90),
        lambdaDepth * (0.65 + 0.35 * flow)
    ) * lambdaFill;

    // Radiant amber corona & volumetric zero-point bloom
    float lambdaAura = exp(-max(0.0, dLambda) * 26.0) * 1.5;
    float lambdaHalo = exp(-max(0.0, dLambda) * 7.5) * 0.55;
    float3 lambdaGlow = float3(1.2, 0.52, 0.06) * lambdaAura + float3(0.7, 0.22, 0.01) * lambdaHalo;
    float3 lambdaColor = lambdaBody + lambdaGlow;

    // --- 2. Zero-Point Containment Ring & Dial ---
    float r = length(uv);
    float ringR = 0.355;
    float ringD = abs(r - ringR);
    float angle = atan2(uv.y, uv.x);

    // Emissive ring rim and ambient glow (solid, unbroken perimeter)
    float ringCore = smoothstep(0.008, 0.002, ringD);
    float ringHalo = exp(-ringD * 22.0) * 0.65;

    // Mechanical telemetry ticks around perimeter
    float tickAngle = angle + time * 0.25;
    float ticks = smoothstep(0.85, 0.98, sin(tickAngle * 36.0));
    float tickBand = smoothstep(0.006, 0.001, abs(r - 0.385)) * ticks;

    float3 ringColor = float3(1.3, 0.60, 0.08) * (ringCore + tickBand * 0.9)
                     + float3(0.8, 0.28, 0.02) * ringHalo;

    // --- 3. Three Gravity Gun Claws & Violent Electric Arcs ---
    float3 clawAccum = float3(0.0);
    float3 arcAccum = float3(0.0);

    // 3 Targets located along the Lambda body
    float2 targets[3] = {
        float2(-0.045, -0.160), // top serif
        float2( 0.135,  0.130), // right foot
        float2(-0.135,  0.140)  // left foot
    };

    // Mechanical claw breathing / slight hydraulic twitch
    float clawTwitch = sin(time * 1.8) * 0.04;

    for (int i = 0; i < 3; ++i) {
        float baseAngle = -1.570796 + float(i) * 2.094395 + clawTwitch;
        float clawRadius = 0.365 + 0.010 * sin(time * 3.5 + float(i) * 2.1);

        float2 clawTip = float2(cos(baseAngle), sin(baseAngle)) * clawRadius;
        float2 clawBase = float2(cos(baseAngle), sin(baseAngle)) * (clawRadius + 0.080);

        // Mechanical Combine gunmetal prongs
        float dProng = hlSegmentSDF(uv, clawBase, clawTip);
        float prongMetal = smoothstep(0.014, 0.006, dProng);
        float prongGlow = exp(-dProng * 24.0) * 0.65;
        clawAccum += float3(0.28, 0.25, 0.22) * prongMetal + float3(1.1, 0.45, 0.06) * prongGlow;

        // Glowing focusing coil at claw tip
        float dTip = length(uv - clawTip);
        clawAccum += float3(1.8, 1.25, 0.70) * exp(-dTip * 38.0) * 1.3;

        // --- Violent Primary Electric Arc (Focused single high-tension discharge) ---
        float boltSeed = float(i) * 11.73;
        float dBolt = hlLightningBolt(uv, clawTip, targets[i], boltSeed, time);
        
        // High-voltage snapping discharge probability & violent jitter
        float frameStep = floor(time * 28.0) + float(i) * 7.0;
        float arcActive = step(0.12, fastHash(float2(frameStep, boltSeed)));
        
        float arcCore = exp(-dBolt * 155.0) * arcActive;
        float arcAura = exp(-dBolt * 28.0) * arcActive * 0.70;

        // Color ramp: Blinding white-hot core -> Combine Cherenkov ionization -> Amber corona
        arcAccum += float3(2.8, 2.6, 2.2) * arcCore;
        arcAccum += float3(0.5, 1.1, 1.9) * (arcCore * 0.55 + arcAura * 0.25);
        arcAccum += float3(1.5, 0.65, 0.07) * arcAura;

        // --- Molten Metal Strike Zone & Thermal Incandescence (tight pinpoint spots) ---
        float dTarget = length(uv - targets[i]);
        float heatPulse = arcActive * 0.85 + 0.15;
        float meltCore = smoothstep(0.007, 0.001, dTarget) * heatPulse;
        float meltPuddle = exp(-dTarget * 95.0) * heatPulse * 1.1;
        float meltHalo = exp(-dTarget * 45.0) * 0.30;
        
        arcAccum += float3(2.8, 2.4, 1.8) * meltCore
                  + float3(2.0, 0.80, 0.09) * meltPuddle
                  + float3(1.0, 0.25, 0.02) * meltHalo;

        // --- Ballistic Welding Spatter & Ricochet Wall/Floor Bouncing Sparks ---
        float floorY = 0.5 * (size.y / minDim) - 0.035;
        float halfW = 0.5 * (size.x / minDim);
        float wallDist = halfW - 0.025;
        float gravity = 2.4;
        float restFloor = 0.38;
        float restWall = 0.55;

        for (int s = 0; s < 5; ++s) {
            float sSeed = float(i) * 41.7 + float(s) * 17.3;
            // Continuous asynchronous spark stream
            float sTime = time * (0.85 + float(s) * 0.16) + fastHash(float2(sSeed, 1.9));
            float sCycle = fract(sTime);
            float sId = floor(sTime);
            
            // Frequent bursts triggered by arc discharge events
            float sparkTrigger = step(0.18, fastHash(float2(sSeed, sId)));
            
            // Trajectory classification: mostly downward/lateral, occasionally rare high/upward kick
            float isHighKick = step(0.72, fastHash(float2(sSeed, sId + 5.7)));
            
            float vx, vy;
            if (isHighKick > 0.5) {
                // Rare energetic ejection: strong sideways sweep to hit view boundaries and upward thrust
                vx = (fastHash(float2(sSeed, sId + 1.1)) - 0.5) * 1.45;
                vy = -0.52 - 0.40 * fastHash(float2(sSeed + 4.7, sId + 2.3));
            } else {
                // Standard downward welding cascade
                vx = (fastHash(float2(sSeed, sId + 1.1)) - 0.5) * 0.65;
                vy = -0.06 - 0.22 * fastHash(float2(sSeed + 4.7, sId + 2.3));
            }

            // Analytical ballistic collision detection (view border walls & floor)
            float2 p0 = targets[i];
            
            // 1. Time to direct floor strike without wall interference
            float discFloor = max(0.0, vy * vy - 2.0 * gravity * (p0.y - floorY));
            float tFloor = (-vy + sqrt(discFloor)) / gravity;
            
            // 2. Time to side wall strike along direction of horizontal motion
            float tWall = 999.0;
            float targetWallX = (vx >= 0.0) ? wallDist : -wallDist;
            if (abs(vx) > 0.001) {
                tWall = (targetWallX - p0.x) / vx;
            }

            float2 sparkPos = p0;
            float2 sparkVel = float2(0.0);
            bool isResting = false;
            bool didHitWall = (tWall > 0.0 && tWall < tFloor);
            
            if (didHitWall) {
                // Spark collides with side wall first
                float xWall = targetWallX;
                float yWall = p0.y + vy * tWall + 0.5 * gravity * tWall * tWall;
                float vxPost = -vx * restWall;
                float vyPost = vy + gravity * tWall;

                // Time from wall bounce to floor contact
                float discPost = max(0.0, vyPost * vyPost - 2.0 * gravity * (yWall - floorY));
                float dtWallToFloor = (-vyPost + sqrt(discPost)) / gravity;
                float tFloorTotal = tWall + dtWallToFloor;

                if (sCycle < tWall) {
                    // Flight towards wall
                    sparkPos.x = p0.x + vx * sCycle;
                    sparkPos.y = p0.y + vy * sCycle + 0.5 * gravity * sCycle * sCycle;
                    sparkVel = float2(vx, vy + gravity * sCycle);
                } else if (sCycle < tFloorTotal) {
                    // Deflected flight from wall towards floor
                    float dtW = sCycle - tWall;
                    sparkPos.x = xWall + vxPost * dtW;
                    sparkPos.y = yWall + vyPost * dtW + 0.5 * gravity * dtW * dtW;
                    sparkVel = float2(vxPost, vyPost + gravity * dtW);
                } else {
                    // Post-floor impact after wall ricochet
                    float dtF = sCycle - tFloorTotal;
                    float vImpactY = vyPost + gravity * dtWallToFloor;
                    float vBounceY = -vImpactY * restFloor;
                    float tBounceAir = max(0.01, -2.0 * vBounceY / gravity);
                    float xLanding = clamp(xWall + vxPost * dtWallToFloor, -wallDist, wallDist);

                    if (dtF < tBounceAir) {
                        sparkPos.x = clamp(xLanding + vxPost * 0.40 * dtF, -wallDist, wallDist);
                        sparkPos.y = floorY + vBounceY * dtF + 0.5 * gravity * dtF * dtF;
                        sparkVel = float2(vxPost * 0.40, vBounceY + gravity * dtF);
                    } else {
                        float dtRest = dtF - tBounceAir;
                        sparkPos.x = clamp(xLanding + vxPost * 0.40 * tBounceAir + vxPost * 0.10 * dtRest, -wallDist, wallDist);
                        sparkPos.y = floorY;
                        sparkVel = float2(0.0);
                        isResting = true;
                    }
                }
            } else {
                // Direct ballistic arc to floor
                if (sCycle < tFloor) {
                    sparkPos.x = p0.x + vx * sCycle;
                    sparkPos.y = p0.y + vy * sCycle + 0.5 * gravity * sCycle * sCycle;
                    sparkVel = float2(vx, vy + gravity * sCycle);
                } else {
                    float dtF = sCycle - tFloor;
                    float vImpactY = vy + gravity * tFloor;
                    float vBounceY = -vImpactY * restFloor;
                    float tBounceAir = max(0.01, -2.0 * vBounceY / gravity);
                    float xLanding = clamp(p0.x + vx * tFloor, -wallDist, wallDist);

                    if (dtF < tBounceAir) {
                        sparkPos.x = clamp(xLanding + vx * 0.45 * dtF, -wallDist, wallDist);
                        sparkPos.y = floorY + vBounceY * dtF + 0.5 * gravity * dtF * dtF;
                        sparkVel = float2(vx * 0.45, vBounceY + gravity * dtF);
                    } else {
                        float dtRest = dtF - tBounceAir;
                        sparkPos.x = clamp(xLanding + vx * 0.45 * tBounceAir + vx * 0.12 * dtRest, -wallDist, wallDist);
                        sparkPos.y = floorY;
                        sparkVel = float2(0.0);
                        isResting = true;
                    }
                }
            }
            
            // Physical ballistic geometry: directional motion streak vs rectangular slag flake
            float dSpark;
            if (isResting) {
                // Jagged irregular rectangular flake of severed steel slag on deck
                float2 pFlake = uv - sparkPos;
                float rAngle = fastHash(float2(sSeed, sId + 8.13)) * 3.14159;
                float cA = cos(rAngle), sA = sin(rAngle);
                float2 rotP = float2(pFlake.x * cA - pFlake.y * sA, pFlake.x * sA + pFlake.y * cA);
                float flakeW = 0.0025 + 0.0015 * fastHash(float2(sSeed + 1.2, sId));
                float flakeH = 0.0010 + 0.0006 * fastHash(float2(sSeed + 3.4, sId));
                float2 bBox = abs(rotP) - float2(flakeW, flakeH);
                dSpark = length(max(bBox, 0.0)) + min(max(bBox.x, bBox.y), 0.0);
            } else {
                // High-velocity ballistic motion streak (directional needle aligned with velocity)
                float streakTime = 0.024;
                float2 streakTail = sparkPos - sparkVel * streakTime;
                dSpark = hlSegmentSDF(uv, streakTail, sparkPos);
            }

            // Sustained ember lifespan: stays at full intensity through flight & resting on floor, fading only at cycle end
            float sparkLife = smoothstep(0.0, 0.03, sCycle) * smoothstep(1.0, 0.82, sCycle) * sparkTrigger;
            
            // Incandescent white-hot thermal emission -> lemon gold -> resting floor ember
            float3 sparkColor;
            if (sCycle < 0.52) {
                sparkColor = mix(float3(5.0, 4.8, 4.4), float3(3.8, 3.4, 2.5), sCycle / 0.52);
            } else if (sCycle < 0.82) {
                sparkColor = mix(float3(3.8, 3.4, 2.5), float3(3.2, 2.0, 0.6), (sCycle - 0.52) / 0.30);
            } else {
                sparkColor = mix(float3(3.2, 2.0, 0.6), float3(1.5, 0.5, 0.05), (sCycle - 0.82) / 0.18);
            }
            
            // Needle-sharp additive incandescence without circular cutoff or fake shadow boundaries
            float sparkPoint = exp(-max(0.0, dSpark) * 850.0);
            float sparkCore = exp(-max(0.0, dSpark) * 320.0);
            float sparkAura = exp(-max(0.0, dSpark) * 90.0);
            
            arcAccum += (float3(5.0, 5.0, 5.0) * sparkPoint + sparkColor * (sparkCore * 2.4 + sparkAura * 0.35)) * sparkLife;
        }
    }

    // --- 4. Zero-Point Swirling Dark Energy Singularity ---
    float centralR = length(uv);
    float singularityBloom = exp(-centralR * 8.5) * 0.35;
    float3 singularityColor = float3(1.0, 0.42, 0.05) * singularityBloom;

    // --- 5. Composite All Layers (clean dark industrial focus) ---
    float3 baseLayers = bg
                      + lambdaColor
                      + ringColor
                      + clawAccum
                      + singularityColor;

    // CRT Phosphor Scanlines modulate UI & environment
    float scanline = 0.93 + 0.07 * sin(position.y * 1.75);
    baseLayers *= scanline;

    // Superheated electric discharges & incandescent sparks burn over scanlines with pure additive energy
    float3 colorOut = baseLayers + arcAccum;

    // Industrial Dark Vignette
    float vig = smoothstep(0.85, 0.35, length(uvNorm * float2(1.0, size.y / size.x)));
    colorOut *= mix(0.68, 1.0, vig);

    // Filmic tone-mapping
    float3 mapped = colorOut / (1.0 + colorOut * 0.24);

    return half4(half3(mapped), 1.0);
}
