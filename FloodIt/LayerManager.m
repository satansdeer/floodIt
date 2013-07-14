//
//  LayerManager.m
//  FloodIt
//
//  Created by Satansdeer satansdeer on 14.07.13.
//
//

#import "LayerManager.h"

@implementation LayerManager

+ (LayerManager *)sharedManager {
    static LayerManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[LayerManager alloc] init];
    });
    return _sharedClient;
}

-(id)init{
    if(self = [super init]){
        self.bonusLayer = [[CCLayer alloc] init];
        self.guiLayer = [[CCLayer alloc] init];
        self.objectsLayer = [[CCLayer alloc] init];
        self.backgroundLayer = [[CCLayer alloc] init];
    }
    return self;
}

-(void)addLayersToNode:(CCNode*)node{
    [node addChild:self.backgroundLayer];
    [node addChild:self.objectsLayer];
    [node addChild:self.guiLayer];
    [node addChild:self.bonusLayer];
}

-(void)clear:(CCNode*)node{
    [self.backgroundLayer removeAllChildren];
    [self.guiLayer removeAllChildren];
    [self.bonusLayer removeAllChildren];
    [self.objectsLayer removeAllChildren];
    [node removeChild:self.backgroundLayer];
    [node removeChild:self.guiLayer];
    [node removeChild:self.objectsLayer];
    [node removeChild:self.bonusLayer];
}

@end
