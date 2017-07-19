//
//  AudioTransform.m
//  ShangWuMiao
//
//  Created by ju on 2017/7/19.
//  Copyright © 2017年 ju. All rights reserved.
//

#import "AudioTransform.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"

// 采样率
typedef NS_ENUM(NSInteger, AudioSample) {
    AudioSampleRateLow = 8000,
    AudioSampleRateMedium = 44100, //音频CD采样率
    AudioSampleRateHigh = 96000
};

@implementation AudioTransform

+ (BOOL)transformToMp3FromPath:(NSString *)originalPath
                     toMp3Path:(NSString *)mp3Path
           withAVSampleRateKey:(int)rateKey {
    @try {
        int read, write;
        
        FILE *pcm = fopen([originalPath cStringUsingEncoding:1], "rb");  //source
        fseek(pcm, 4*1024, SEEK_CUR);                                    //skip file header
        FILE *mp3 = fopen([mp3Path cStringUsingEncoding:1], "wb");       //output
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, rateKey);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
        return false;
    }
    @finally {
        return true;
    }

}


@end
