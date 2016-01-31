//
//  NIWorldGenerator.h
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/30/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface NIWorldGenerator : SKNode

+(id)generatorWithWorld:(SKNode *)world;
-(void)populate;
-(void)generate;
@end
