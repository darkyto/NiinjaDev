//
//  MLHero.h
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/29/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface NIHero : SKSpriteNode

+(id) hero: (NSString *) heroType;

-(void) walkRight; // tap right of hero
-(void) walkLeft;  // tap left of hero
-(void) jumpRight; // double-tap right of hero
-(void) jumpLeft;  // double-tap left of hero
-(void) makeHeroSmaller; // swipe up-down
-(void) makeHeroLarger;  // swipe down-up

-(void) start;
-(void) stop;

@end
