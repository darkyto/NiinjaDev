//
//  MLHero.h
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/29/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface NIHero : SKSpriteNode

+(id) hero;
-(void) walkRight;
-(void) walkLeft;
-(void) jumpRight;
-(void) jumpLeft;
-(void)start;
-(void)stop;
+(NSMutableArray *) createWalkingFrames:walkFrames;

@end
