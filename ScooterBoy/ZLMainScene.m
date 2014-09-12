//
//  ZLMainScene.m
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "ZLMainScene.h"
#import "ZLHistoryManager.h"
#import "SKSharedAtles.h"
#import "ZLCoinNode.h"
#import "ZLAudioPlayer.h"
#import <GameKit/GameKit.h>


#define BIRD_ANCHOR_POINT       0.75f
#define DEFAULT_VELOCITY        (300)//(-200)
#define VELOCITY_CHANGE_DELTA   (10)//(15)

#define OBSTACLE_WIDTH                  60//  60//障碍宽度

#define   COIN_ZPOSITION            1

#define BACKGROUND_HEIGHT           48//51//  60//地板高度

@implementation ZLMainScene

- (instancetype)initWithSize:(CGSize)size{
    
    self = [super initWithSize:size];
    if (self) {
        
        [self initGameParams];
        [self initPhysicsWorld];
        [self initBackground];
        [self initWorldBorder];
        [self initAction];
        [self initScroe];
        [self initPlayerBird];
        [self startPlayerBirdAction];
        [self initStartLabel:YES];
        [self initAudio];
    }
    return self;
}

-(void)restartNotification
{
    [self initGameParams];
    for (SKNode *child in [self children]) {
        if (child.zPosition!=0) {
            [child removeFromParent];
        }
    }
    [self removeAllActions];
    //[self removeAllChildren];
    //[self initBackground];
    [self initScroe];
    [self initPlayerBird];
    [self startPlayerBirdAction];
    [self initStartLabel:YES];
}

//初设游戏参数
-(void)initGameParams
{
    _bGameOver=YES;
    //int _maxYWallCount=((CGRectGetMaxX(self.frame)-80)/OBSTACLE_WIDTH);
    //ZLTRACE(@"maxYWallCount:%d",_maxYWallCount);
    _obstacleGenerateDuration=60;
    _coinGenerateDuration=20;
    [self resetGameMusic];
    [self resetParams];
}

-(void)resetGameMusic
{
    _bPlayVoice=[ZLHistoryManager voiceOpened];
}

//重置参数
-(void)resetParams
{
    _heroBlood=1;
    _obstacleGenerateTimer=-1;
    _coinGenerateTimer=-10;
//    _curGold=0;//[ZLHistoryManager getLastScore];
//    _recordGold=[ZLHistoryManager getMaxGold];
}

-(void)onTapStartGame
{
    [self resetParams];
    for (SKNode *child in [self children]) {
        if (child.zPosition!=0) {
            [child removeFromParent];
        }
    }
    //[self removeAllChildren];
    [self removeAllActions];
    //[self initBackground];
    [self initScroe];
    [self initPlayerBird];
    //_playerHero.physicsBody.velocity=CGVectorMake(0, _birdVelocity);
    self.physicsWorld.speed=1.0;
    _bGameOver=NO;
    //[_playerHero runAction:[SKSharedAtles playerAction] withKey:@"playerAction"];
    //self.physicsWorld.gravity=CGVectorMake(0, DEFAULT_GRAVITY+_forceGravity);
}

- (void)initPhysicsWorld{
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0,0);
}

-(void)initAudio
{
    //waitForCompletion 音效动作是否和音效长度一样
    //捡到金币
    _playGoldAudio=[SKAction playSoundFileNamed:@"sound_good.mp3" waitForCompletion:NO];
    //拍翅膀
    _playFlapAudio=[SKAction playSoundFileNamed:@"wingflap.mp3" waitForCompletion:NO];
    
    //碰到墙壁
    _playHitAudio=[SKAction playSoundFileNamed:@"die.mp3" waitForCompletion:YES];
    //碰到炸弹
    //_playBombAudio=[SKAction playSoundFileNamed:@"bomb.mp3" waitForCompletion:YES];
    //_playNewRecordAudio=[SKAction playSoundFileNamed:@"select.mp3" waitForCompletion:NO];
}

- (void)initBackground{
    _adjustmentBackgroundPosition = self.size.width;
    
    SKTexture *layer1Texture=[SKSharedAtles textureWithType:SKTextureTypeBackLayer1];
    _adjustmentBackLayer1Position=layer1Texture.size.width;
    SKTexture *layer2Texture=[SKSharedAtles textureWithType:SKTextureTypeBackLayer2];
    _adjustmentBackLayer2Position=layer2Texture.size.width;
    SKTexture *groundTexture=[SKSharedAtles textureWithType:SKTextureTypeBackground];
    
    _backLayer3 = [SKSpriteNode spriteNodeWithTexture:layer2Texture];
    _backLayer3.position = CGPointMake(_adjustmentBackLayer2Position-layer2Texture.size.width, groundTexture.size.height+20);
    _backLayer3.anchorPoint = CGPointMake(0, 0);
    _backLayer3.zPosition = 0;
    
    _backLayer4 = [SKSpriteNode spriteNodeWithTexture:layer2Texture];
    _backLayer4.anchorPoint = CGPointMake(0, 0);
    _backLayer4.position = CGPointMake(_adjustmentBackLayer2Position-1, groundTexture.size.height+20);
    _backLayer4.zPosition = 0;
    
    [self addChild:_backLayer3];
    [self addChild:_backLayer4];
    
    
    _backLayer1 = [SKSpriteNode spriteNodeWithTexture:layer1Texture];
    _backLayer1.position = CGPointMake(_adjustmentBackLayer1Position-layer1Texture.size.width, groundTexture.size.height);
    _backLayer1.anchorPoint = CGPointMake(0, 0);
    _backLayer1.zPosition = 0;
    
    _backLayer2 = [SKSpriteNode spriteNodeWithTexture:layer1Texture];
    _backLayer2.anchorPoint = CGPointMake(0, 0);
    _backLayer2.position = CGPointMake(_adjustmentBackLayer1Position-1, groundTexture.size.height);
    _backLayer2.zPosition = 0;
    
    [self addChild:_backLayer1];
    [self addChild:_backLayer2];
    
    
    // [self runAction:[SKAction repeatActionForever:[SKAction playSoundFileNamed:@"game_music.mp3" waitForCompletion:YES]]];
    
    
    _groundNode1=[SKSpriteNode spriteNodeWithTexture:groundTexture];
    _groundNode1.position=CGPointMake(_adjustmentBackgroundPosition-groundTexture.size.width, groundTexture.size.height/2);
    _groundNode1.anchorPoint=CGPointMake(0, 0.5);
    _groundNode1.zPosition=0;

    [self addChild:_groundNode1];
    
    _groundNode2=[SKSpriteNode spriteNodeWithTexture:groundTexture];
    _groundNode2.position=CGPointMake(_adjustmentBackgroundPosition-1, groundTexture.size.height/2);
    _groundNode2.anchorPoint=CGPointMake(0, 0.5);
    _groundNode2.zPosition=0;
    [self addChild:_groundNode2];
    /*
    
    SKTexture *groundTexture=[SKSharedAtles textureWithType:SKTextureTypeBackground];
    _adjustmentBackgroundPosition=self.size.width;
    
   
    _groundNode1=[SKSpriteNode spriteNodeWithTexture:groundTexture];
    _groundNode1.position=CGPointMake(0, _adjustmentBackgroundPosition);
    _groundNode1.anchorPoint=CGPointMake(0, 1);
    _groundNode1.zPosition=0;
    [self addChild:_groundNode1];
    
    _groundNode2=[SKSpriteNode spriteNodeWithTexture:groundTexture];
    _groundNode2.position=CGPointMake(0, _adjustmentBackgroundPosition+self.size.width-1);
    _groundNode2.anchorPoint=CGPointMake(0, 1);
    _groundNode2.zPosition=0;
    [self addChild:_groundNode2];
     */
}

- (void)initAction{
    _HeroAction = [SKSharedAtles playerAction];
    _coinRotateAction = [SKSharedAtles coinRotateAction];
}

- (void)scrollBackgroundWithTime:(NSTimeInterval)currentTime{
    _adjustmentBackgroundPosition -=7;
    _adjustmentBackLayer1Position -=5;
    _adjustmentBackLayer2Position -=2;
    if (_adjustmentBackgroundPosition <= 0)
    {
        _adjustmentBackgroundPosition = self.size.width;
    }
    if (_adjustmentBackLayer1Position<=0) {
        _adjustmentBackLayer1Position=_backLayer1.size.width;
    }
    if (_adjustmentBackLayer2Position<=0) {
        _adjustmentBackLayer2Position=_backLayer3.size.width;
    }
    float layer1YPosition=_backLayer1.position.y;
    float layer2YPosition=_backLayer3.position.y;
    float groundYPosition=_groundNode1.position.y;
    [_backLayer1 setPosition:CGPointMake(_adjustmentBackLayer1Position - _backLayer1.size.width, layer1YPosition)];
    [_backLayer2 setPosition:CGPointMake(_adjustmentBackLayer1Position-1, layer1YPosition)];
    [_backLayer3 setPosition:CGPointMake(_adjustmentBackLayer2Position - _backLayer3.size.width, layer2YPosition)];
    [_backLayer4 setPosition:CGPointMake(_adjustmentBackLayer2Position-1, layer2YPosition)];
    [_groundNode1 setPosition:CGPointMake(_adjustmentBackgroundPosition - self.size.width, groundYPosition)];
    [_groundNode2 setPosition:CGPointMake(_adjustmentBackgroundPosition-1, groundYPosition)];
}

-(void)initWorldBorder
{
    //上边界
    /*
    SKSpriteNode *topBorderLine = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(self.size.width, 2)];
    topBorderLine.zPosition = 0;
    topBorderLine.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMaxY(self.frame)+OBSTACLE_WIDTH);
    topBorderLine.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:topBorderLine.size];
    topBorderLine.physicsBody.mass=1;
    // wallLine.physicsBody.affectedByGravity=NO;
    topBorderLine.physicsBody.dynamic=NO;
    topBorderLine.physicsBody.restitution=0;
    topBorderLine.physicsBody.categoryBitMask = SKRoleCategoryBorder;
    topBorderLine.physicsBody.collisionBitMask=0;
    topBorderLine.physicsBody.contactTestBitMask = SKRoleCategoryCoin|SKRoleCategoryWall;
    [self addChild:topBorderLine];
    */
    //左边界
    /*
    SKSpriteNode *leftBorderLine = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(2, self.size.height)];
    leftBorderLine.zPosition = 0;
    leftBorderLine.position = CGPointMake(CGRectGetMinX(self.frame)+LEFT_MARGIN-3,CGRectGetMidY(self.frame));
    leftBorderLine.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:leftBorderLine.size];
    leftBorderLine.physicsBody.mass=1;
    // wallLine.physicsBody.affectedByGravity=NO;
    leftBorderLine.physicsBody.dynamic=NO;
    leftBorderLine.physicsBody.restitution=0;
    leftBorderLine.physicsBody.categoryBitMask = SKRoleCategoryBorder;
    leftBorderLine.physicsBody.collisionBitMask=0;
    leftBorderLine.physicsBody.contactTestBitMask = SKRoleCategoryCoin|SKRoleCategoryWall|SKRoleCategoryHero;
    [self addChild:leftBorderLine];
    
    //右边界
    SKSpriteNode *rightBorderLine = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(2, self.size.height)];
    rightBorderLine.zPosition = 0;
    rightBorderLine.position = CGPointMake(CGRectGetMaxX(self.frame)-LEFT_MARGIN+3,CGRectGetMidY(self.frame));
    rightBorderLine.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:rightBorderLine.size];
    rightBorderLine.physicsBody.mass=1;
    // wallLine.physicsBody.affectedByGravity=NO;
    rightBorderLine.physicsBody.dynamic=NO;
    rightBorderLine.physicsBody.restitution=0;
    rightBorderLine.physicsBody.categoryBitMask = SKRoleCategoryBorder;
    rightBorderLine.physicsBody.collisionBitMask=0;
    rightBorderLine.physicsBody.contactTestBitMask = SKRoleCategoryCoin|SKRoleCategoryWall|SKRoleCategoryHero;
    [self addChild:rightBorderLine];
     */
}

- (void)initStartLabel:(BOOL)firsttime
{
    SKLabelNode *_startLabel = [SKLabelNode labelNodeWithFontNamed:ZL_DEFAULT_FONT_NAME];
    _startLabel.text = firsttime?@"Tap to Start":@"Tap to Restart";
    _startLabel.name=@"startLabel";
    _startLabel.zPosition = 4;
    _startLabel.fontColor = ZL_HEADVIEW_TEXTCOLOR;//HEXCOLOR(0x362e2b);///HEXCOLOR(0xe6b003);//HEXCOLOR(0x552d19);//[SKColor brownColor];
    _startLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _startLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:_startLabel];
    [_startLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:1],[SKAction waitForDuration:0.1],[SKAction fadeInWithDuration:1.5],[SKAction waitForDuration:0.1]]]]];
}

- (void)initScroe{
    _curGold=0;
    _recordGold=[ZLHistoryManager getMaxGold];
    _goldLabel = [SKLabelNode labelNodeWithFontNamed:ZL_DEFAULT_FONT_NAME];
    
    _goldLabel.zPosition = 4;
    _goldLabel.fontSize=ZL_MIDDLE_FONT_SIZE;
    _goldLabel.fontColor = ZL_HEADVIEW_TEXTCOLOR;//HEXCOLOR(0xe6b003);//[SKColor whiteColor];
    _goldLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    //_pointLabel.position = CGPointMake(60 , self.size.height - 50);
    _goldLabel.position = CGPointMake(5 , self.size.height - 40);
    [self addChild:_goldLabel];
    
    _recordGoldLabel = [SKLabelNode labelNodeWithFontNamed:ZL_DEFAULT_FONT_NAME];//@"Chalkduster"
    
    _recordGoldLabel.zPosition = 4;
    _recordGoldLabel.fontColor = ZL_HEADVIEW_TEXTCOLOR;//HEXCOLOR(0xe6b003);//[SKColor whiteColor];
    _recordGoldLabel.fontSize=ZL_MIDDLE_FONT_SIZE;
    _recordGoldLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _recordGoldLabel.position = CGPointMake(CGRectGetMidX(self.frame)+20 , self.size.height - 40);
    //_historyPointLabel.position = CGPointMake(CGRectGetMidX(self.frame)+60 , self.size.height - 50);
    [self addChild:_recordGoldLabel];
    
    [self setCurrentPointLabel];
    [self setHistoryPointLabel];
    
    /*
     _goldsLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
     _goldsLabel.text = [NSString stringWithFormat:@"Coins:%d",_curGolds];
     _goldsLabel.zPosition = 4;
     _goldsLabel.fontSize=14;
     _goldsLabel.fontColor = HEXCOLOR(0x362e2b);//HEXCOLOR(0xe6b003);//[SKColor whiteColor];
     _goldsLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
     _goldsLabel.position = CGPointMake(15 , self.size.height - 45);
     [self addChild:_goldsLabel];
     */
}

-(void)setCurrentPointLabel
{
    _goldLabel.text = [NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"Gold", nil),_curGold];
}

-(void)setHistoryPointLabel
{
    _recordGoldLabel.text = [NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"Record", nil),_recordGold];
}

- (void)initPlayerBird{
    
    _playerHero = [SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeHero]];
    _playerHero.position =  CGPointMake(CGRectGetMidX(self.frame),CGRectGetMinY(self.frame)+BACKGROUND_HEIGHT+_playerHero.size.height/2);//CGPointMake(160, 300);
    _playerHero.zPosition = 2;
    _playerHero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeApplyAffineTransform(_playerHero.size, CGAffineTransformMakeScale(0.8, 0.8))];
    //_playerHero.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:_playerHero.size.width/3];
    _playerHero.physicsBody.categoryBitMask = SKRoleCategoryHero;
    _playerHero.physicsBody.mass=1;
    _playerHero.physicsBody.collisionBitMask = SKRoleCategoryObstacle;
    _playerHero.physicsBody.contactTestBitMask = SKRoleCategoryObstacle|SKRoleCategoryCoin;
    [self addChild:_playerHero];
    //[_playerHero runAction:[SKSharedAtles playerAction]];
}

-(void)startPlayerBirdAction
{
    //[_playerHero runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction moveByX:0 y:15 duration:0.5],[SKAction waitForDuration:0.1],[SKAction moveByX:0 y:-30 duration:1],[SKAction waitForDuration:0.1],[SKAction moveByX:0 y:15 duration:0.5]]]]];
}

-(SKSpriteNode *)createObstacle
{
    //int wallCount= (arc4random() % _maxYWallCount);
    
    //wallHeight=(CGRectGetHeight(self.frame)-wallCount*OBSTACLE_WIDTH-_wallGapHeight-BACKGROUND_HEIGHT);
    // int _bombYPosition=(arc4random() % (lround(CGRectGetHeight(self.frame)-100-BACKGROUND_HEIGHT))) + 100;
    //int _wallXPosition=CGRectGetMinX(self.frame)+(wallPos+0.5f)*OBSTACLE_WIDTH;
    //ZLTRACE(@"wallCount:%d wallYPosition:%d",wallPos,_wallYPosition);
    //int y2Position=CGRectGetMaxY(self.frame)-wallHeight+OBSTACLE_WIDTH/2;
    SKSpriteNode *wallSprite=[SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeObstacle]];
    wallSprite.anchorPoint=CGPointMake(0.5, 0.5);
    wallSprite.position=CGPointMake(CGRectGetWidth(self.frame)+wallSprite.size.width/2, CGRectGetMinY(self.frame)+BACKGROUND_HEIGHT+wallSprite.size.height/2);
    wallSprite.zPosition=COIN_ZPOSITION;
    
    wallSprite.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:wallSprite.size];
    wallSprite.physicsBody.allowsRotation=NO;
    wallSprite.physicsBody.linearDamping=0.0;
    wallSprite.physicsBody.mass=10000;
    wallSprite.physicsBody.affectedByGravity=NO;
    wallSprite.physicsBody.categoryBitMask=SKRoleCategoryObstacle;
    //bombSprite.physicsBody.collisionBitMask = SKRoleCategoryHero;
    wallSprite.physicsBody.contactTestBitMask=SKRoleCategoryHero;
    //wallSprite.physicsBody.dynamic=NO;
    wallSprite.physicsBody.restitution=0;
    
    return wallSprite;
}

-(ZLCoinNode *)createCoin
{
    ZLCoinNode *coinSprite=[ZLCoinNode createCoinWithType:SKTextureTypeCoin];
     int _coinYPosition=CGRectGetMinY(self.frame)+BACKGROUND_HEIGHT+_playerHero.size.height+10+coinSprite.size.height/2+(arc4random()%lround(CGRectGetHeight(self.frame)-BACKGROUND_HEIGHT-coinSprite.size.height-_playerHero.size.height-40));
    //int _wallYPosition=CGRectGetMinY(self.frame)+(position+0.5f)*OBSTACLE_WIDTH+BACKGROUND_HEIGHT;
    
    coinSprite.position=CGPointMake(CGRectGetWidth(self.frame)+coinSprite.size.width/2, _coinYPosition);
    [coinSprite runAction:_coinRotateAction];
    return coinSprite;
}

-(void)createIncomingObstacles
{
    _obstacleGenerateTimer++;
    if (_obstacleGenerateTimer >= _obstacleGenerateDuration)
    {
        SKSpriteNode *wallNode = [self createObstacle];
        [self addChild:wallNode];
        //[wallNode runAction:[SKAction sequence:@[[SKAction moveToY:CGRectGetMaxY(self.frame)+OBSTACLE_WIDTH/2 duration:_wallMoveSpeed],[SKAction removeFromParent]]]];
        [wallNode runAction:[SKAction sequence:@[[SKAction moveToX:-OBSTACLE_WIDTH/2 duration:2.5f],[SKAction removeFromParent]]]];
        _obstacleGenerateTimer = 0;
    }
   // _obstacleGenerateTimer +=1.0f*_birdVelocity/DEFAULT_VELOCITY;
}


-(void)createIncomingCoins
{
    _coinGenerateTimer++;
    if (_coinGenerateTimer >= _coinGenerateDuration)
    {
        ZLCoinNode *coinSprite = [self createCoin];
        [self addChild:coinSprite];
        [coinSprite runAction:[SKAction sequence:@[[SKAction moveToX:-OBSTACLE_WIDTH/2 duration:coinSprite.movespeed],[SKAction removeFromParent]]]];
        _coinGenerateTimer = 0;
    }
}

-(void)adjustPlayerBirdAngle
{
    CGVector velocity=_playerHero.physicsBody.velocity;
    if (velocity.dy>0) {
        [_playerHero removeActionForKey:@"turndownaction"];
        if (![_playerHero actionForKey:@"turnupaction"]) {
            [_playerHero runAction:[SKAction rotateToAngle:0 duration:0.1f]];
            //[_playerHero runAction:[SKAction setTexture:[SKSharedAtles textureWithType:SKTextureTypeHeroUp]]];
            SKAction *rotateAction=[SKAction rotateToAngle:M_PI_4 duration:0.3f];
            rotateAction.timingMode=SKActionTimingEaseOut;
            [_playerHero runAction:rotateAction withKey:@"turnupaction"];
        }
    }else{
        [_playerHero removeActionForKey:@"turnupaction"];
        if (![_playerHero actionForKey:@"turndownaction"]) {
            //[_playerHero runAction:[SKAction setTexture:[SKSharedAtles textureWithType:SKTextureTypeHeroDown]]];
            SKAction *rotateAction=[SKAction rotateToAngle:M_PI_4*(-1) duration:0.5f];
            rotateAction.timingMode=SKActionTimingEaseIn;
            [_playerHero runAction:rotateAction withKey:@"turndownaction"];
        }
    }
}

-(void)obstacleCollisionAnimated:(SKSpriteNode *)node
{
    [self runAction:_playHitAudio];
    //[node removeFromParent];
    _heroBlood--;
    if (_heroBlood<=0) {
        [self onGameOverWithType:1];
    }
}

-(void)borderCollisionAnimated
{
    
}

-(void)wallOrCoinCollisionWithBorder:(SKSpriteNode *)node
{
    [node removeAllActions];
    [node removeFromParent];
}

-(void)onGotCoin:(ZLCoinNode *)sprite
{
    
    _curGold +=sprite.coinValue;
    [sprite removeAllActions];
    [sprite removeFromParent];
    [_goldLabel runAction:[SKAction runBlock:^{
        [self setCurrentPointLabel];
    }]];
    if (_bPlayVoice) {
        [self runAction:_playGoldAudio];
        //[ZLAudioPlayer playAudioWithType:ZLAUDIOTYPEGOLD];
    }
    if (_curGold>_recordGold) {
        _recordGold=_curGold;
        [_recordGoldLabel runAction:[SKAction runBlock:^{
            [self setHistoryPointLabel];
        }]];
    }
}

-(void)addRecordToGameCenter
{
    if (_curGold) {
        [ZLHistoryManager addNewGold:_curGold];
        if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
            GKScore *totalScore=[[GKScore alloc] initWithLeaderboardIdentifier:ZL_TOTALGOLD_LEADERBOARD_IDENTIFIER];
            totalScore.value=[ZLHistoryManager getLastGold];
            
            GKScore *newScore=[[GKScore alloc] initWithLeaderboardIdentifier:ZL_NEWRECORD_LEADERBOARD_IDENTIFIER];
            newScore.value=_curGold;
            
            GKScore *bestScore=[[GKScore alloc] initWithLeaderboardIdentifier:ZL_BESTRECORD_LEADERBOARD_IDENTIFIER];
            bestScore.value=[ZLHistoryManager getMaxGold];
            [GKScore reportScores:[NSArray arrayWithObjects:newScore,bestScore,totalScore,nil] withCompletionHandler:^(NSError *error){
                
            }];
        }
    }
}

/**
 overType =1 碰到墙壁
 overType=2  碰到炸弹
 */
-(void)onGameOverWithType:(int)overType
{
    if (_bGameOver) {
        return;
    }
    _bGameOver=YES;
    [self addRecordToGameCenter];
    [self removeAllActions];
//    _playerHero.physicsBody.velocity=CGVectorMake(0, 0);
//    _playerHero.physicsBody.angularVelocity=0;
    _playerHero.physicsBody.resting=YES;
    self.physicsWorld.speed=0;
    for (SKNode *child in [self children]) {
        child.physicsBody.resting=YES;
        [child removeAllActions];
    }
    SKAction *dieAudio=nil;
    if (overType==1) {
        dieAudio=_playHitAudio;
    }
    if (_bPlayVoice) {
        [self runAction:[SKAction sequence:@[dieAudio,[SKAction runBlock:^{
            [self initStartLabel:NO];
            
        }]]]];
    }else{
        [self runAction:[SKAction runBlock:^{
            [self initStartLabel:NO];
        }]];
    }
}

-(void)onCollisionWithGround
{
    //_birdVelocity=0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.paused) {
        ZLTRACE(@"game has paused");
        return;
    }
    if (_bGameOver) {
        if ([self childNodeWithName:@"startLabel"]) {
            //出现了点击开始图标才能开始
            [self onTapStartGame];
        }
    }
    else{
        [self applyJumpToPlayer];
        
        //[_playerHero.physicsBody applyImpulse:CGVectorMake(0,50)];
    }
}

/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (self.paused) {
        ZLTRACE(@"game has paused");
        return;
    }
    if (_bGameOver) {
        ZLTRACE(@"game is over");
        return;
    }
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        
        if (location.x >= self.size.width - (_playerHero.size.width / 2)-LEFT_MARGIN) {
            
            location.x = self.size.width - (_playerHero.size.width / 2)-LEFT_MARGIN;
            
        }else if (location.x <= (_playerHero.size.width / 2)+LEFT_MARGIN) {
            
            location.x = _playerHero.size.width / 2+LEFT_MARGIN;
            
        }
 
        if (location.y >= self.size.height - (_playerPlane.size.height / 2)) {
            
            location.y = self.size.height - (_playerPlane.size.height / 2);
            
        }else if (location.y <= (_playerPlane.size.height / 2)) {
            
            location.y = (_playerPlane.size.height / 2);
            
        }
 
        SKAction *action = [SKAction moveTo:CGPointMake(location.x, _playerHero.position.y) duration:0];
        
        [_playerHero runAction:action];
    }
}
*/

//跳
-(void)applyJumpToPlayer
{
    if (![_playerHero actionForKey:@"jumpAction"]) {
       // [_playerHero runAction:[SKAction rotateToAngle:0 duration:0.1f]];
        //[_playerHero runAction:[SKAction setTexture:[SKSharedAtles textureWithType:SKTextureTypeHeroUp]]];
//        SKAction *rotateupAction=[SKAction rotateToAngle:M_PI_4 duration:0.7f];
//        rotateupAction.timingMode=SKActionTimingEaseOut;
//        
//        SKAction *rotatedownAction=[SKAction rotateToAngle:M_PI_4*(-0.5) duration:0.4f];
//        rotatedownAction.timingMode=SKActionTimingEaseOut;
        
        SKAction *moveupAction=[SKAction moveToY:_playerHero.position.y+170 duration:0.4];
        moveupAction.timingMode=SKActionTimingEaseOut;
        
        SKAction *movedownAction=[SKAction moveToY:_playerHero.position.y duration:0.5];
        movedownAction.timingMode=SKActionTimingEaseIn;
        
        //[_playerHero runAction:rotateAction withKey:@"jumpAction"];
        //[_playerHero removeActionForKey:@"playerAction"];
        //[_playerHero runAction:[SKSharedAtles playerAction] withKey:@"playerAction"];
        //[_playerHero runAction:[SKAction sequence:@[moveupAction,movedownAction]] withKey:@"jumpAction"];
        [_playerHero runAction:[SKAction sequence:@[[SKAction group:@[[SKAction setTexture:[SKSharedAtles textureWithType:SKTextureTypeHeroUp]],moveupAction]],[SKAction sequence:@[movedownAction,[SKAction setTexture:[SKSharedAtles textureWithType:SKTextureTypeHero]]]]]] withKey:@"jumpAction"];
        
        if (_bPlayVoice) {
            // [ZLAudioPlayer playAudioWithType:ZLAUDIOTYPEFLAP];
            [self runAction:_playFlapAudio];
        }
        
    }
}


- (void)update:(NSTimeInterval)currentTime{
    
    if (!_bGameOver) {
        
        //[self adjustPlayerBirdAngle];
        //[self createIncomingWalls];
        //[self createIncomingWallBombAndCoins];
        
        [self scrollBackgroundWithTime:currentTime];
        [self createIncomingObstacles];
        [self createIncomingCoins];
        /*
        if (_coinModeTimer>=1000) {
            [self createIncomingCoins];
        }else{
            [self createIncomingWallBombAndCoins];
        }
        _coinModeTimer++;
         */
    }
}

#pragma mark -
- (void)didBeginContact:(SKPhysicsContact *)contact{
    if (contact.bodyA.categoryBitMask & SKRoleCategoryHero || contact.bodyB.categoryBitMask & SKRoleCategoryHero) {
        
        if (contact.bodyA.categoryBitMask & SKRoleCategoryObstacle || contact.bodyB.categoryBitMask & SKRoleCategoryObstacle) {
            ZLTRACE(@"bird collision with obstacle");
            SKSpriteNode *obstacleNode = (contact.bodyA.categoryBitMask & SKRoleCategoryObstacle) ? (SKSpriteNode *)contact.bodyA.node : (SKSpriteNode *)contact.bodyB.node;
            [self obstacleCollisionAnimated:obstacleNode];
            //[self onGameOverWithType:1];
        }else if(contact.bodyA.categoryBitMask & SKRoleCategoryCoin || contact.bodyB.categoryBitMask & SKRoleCategoryCoin){
            ZLTRACE(@"bird collision with coin");
            ZLCoinNode *coinNode = (contact.bodyA.categoryBitMask & SKRoleCategoryCoin) ? (ZLCoinNode *)contact.bodyA.node : (ZLCoinNode *)contact.bodyB.node;
            [self onGotCoin:coinNode];
        }else if(contact.bodyA.categoryBitMask & SKRoleCategoryGround || contact.bodyB.categoryBitMask & SKRoleCategoryGround){
            ZLTRACE(@"bird collision with ground");
            [self onCollisionWithGround];
        }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact{
}


@end
