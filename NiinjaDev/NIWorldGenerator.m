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

NSArray *fireFrames;


+(id)generatorWithWorld:(SKNode *)world {
    NIWorldGenerator *generator = [NIWorldGenerator node];
    generator.currentGroundX = 0;
    generator.currentObstacleX = 400;
    generator.world = world;
    
    NSMutableArray *fireObstacleFrames = [NSMutableArray array];
    fireFrames = [self createFireFrames: fireObstacleFrames];
    
    [generator generate];
    return generator;
}

-(void)populate {

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
        if ((i % 5 != 1)) {
            
//            if (i % 7 == 1) {
//                SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
//                ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
//                ground.xScale = 0.3;
//                ground.yScale = 0.3;
//                ground.position = CGPointMake((i * ground.frame.size.width),  -ground.frame.size.height * 2);
//                ground.zPosition = 1;
//                ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(ground.frame.size.width/2, ground.frame.size.height/2)];
//                ground.physicsBody.dynamic = NO;
//                ground.name = @"back";
//                ground.physicsBody.categoryBitMask = groundCategory;
//                [self.world addChild:ground];
//            }
            
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
            ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
            ground.position = CGPointMake((i * ground.frame.size.width), -ground.frame.size.height - 15);
            ground.zPosition = 2;
            ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.frame.size];
            ground.physicsBody.dynamic = NO;
            ground.name = @"back";
            ground.physicsBody.categoryBitMask = groundCategory;
            [self.world addChild:ground];
            
            self.currentGroundX += ground.frame.size.width;
            
        } else {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];

            SKTexture *fireTexture = fireFrames[0];
            SKSpriteNode *fireAnimation = [SKSpriteNode spriteNodeWithTexture:fireTexture];
            fireAnimation.position = CGPointMake((i * ground.frame.size.width), -ground.frame.size.height + fireAnimation.frame.size.height/2);
            fireAnimation.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(fireAnimation.frame.size.width/2, fireAnimation.frame.size.width/2)];
            fireAnimation.physicsBody.dynamic = NO;
            fireAnimation.name = @"fireObstacle";
            fireAnimation.physicsBody.categoryBitMask = obstacleCategory;
            
            [fireAnimation runAction:[SKAction repeatActionForever:
                             [SKAction animateWithTextures:fireFrames
                                              timePerFrame:0.1f
                                                    resize:YES
                                                   restore:YES]] withKey:@"fireObstacle"];
            
            [self.world addChild:fireAnimation];
        }
        
        if (i % 5 != 1 & i % 2 != 1) {
            
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

+(NSMutableArray *)createFireFrames: fireFrames {
    SKTextureAtlas *heroAnimatedAtlas = [SKTextureAtlas atlasNamed:@"Fire"];
    
    for (int i=0; i <= 3; i++) {
        NSString *textureName = [NSString stringWithFormat:@"Fire-%d", i];
        SKTexture *temp = [heroAnimatedAtlas textureNamed:textureName];
        [fireFrames addObject:temp];
    }
    
    return fireFrames;
}

@end
