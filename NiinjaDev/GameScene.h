//
//  GameScene.h
//  NiinjaDev
//

//  Copyright (c) 2016 iNick Iliev. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

-(instancetype) initWithSize:(CGSize)size
                  andHero: (NSString *) userChoiceHero;

@end
