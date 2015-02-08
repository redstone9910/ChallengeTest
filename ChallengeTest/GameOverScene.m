//
//  GameOverScence.m
//  ChallengeTest
//
//  Created by YinYanhui on 14-11-23.
//  Copyright (c) 2014年 YinYanhui. All rights reserved.
//

#import "GameOverScene.h"

#define BACK_R (231.0 / 255.0)
#define BACK_G (176.0 / 255.0)
#define BACK_B (69.0 / 255.0)
#define BACK_A 1.0

@implementation GameOverScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed: BACK_R green: BACK_G blue: BACK_B alpha:BACK_A];
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene * myScene = [[MyScene alloc] initWithSize:CGSizeMake(self.size.width * 2, self.size.height * 2) : 2];
    [self.view presentScene:myScene transition: reveal];
}

@end
