
//
//  GameScene.h
//  NiinjaDev
//
//  Copyright (c) 2016 iNick Iliev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

-(instancetype)initWithSize:(CGSize)size andUserChoiceHero:(NSString *)userChoiceHero;

+(id)initWithSize:(CGSize)size andUserChoiceHero:(NSString *)userChoiceHero;

@end
