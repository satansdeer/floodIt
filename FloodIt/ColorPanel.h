//
//  ColorPanel.h
//  FloodIt
//
//  Created by Satansdeer satansdeer on 09.07.13.
//
//

#import "CCLayer.h"
#import "FloodItem.h"

@protocol ColorPanelDelegate <NSObject, FloodItemDelegate>

-(void)chooseColor:(NSString*)color;

@end

@interface ColorPanel : CCLayer

@property (nonatomic, assign) id myDelegate;
@property (nonatomic, retain) NSMutableArray*items;

-(id) initWithDelegate:(id)delegate andAvailableColors:(NSArray*)colors;
-(void)floodItemTapped:(id)item;
@end
