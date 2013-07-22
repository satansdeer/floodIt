//
//  FloodItem.m
//  FloodIt
//
//  Created by Satansdeer satansdeer on 06.07.13.
//
//

#import "FloodItem.h"

@implementation FloodItem

-(id)initWithFile:(NSString*)filename position:(CGPoint)pos andDelegate:(id)delegate{
    //if(self = [super initWithFile:filename]){
    if(self = [super initWithFile:@"transparent.png"]){
        self.myDelegate = delegate;
        self.tileSize = self.boundingBox.size;
        CCSprite*shadow = [[CCSprite alloc] initWithFile:@"shadow.png"];
        shadow.anchorPoint = ccp(0,0);
        shadow.position = ccp(10,-2);
        [self addChild:shadow];
        self.image = [[CCSprite alloc] initWithFile:@"crystal.png"];
        self.image.anchorPoint = ccp(0,0);
        self.image.scale = 0.8;
        //self.image.position = ccp(self.tileSize.width/2 - self.image.boundingBox.size.width/2 -10,0);
        [self addChild:self.image];
        //[self setupSkeleton:filename];
        self.positionInGame = pos;
        self.filename = filename;
        [self setColor:filename];
        [self pulsate];
    }
    return self;
}


-(void)setColor:(NSString*)color{
    if([color isEqual:@"red.png"]){
        self.image.color = ccc3(219, 57, 30);
    }
    if([color isEqual:@"green.png"]){
        self.image.color = ccc3(255, 255, 255);
    }
    if([color isEqual:@"blue.png"]){
        self.image.color = ccc3(37, 161, 234);
    }
    if([color isEqual:@"purple.png"]){
        self.image.color = ccc3(120, 0, 242);
    }
    if([color isEqual:@"orange.png"]){
        self.image.color = ccc3(153, 204, 0);
    }
    if([color isEqual:@"yellow.png"]){
        self.image.color = ccc3(221, 223, 93);
    }
    if([color isEqual:@"p1.png"]){
        self.image.color = ccc3(255, 255, 255);
        if(self.currentColor){
            [self removeChild:self.image];
            self.image = [[CCSprite alloc] initWithFile:@"blue.png"];
            self.image.anchorPoint = ccp(0,0);
            self.image.position = ccp(10,0);
            self.image.scale = 0.8;
            [self addChild:self.image];
        }
    }
    self.currentColor = color;
}

-(void)pulsate{
    ccColor3B currentColor = self.image.color;
    ccColor3B tintColor = ccc3(40, 40, 40);
    if(currentColor.r<tintColor.r){
        tintColor.r = currentColor.r;
    }
    if(currentColor.g<tintColor.g){
        tintColor.g = currentColor.g;
    }
    if(currentColor.b<tintColor.b){
        tintColor.b = currentColor.b;
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

-(void)updateToFilename:(NSString*)file{
    self.filename = file;
}

@end
