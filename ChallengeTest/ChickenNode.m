//
//  ChickenNode.m
//  ChallengeTest
//
//  Created by YinYanhui on 14-11-15.
//  Copyright (c) 2014年 YinYanhui. All rights reserved.
//

#import "ChickenNode.h"

@implementation ChickenNode

-(id) init:(int) xx :(int) yy :(int) ww :(int) vv
{
    if (self = [super init])
    {
        self->x = xx;
        self->y = yy;
        self->w = ww;
        self->v = vv;
        return self;
    }
    
    return Nil;
}

+(id) newWithValue:(int) x :(int) y :(int) w :(int) v
{
    return [[self alloc] init: x: y: w: v];
}

@end
