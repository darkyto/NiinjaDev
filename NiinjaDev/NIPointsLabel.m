//
//  NIPointsLabel.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/30/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import "NIPointsLabel.h"

@implementation NIPointsLabel

+(id)pointsLabelWithFontNamed:(NSString*) fontName {
    NIPointsLabel *pointsLabel = [NIPointsLabel labelNodeWithFontNamed:fontName];
    pointsLabel.text = @"0";
    pointsLabel.fontSize = 18;
    pointsLabel.number = 0;
    return  pointsLabel;
}

-(void)increment {
    self.number++;
    self.text = [NSString stringWithFormat:@"%i", self.number];
}

-(void)setPoints:(int)points {
    self.number = points;
    self.text = [NSString stringWithFormat:@"%i", self.number];
}

-(void)reset {
    self.number = 0;
    self.text = @"0";
}

@end
