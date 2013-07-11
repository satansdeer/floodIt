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
	if( (self=[super initWithColor:ccc4(0, 0, 0, 255)]) ) {
        GameModel*gameModel = [GameModel sharedModel];
        NSLog(@"!!!!! level %d", gameModel.level);
        self.totalItems = 0;
        NSDictionary*level = gameModel.levels[gameModel.level-1];
        NSNumber *tilesnum = [level objectForKey:@"tilesNum"];
        [self startWithTilesNum:[tilesnum integerValue] andAvailableColors:[level objectForKey:@"colors"]];
	}
	return self;
}

-(void)startWithTilesNum:(int)tilesNum andAvailableColors:(NSArray*)availableColors{
    self.startingGroup = [[NSMutableArray alloc] init];
    self.availableColors = availableColors;
    [self drawBackground:tilesNum];
    [self placeTiles:tilesNum];
    self.colorPanel = [[ColorPanel alloc] initWithDelegate:self andAvailableColors:self.availableColors];
    [self addChild:self.colorPanel];
    self.guiLayer = [[GuiLayer alloc] initWithDelegate:self];
    [self addChild:self.guiLayer];
}

-(void) tweenNode: (CCNode  *) node {
    [node runAction:[CCEaseElasticOut actionWithAction:[CCScaleTo actionWithDuration:1.7 scale:1]]];
}

-(void)drawBackground:(int)tilesNumber{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float tileSize = (winSize.width-8)/tilesNumber;
    for(int i = 0; i<tilesNumber; i++){
        self.floodItems[i] = [[NSMutableArray alloc] init];
        for(int j = tilesNumber; j>0; j--){
            CGPoint position = CGPointMake((tileSize)*i+4 + TILESIZE/2,
                                           (tileSize)*(j-1)+(winSize.height/2 - (TILESIZE*tilesNumber)/2)+22);
            CCSprite*tile = [[CCSprite alloc] initWithFile:@"Dirt Block.png"];
            tile.position = position;
            tile.scale = tileSize/TILESIZE;
            [self addChild:tile];
        }
    }
}

-(void)placeTiles:(int)tilesNumber{
    self.floodItems = [[NSMutableArray alloc] init];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float tileSize = (winSize.width-8-(2*tilesNumber))/tilesNumber;
    for(int i = 0; i<tilesNumber; i++){
        self.floodItems[i] = [[NSMutableArray alloc] init];
        for(int j = 0; j<tilesNumber; j++){
            NSString*filename;
            filename = [self randomFileName:FALSE];
            if(filename){
                CGPoint position = CGPointMake((tileSize+2)*i+4 + TILESIZE/2,
                                           (tileSize+2)*j+(winSize.height/2 - (TILESIZE*tilesNumber)/2)+30);
                FloodItem* image = [[FloodItem alloc] initWithFile:filename
                                                      position:CGPointMake(i, j)
                                                   andDelegate:nil];
                image.position = position;
                image.scale = tileSize/(TILESIZE+8);
                self.floodItems[i][j] = image;
                self.totalItems++;
            }
        }
    }
    FloodItem*startItem = self.floodItems[0][tilesNumber-1];
    [self makeEmptySpaces];
    [self displayItems];
    [startItem setTexture:[[CCTextureCache sharedTextureCache] addImage:@"p1.png"]];
    self.startingColor = startItem.filename;
    startItem.isInWinGroup = TRUE;
    [self.startingGroup addObject:startItem];
}

-(void)displayItems{
    for(int i = 0; i<self.floodItems.count; i++){
        for(int j = 0; j<self.floodItems.count; j++){
            if(![self.floodItems[i][j] isEqual:@"empty"]){
                [self addChild:self.floodItems[i][j]];
            }else{
                int tilesNumber = self.floodItems.count;
                CGSize winSize = [[CCDirector sharedDirector] winSize];
                float tileSize = (winSize.width-8-(2*tilesNumber))/tilesNumber;
                CGPoint position = CGPointMake((tileSize+2)*i+4 + TILESIZE/2,
                                               (tileSize+2)*j+(winSize.height/2 - (TILESIZE*tilesNumber)/2)+38);
                CCSprite*sprite = [[CCSprite alloc] initWithFile:@"Tree Tall.png"];
                sprite.zOrder = j*tilesNumber +i;
                sprite.position = position;
                [self addChild:sprite];
            }
        }
    }
}

-(void)makeEmptySpaces{
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
    while(checkedItems >= totalItems){
        NSLog(@"%d %d", checkedItems, totalItems);
        for(int i = 0; i<self.floodItems.count; i++){
            self.floodItems[i] = [[NSMutableArray alloc] init];
            for(int j = 0; j<self.floodItems.count; j++){
                self.floodItems[i][j] = testField[i][j];
            }
        }
        self.totalItems = totalItems;
        checkedItems = 0;
        NSMutableArray * checkedItemsArray = [[NSMutableArray alloc] init];
        [self removeRandomItemFromField:testField totalItems:&totalItems];
        [self checkIfField:testField
                   IsValid:startItem
              checkedItems:&checkedItems
         checkedItemsArray:checkedItemsArray];
        NSLog(@"%d %d", checkedItems, totalItems);
        NSLog(@"--");
    }
}

-(void)removeRandomItemFromField:(NSMutableArray*)field totalItems:(int*)totalItems{
    CGPoint point = CGPointMake((arc4random()%field.count-1)+1, (arc4random()%field.count-1)+1);
    if(![field[(int)point.x][(int)point.y] isEqual:@"empty"]){
        if(point.x!=0 && point.y < self.floodItems.count-1){
            *totalItems -= 1;
            field[(int)point.x][(int)point.y] = @"empty";
        }
    }
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

-(NSString*)randomFileName:(BOOL)canBeEmpty{
    int r;
    if(canBeEmpty){
        r = arc4random() % self.availableColors.count+1;
    }else{
        r = arc4random() % self.availableColors.count;
    }
    if(r<self.availableColors.count){
        return self.availableColors[r];
    }else{
        return nil;
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
        [item updateToFilename:filename];
    }
}

-(void)addSameItemsToWinGroup:(FloodItem*)item{
    if(![item isEqual:@"empty"]){
    if(![self.startingGroup containsObject:item]){
        [self.startingGroup addObject:item];
        [GameModel sharedModel].score++;
    }
    item.isInWinGroup = TRUE;
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
        if(item.filename == testItem.filename && !testItem.isInWinGroup){
            [self addSameItemsToWinGroup:testItem];
        }
    }
}

-(void)checkStartgroupNeighbourhood{
    NSLog(@"%@", [self.startingGroup[0] filename]);
    for (FloodItem*item in self.startingGroup) {
        item.isInWinGroup = FALSE;
    }
    [self addSameItemsToWinGroup:self.startingGroup[0]];
    for (FloodItem*item in self.startingGroup) {
    }
}

-(void)win{
    if([GameModel sharedModel].levels.count-1>[GameModel sharedModel].level){
        [GameModel sharedModel].level++;
        [GameModel sharedModel].turns += 7;
        [[CCTouchDispatcher sharedDispatcher] removeDelegate:self.colorPanel];
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameFieldLayer scene] withColor:ccWHITE]];
}

-(void)loose{
    [GameModel sharedModel].level = 1;
    [GameModel sharedModel].turns = 25;
    [GameModel sharedModel].score = 0;
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self.colorPanel];
     [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene] withColor:ccWHITE]];
}

#pragma mark - FloodItemDelegate


#pragma mark - ColorPanelDelegate

-(void)chooseColor:(NSString *)color{
    [GameModel sharedModel].turns--;
    [self changeWinGroupTo:color];
    [self addSameItemsToWinGroup:self.startingGroup[0]];
    [self checkStartgroupNeighbourhood];
    for (FloodItem*item in self.startingGroup) {
        [item updateToFilename:@"p1.png"];
    }
    [self.guiLayer update];
    if(self.startingGroup.count == self.totalItems){
        [self win];
    }
    if([GameModel sharedModel].turns == 0){
        [self loose];
    }
}

#pragma mark - GuiLayerDelegate

-(void)exitToMenu{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self.colorPanel];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainMenuLayer scene] withColor:ccWHITE]];
}

@end
