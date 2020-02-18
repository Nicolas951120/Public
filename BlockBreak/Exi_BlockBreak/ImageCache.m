//
//  ImageCache.m
//  Exi_BlockBreak
//
//  Created by student on 16/4/21.
//  Copyright © 2016年 李梓键. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache
static NSMutableDictionary *dict;

+(UIImage*)loadImage:(NSString *)imageName{
    if (!dict) {
        dict=[NSMutableDictionary dictionary];
    }
    UIImage* image=[dict objectForKey:imageName];
    
    if (!image) {
        NSString *imagePath=[[NSBundle mainBundle]pathForResource:imageName ofType:nil];
        image=[UIImage imageWithContentsOfFile:imagePath];
        if (image) {
            [dict setObject:image forKey:imageName];
        }
    }
    return image;
}

+(void)releaseCache{
    if (dict) {
        [dict removeAllObjects];
    }
}

@end
