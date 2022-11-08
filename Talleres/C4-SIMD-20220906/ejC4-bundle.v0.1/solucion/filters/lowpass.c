/*

FIR filter designed with
http://t-filter.appspot.com

sampling frequency: 44100 Hz

fixed point precision: 16 bits

* 0 Hz - 3000 Hz
  gain = 3
  desired ripple = 5 dB
  actual ripple = n/a

* 3500 Hz - 22000 Hz
  gain = 0
  desired attenuation = -40 dB
  actual attenuation = n/a

*/
#include<stdint.h>

int FILTER_TAP_NUM = 91;

int16_t COEFS[] = {
  -267,
  -276,
  -382,
  -479,
  -552,
  -586,
  -571,
  -500,
  -379,
  -217,
  -36,
  141,
  288,
  382,
  407,
  360,
  247,
  88,
  -88,
  -246,
  -355,
  -390,
  -338,
  -202,
  -5,
  220,
  429,
  577,
  626,
  555,
  361,
  69,
  -277,
  -615,
  -872,
  -980,
  -886,
  -558,
  1,
  756,
  1640,
  2565,
  3428,
  4131,
  4589,
  4749,
  4589,
  4131,
  3428,
  2565,
  1640,
  756,
  1,
  -558,
  -886,
  -980,
  -872,
  -615,
  -277,
  69,
  361,
  555,
  626,
  577,
  429,
  220,
  -5,
  -202,
  -338,
  -390,
  -355,
  -246,
  -88,
  88,
  247,
  360,
  407,
  382,
  288,
  141,
  -36,
  -217,
  -379,
  -500,
  -571,
  -586,
  -552,
  -479,
  -382,
  -276,
  -267
};
