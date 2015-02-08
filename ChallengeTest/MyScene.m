//
//  MyScene.m
//  ChallengeTest
//
//  Created by YinYanhui on 14-11-13.
//  Copyright (c) 2014年 YinYanhui. All rights reserved.
//

#import "MyScene.h"

#define BACK_R (231.0 / 255.0)
#define BACK_G (176.0 / 255.0)
#define BACK_B (69.0 / 255.0)
#define BACK_A 1.0

#define UNDO_W 0.2
#define UNDO_H 0.15
#define UNDO_SIZE 0.08

#define REFRASH_W 0.8
#define REFRASH_H 0.15
#define REFRASH_SIZE 0.08

#define FROG_W 0.5
#define FROG_H 0.2
#define FROG_SIZE 0.3

#define SCORE_W 0.5
#define SCORE_H 0.25
#define SCORE_SIZE 0.05

#define BOARD_WIDTH 1.1

@implementation MyScene

ChickenBoard *mBoard;
NSMutableArray *mBoardList;
NSMutableArray *mChickenList;
float FrogX, FrogY;
FrogSprite *mFrog;
SKSpriteNode *spriteUndo;
SKSpriteNode *spriteRefrash;

SKSpriteNode *touchedNode;
ScoreSprite* spriteScore;

UIAlertView *alert;

NSString *APP_ID = @"wx4f061aef80859fd3";

-(id)initWithSize:(CGSize)size : (int)frameIndex
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed: BACK_R green: BACK_G blue: BACK_B alpha:BACK_A];
        
        float boardWidth;
        float x0, y0;
        float frameWidth = self.frame.size.width;
        float frameHeight = self.frame.size.height;
        float dW;
        
        if (frameWidth > frameHeight)
        {
            dW = frameHeight * (1 - BOARD_WIDTH);
            
            x0 = frameWidth - frameHeight + dW / 2;
            y0 = 0 + dW / 2;
            boardWidth = frameHeight - dW;
        }
        else
        {
            dW = frameWidth * (1 - BOARD_WIDTH);
            
            y0 = frameHeight - frameWidth + dW / 2;
            x0 = 0 + dW / 2;
            boardWidth = frameWidth - dW;
        }
        //boardWidth *= 0.5;
        
        spriteUndo = [SKSpriteNode spriteNodeWithImageNamed:@"button1.png"];
        [spriteUndo setPosition:CGPointMake(frameWidth * UNDO_W, frameHeight * UNDO_H)];
        [spriteUndo setName:@"Undo"];
        //float t_scale = spriteUndo.size.width / boardWidth;
        [spriteUndo setScale:boardWidth * UNDO_SIZE / spriteUndo.size.height];
        [self addChild:spriteUndo];
        
        SKLabelNode *labelUndo = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelUndo.name = @"Undo";
        labelUndo.text = @"后退一步";
        labelUndo.fontSize = 20;
        labelUndo.fontColor = [SKColor blackColor];
        labelUndo.position = CGPointMake(0, spriteUndo.size.height/2 * -0.2);
        [spriteUndo addChild:labelUndo];
        
        spriteRefrash = [SKSpriteNode spriteNodeWithImageNamed:@"button2.png"];
        [spriteRefrash setPosition:CGPointMake(frameWidth * REFRASH_W, frameHeight * REFRASH_H)];
        [spriteRefrash setName:@"Refrash"];
        [spriteRefrash setScale:boardWidth * REFRASH_SIZE / spriteRefrash.size.height];
        [self addChild:spriteRefrash];
        
        SKLabelNode *labelRefrash = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        labelRefrash.name = @"Refrash";
        labelRefrash.text = @"重新开始";
        labelRefrash.fontSize = 20;
        labelRefrash.fontColor = [SKColor blackColor];
        labelRefrash.position = CGPointMake(0, spriteUndo.size.height/2 * -0.2);
        [spriteRefrash addChild:labelRefrash];
        
        FrogX = frameWidth * FROG_W;
        FrogY = frameHeight * FROG_H;
        mFrog = [FrogSprite newWithAlloc:boardWidth * FROG_SIZE];
        [mFrog setPosition:CGPointMake(FrogX, FrogY)];
        [mFrog performFrogBlink];
        [mFrog setZPosition:2];
        [mFrog setName:@"Frog"];
        [self addChild:mFrog];
        
        _sChicken = nil;
        
        mBoardList = [NSMutableArray array];
        [mBoardList addObject: [ChickenBoard newWithValue : x0 : y0 : boardWidth : frameIndex]];
        
        mChickenList = [NSMutableArray array];
		
		for(int i = 0; i < ROWNUM * ROWNUM; i ++)
		{
            ChickenBoard *tBoard = mBoardList[0];
            ChickenNode *tNode = [[tBoard.mNode objectAtIndex:i / ROWNUM] objectAtIndex: i % ROWNUM];
            
            [mChickenList addObject:[ChickenSprite newWithAlloc : tNode->w]];
            [mChickenList[i] setPosition:CGPointMake(tNode->x, tNode->y)];
            [mChickenList[i] setStatus: tNode->v];
            [mChickenList[i] updateNodePos: tNode->x: tNode->y];
            
            [self addChild:mChickenList[i]];
        }
        
        spriteScore = [ScoreSprite newWithAlloc:frameWidth * SCORE_W: frameHeight * SCORE_H :frameWidth * SCORE_SIZE];
        for (int i = 0; i < spriteScore.scoreLengh; i ++)
        {
            [self addChild:spriteScore.scoreSprites[i]];
        }
        [spriteScore setScore:0];
        [spriteScore displayNumberOn:true];
        
        [WXApi registerApp:APP_ID withDescription:@"智商大挑战"];
        
        /*Class cls = NSClassFromString(@"UMANUtil");
        SEL deviceIDSelector = @selector(openUDIDString);
        NSString *deviceID = nil;
        if(cls && [cls respondsToSelector:deviceIDSelector]){
            deviceID = [cls performSelector:deviceIDSelector];
        }
        NSLog(@"{\"oid\": \"%@\"}", deviceID);*/
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    ChickenSprite *tChicken;
    
    for (UITouch *touch in touches)
    {
        mBoard = mBoardList[[mBoardList count] - 1];
        CGPoint touchPoint = [touch locationInNode:self];
        float tx = touchPoint.x;
        float ty = touchPoint.y;
        ChickenNode *tNode = [mBoard getNode: tx : ty];

        if((tNode->v != 2) && (tNode->v != 0))
        {
            for(int i = 0; i < ROWNUM * ROWNUM; i ++)
            {
                tChicken = [mChickenList objectAtIndex:i];
                if((tChicken->orgX == tNode->x) && (tChicken->orgY == tNode->y))
                {
                    _sChicken = tChicken;
                }
            }
            _sChicken->beSelected = true;
            [_sChicken setZPosition:1];
        }
        else
        {
            touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchPoint];
            //NSLog(@"x=%f,y=%f,Sprite=%@",touchPoint.x,touchPoint.y,touchedNode.name);
        }
        
        return;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    ChickenSprite *tChicken;
    
    for (UITouch *touch in touches)
    {
        CGPoint touchPoint = [touch locationInNode:self];
        float tx = touchPoint.x;
        float ty = touchPoint.y;
        
        mBoard = mBoardList[[mBoardList count] - 1];
        if(_sChicken != nil && (_sChicken->beSelected))
        {
            ChickenNode *sNode = [mBoard getNode : _sChicken->orgX : _sChicken->orgY];
            ChickenNode *dNode = [mBoard getNode : tx : ty];
            ChickenNode *midNode = [mBoard getNode : (sNode->x + dNode->x) / 2: (sNode->y + dNode->y) / 2];
            
            int dx = (midNode->x - sNode->x) / sNode->w;
            int dy = (midNode->y - sNode->y) / sNode->w;
            
            [_sChicken setPosition : touchPoint];
            
            if(abs(dx) > abs(dy))
            {
                dy = 0;
                
                if(dx > 1)
                {
                    dx = 1;
                }
                else if(dx < -1)
                {
                    dx = -1;
                }
            }
            else
            {
                dx = 0;
                
                if(dy > 1)
                {
                    dy = 1;
                }
                else if(dy < -1)
                {
                    dy = -1;
                }
            }
            
            midNode = [mBoard getNode : sNode->x + dx * sNode->w : sNode->y + dy * sNode->w];
            dNode = [mBoard getNode : midNode->x * 2 - sNode->x : midNode->y * 2 - sNode->y];
            
            if((midNode->v == 1) && (dNode->v == 0))
            {
                int m;
                for(m = 0;m < ROWNUM * ROWNUM ;m ++)
                {
                    tChicken = [mChickenList objectAtIndex : m];
                    if((tChicken->orgX == midNode->x) && (tChicken->orgY == midNode->y))
                    {
                        [tChicken setHovered : true];
                        break;
                    }
                }
                
                return ;
            }
            
            for(int m = 0;m < ROWNUM * ROWNUM ; m ++)
            {
                tChicken = [mChickenList objectAtIndex : m];
                [tChicken setHovered : false];
            }
            
            return;
        }
        else
        {
            //////////////////////////////////////////////////////
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        ChickenSprite *tChicken;
        
        CGPoint touchPoint = [touch locationInNode:self];
        float tx = touchPoint.x;
        float ty = touchPoint.y;
        
        [_sChicken setZPosition:0];
        
        ChickenBoard *tBoard = mBoardList[[mBoardList count] - 1];
        mBoard = [ChickenBoard newWithValue: tBoard];
        if(_sChicken != nil && (_sChicken->beSelected))
        {
            _sChicken->beSelected = false;
            
            ChickenNode *sNode = [mBoard getNode : _sChicken->orgX : _sChicken->orgY];
            ChickenNode *dNode = [mBoard getNode : tx : ty];
            ChickenNode *midNode = [mBoard getNode : (sNode->x + dNode->x) / 2: (sNode->y + dNode->y) / 2];
            
            int dx = (midNode->x - sNode->x) / sNode->w;
            int dy = (midNode->y - sNode->y) / sNode->w;
            
            //if(!((dNode.x != sNode.x) && (dNode.y != sNode.y)))//
            {
                if(abs(dx) > abs(dy))
                {
                    dy = 0;
                    
                    if(dx > 1)
                    {
                        dx = 1;
                    }
                    else if(dx < -1)
                    {
                        dx = -1;
                    }
                }
                else
                {
                    dx = 0;
                    
                    if(dy > 1)
                    {
                        dy = 1;
                    }
                    else if(dy < -1)
                    {
                        dy = -1;
                    }
                }
                midNode = [mBoard getNode : sNode->x + dx * sNode->w : sNode->y + dy * sNode->w];
                dNode = [mBoard getNode : midNode->x * 2 - sNode->x : midNode->y * 2 - sNode->y];
                
                if((midNode->v == 1) && (dNode->v == 0))
                {
                    for(int m = 0;m < ROWNUM * ROWNUM ; m ++)
                    {
                        tChicken = [mChickenList objectAtIndex : m];
                        [tChicken setHovered : false];
                    }
                    
                    for(int m = 0;m < ROWNUM * ROWNUM ; m ++)
                    {
                        tChicken = [mChickenList objectAtIndex : m];
                        if((tChicken->orgX == midNode->x) && (tChicken->orgY == midNode->y))
                        {
                            [tChicken setZPosition:1];
                            [tChicken setHovered:true];
                            
                            [self chickenMove: FrogX : FrogY : 0.5f : tChicken];
                            [mFrog performFrogEat];
                            
                            midNode->v = 0;
                            break;
                        }
                    }
                    
                    for(int m = 0;m < ROWNUM * ROWNUM ; m ++)
                    {
                        tChicken = [mChickenList objectAtIndex : m];
                        
                        if((tChicken->orgX == dNode->x) && (tChicken->orgY == dNode->y))
                        {
                            [tChicken updateNodePos:sNode->x : sNode->y];
                            sNode->v = 0;
                            
                            break;
                        }
                    }
                    
                    [_sChicken updateNodePos : dNode->x : dNode->y];
                    dNode->v = 1;
                    _sChicken = nil;
                    
                    [mBoardList addObject: mBoard];
                    
                    //mHandler1.post(new Thread(mScoreRunnable));
                    [spriteScore setScore:(int)(mBoardList.count - 1)];
                    
                    if(![mBoard findAvailableMoves])
                    {
                        NSLog(@"No Available Moves!");
                        //mHandler.post(new Thread(mGameOverRunnable));
                        //SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
                        //SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:CGSizeMake(self.size.width / 2, self.size.height / 2)];
                        //[self.view presentScene:gameOverScene transition: reveal];
                        
                        [self ShowMessage : @"啊哦！已经没有可以吃到的小黄鸡啦" msg : @""];
                    }
         ;           return;
                }
            }
            
            [_sChicken restoreNodePos];
            _sChicken = nil;
            return;
        }
        else
        {
            SKSpriteNode *touchedNode0 = (SKSpriteNode *)[self nodeAtPoint:touchPoint];
            if ([touchedNode0.name isEqual: touchedNode.name])
            {
                if ([touchedNode.name  isEqual: @"Undo"])
                {
                    [self unDo];
                }
                else if ([touchedNode.name  isEqual: @"Refrash"])
                {
                    [self reFresh];
                }
            }
            return;
        }
    }
}

-(void)chickenMove :(float) x : (float) y : (float) d : (ChickenSprite*) tChicken
{
    NSThread* myThread;
    myThread = [[NSThread alloc] initWithTarget:self
                                       selector:@selector(performMoveEnd:)
                                         object:tChicken];
    
    [tChicken runAction:[SKAction playSoundFileNamed:@"Fly151.mp3" waitForCompletion:NO]];
    
    SKAction *moveAction = [SKAction moveTo:CGPointMake(x, y) duration:d];
    SKAction *doneAction = [SKAction runBlock:(dispatch_block_t)^()
                            {
                                [myThread start]; //启动线程
                            }];
    SKAction *moveActionWithDone = [SKAction sequence:@[moveAction,doneAction ]];
    [tChicken runAction:moveActionWithDone withKey:@"chickenMoving"];
}

-(void)performMoveEnd : (ChickenSprite*) tChicken
{
    [tChicken setStatus:0];
    [tChicken setZPosition:0];
    [tChicken setHovered:false];
    [tChicken restoreNodePos];
}

-(void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

-(bool) unDo
{
    if(mBoardList.count > 1)
    {
        [mBoardList removeObjectAtIndex:mBoardList.count - 1];
        
        ChickenBoard* tBoard = [mBoardList objectAtIndex: mBoardList.count - 1];
        
		for(int i = 0; i < ROWNUM * ROWNUM; i ++)
		{
            ChickenNode *tNode = [[tBoard.mNode objectAtIndex:i / ROWNUM] objectAtIndex: i % ROWNUM];
            
            [mChickenList[i] setStatus: tNode->v];
            [mChickenList[i] restoreNodePos: tNode->x: tNode->y];
            [mChickenList[i] setZPosition:1];
            [mChickenList[i] setZPosition:0];
        }
        
        //mHandler1.post(new Thread(mScoreRunnable));
        [spriteScore setScore : (int)(mBoardList.count - 1)];
        return true;
    }
    else return false;
}

-(void) reFresh
{
    while ([self unDo]);
}

-(void)ShowMessage:(NSString *) title msg:(NSString *) message
{
    alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"微信炫(求)耀(助)"
                                          otherButtonTitles:@"后退一步试试？", nil];
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"Button %d pressed",buttonIndex);
    if (buttonIndex == 0)
    {
        //"ShareToWX", "OnShare" + (mBoardList.size() - 1)
        NSMutableString *t_evnt = [NSMutableString stringWithFormat:@"OnShare%d",(int)(mBoardList.count - 1)];
        [MobClick event:@"ShareToWX" label:t_evnt];
        [self sendLinkContent];
    }
    else if (buttonIndex == 1)
    {
        [self unDo];
    }
}

- (void) sendTextContent
{
    //SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"人文的东西并不是体现在你看得到的方面，它更多的体现在你看不到的那些方面，它会影响每一个功能，这才是最本质的。但是，对这点可能很多人没有思考过，以为人文的东西就是我们搞一个很小清新的图片什么的。”综合来看，人文的东西其实是贯穿整个产品的脉络，或者说是它的灵魂所在。";
    req.bText = YES;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void) sendLinkContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    
    NSMutableString *ts;
    if (mBoardList.count - 1 < 30)
    {
        ts = [NSMutableString stringWithFormat:@"还有%d只小黄鸡吃不到，智商被鄙视了！",(int)(31 - mBoardList.count)];
    }
    else
    {
        ts = [NSMutableString stringWithFormat:@"我吃光了所有小黄鸡！对自己智商自信满满！"];
    }
    message.title = ts;
    message.description = @"吃掉小黄鸡，智商大挑战！";
    [message setThumbImage:[UIImage imageNamed:@"xiaoji05.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.redstone9910.AccountingPractice";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

@end
