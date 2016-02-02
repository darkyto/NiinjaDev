//
//  NIWorldGenerator.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/30/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import "NIWorldGenerator.h"

@interface NIWorldGenerator()

@property SKNode *world;
@property SKSpriteNode *ground;

@end

@implementation NIWorldGenerator

static const uint32_t obstacleCategory = 0x1 << 1;
static const uint32_t groundCategory = 0x1 << 2;
static const uint32_t backgroundCategory = 0x1 << 3;

NSArray *fireFrames;


+(id)generatorWithWorld:(SKNode *)world {
    
    NIWorldGenerator *generator = [NIWorldGenerator node];
    generator.world = world;
    
    NSMutableArray *fireObstacleFrames = [NSMutableArray array];
    fireFrames = [self createFireFrames: fireObstacleFrames];
    
    [generator generate];
    return generator;
}

-(void)populate {

}

-(void)generate {
    // background creation
    for (int y = 0; y < 8; y++) {
        if (y % 2 == 0) {
            SKSpriteNode *background = [self setBackgroundFilepath:@"video-game-background-0" andName:@"background"];
            background.position = CGPointMake(y * background.frame.size.width,30);
            [self.world addChild:background];
        } else {
            SKSpriteNode *background2 = [self setBackgroundFilepath:@"video-game-background-1" andName:@"background2"];
            background2.position = CGPointMake(y * background2.frame.size.width,30);
            [self.world addChild:background2];
        }

    }

    // ground, blocks, bonuses and enemies creation
    for (int i=0; i<60; i++)
    {
        // opening holes
        if ((i % 5 != 1)) {
            
            // small blocks to crawl under
            if (i % 7 == 1) {
                SKSpriteNode *ground = [self setSmallGroundBlockWithFilepath:@"back" andName:@"back"];
                ground.position = CGPointMake((i * ground.frame.size.width),  -ground.frame.size.height * 2 + 50);
                [self.world addChild:ground];
            }
            
            
            if (i == 25) {
                // smaller ground blocks to climb up
                for (int z = 0; z < 4; z++) {
                    
                    SKSpriteNode *ground = [self setSmallGroundBlockWithFilepath:@"back" andName:@"back"];
                    ground.position = CGPointMake((i + z )* 24, (z * 10 ) - 30);
                    [self.world addChild:ground];
                    
                    // Bonus runes
                    if (z == 3) {
                        SKSpriteNode *bonusPointsRune = [self setBonusRuneWithFilepath:@"7_gf_set_3" andName:@"pointsBonusRune"];
                        bonusPointsRune.position = CGPointMake((i + z )* 24, z * 10);
                        [self.world addChild:bonusPointsRune];
                    }
                }
                
                // smaller ground blocks to go down
                for (int w = 0; w < 4; w++) {
                    
                    SKSpriteNode *ground = [self setSmallGroundBlockWithFilepath:@"back" andName:@"back"];
                    ground.position = CGPointMake((i - w )* 32, (w * 10 ) - 30);
                    [self.world addChild:ground];
                }
            
            }
            
            // initial ground  setBigGroundBlockWithFilepath
            SKSpriteNode *ground = [self setBigGroundBlockWithFilepath:@"back" andName:@"back"];
            ground.position = CGPointMake((i * ground.frame.size.width), -ground.frame.size.height - 15);
            [self.world addChild:ground];
            
        } else {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];

            // Fire obstacle in each hole where no ground is created
            SKTexture *fireTexture = fireFrames[0];
            SKSpriteNode *fireAnimation = [SKSpriteNode spriteNodeWithTexture:fireTexture];
            fireAnimation.position = CGPointMake((i * ground.frame.size.width),
                                                 -ground.frame.size.height + fireAnimation.frame.size.height/2);
            fireAnimation.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(fireAnimation.frame.size.width/2,
                                                                                          fireAnimation.frame.size.width/2)];
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
            
            SKSpriteNode *bonusPointsRune = [self setBonusRuneWithFilepath:@"7_gf_set_3" andName:@"pointsBonusRune"];
            bonusPointsRune.position = CGPointMake((i * ground.frame.size.width),
                                                   -ground.frame.size.height + bonusPointsRune.frame.size.height * 3);
            [self.world addChild:bonusPointsRune];
        }
    }
    
}

-(SKSpriteNode *) setBonusRuneWithFilepath: (NSString *)filepath andName:(NSString *)nodeName {
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:filepath];
    node.xScale = 0.2;
    node.yScale = 0.2;
    node.name = nodeName;
    node.physicsBody.dynamic = NO;
    node.physicsBody.categoryBitMask = groundCategory;
    
    return node;
}

-(SKSpriteNode *) setBackgroundFilepath: (NSString *)filepath andName:(NSString *)nodeName {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:filepath];
    background.physicsBody.dynamic = NO;
    background.name = nodeName;
    background.physicsBody.categoryBitMask = backgroundCategory;
    
    return background;
}

-(SKSpriteNode *) setSmallGroundBlockWithFilepath: (NSString *)filepath andName:(NSString *)nodeName {
    SKSpriteNode *smallBlockGround = [SKSpriteNode spriteNodeWithImageNamed:filepath];
    smallBlockGround.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(smallBlockGround.frame.size.width/2, smallBlockGround.frame.size.height)];
    smallBlockGround.physicsBody.dynamic = NO;
    smallBlockGround.physicsBody.categoryBitMask = groundCategory;
    smallBlockGround.xScale = 0.3;
    smallBlockGround.yScale = 0.3;
    smallBlockGround.zPosition = 1;
    smallBlockGround.name = nodeName;

    return smallBlockGround;
}

-(SKSpriteNode *) setBigGroundBlockWithFilepath: (NSString *)filepath andName:(NSString *)nodeName {
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
    ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
    ground.zPosition = 2;
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.frame.size];
    ground.physicsBody.dynamic = NO;
    ground.name = @"back";
    ground.physicsBody.categoryBitMask = groundCategory;
    
    return ground;
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
