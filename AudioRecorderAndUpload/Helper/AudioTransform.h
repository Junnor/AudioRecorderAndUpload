//
//  AudioTransform.h
//  ShangWuMiao
//
//  Created by ju on 2017/7/19.
//  Copyright © 2017年 ju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioTransform : NSObject

+ (BOOL)transformToMp3FromPath:(NSString *)originalPath
                     toMp3Path:(NSString *)mp3Path
           withAVSampleRateKey:(int)rateKey;

@end
