//
//  HelloWorldLayer.m
//  FloodIt
//
//  Created by Satansdeer satansdeer on 06.07.13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "GameFieldLayer.h"
#import "MainMenuLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "FloodItem.h"
#import "GuiLayer.h"
#import "GameModel.h"
#import "ScoreLayer.h"
#import "LayerManager.h"
#import "Utils.h"

#define TILESIZE 50

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation GameFieldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameFieldLayer *layer = [[GameFieldLayer alloc] init];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super initWithColor:ccc4(153, 204, 0, 255)]) ) {
        GameModel*gameModel = [GameModel sharedModel];
        self.totalItems = 0;
        NSDictionary*level = gameModel.levels[gameModel.level-1];
        NSNumber *tilesnum = [level objectForKey:@"tilesNum"];
        [[LayerManager sharedManager] addLayersToNode:self];
        [self startWithTilesNum:[tilesnum integerValue] andAvailableColors:[level objectForKey:@"colors"]];
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
}

-(void)startWithTilesNum:(int)tilesNum andAvailableColors:(NSArray*)availableColors{
    self.startingGroup = [[NSMutableArray alloc] init];
    [Utils sharedUtils].availableColors = availableColors;
    [self drawBackground:tilesNum];
    [self placeTiles:tilesNum];
    [self makeEmptySpaces:0];
    [self displayItems];
    [self createStartingItem:tilesNum];
    [self updateItemCounters];
    self.guiLayer = [[GuiLayer alloc] initWithDelegate:self];
    [[LayerManager sharedManager].guiLayer addChild:self.guiLayer];
}

-(void)createStartingItem:(int)tilesNum{
    FloodItem*startItem = self.floodItems[0][tilesNum-1];
    [startItem updateAsset:@"p1.png"];
    self.startingColor = startItem.currentColor;
    startItem.isInWinGroup = TRUE;
    [self.startingGroup addObject:startItem];
}

-(void)drawBackground:(int)tilesNumber{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite*back = [[CCSprite alloc] initWithFile:@"back.png"];
    float scale = winSize.width/back.boundingBox.size.width;
    back.scale = scale;
    back.anchorPoint = ccp(0,0);
    back.position = ccp(0,winSize.height/2 - back.boundingBox.size.height/2);
    [[LayerManager sharedManager].backgroundLayer addChild:back];
}

-(void)placeTiles:(int)tilesNumber{
    self.floodItems = [[NSMutableArray alloc] init];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float tileSize = (winSize.width-8-(2*tilesNumber))/tilesNumber;
    for(int i = 0; i<tilesNumber; i++){
        self.floodItems[i] = [[NSMutableArray alloc] init];
        for(int j = 0; j<tilesNumber; j++){
            NSString*filename = [Utils randomArrayElementFromArray:[Utils sharedUtils].availableColors canBeEmpty:NO];
            if(filename){
                CGPoint position = CGPointMake((tileSize+2)*i+4 + tileSize/2,
                                           (tileSize+2)*j+(winSize.height/2 - (tileSize*tilesNumber)/2)+tileSize/3+tileSize/4);
                FloodItem* image = [[FloodItem alloc] initWithFile:filename
                                                      position:CGPointMake(i, j)
                                                   andDelegate:nil];
                image.position = position;
                image.scale = tileSize/(image.boundingBox.size.width+8);
                self.floodItems[i][j] = image;
                self.totalItems++;
            }
        }
    }
}

-(void)displayItems{
    for(int i = 0; i<self.floodItems.count; i++){
        for(int j = 0; j<self.floodItems.count; j++){
            if(![self.floodItems[i][j] isEqual:@"empty"]){
                FloodItem*item = self.floodItems[i][j];
                item.zOrder = self.floodItems.count-j;
                [[LayerManager sharedManager].objectsLayer addChild:self.floodItems[i][j]];
            }else{
                int tilesNumber = self.floodItems.count;
                CGSize winSize = [[CCDirector sharedDirector] winSize];
                float tileSize = (winSize.width-8-(2*tilesNumber))/tilesNumber;
                CGPoint position = CGPointMake((tileSize+2)*i+4 + TILESIZE/2,
                                               (tileSize+2)*j+(winSize.height/2 - (TILESIZE*tilesNumber)/2)+38);
                CCSprite*sprite = [[CCSprite alloc] initWithFile:@"Tree Tall.png"];
                sprite.scale = tileSize/sprite.boundingBox.size.width;
                sprite.position = position;
                sprite.zOrder = self.floodItems.count-j;
                [[LayerManager sharedManager].objectsLayer addChild:sprite];
            }
        }
    }
}

-(void)makeEmptySpaces:(int)numOfItemsToDelete{
    FloodItem*startItem = self.floodItems[0][self.floodItems.count-1];
    NSMutableArray*testField = [[NSMutableArray alloc] init];
    for(int i = 0; i<self.floodItems.count; i++){
        testField[i] = [[NSMutableArray alloc] init];
        for(int j = 0; j<self.floodItems.count; j++){
            testField[i][j] = self.floodItems[i][j];
        }
    }
    int checkedItems = self.totalItems;
    int totalItems = self.totalItems;
    int iteration = 0;
    while(checkedItems >= totalItems){
        NSLog(@"%d %d %d", checkedItems, totalItems,totalItems);
        for(int i = 0; i<self.floodItems.count; i++){
            self.floodItems[i] = [[NSMutableArray alloc] init];
            for(int j = 0; j<self.floodItems.count; j++){
                self.floodItems[i][j] = testField[i][j];
            }
        }
        self.totalItems = totalItems;
        iteration++;
        if(iteration>numOfItemsToDelete){
            return;
        }
        self.totalItems = totalItems;
        checkedItems = 0;
        NSMutableArray * checkedItemsArray = [[NSMutableArray alloc] init];
        [self removeRandomItemFromField:testField totalItems:&totalItems];
        [self checkIfField:testField
                   IsValid:startItem
              checkedItems:&checkedItems
         checkedItemsArray:checkedItemsArray];
    }
}

-(void)removeRandomItemFromField:(NSMutableArray*)field totalItems:(int*)totalItems{
    CGPoint point = CGPointMake((arc4random()%field.count-1)+1, (arc4random()%field.count-1)+1);
    if(![field[(int)point.x][(int)point.y] isEqual:@"empty"]){
        if((point.x!=0 && point.y < self.floodItems.count-1) &&
           (point.y!=0 && point.x < self.floodItems.count-1)){
            *totalItems -= 1;
            field[(int)point.x][(int)point.y] = @"empty";
            return;
        }
    }
    [self removeRandomItemFromField:field totalItems:totalItems];
}

-(void)checkIfField:(NSArray*)field IsValid:(FloodItem*)item checkedItems:(int*)checkedItems checkedItemsArray:(NSMutableArray*)checkedItemsArray{
    if(![item isEqual:@"empty"] && ![checkedItemsArray containsObject:item]){
    *checkedItems+=1;
    [checkedItemsArray  addObject:item];
    CGPoint position = item.positionInGame;
    CGPoint testPosition;
        FloodItem*testItem;
    if(position.x<[field count]-1){
        testPosition = CGPointMake((int)position.x+1, (int)position.y);
        testItem = field[(int)testPosition.x][(int)testPosition.y];
        [self checkIfField:field IsValid:testItem checkedItems:checkedItems checkedItemsArray:checkedItemsArray];
    }
    if(position.x>0){
        testPosition = CGPointMake((int)position.x-1, (int)position.y);
        testItem = field[(int)testPosition.x][(int)testPosition.y];
        [self checkIfField:field IsValid:testItem checkedItems:checkedItems checkedItemsArray:checkedItemsArray];
    }
    if(position.y<[self.floodItems[0] count]-1){
        testPosition = CGPointMake((int)position.x, (int)position.y+1);
        testItem = field[(int)testPosition.x][(int)testPosition.y];
        [self checkIfField:field IsValid:testItem checkedItems:checkedItems checkedItemsArray:checkedItemsArray];
    }
    if(position.y>0){
        testPosition = CGPointMake((int)position.x, (int)position.y-1);
        testItem = field[(int)testPosition.x][(int)testPosition.y];
        [self checkIfField:field IsValid:testItem checkedItems:checkedItems checkedItemsArray:checkedItemsArray];
    }
    }
}

-(BOOL)checkIfNearStartGroup:(CGPoint)position{
    FloodItem* item;
    if(position.x<[self.floodItems count]-1){
        item = self.floodItems[(int)position.x+1][(int)position.y];
        if(item.isInWinGroup){
            return TRUE;
        }
    }
    if(position.x>0){
        item = self.floodItems[(int)position.x-1][(int)position.y];
        if(item.isInWinGroup){
            return TRUE;
        }
    }
    if(position.y<[self.floodItems[0] count]-1){
        item = self.floodItems[(int)position.x][(int)position.y+1];
        if(item.isInWinGroup){
            return TRUE;
        }
    }
    if(position.y>0){
        item = self.floodItems[(int)position.x][(int)position.y-1];
        if(item.isInWinGroup){
            return TRUE;
        }
    }
    return FALSE;
}

-(void)changeWinGroupTo:(NSString*)filename{
    for (FloodItem*item in self.startingGroup) {
        [item setColor:filename];
    }
}

-(void)addSameItemsToWinGroup:(FloodItem*)item{
    if(![item isEqual:@"empty"]){
        if(![self.sameColorGroup containsObject:item] && ![self.startingGroup containsObject:item]){
            [self.sameColorGroup addObject:item];
        }
        CGPoint position = item.positionInGame;
        CGPoint testPosition;
        if(position.x<[self.floodItems count]-1){
            testPosition = CGPointMake((int)position.x+1, (int)position.y);
            [self checkItemAtPos:testPosition andItem:item];
        }
        if(position.x>0){
            testPosition = CGPointMake((int)position.x-1, (int)position.y);
            [self checkItemAtPos:testPosition andItem:item];
        }
        if(position.y<[self.floodItems[0] count]-1){
            testPosition = CGPointMake((int)position.x, (int)position.y+1);
            [self checkItemAtPos:testPosition andItem:item];
        }
        if(position.y>0){
            testPosition = CGPointMake((int)position.x, (int)position.y-1);
            [self checkItemAtPos:testPosition andItem:item];
        }
    }
}

-(void)checkItemAtPos:(CGPoint)testPosition andItem:(FloodItem*)item{
    FloodItem*testItem;
    testItem = self.floodItems[(int)testPosition.x][(int)testPosition.y];
    if(![testItem isEqual:@"empty"]){
        if([item.currentColor isEqualToString:testItem.currentColor] && ![self.sameColorGroup containsObject:testItem]){
            [self addSameItemsToWinGroup:testItem];
        }
    }
}

-(void)addSameItemsToStartGroup{
    for (FloodItem*item in self.sameColorGroup) {
        [item updateAsset:@"p1.png"];
        item.isInWinGroup = YES;
        [self.startingGroup addObject:item];
        [GameModel sharedModel].score++;
    }
}

-(void)checkStartgroupNeighbourhood{
    for (FloodItem*item in self.sameColorGroup) {
        if([self checkIfNearStartGroup:item.positionInGame]){
            [GameModel sharedModel].turns--;
            [self addSameItemsToStartGroup];
            return;
        }
    }
}

-(void)win{
    if([GameModel sharedModel].levels.count-1>[GameModel sharedModel].level){
        [GameModel sharedModel].level++;
        [GameModel sharedModel].turns += 7;
        [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    }
    [self applyWinSequence];
}

-(void)applyLooseSequence{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite*sprite = [[CCSprite alloc] initWithFile:@"loose.png"];
    [self.guiLayer addChild:sprite];
    id moveToCenter = [CCMoveTo actionWithDuration:2 position:ccp(winSize.width/2, winSize.height/2)];
    id moveToLeft = [CCMoveTo actionWithDuration:2 position:ccp(0-sprite.boundingBox.size.width, winSize.height/2)];
    sprite.position = ccp(winSize.width+sprite.boundingBox.size.width, winSize.height/2);
    [sprite runAction:[CCSequence actions:
                       [CCEaseBackInOut actionWithAction:moveToCenter],
                       [CCDelayTime actionWithDuration:0.5],
                       [CCEaseBackInOut actionWithAction:moveToLeft],
                       [CCCallFuncO actionWithTarget:self selector:@selector(openScore) object:nil],
                       nil]];
}

-(void)openScore{
    [[LayerManager sharedManager] clear:self];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ScoreLayer scene] withColor:ccWHITE]];
}

-(void)applyWinSequence{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite*sprite = [[CCSprite alloc] initWithFile:@"win.png"];
    [self.guiLayer addChild:sprite];
    id moveToCenter = [CCMoveTo actionWithDuration:1 position:ccp(winSize.width/2, winSize.height/2)];
    id moveToLeft = [CCMoveTo actionWithDuration:1 position:ccp(0-sprite.boundingBox.size.width, winSize.height/2)];
    sprite.position = ccp(winSize.width+sprite.boundingBox.size.width, winSize.height/2);
    [sprite runAction:[CCSequence actions:
                       [CCEaseBackInOut actionWithAction:moveToCenter],
                       [CCDelayTime actionWithDuration:0.5],
                       [CCEaseBackInOut actionWithAction:moveToLeft],
                       [CCCallFuncO actionWithTarget:self selector:@selector(nextLevel) object:nil],
                     nil]];
}

-(void)nextLevel{
    [[LayerManager sharedManager] clear:self];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameFieldLayer scene] withColor:ccWHITE]];
}

-(void)loose{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [self applyLooseSequence];
}

#pragma mark -

-(void)chooseItem:(FloodItem *)item{
    if(item.isInWinGroup){return;}
    self.sameColorGroup = [[NSMutableArray alloc] init];
    [self addSameItemsToWinGroup:item];
    [self checkStartgroupNeighbourhood];
    [self.guiLayer update];
    if(self.startingGroup.count == self.totalItems){
        [self win];
    }
    if([GameModel sharedModel].turns == 0){
        [self loose];
    }
}

-(void)chooseColor:(NSString *)color{
    [GameModel sharedModel].turns--;
    [self changeWinGroupTo:color];
    [self addSameItemsToWinGroup:self.startingGroup[0]];
    [self checkStartgroupNeighbourhood];
    for (FloodItem*item in self.startingGroup) {
        item.currentColor = @"p1.png";
    }
    [self.guiLayer update];
    if(self.startingGroup.count == self.totalItems){
        [self win];
    }
    if([GameModel sharedModel].turns == 0){
        [self loose];
    }
}

#pragma mark -

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
        for (NSArray*items in self.floodItems) {
                for (FloodItem*item in items) {
                    if (CGRectContainsPoint(item.boundingBox, [self convertTouchToNodeSpace:touch])) {
                        [self floodItemTapped:item];
                        return true;
                    }
            }
        }
    return false;
}

-(void)floodItemTapped:(id)item{
    FloodItem*floodItem = item;
    NSLog(@"%@", floodItem.currentColor);
    //[self chooseColor:floodItem.filename];
    [self chooseItem:floodItem];
    if(floodItem.isInWinGroup){
        [self updateItemCounters];
    }
}

#pragma mark -

-(void)updateItemCounters{
    for (NSArray*items in self.floodItems) {
        for (FloodItem*item in items) {
            [item updateCounter];
        }
    }
}

@end
