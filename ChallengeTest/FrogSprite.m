//
//  FrogSprite.m
//  ChallengeTest
//
//  Created by YinYanhui on 14-11-22.
//  Copyright (c) 2014年 YinYanhui. All rights reserved.
//

#import "FrogSprite.h"

SKAction* frogBlink;
SKAction* frogEat;

@implementation FrogSprite

+(FrogSprite *) newWithAlloc : (float) spriteWidth
{
    SKTextureAtlas *frog = [SKTextureAtlas atlasNamed:@"Frog"];
    int numImages = (int)frog.textureNames.count;
    
    frogBlinkFramesOpen = [NSMutableArray array];
    for (int i=1; i <= 1; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"frog%02d", i];
        SKTexture *temp = [frog textureNamed:textureName];
        [frogBlinkFramesOpen addObject:temp];
    }
    
    frogBlinkFramesClose = [NSMutableArray array];
    for (int i=2; i <= 2; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"frog%02d", i];
        SKTexture *temp = [frog textureNamed:textureName];
        [frogBlinkFramesClose addObject:temp];
    }
    
    frogActionFrames = [NSMutableArray array];
    for (int i=3; i <= numImages; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"frog%02d", i];
        SKTexture *temp = [frog textureNamed:textureName];
        [frogActionFrames addObject:temp];
    }
    
    SKAction *actionOpen = [SKAction animateWithTextures:frogBlinkFramesOpen timePerFrame:2.0f resize:NO restore:YES];
    SKAction *actionClose = [SKAction animateWithTextures:frogBlinkFramesClose timePerFrame:0.1f resize:NO restore:YES];
    
    frogBlink = [SKAction repeatActionForever:[SKAction sequence:@[actionOpen ,actionClose]]];
    
    frogEat = [SKAction repeatAction:
               [SKAction animateWithTextures:frogActionFrames
                                timePerFrame:0.1f
                                      resize:NO
                                     restore:YES] count : 1];
    
    SKTexture *temp = frogBlinkFramesClose[0];
    return [FrogSprite spriteNodeWithTexture: temp size: CGSizeMake(spriteWidth, spriteWidth)];
}

-(void) performFrogEat
{
    [self runAction:[SKAction playSoundFileNamed:@"Feed02.mp3" waitForCompletion:NO]];
    
    NSString *ts = @"frogEat";
    SKAction *eatActionWithDone = [SKAction sequence:@[frogEat,frogBlink ]];
    [self runAction: eatActionWithDone withKey:ts];
}

-(void) performFrogBlink
{
    [self removeAllActions];
    NSString *ts = @"frogBlink";
    [self runAction: frogBlink withKey:ts];
}

@end
