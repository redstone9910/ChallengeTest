//
//  MyScene.h
//  ChallengeTest
//

//  Copyright (c) 2014年 YinYanhui. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ChickenBoard.h"
#import "ChickenNode.h"
#import "ChickenSprite.h"
#import "FrogSprite.h"
#import "ScoreSprite.h"
#import "GameOverScene.h"
#import "WXApi.h"
#import "MobClick.h"

@interface MyScene : SKScene
{
    enum WXScene _scene;
}

@property (nonatomic, retain) ChickenSprite *sChicken;

-(id)initWithSize:(CGSize)size : (int)frameIndex;

@end
