//
//  NIWorldGenerator.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/30/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import "NIWorldGenerator.h"

@interface NIWorldGenerator()

@property double currentGroundX;
@property double currentObstacleX;
@property SKNode *world;

@end

@implementation NIWorldGenerator

static const uint32_t obstacleCategory = 0x1 << 1;
static const uint32_t groundCategory = 0x1 << 2;
static const uint32_t backgroundCategory = 0x1 << 3;


+(id)generatorWithWorld:(SKNode *)world {
    NIWorldGenerator *generator = [NIWorldGenerator node];
    generator.currentGroundX = 0;
    generator.currentObstacleX = 400;
    generator.world = world;
    [generator generate];
    return generator;
}

-(void)populate {
    // not what i espected here
//    for (int i = 0; i < 4; i++) {
//        [self generate];
//    }
}

-(void)generate {
    for (int y = 0; y < 5; y++) {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"game-background-sprites-0"];
        background.position = CGPointMake(y*background.frame.size.width, 30);
        background.physicsBody.dynamic = NO;
        background.name = @"background";
        background.physicsBody.categoryBitMask = backgroundCategory;
        [self.world addChild:background];
    }
    
    //        for (int z = 4; z < 8; z++) {
    //            SKSpriteNode *background2 = [SKSpriteNode spriteNodeWithImageNamed:@"game-background-sprites-1"];
    //            background2.position = CGPointMake(z*background2.size.width, 30);
    //            background2.physicsBody.dynamic = NO;
    //            background2.name = @"background2";
    //            [world addChild:background2];
    //        }
    
    
    for (int i=0; i<60; i++)
    {
        if ((i % 4 != 1)) {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
            ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
            ground.position = CGPointMake((i * ground.frame.size.width), -ground.frame.size.height - 15);
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.frame.size];
            ground.physicsBody.dynamic = NO;
            ground.name = @"back";
            ground.physicsBody.categoryBitMask = groundCategory;
            [self.world addChild:ground];
            
            self.currentGroundX += ground.frame.size.width;
            
        } else {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
            SKSpriteNode *fireObstacle = [SKSpriteNode spriteNodeWithColor:[UIColor redColor]
                                                                      size:CGSizeMake(40, 70)];
            fireObstacle.position = CGPointMake((i * ground.frame.size.width), -ground.frame.size.height + 10);
            fireObstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:fireObstacle.frame.size];
            fireObstacle.physicsBody.dynamic = NO;
            fireObstacle.name = @"fireObstacle";
            fireObstacle.physicsBody.categoryBitMask = obstacleCategory;
            [self.world addChild:fireObstacle];
        }
        
        if (i % 3 != 1 & i % 2 != 1) {
            
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
            SKSpriteNode *bonusPointsRune = [SKSpriteNode spriteNodeWithImageNamed:@"7_gf_set_3"];
            bonusPointsRune.xScale = 0.2;
            bonusPointsRune.yScale = 0.2;
            bonusPointsRune.position = CGPointMake((i * ground.frame.size.width),
                                                   -ground.frame.size.height + bonusPointsRune.frame.size.height * 3);
            bonusPointsRune.name = @"pointsBonusRune";
            bonusPointsRune.physicsBody.dynamic = NO;
            bonusPointsRune.physicsBody.categoryBitMask = groundCategory;
            
            [self.world addChild:bonusPointsRune];
        }
    }
    

}
@end
