//
//  FloodItem.h
//  FloodIt
//
//  Created by Satansdeer satansdeer on 06.07.13.
//
//

#import "cocos2d.h"
#import <spine/spine-cocos2d-iphone.h>

@protocol FloodItemDelegate
-(void)floodItemTapped:(id)item;
@end

@interface FloodItem : CCSprite <CCTouchOneByOneDelegate>

@property (nonatomic, assign) CGPoint positionInGame;
@property (nonatomic, assign) NSString* filename;
@property (nonatomic, assign) id myDelegate;
@property (nonatomic, assign) BOOL isInWinGroup;
@property (nonatomic, retain) CCSkeleton* skeletonNode;
@property (nonatomic, assign) CGSize tileSize;

-(id)initWithFile:(NSString*)filename position:(CGPoint)position andDelegate:(id)delegate;
-(void)updateToFilename:(NSString*)file;
-(void)setSkeletonColor:(NSString*)color;
-(void)updateAsset:(NSString*)filename;
@end
