//
//  ChickenSprite.h
//  ChallengeTest
//
//  Created by YinYanhui on 14-11-16.
//  Copyright (c) 2014年 YinYanhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SKSpriteNode.h>
#import <SpriteKit/SKTextureAtlas.h>
#import <SpriteKit/SKAction.h>

static NSMutableArray *chickenActionFrames;
static NSMutableArray *chickenBlinkFramesOpen;
static NSMutableArray *chickenBlinkFramesClose;
static NSMutableArray *chickenStopFrames;
static NSMutableArray *chickenBlankFrames;

@interface ChickenSprite : SKSpriteNode
{
    @public
    float orgX;
    float orgY;
    bool beSelected;
    bool beHovered;
    int v_status;
    float resTime;
}

+(instancetype) newWithAlloc : (float) spriteWidth;
-(void)saveNodePos:(float)x :(float) y;
-(void)restoreNodePos;
-(void)restoreNodePos:(float)x :(float) y;

-(void)updateNodePos:(CGPoint)v;
-(void)updateNodePos:(float)x :(float) y;

-(void)setStatus:(int) v;
-(void)setHovered:(bool) h;
-(void)animationingChicken:(int) t;//(NSMutableArray*) chickenFrames;
//-(void)performMove : (float) x : (float) y : (float) d : (SEL) selector;
//-(void)performMoveEnd;
@end
