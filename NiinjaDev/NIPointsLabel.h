//
//  NIPointsLabel.h
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/30/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface NIPointsLabel : SKLabelNode

@property int number;

+(id)pointsLabelWithFontNamed:(NSString*) fontName;

-(void)increment;
-(void)incrementWith:(int)points;

@end
