//
//  ColorPanel.m
//  FloodIt
//
//  Created by Satansdeer satansdeer on 09.07.13.
//
//

#import "ColorPanel.h"
#import "FloodItem.h"

@implementation ColorPanel

-(id) initWithDelegate:(id)delegate andAvailableColors:(NSArray*)colors
{
	if( (self=[super init]) ) {
        self.myDelegate = delegate;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        float tileSize = (winSize.width-8-(2*6))/6;
        self.items = [[NSMutableArray alloc] init];
        int i = 0;
        for (NSString*color in colors) {
            
            FloodItem*item = [[FloodItem alloc] initWithFile:color position:CGPointMake(0, 0) andDelegate:self];
            item.scale = tileSize/item.boundingBox.size.width;
            item.anchorPoint = CGPointMake(0, 0);
            float totalSize = colors.count*(item.boundingBox.size.width+2);
            item.position = CGPointMake(i*(item.boundingBox.size.width+2) + (winSize.width/2 - totalSize/2), 14);
            [self.items addObject:item];
            [self addChild:item];
            i++;
        }
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    }
    return self;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"ccTouchBegan");
    if(self.myDelegate){
        for (FloodItem*item in self.items) {
            if (CGRectContainsPoint(item.boundingBox, [self convertTouchToNodeSpace:touch])) {
                [self floodItemTapped:item];
                return true;
            }
        }
    }
    return false;
}

#pragma mark - FloodItemDelegate

-(void)floodItemTapped:(id)item{
    FloodItem*floodItem = item;
    [self.myDelegate chooseColor:floodItem.filename];
}

@end
