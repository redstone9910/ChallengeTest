//
//  ScoreSprite.m
//  ChallengeTest
//
//  Created by YinYanhui on 14-11-23.
//  Copyright (c) 2014年 YinYanhui. All rights reserved.
//

#import "ScoreSprite.h"

#define SCORE_LENGH 4
#define SCORE_DIS 0.1

@implementation ScoreSprite

NSMutableArray* scoreTextures;

-(id)init
{
    /*int scoreValue = 0;
     float mmX = 0,mmY = 0;
     float mmW = 0,mmH = 0;
     bool mOnOff = false;
     SKSpriteNode * scoreSprites[4];
     CGPoint scorePositions[4];
     int singleScore[4];
     enum ScoreAlignMode mAlign;*/
    
    SKTexture *tempTexture;
    
    self.scoreLengh = SCORE_LENGH;
    
    if (self = [super init])
    {
        self.mAlign = modeCenter;
        self.scoreValue = 0;
        
        self.scoreSprites = [NSMutableArray array];
        //self.scorePositions = [NSMutableArray array];
        for(int i = 0;i < self.scoreLengh;i ++)
        {
            //tempTexture = scoreTextures[10][0][0];
            tempTexture = [[scoreTextures objectAtIndex:10] objectAtIndex:0];
            [self.scoreSprites addObject: [SKSpriteNode spriteNodeWithTexture:tempTexture]];
            //[scorePositions addObject: CGPointMake(pX, pY)];
        }
        
        return self;
    }
    return nil;
}

+(ScoreSprite *) newWithAlloc : (float)pX : (float) pY : (float) spriteWidth
{
    // TODO Auto-generated constructor stub
    
    SKTexture *tempTexture;
    SKSpriteNode *tSprite;
    
    SKTextureAtlas *scoreImages = [SKTextureAtlas atlasNamed:@"Score"];
    int numImages = (int)scoreImages.textureNames.count;
    
    scoreTextures = [NSMutableArray array];
    for (int i=0; i < numImages; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"b%02d", i];
        tempTexture = [scoreImages textureNamed:textureName];
        
        NSMutableArray* tTextures = [NSMutableArray arrayWithObject:tempTexture];
        [scoreTextures addObject:tTextures];
    }
    
    ScoreSprite * retSprite = [[ScoreSprite alloc] init];
    [retSprite setPosition: pX : pY];
    
    tSprite = retSprite.scoreSprites[0];
    retSprite.mmW = spriteWidth;
    retSprite.mmH = spriteWidth / tSprite.size.width * tSprite.size.height;
    
    for (int i = 0; i < retSprite.scoreLengh; i ++)
    {
        tSprite = retSprite.scoreSprites[i];
        [tSprite setSize:CGSizeMake(retSprite.mmW, retSprite.mmH)];
    }
    
    [retSprite updateScore];
    [retSprite displayNumberOn:false];
    
    return retSprite;
}

-(void) setPosition: (float) pX : (float) pY
{
    SKSpriteNode *tSprite;
    
    self.mmX = pX;
    self.mmY = pY;
    
    int tLengh = 1;
    int tValue = self.scoreValue;
    while(tValue /= 10)
    {
        tLengh ++;
    }
    
    switch(self.mAlign)
    {
        case modeCenter:
        {
            for (int i = 0; i < tLengh; i ++)
            {
                tSprite = self.scoreSprites[i];
                
                [tSprite setPosition:CGPointMake(self.mmX + ((tLengh - 1) / 2 - i) * (SCORE_DIS + 1) * self.mmW, self.mmY)];
            }
            break;
        }
        case modeRight:
        {
            break;
        }
        case modeLeft:
        {
            for (int i = 0; i < tLengh; i ++)
            {
                tSprite = self.scoreSprites[i];
                
                [tSprite setPosition:CGPointMake(self.mmX + (tLengh - 1 - i) * (SCORE_DIS + 1) * self.mmW, self.mmY)];
            }
            break;
        }
        default:
        {
            break;
        }
    }
}

-(void) setScore:(int) num
{
    if(num < 0) self.scoreValue = -num;
    else self.scoreValue = num;
    //if((mSound != null) && (self.scoreValue != 0)) mSound.play();
    [self updateScore];
}

-(void) updateScore
{
    SKTexture *tempTexture;
    SKSpriteNode *tSprite;
    int singleScore;
    
    [self setPosition : self.mmX : self.mmY];
    
    int i = 0;
    for(int tNum = self.scoreValue;(i < self.scoreLengh) && (tNum != 0);i ++)
    {
        singleScore = tNum % 10;
        tNum /= 10;
        
        tempTexture = scoreTextures[singleScore][0];
        tSprite = self.scoreSprites[i];
        [tSprite setTexture : tempTexture];
    }
    for(int j = i;j < self.scoreLengh;j ++)
    {
        if(j == 0) singleScore = 0;
        else singleScore = 10;
        tempTexture = scoreTextures[singleScore][0];
        tSprite = self.scoreSprites[j];
        [tSprite setTexture : tempTexture];
    }
}

-(void) displayNumberOn:(bool) onoff
{
    SKSpriteNode *tSprite;
    self.mOnOff = onoff;
    
    for(int i = 0;i < self.scoreLengh;i ++)
    {
        tSprite = self.scoreSprites[i];
        [tSprite setScale:self.mOnOff ? 1 : 0];
    }
}

-(void) setAlign : (enum ScoreAlignMode) mAlign
{
    self.mAlign = mAlign;
}

-(float) getWidth
{
    return self.mmW;
}

-(float) getHeight
{
    return self.mmH;
}

/*public int getScore()
{
    return scoreValue;
}

public void setSound(Sound mSound)
{
    this.mSound = mSound;
}
*/
@end
