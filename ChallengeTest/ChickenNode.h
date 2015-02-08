//
//  ChickenNode.h
//  ChallengeTest
//
//  Created by YinYanhui on 14-11-15.
//  Copyright (c) 2014年 YinYanhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChickenNode : NSObject
{
    @public
    int x;
    int y;
    int w;
    int v;
}
+(id) newWithValue:(int) x :(int) y :(int) w :(int) v;
@end
