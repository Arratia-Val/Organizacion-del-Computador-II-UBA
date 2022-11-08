#include<assert.h>
#include<stdio.h>
#include<stdint.h>
#include<string.h>
#include<stdlib.h>

#include "filtros.h"
#include "utils.h"

#include "wav.h"

#define NUM_CHANNELS 2

#define LEFT 0
#define RIGHT 1

#define BLOCK_SIZE 250

extern int16_t COEFS[]; 
extern int FILTER_TAP_NUM;

void wav_setup(WavFile* readfile, WavFile* writefile);

int main (int argc, char *argv[]) {
    assert(BLOCK_SIZE <= MAX_INPUT_BLOCK_LEN && "Tamaño de bloque excedido");
    
    char* outputPath = "output.wav";

    if (argc < 2) return -1;
    const char *inputPath = argv[1];

    WavFile *readfile = wav_open(inputPath, WAV_OPEN_READ);
    WavFile *writefile = wav_open(outputPath, WAV_OPEN_WRITE);

    wav_setup(readfile, writefile);

    FIR_t filtro_l;
    FIR_t filtro_r;
    filtro_l.coefs = COEFS;
    filtro_l.length = FILTER_TAP_NUM;

    filtro_r.coefs = COEFS;
    filtro_r.length = FILTER_TAP_NUM;

    fir_init(&filtro_l);
    fir_init(&filtro_r);

    int samplesProcessed = 0;
    int samplesRead;
    int16_t (*rbuffer)[BLOCK_SIZE] = (int16_t(*)[BLOCK_SIZE]) malloc(NUM_CHANNELS * BLOCK_SIZE * sizeof(int16_t));
    int16_t (*wbuffer)[BLOCK_SIZE] = (int16_t(*)[BLOCK_SIZE]) malloc(NUM_CHANNELS * BLOCK_SIZE * sizeof(int16_t));

    size_t totalNumSamples = wav_get_length(readfile);

    while ( (samplesRead = wav_read(readfile, (void*) rbuffer, BLOCK_SIZE, SPLIT)) != 0) {

        fir_filter(&filtro_l, rbuffer[LEFT], samplesRead, wbuffer[LEFT]);
        fir_filter(&filtro_r, rbuffer[RIGHT], samplesRead, wbuffer[RIGHT]);

        int samplesWritten = wav_write(writefile, (void*) wbuffer, BLOCK_SIZE, SPLIT);

        assert(samplesWritten > 0 && "No se pudo escribir al archivo!");

        samplesProcessed += samplesRead;
        display_progress(((samplesProcessed * 1.0)/totalNumSamples));

    }

    free(rbuffer);
    free(wbuffer);
    wav_close(readfile);
    wav_close(writefile);
    return 0;

}

void wav_setup(WavFile* readfile, WavFile* writefile){
    int sampleRate = wav_get_sample_rate(readfile);
    size_t totalNumSamples = wav_get_length(readfile);
    int channels = wav_get_num_channels(readfile);

    char *format;
    switch (wav_get_format(readfile))
    {
        case WAV_FORMAT_PCM:        format="PCM"; break;
        case WAV_FORMAT_IEEE_FLOAT: format="IEEE FLOAT"; break;
        case WAV_FORMAT_ALAW:       format="A-LAW"; break;
        case WAV_FORMAT_MULAW:      format="u-LAW"; break;
        case WAV_FORMAT_EXTENSIBLE: format="EXT"; break;
        default: break;
    }

    printf("WAV Format: %s\n", format);
    printf("Sample Rate: %d\n", sampleRate);
    printf("Samples: %ld\n", totalNumSamples);
    printf("Channels: %d\n", channels);
    printf("Sample Size: %ld-bits\n", wav_get_sample_size(readfile)*8);

    wav_set_format(writefile, wav_get_format(readfile));
    wav_set_sample_size(writefile, wav_get_sample_size(readfile));
    wav_set_num_channels(writefile,wav_get_num_channels(readfile));
    wav_set_sample_rate(writefile,wav_get_sample_rate(readfile));
}