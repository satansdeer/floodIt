//
//  LayerManager.h
//  FloodIt
//
//  Created by Satansdeer satansdeer on 14.07.13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LayerManager : NSObject

@property (nonatomic, retain) CCLayer* bonusLayer;
@property (nonatomic, retain) CCLayer* guiLayer;
@property (nonatomic, retain) CCLayer* objectsLayer;
@property (nonatomic, retain) CCLayer* backgroundLayer;

+ (LayerManager *)sharedManager;
-(void)addLayersToNode:(CCNode*)node;
-(void)clear:(CCNode*)node;

@end
