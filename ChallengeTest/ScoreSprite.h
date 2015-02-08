//
//  ScoreSprite.h
//  ChallengeTest
//
//  Created by YinYanhui on 14-11-23.
//  Copyright (c) 2014年 YinYanhui. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ScoreSprite : NSObject

@property enum ScoreAlignMode
{
    modeRight,
    modeCenter,
    modeLeft
};

@property int scoreValue;
@property float mmX,mmY;
@property float mmW,mmH;
@property bool mOnOff;

@property int scoreLengh;

@property NSMutableArray* scoreSprites;
//@property NSMutableArray* scorePositions;

//@property int* singleScore;
@property enum ScoreAlignMode mAlign;

-(id)init;
+(ScoreSprite *) newWithAlloc : (float)pX : (float) pY : (float) spriteWidth;
-(void) setPosition: (float) pX : (float) pY;
-(void) setScore:(int) num;
-(void) updateScore;
-(void) displayNumberOn:(bool) onoff;
-(void) setAlign : (enum ScoreAlignMode) mAlign;

@end
