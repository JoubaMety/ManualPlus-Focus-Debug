#version 120

#define x 32 // [0.1 0.2 0.3 0.4 0.5 0.7 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 4 5 6 7 8 9 10 12 14 16 24 32 40 48 56 64 72 80 88 96 104 112 120 128 136 144 152 160 168 176 184 192 200 208 216 224 232 240 248 256]
#define transparency 0.7 // [0.0 0.033 0.066 0.1 0.133 0.166 0.2 0.233 0.266 0.3 0.333 0.366 0.4 0.433 0.466 0.5 0.533 0.566 0.6 0.633 0.666 0.7 0.733 0.766 0.8 0.833 0.866 0.9 0.933 0.966 1.0]
#define bluesize 0.00001 // [0.000001 0.00001 0.00002 0.00003 0.00004 0.00005 0.00006 0.00007 0.00008 0.00009 0.0001 0.00011 0.00012 0.00013 0.00014 0.00015 0.00016 0.00017 0.00018 0.00019 0.0002]

#define farplaneR 0.0 // [0.0 0.033 0.066 0.1 0.133 0.166 0.2 0.233 0.266 0.3 0.333 0.366 0.4 0.433 0.466 0.5 0.533 0.566 0.6 0.633 0.666 0.7 0.733 0.766 0.8 0.833 0.866 0.9 0.933 0.966 1.0]
#define farplaneG 1.0 // [0.0 0.033 0.066 0.1 0.133 0.166 0.2 0.233 0.266 0.3 0.333 0.366 0.4 0.433 0.466 0.5 0.533 0.566 0.6 0.633 0.666 0.7 0.733 0.766 0.8 0.833 0.866 0.9 0.933 0.966 1.0]
#define farplaneB 0.0 // [0.0 0.033 0.066 0.1 0.133 0.166 0.2 0.233 0.266 0.3 0.333 0.366 0.4 0.433 0.466 0.5 0.533 0.566 0.6 0.633 0.666 0.7 0.733 0.766 0.8 0.833 0.866 0.9 0.933 0.966 1.0]

#define nearplaneR 1.0 // [0.0 0.033 0.066 0.1 0.133 0.166 0.2 0.233 0.266 0.3 0.333 0.366 0.4 0.433 0.466 0.5 0.533 0.566 0.6 0.633 0.666 0.7 0.733 0.766 0.8 0.833 0.866 0.9 0.933 0.966 1.0]
#define nearplaneG 0.0 // [0.0 0.033 0.066 0.1 0.133 0.166 0.2 0.233 0.266 0.3 0.333 0.366 0.4 0.433 0.466 0.5 0.533 0.566 0.6 0.633 0.666 0.7 0.733 0.766 0.8 0.833 0.866 0.9 0.933 0.966 1.0]
#define nearplaneB 0.0 // [0.0 0.033 0.066 0.1 0.133 0.166 0.2 0.233 0.266 0.3 0.333 0.366 0.4 0.433 0.466 0.5 0.533 0.566 0.6 0.633 0.666 0.7 0.733 0.766 0.8 0.833 0.866 0.9 0.933 0.966 1.0]

#define focuspointR 0.0 // [0.0 0.033 0.066 0.1 0.133 0.166 0.2 0.233 0.266 0.3 0.333 0.366 0.4 0.433 0.466 0.5 0.533 0.566 0.6 0.633 0.666 0.7 0.733 0.766 0.8 0.833 0.866 0.9 0.933 0.966 1.0]
#define focuspointG 0.0// [0.0 0.033 0.066 0.1 0.133 0.166 0.2 0.233 0.266 0.3 0.333 0.366 0.4 0.433 0.466 0.5 0.533 0.566 0.6 0.633 0.666 0.7 0.733 0.766 0.8 0.833 0.866 0.9 0.933 0.966 1.0]
#define focuspointB 1.0 // [0.0 0.033 0.066 0.1 0.133 0.166 0.2 0.233 0.266 0.3 0.333 0.366 0.4 0.433 0.466 0.5 0.533 0.566 0.6 0.633 0.666 0.7 0.733 0.766 0.8 0.833 0.866 0.9 0.933 0.966 1.0]

#define NEARPLANE
#define FARPLANE
#define FOCUSPLANE

//#define contimodded_2_1_mode

uniform sampler2D colortex0;
uniform sampler2D depthtex0;

varying vec2 texcoord;

/* Required uniforms for Manual+ Focus */
uniform float far;
uniform float near;
uniform float screenBrightness;

void main() {

    /* COLOR AND DEPTH */
    vec3 color = texture2D(colortex0, texcoord).rgb; // Color buffer
    vec3 depth = texture2D(depthtex0, texcoord).rgb; // Depth buffer

    /* MANUAL+ FOCUS FUNCTION */
    
    float focus = (far * ((screenBrightness * x) - near)) / ((screenBrightness * x) * (far - near));
    #ifdef contimodded_2_1_mode
          focus = (far * ((1+((x - 1) * screenBrightness)) - near)) / ((1+((x - 1) * screenBrightness)) * (far - near));
    #endif

    /* FOCUS PLANE SIZE */
    float bluesizef;
    #ifdef FOCUSPLANE
          bluesizef = bluesize;
    #else
          bluesizef = 0.;
    #endif

    /* MANUAL+ FOCUS VISUALISER */
    vec3 overlay;
    #ifdef FARPLANE
         if (abs(focus) < (depth.z - bluesizef))
         overlay = vec3(farplaneR, farplaneG, farplaneB);
    #else
         if (abs(focus) < (depth.z - bluesizef))
         overlay = vec3(0.);
    #endif

    #ifdef NEARPLANE
         if (abs(focus) > (depth.z + bluesizef))
         overlay = vec3(nearplaneR,nearplaneG,nearplaneB);
    #else
         if (abs(focus) > (depth.z + bluesizef))
         overlay = vec3(0.);
    #endif

    #ifdef FOCUSPLANE
         if (abs(focus) < (depth.z + bluesizef) && abs(focus) > (depth.z - bluesizef))
         overlay += vec3(focuspointR,focuspointG,focuspointB);
    #endif

    /* MIXER */
    color = mix(color,overlay,transparency);

    /* OUTPUT */
    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4(color, 1.0);

}