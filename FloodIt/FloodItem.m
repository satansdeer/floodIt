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
        self.skeletonNode = [CCSkeleton skeletonWithFile:@"skeleton.json" atlasFile:@"skeleton.atlas"];
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            self.skeletonNode.scale = 0.15;
        } else {
            self.skeletonNode.scale = 0.3;
        }
        self.filename = filename;
        self.positionInGame = pos;
        [self setSkeletonColor:filename];
        //NSLog(@"%f", self.skeletonNode.boundingBox.size.width);
        self.skeletonNode.position = ccp(self.boundingBox.size.width/2, self.boundingBox.size.height/2);
        AnimationState_setAnimationByName(self.skeletonNode->state, "animation", true);
        self.skeletonNode->timeScale = 0.3f;
        self.skeletonNode->timeScale = 0.3f;
        [self addChild:self.skeletonNode];
    }
    return self;
}

-(void)setSkeletonColor:(NSString*)color{
    if([color isEqual:@"red.png"]){
        self.skeletonNode.color = ccc3(219, 57, 30);
    }
    if([color isEqual:@"green.png"]){
        self.skeletonNode.color = ccc3(120, 231, 66);
    }
    if([color isEqual:@"blue.png"]){
        self.skeletonNode.color = ccc3(37, 161, 234);
    }
    if([color isEqual:@"purple.png"]){
        self.skeletonNode.color = ccc3(120, 0, 242);
    }
    if([color isEqual:@"orange.png"]){
        self.skeletonNode.color = ccc3(232, 131, 38);
    }
    if([color isEqual:@"yellow.png"]){
        self.skeletonNode.color = ccc3(221, 223, 93);
    }
    if([color isEqual:@"p1.png"]){
        self.skeletonNode.color = ccc3(229, 126, 218);
    }
}

-(void)updateToFilename:(NSString*)file{
    self.filename = file;
    [self setSkeletonColor:file];
    //[self setTexture:[[CCTextureCache sharedTextureCache] addImage:file]];
}

@end
