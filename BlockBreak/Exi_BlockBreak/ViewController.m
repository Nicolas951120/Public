//
//  ViewController.m
//  Exi_BlockBreak
//
//  Created by 李梓键 on 16/4/7.
//  Copyright © 2016年 李梓键. All rights reserved.
//

#import "ViewController.h"
#import "ImageCache.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>
#define BRICKS_WIDTH 5
#define BRICKS_HEIGHT 4
@interface ViewController ()
{
    CGPoint _ballMovement;
    CGFloat _touchOffset;
    NSString *_pictureNames[4];
    UIImageView *_bricks[BRICKS_WIDTH][BRICKS_HEIGHT];
    int _score;
    int _lives;
    //NSTimer *_theTimer;
    CADisplayLink *_theLink;
    BOOL _isPlaying;
    CMMotionManager *_motionManager;
    UIImageView *theAnimation1;
    UIImageView *theAnimation2;
    UIImageView *theAnimation3;
    BOOL _animationIsPlaying;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *ball;
@property (weak, nonatomic) IBOutlet UIImageView *paddle;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *livesLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
//-(void)moveBall:(NSTimer*)timer;
-(void)moveBall:(CADisplayLink*)displayLink;
//-(void)initTimer;
-(void)initDisplayLink;
-(void)processCollision:(UIImageView*)brick targetCenter:(CGPoint)center;
-(void)startPlaying;
-(void)pauseGame;
-(void)saveGameState;
-(void)loadGameState;
-(void)startAnimating;
//+(NSUserDefaults *)standardUserDefults;
@end

@implementation ViewController

NSString *kLivesKey = @"Lives";
NSString *kScoreKey = @"Score";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadGameState];
    [self initBricks];
    [self initDisplayLink];
    [self startPlaying];
    [NSThread sleepForTimeInterval:1.5];
    //动画1：
    [self setAnimation1];
    //动画2；
    [self setAnimation2];
    //动画3:
    [self setAnimation3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//碰撞处理：小球－砖块
-(void)processCollision:(UIImageView *)brick targetCenter:(CGPoint)center{
    _score+=10;
    self.scoreLabel.text=[NSString stringWithFormat:@"%d",_score];
    if (_ballMovement.x>0&&center.x>=brick.frame.origin.x-8&&center.x<=brick.frame.origin.x-3) {
        //球与砖左侧碰撞
        _ballMovement.x *= -1;
        
    }else if (_ballMovement.x<0&&center.x<=brick.frame.origin.x+brick.frame.size.width+8&&center.x>=brick.frame.origin.x+brick.frame.size.width+3){
        //球与砖右侧碰撞
        _ballMovement.x *= -1;
        
    }
    if (_ballMovement.y>0&&center.y>=brick.frame.origin.y-8&&center.y<=brick.frame.origin.y-3) {
        //球与砖上侧碰撞
        
        _ballMovement.y *= -1;
    }else if (_ballMovement.y<0&&center.y<=brick.frame.origin.y+brick.frame.size.height+8&&center.y>=brick.frame.origin.y+brick.frame.size.height+3){
        //球与砖下侧碰撞
        
        _ballMovement.y *= -1;
    }
    
    brick.alpha -= 0.1;
}

-(void)moveBall:(CADisplayLink *)displayLink{
    if (_isPlaying&&_motionManager.isAccelerometerAvailable) {
        CMAccelerometerData *accel=_motionManager.accelerometerData;
        float newX=self.paddle.center.x+accel.acceleration.x*24;
        if (newX>30&&newX<290) {
            self.paddle.center=CGPointMake(newX, self.paddle.center.y);
        }
    }
    
    
    //生成小球预判
    CGPoint center=self.ball.center;
    CGRect frame=self.ball.frame;
    center.x+=_ballMovement.x;
    center.y+=_ballMovement.y;
    frame=CGRectOffset(self.ball.frame, _ballMovement.x, _ballMovement.y);
    //碰撞检测：小球－挡板
    BOOL paddleCollision=CGRectIntersectsRect(frame, self.paddle.frame);
    if (paddleCollision) {
        center=CGPointMake(center.x, self.paddle.center.y-16);
        _ballMovement.y*=-1;
    }
    //碰撞检测：小球－砖块
    BOOL there_are_solid_bricks=NO;
    for (int y=0; y<BRICKS_HEIGHT; y++) {
        for (int x=0; x<BRICKS_WIDTH; x++) {
            if (1.0==_bricks[x][y].alpha) {
                there_are_solid_bricks=YES;
                if (CGRectIntersectsRect(frame, _bricks[x][y].frame)) {
                    [self processCollision:_bricks[x][y] targetCenter:center];
                    break;
                }
            }else if (_bricks[x][y].alpha>0){
                _bricks[x][y].alpha -=0.1;
            }
        }
    }
    //碰撞检测：小球－屏幕
    if (center.x<8) {
        _ballMovement.x*=-1;
        center=CGPointMake(8, center.y);
    }
    else if (center.x>312){
        _ballMovement.x*=-1;
        center=CGPointMake(312, center.y);
    }
    if (center.y<8 +self.scoreLabel.frame.size.height) {
        _ballMovement.y*=-1;
        center=CGPointMake(center.x, 8+self.scoreLabel.frame.size.height);
    }
    else if (center.y>=self.paddle.center.y+8){
        [self pauseGame];
        _isPlaying=NO;
        _lives --;
        if (_lives!=0) {
            self.resultLabel.text=@"Out of Bounds!";
            self.ball.hidden=YES;
            self.paddle.hidden=YES;
            [self Animating2];
        }else{
            self.resultLabel.text=@"Game Over!";
            self.ball.hidden=YES;
            self.paddle.hidden=YES;
            [self Animating3];
            [self saveGameState];
        }
        self.resultLabel.hidden=NO;
        
    }
    
    self.ball.center=center;

    if (!there_are_solid_bricks) {
        [self pauseGame];
        _isPlaying=NO;
        _lives=0;
        self.resultLabel.text=@"You Win!";
        self.ball.hidden=YES;
        self.paddle.hidden=YES;
        for (int y=0; y<BRICKS_HEIGHT; y++) {
            for (int x=0; x<BRICKS_WIDTH; x++) {
                _bricks[x][y].alpha=0;
            }
        }
        [self Animating1];
        self.resultLabel.hidden=NO;
        
    }
}

//-(void)initTimer{
//    float interval=1.0/100.0;
//
//    _theTimer=[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(moveBall:) userInfo:nil repeats:YES];
//}
-(void)initDisplayLink{
    _theLink=[CADisplayLink displayLinkWithTarget:self selector:@selector(moveBall:)];
    _theLink.frameInterval=1;
    [_theLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}


-(void)initBricks{
    for (int i=0; i<4; i++) {
        _pictureNames[i]=[NSString stringWithFormat:@"bricktype%i.png",i+1];
    }
    int count=0;
    for (int y=0; y<BRICKS_HEIGHT; y++) {
        for (int x=0; x<BRICKS_WIDTH; x++) {
            count ++;
            UIImage *image=[ImageCache loadImage:_pictureNames[count%4]];
            _bricks[x][y]=[[UIImageView alloc]initWithImage:image];
            CGRect newFrame=_bricks[x][y].frame;
            newFrame.origin=CGPointMake(x*64, y*40+50);
            _bricks[x][y].frame=newFrame;
            [self.view addSubview:_bricks[x][y]];
        }
    }
}

-(void)startPlaying{
    if (_lives==0) {
        _lives=3;
        _score=0;
        for (int y=0; y<BRICKS_HEIGHT; y++) {
            for (int x=0; x<BRICKS_WIDTH; x++) {
                _bricks[x][y].alpha=1.0;
            }
        }
    }
    self.ball.hidden=NO;
    self.paddle.hidden=NO;
    self.scoreLabel.text=[NSString stringWithFormat:@"%d",_score];
    self.livesLabel.text=[NSString stringWithFormat:@"%d",_lives];
    self.ball.center=CGPointMake(141, 428);
    _ballMovement=CGPointMake(4,-4);
    if (arc4random()%2==1) {
        _ballMovement.x*=-1;
    }
    self.resultLabel.hidden=YES;
    _isPlaying=YES;
//    [self initTimer];
    _theLink.paused=NO;
    
}

-(void)pauseGame{
//    [_theTimer invalidate];
//    _theTimer=nil;
    _theLink.paused=YES;
}

-(void)saveGameState{
    [[NSUserDefaults standardUserDefaults]setInteger:_lives forKey:kLivesKey];
    [[NSUserDefaults standardUserDefaults]setInteger:_score forKey:kScoreKey];
}

-(void)loadGameState{
    _lives=[[NSUserDefaults standardUserDefaults] integerForKey:kLivesKey];
    _score=[[NSUserDefaults standardUserDefaults] integerForKey:kScoreKey];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_isPlaying) {
        UITouch*touch=[touches anyObject];
        _touchOffset=self.paddle.center.x-[touch locationInView:touch.view].x;
    }else{
        theAnimation1.hidden=YES;
        theAnimation2.hidden=YES;
        theAnimation3.hidden=YES;
        _animationIsPlaying=NO;
        [self startPlaying];
    }
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch*touch=[touches anyObject];
    CGFloat newX=[touch locationInView:touch.view].x+_touchOffset;
    if (newX>=30&&newX<=290) {
        self.paddle.center=CGPointMake(newX, self.paddle.center.y);
    }
    if (newX<30) {
        self.paddle.center=CGPointMake(30, self.paddle.center.y);
    }
    if (newX>290) {
        self.paddle.center=CGPointMake(290, self.paddle.center.y);
    }
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
    _motionManager=[[CMMotionManager alloc]init];
    if (_motionManager.isAccelerometerAvailable) {
        _motionManager.accelerometerUpdateInterval=0.01;
        [_motionManager startAccelerometerUpdates];
    }
    [self becomeFirstResponder];
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (!_isPlaying&&motion==UIEventSubtypeMotionShake) {
        theAnimation1.hidden=YES;
        theAnimation2.hidden=YES;
        theAnimation3.hidden=YES;
        _animationIsPlaying=NO;
        [self startPlaying];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [_motionManager stopAccelerometerUpdates];
}

-(void)setAnimation1{
    CGRect newFrame1;
    newFrame1.origin=CGPointMake(60, 203);
    newFrame1.size=CGSizeMake(200, 204);
    theAnimation1=[[UIImageView alloc]initWithFrame:newFrame1];
    NSMutableArray *images1=[NSMutableArray array];
    for (int i=1; i<=28; i++) {
        [images1 addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]]];
    }
    theAnimation1.animationImages=images1;
    theAnimation1.animationRepeatCount=0;
    theAnimation1.animationDuration=0.5;
    [self.view addSubview:theAnimation1];
    theAnimation1.hidden=YES;
}

-(void)setAnimation2{
    CGRect newFrame;
    newFrame.origin=CGPointMake(60, 227);
    newFrame.size=CGSizeMake(200, 156);
    theAnimation2=[[UIImageView alloc]initWithFrame:newFrame];
    NSMutableArray *images=[NSMutableArray array];
    for (int i=1; i<=4; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"p%d.png",i]]];
    }
    theAnimation2.animationImages=images;
    theAnimation2.animationRepeatCount=0;
    theAnimation2.animationDuration=0.5;
    [self.view addSubview:theAnimation2];
    theAnimation2.hidden=YES;
}

-(void)setAnimation3{
    CGRect newFrame;
    newFrame.origin=CGPointMake(112, 261);
    newFrame.size=CGSizeMake(96, 96);
    theAnimation3=[[UIImageView alloc]initWithFrame:newFrame];
    NSMutableArray *images=[NSMutableArray array];
    for (int i=12; i<=21; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"player_%d.bmp",i]]];
    }
    theAnimation3.animationImages=images;
    theAnimation3.animationRepeatCount=0;
    theAnimation3.animationDuration=0.5;
    [self.view addSubview:theAnimation3];
    theAnimation3.hidden=YES;
}

-(void)Animating1{
    if (!_animationIsPlaying) {
        theAnimation1.hidden=NO;
        [theAnimation1 startAnimating];
        _animationIsPlaying=YES;
    }else{
        theAnimation1.hidden=YES;
        _animationIsPlaying=NO;
    }
}
-(void)Animating2{
    if (!_animationIsPlaying) {
        theAnimation2.hidden=NO;
        [theAnimation2 startAnimating];
        _animationIsPlaying=YES;
    }else{
        theAnimation2.hidden=YES;
        _animationIsPlaying=NO;
    }
}
-(void)Animating3{
    if (!_animationIsPlaying) {
        theAnimation3.hidden=NO;
        [theAnimation3 startAnimating];
        _animationIsPlaying=YES;
    }else{
        theAnimation3.hidden=YES;
        _animationIsPlaying=NO;
    }
}
@end
