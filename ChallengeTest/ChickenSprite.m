//
//  ChickenSprite.m
//  ChallengeTest
//
//  Created by YinYanhui on 14-11-16.
//  Copyright (c) 2014年 YinYanhui. All rights reserved.
//

#import "ChickenSprite.h"

@implementation ChickenSprite

/*float orgX;
float orgY;
bool beSelected = false;
bool beHovered = false;
int v_status = 0;
static float resTime = 0.1f;
NSThread* myThread;*/

+(ChickenSprite *) newWithAlloc : (float) spriteWidth
{
    SKTextureAtlas *chicken = [SKTextureAtlas atlasNamed:@"Chicken"];
    int numImages = (int)chicken.textureNames.count;
    
    chickenActionFrames = [NSMutableArray array];
    for (int i=1; i <= numImages - 4; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"xiaoji%02d", i];
        SKTexture *temp = [chicken textureNamed:textureName];
        [chickenActionFrames addObject:temp];
    }
    
    chickenBlinkFramesOpen = [NSMutableArray array];
    for (int i=numImages - 3; i <= numImages - 3; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"xiaoji%02d", i];
        SKTexture *temp = [chicken textureNamed:textureName];
        [chickenBlinkFramesOpen addObject:temp];
    }
    
    chickenBlinkFramesClose = [NSMutableArray array];
    for (int i=numImages - 2; i <= numImages - 2; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"xiaoji%02d", i];
        SKTexture *temp = [chicken textureNamed:textureName];
        [chickenBlinkFramesClose addObject:temp];
    }
    
    chickenStopFrames = [NSMutableArray array];
    for (int i=numImages - 1; i <= numImages - 1; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"xiaoji%02d", i];
        SKTexture *temp = [chicken textureNamed:textureName];
        [chickenStopFrames addObject:temp];
    }
    
    chickenBlankFrames = [NSMutableArray array];
    for (int i=numImages; i <= numImages; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"xiaoji%02d", i];
        SKTexture *temp = [chicken textureNamed:textureName];
        [chickenBlankFrames addObject:temp];
    }
    
    ChickenSprite *retSprite;
    
    SKTexture *temp = chickenBlinkFramesOpen[0];
    retSprite = [ChickenSprite spriteNodeWithTexture: temp size: CGSizeMake(spriteWidth, spriteWidth)];
    
    retSprite->beSelected = false;
    retSprite->beHovered = false;
    retSprite->v_status = 0;
    retSprite->resTime = 0.1f;
    return retSprite;
    
    retSprite = [ChickenSprite spriteNodeWithImageNamed:[NSString stringWithFormat:@"xiaoji%02d", numImages - 3]];
    [retSprite setSize:CGSizeMake(spriteWidth, spriteWidth)];
    return retSprite;
}

-(void) saveNodePos:(float)x : (float) y
{
    orgX = x;
    orgY = y;
}

-(void)restoreNodePos
{
    [self setPosition:CGPointMake(orgX, orgY)];
}

-(void)restoreNodePos:(float)x :(float) y
{
    [self saveNodePos: x :y];
    [self restoreNodePos];
}

-(void)updateNodePos:(CGPoint)v
{
    [self updateNodePos:v.x :v.y];
}

-(void)updateNodePos:(float)x :(float) y
{
    [self saveNodePos: x :y];
    SKAction *moveAction = [SKAction moveTo:CGPointMake(x, y) duration:resTime];
    [self runAction:moveAction withKey:@"movingChicken"];
}

-(void)setStatus:(int) v
{
    v_status = v;
    if(v_status == 0)
    {
        //this.stopAnimation(this.getTiledTextureRegion().getTileCount() - 1);
        [self animationingChicken:4];
    }
    else if(v_status == 2)
    {
        //this.stopAnimation(this.getTiledTextureRegion().getTileCount() - 2);
        [self animationingChicken:3];
    }
    else if(v_status == 1)
    {
        if(beHovered)
        {
            //final long[] pFrameDurations = new long[this.getTiledTextureRegion().getTileCount() - 4];
            //Arrays.fill(pFrameDurations, (long)(100));
            //this.animate(pFrameDurations, 0, this.getTiledTextureRegion().getTileCount() - 5, true);
            [self animationingChicken:1];
        }
        else
        {
            //final long pDurations[] = {(long) (1000 * Math.random() * 2 + 1000),100};
            //this.animate(pDurations, this.getTiledTextureRegion().getTileCount() - 4, this.getTiledTextureRegion().getTileCount() - 3, true);
            [self animationingChicken:2];
        }
    }
}

-(void)setHovered:(bool) h
{
    if(beHovered != h)
    {
        beHovered = h;
        [self setStatus:v_status];
    }
}

-(void)animationingChicken:(int) t//(NSMutableArray*) chickenFrames
{
    //[self removeAllActions];
    NSMutableArray* chickenFrames;
    NSMutableString *ts = [[NSMutableString alloc] init];
    
    for (int i = 0; i < 4; i ++)
    {
        [ts setString:@""];
        [ts appendFormat:@"Status%d" , i];
        while ([self actionForKey:ts])
        {
            [self removeActionForKey:ts];
        }
    }
    //[self removeAllActions];
    
    [ts setString:@""];
    [ts appendFormat:@"Status%d" , t];
    switch (t)
    {
        case 1:
        chickenFrames = chickenActionFrames;
        [self setTexture:chickenFrames[0]];
        [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:chickenFrames
                                                                       timePerFrame:0.1f
                                                                             resize:NO
                                                                            restore:YES]] withKey:ts];
        return;
        
        case 2:
        {
            [self setTexture:chickenBlinkFramesOpen[0]];
            
            float timePerFrame = (arc4random() % 30) / 100.0f;
            SKAction *actionOpen = [SKAction animateWithTextures:chickenBlinkFramesOpen timePerFrame:2.0f + timePerFrame resize:NO restore:YES];
            SKAction *actionClose = [SKAction animateWithTextures:chickenBlinkFramesClose timePerFrame:0.1f resize:NO restore:YES];
            
            [self runAction:[SKAction repeatActionForever: [SKAction sequence:@[actionClose,[SKAction waitForDuration:1.0],actionOpen ]]] withKey:ts];
            return;
        }
        case 3:
        chickenFrames = chickenStopFrames;
        [self setTexture:chickenFrames[0]];
        return;
        
        case 4:
        chickenFrames = chickenBlankFrames;
        [self setTexture:chickenFrames[0]];
        return;
        
        default:
        return;
    }
    
    return;
}

/*-(void)performMove : (float) x : (float) y : (float) d : (SEL) selector
{
    [self runAction:[SKAction playSoundFileNamed:@"Fly151.mp3" waitForCompletion:NO]];
    
    NSThread* myThread;
    myThread = [[NSThread alloc] initWithTarget:self
                                       selector:selector
                                         object:self];
    
    SKAction *moveAction = [SKAction moveTo:CGPointMake(x, y) duration:d];
    SKAction *doneAction = [SKAction runBlock:(dispatch_block_t)^()
    {
        [myThread start]; //启动线程
    }];
    
    SKAction *moveActionWithDone = [SKAction sequence:@[moveAction,doneAction ]];
    
    [self runAction:moveActionWithDone withKey:@"chickenMoving"];
}

-(void)performMoveEnd
{
    [self setStatus:0];
    [self setZPosition:0];
    [self setHovered:false];
    [self restoreNodePos];
}*/

@end
