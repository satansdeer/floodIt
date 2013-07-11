//
//  GuiLayer.h
//  FloodIt
//
//  Created by Satansdeer satansdeer on 09.07.13.
//
//

#import "cocos2d.h"
@protocol GuiLayerDelegate <NSObject>
-(void)exitToMenu;
@end


@interface GuiLayer : CCLayer

@property (nonatomic, assign) id myDelegate;
@property (nonatomic, retain) CCLabelTTF*scoreLabel;
@property (nonatomic, retain) CCLabelTTF*levelLabel;
@property (nonatomic, retain) CCLabelTTF*turnsLabel;

-(id) initWithDelegate:(id)delegate;
-(void)update;
@end
