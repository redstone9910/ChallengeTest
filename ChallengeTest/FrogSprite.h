//
//  FrogSprite.h
//  ChallengeTest
//
//  Created by YinYanhui on 14-11-22.
//  Copyright (c) 2014年 YinYanhui. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static NSMutableArray *frogActionFrames;
static NSMutableArray *frogBlinkFramesOpen;
static NSMutableArray *frogBlinkFramesClose;

@interface FrogSprite : SKSpriteNode

+(FrogSprite *) newWithAlloc : (float) spriteWidth;
-(void) performFrogEat;
-(void) performFrogBlink;

@end
