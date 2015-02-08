//
//  ChickenBoard.h
//  ChallengeTest
//
//  Created by YinYanhui on 14-11-15.
//  Copyright (c) 2014年 YinYanhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChickenNode.h"

#define NODE_TYPE_NUM 8
#define ROWNUM 9
#define B_WIDTH (CAMERA_WIDTH / (ROWNUM - 2))
#define B_X0 -B_WIDTH
#define B_Y0 0

@interface ChickenBoard : NSObject

@property NSMutableArray *mNode;

@property float frameX0;
@property float frameY0;
@property float nodeWidth;

-(id) init: (float)x : (float)y : (float)frameWidth : (int)frameIndex;
-(id) init: (ChickenBoard*) mBoard;
+(ChickenBoard*) newWithValue: (float)x : (float)y : (float)frameWidth : (int)frameIndex;
+(ChickenBoard*) newWithValue: (ChickenBoard*) mBoard;
-(void) printContent;
-(ChickenNode *) getNode: (int) x : (int) y;
-(bool) findAvailableMoves;

@end
