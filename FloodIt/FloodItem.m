//
//  FloodItem.m
//  FloodIt
//
//  Created by Satansdeer satansdeer on 06.07.13.
//
//

#import "FloodItem.h"
#import "Utils.h"

@implementation FloodItem

-(id)initWithFile:(NSString*)filename position:(CGPoint)pos andDelegate:(id)delegate{
    if(self = [super initWithFile:@"transparent.png"]){
        self.myDelegate = delegate;
        self.counter = 0;
        self.tileSize = self.boundingBox.size;
        CCSprite*shadow = [[CCSprite alloc] initWithFile:@"shadow.png"];
        shadow.anchorPoint = ccp(0,0);
        shadow.position = ccp(10,-2);
        [self addChild:shadow];
        self.image = [[CCSprite alloc] initWithFile:@"crystal.png"];
        self.image.anchorPoint = ccp(0,0);
        self.image.scale = 0.8;
        [self addChild:self.image];
        self.positionInGame = pos;
        [self setColor:filename];
        [self pulsate];
        self.counterText = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"%d", self.counter]
                                                     fontName:@"Marker Felt" fontSize:72];
        self.counterText.color = ccc3(0, 0, 0);
        self.counterText.position = ccp(self.image.contentSize.width/2,
                                        self.image.contentSize.height/2 - self.counterText.contentSize.height/2);
        [self addChild:self.counterText];
    }
    return self;
}

-(void)updateCounter{
    if(!self.isInWinGroup){
        self.counter--;
        if(self.counter < 0){
            self.counter = (arc4random() % 2)+2;
            [self setColor:[Utils randomArrayElementFromArray:[Utils sharedUtils].availableColors canBeEmpty:NO]];
        }
        self.counterText.string = [NSString stringWithFormat:@"%d", self.counter];
    }
}

-(void)setColor:(NSString*)color{
    [self removeChild:self.image];
    if([color isEqualToString:@"red.png"]){
        self.image.color = ccc3(219, 57, 30);
    }
    if([color isEqualToString:@"white.png"]){
        self.image.color = ccc3(255, 255, 255);
    }
    if([color isEqualToString:@"blue.png"]){
        self.image.color = ccc3(37, 161, 234);
    }
    if([color isEqualToString:@"purple.png"]){
        self.image.color = ccc3(120, 0, 242);
    }
    if([color isEqualToString:@"orange.png"]){
        self.image.color = ccc3(153, 204, 0);
    }
    if([color isEqualToString:@"yellow.png"]){
        self.image.color = ccc3(221, 223, 93);
    }
    if([color isEqual:@"p1.png"]){
        self.image.color = ccc3(255, 255, 255);
        self.image = [[CCSprite alloc] initWithFile:@"blue.png"];
        self.image.anchorPoint = ccp(0,0);
        self.image.position = ccp(10,0);
        self.image.scale = 0.8;
        self.counterText.visible = NO;
        [self jump];
    }
    [self addChild:self.image];
    
    if(self.counterText){
     [self removeChild:self.counterText];
     [self addChild:self.counterText];
    }
    self.currentColor = color;
}

-(void)jump{
    CCDelayTime *delay = [CCDelayTime actionWithDuration:arc4random()%8];
    CCMoveBy*moveup = [CCMoveBy actionWithDuration:0.2 position:ccp(0, 6)];
    CCMoveBy*movedown = [CCMoveBy actionWithDuration:0.2 position:ccp(0, -6)];
    CCCallBlock*block = [CCCallBlock actionWithBlock:^(void){
        [self jump];
    }];
    [self.image runAction:[CCSequence actions:delay,moveup,movedown,block, nil]];
}

-(void)pulsate{
    ccColor3B pulseCurrentColor = self.image.color;
    ccColor3B tintColor = ccc3(30, 30, 30);
    if(pulseCurrentColor.r<tintColor.r){
        tintColor.r = pulseCurrentColor.r;
    }
    if(pulseCurrentColor.g<tintColor.g){
        tintColor.g = pulseCurrentColor.g;
    }
    if(pulseCurrentColor.b<tintColor.b){
        tintColor.b = pulseCurrentColor.b;
    }
    CCDelayTime *delay = [CCDelayTime actionWithDuration:arc4random()%8];
    CCTintBy*tintUp = [CCTintBy actionWithDuration:0.6 red:tintColor.r green:tintColor.g blue:tintColor.b];
    CCTintBy*tintDown = [CCTintBy actionWithDuration:0.6 red:-tintColor.r green:-tintColor.g blue:-tintColor.b];
    CCCallBlock*block = [CCCallBlock actionWithBlock:^(void){
        [self pulsate];
    }];
    [self.image runAction:[CCSequence actions:delay,tintDown,tintUp,block, nil]];
}

-(void)updateAsset:(NSString*)filename{
    CCScaleBy *scaleDown;
    CCScaleBy *scaleUp;
    scaleDown = [CCScaleBy actionWithDuration:0.1 scaleX:2 scaleY:0.5];
    scaleUp = [CCScaleBy actionWithDuration:0.1 scaleX:0.5 scaleY:2];
    CCCallBlock*block = [CCCallBlock actionWithBlock:^(void){
        [self setColor:filename];
    }];
    [self runAction:[CCSequence actions:scaleDown,block,scaleUp, nil]];
}

@end
