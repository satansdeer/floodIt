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
        [self setupSkeleton:filename];
        self.positionInGame = pos;
        self.filename = filename;
        [self setSkeletonColor:filename];
        [self changeAnimation];
    }
    return self;
}

-(void)setupSkeleton:(NSString*)filename{
    if([filename isEqual:@"p1.png"]){
        [self removeChild:self.skeletonNode];
        self.skeletonNode = [CCSkeleton skeletonWithFile:@"skeleton.json" atlasFile:@"skeleton.atlas"];
    }else{
        [self removeChild:self.skeletonNode];
        self.skeletonNode = [CCSkeleton skeletonWithFile:@"skeleton.json" atlasFile:@"skeleton2.atlas"];
    }
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        self.skeletonNode.scale = 0.15;
    } else {
        self.skeletonNode.scale = 0.3;
    }
    self.skeletonNode.position = ccp(self.tileSize.width/2, self.tileSize.height/2);
    AnimationState_setAnimationByName(self.skeletonNode->state, "idle", true);
    self.skeletonNode->timeScale = 0.3f;
    self.skeletonNode->timeScale = 0.3f;
    [self addChild:self.skeletonNode];
}

-(void) changeAnimation {
    static int counter = 0;
    if((arc4random()%36)==0){
        AnimationState_setAnimationByName(self.skeletonNode->state, "walk", false);
    }else{
        AnimationState_clearAnimation(self.skeletonNode->state);
        AnimationState_setAnimationByName(self.skeletonNode->state, "idle", true);
    }
    counter++;
        double time = (arc4random()%5)+1;
        id delay = [CCDelayTime actionWithDuration: time];
        id callbackAction = [CCCallFunc actionWithTarget: self selector: @selector(changeAnimation)];
        id sequence = [CCSequence actions: delay, callbackAction, nil];
        [self runAction: sequence];
}

-(void)setSkeletonColor:(NSString*)color{
    if([color isEqual:@"red.png"]){
        self.skeletonNode.color = ccc3(219, 57, 30);
        return;
    }
    if([color isEqual:@"green.png"]){
        self.skeletonNode.color = ccc3(120, 231, 66);
        return;
    }
    if([color isEqual:@"blue.png"]){
        self.skeletonNode.color = ccc3(37, 161, 234);
        return;
    }
    if([color isEqual:@"purple.png"]){
        self.skeletonNode.color = ccc3(120, 0, 242);
        return;
    }
    if([color isEqual:@"orange.png"]){
        self.skeletonNode.color = ccc3(232, 131, 38);
        return;
    }
    if([color isEqual:@"yellow.png"]){
        self.skeletonNode.color = ccc3(221, 223, 93);
        return;
    }
    if([color isEqual:@"p1.png"]){
        self.skeletonNode.color = ccc3(255, 255, 255);
        return;
    }
}

-(void)updateToFilename:(NSString*)file{
    self.filename = file;
    [self setupSkeleton:file];
    [self setSkeletonColor:file];
    //[self setTexture:[[CCTextureCache sharedTextureCache] addImage:file]];
}

@end
