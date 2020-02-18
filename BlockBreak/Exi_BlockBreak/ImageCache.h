//
//  ImageCache.h
//  Exi_BlockBreak
//
//  Created by student on 16/4/21.
//  Copyright © 2016年 李梓键. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ImageCache : NSObject
//将指定图片加入缓冲池
+(UIImage*)loadImage:(NSString*)imageName;
//清空缓冲池
+(void)releaseCache;
@end
