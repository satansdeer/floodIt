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
    if(self = [super initWithFile:filename]){
        self.myDelegate = delegate;
        self.filename = filename;
        //self.color = ccc3(140, 140, 180);
        self.positionInGame = pos;
    }
    return self;
}

-(void)updateToFilename:(NSString*)file{
    self.filename = file;
    [self setTexture:[[CCTextureCache sharedTextureCache] addImage:file]];
}

@end
