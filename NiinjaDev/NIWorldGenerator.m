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
static const uint32_t bonusCategory = 0x1 << 4;

NSArray *fireFrames;
NSArray *snakeFrames;
NSArray *teleportFrames;

+(id)generatorWithWorld:(SKNode *)world {
    
    NIWorldGenerator *generator = [NIWorldGenerator node];
    generator.world = world;
    
    NSMutableArray *snakeTempFrames = [NSMutableArray array];
    snakeFrames = [self createSnakeFrames: snakeTempFrames];
    
    NSMutableArray *fireObstacleFrames = [NSMutableArray array];
    fireFrames = [self createFireFrames: fireObstacleFrames];
    
    NSMutableArray *teleportTempFrames = [NSMutableArray array];
    teleportFrames = [self createTeleportFrames:teleportTempFrames];
    
    [generator generate];
    return generator;
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

    // secret catacombe to prevent hero from falling from the scene.. still gotta fix the NON-ending NON-dying thing
    // still have to fix the falling down thing on the end of the elvel...
    for (int k=0; k < 100; k++) {
        
        SKSpriteNode *ground = [self setBigGroundBlockWithFilepath:@"back" andName:@"hellGround"];
        ground.position = CGPointMake((k * ground.frame.size.width), -ground.frame.size.height - ground.frame.size.height*2);
        [self.world addChild:ground];
        
        if (k % 2 == 1) {
            SKSpriteNode *secretPointsRune = [self setBonusRuneWithFilepath:@"7_gf_set_3" andName:@"pointsBonusRune"];
            secretPointsRune.position = CGPointMake((k * ground.frame.size.width), -ground.frame.size.height -ground.frame.size.height);
            [self.world addChild:secretPointsRune];
        }

        // if i can shoot this can be used as a practice room
        
        if (k % 3 == 1) {
            SKSpriteNode *snake = [self setSnakeObstacleWithName:@"snakeObstacle"];
            snake.position = CGPointMake(k * ground.frame.size.width, -ground.frame.size.height - ground.frame.size.height);
            [self.world addChild:snake];
        }
        
        if (k % 7 == 1 & k > 10) {
            // create teleport
            SKSpriteNode *teleport = [self setTeleportDoorWithName:@"Teleport"];
            teleport.position = CGPointMake(k * ground.frame.size.width, -ground.frame.size.height - ground.frame.size.height);
            [self.world addChild:teleport];
        }
        
        if  (k % 8 == 1) {
            
            SKSpriteNode *bonusPointsRune = [self setBonusRuneWithFilepath:@"7_gf_set_5" andName:@"blueBonusRune"];
            bonusPointsRune.position = CGPointMake((k * ground.frame.size.width),
                                                    -ground.frame.size.height - ground.frame.size.height);
           
            [self.world addChild:bonusPointsRune];
        }
    }
    
    
    // ground, blocks, bonuses and enemies creation
    for (int i=0; i<60; i++)
    {
        // The BONUS LIFE Rune at the end of the level and for testing urposes at the begining
        if (i == 20 | i == 54) {
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
            
            SKSpriteNode *bonusPointsRune = [self setBonusRuneWithFilepath:@"7_gf_set_4" andName:@"redBonusRune"];
            bonusPointsRune.position = CGPointMake((i * ground.frame.size.width),
                                                   
                                                   -ground.frame.size.height + bonusPointsRune.frame.size.height * 3);
            [self.world addChild:bonusPointsRune];
        }
        
        // build the end of level wall!
        if (i == 57) {
            // MARK: Create the end game portal here..
        }
        
        if (i == 58) {
            for (int z = 0; z < 10; z++) {
                SKSpriteNode *wallUpper = [self setBigGroundBlockWithFilepath:@"back" andName:@"back"];
                wallUpper.position = CGPointMake((i * wallUpper.frame.size.width), + wallUpper.frame.size.height * z);
                
                SKSpriteNode *wallUnder = [self setBigGroundBlockWithFilepath:@"back" andName:@"back"];
                wallUnder.position = CGPointMake((i * wallUnder.frame.size.width), - wallUnder.frame.size.height * z);
                
                [self.world addChild:wallUpper];
                [self.world addChild:wallUnder];
            }
        }
        
        
        // opening holes on every fifth block - all other is ground
        if ((i % 5 != 1)) {
            
            if (i % 9 == 1) {
                SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];

                SKSpriteNode *snake = [self setSnakeObstacleWithName:@"snakeObstacle"];
                snake.position = CGPointMake(i * ground.frame.size.width, -ground.frame.size.height);
                [self.world addChild:snake];
            }
            
            // small blocks to crawl under
            if (i % 7 == 1) {
                SKSpriteNode *ground = [self setSmallGroundBlockWithFilepath:@"back" andName:@"back"];
                ground.position = CGPointMake((i * ground.frame.size.width),  -ground.frame.size.height * 2 + 50);
                [self.world addChild:ground];
            }
            
            
            if (i == 25 | i == 50) {
                // smaller ground blocks to climb up
                for (int z = 0; z < 4; z++) {
                    
                    SKSpriteNode *ground = [self setSmallGroundBlockWithFilepath:@"back" andName:@"back"];
                    ground.position = CGPointMake((i + z )* 24, (z * 10 ) - 30);
                    [self.world addChild:ground];
                    
                    // Bonus runes
                    if (z % 2 == 1) {
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

            SKSpriteNode *fireAnimation = [self setFireObstacleWithName:@"fireObstacle"];
            fireAnimation.position = CGPointMake((i * ground.frame.size.width),
                                                 -ground.frame.size.height + fireAnimation.frame.size.height/2);

            [self.world addChild:fireAnimation];
        }
        
        if (i % 2 != 1 & i % 3 != 1 & i % 7 != 1){
            
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
            
            SKSpriteNode *bonusPointsRune = [self setBonusRuneWithFilepath:@"7_gf_set_3" andName:@"pointsBonusRune"];
            bonusPointsRune.position = CGPointMake((i * ground.frame.size.width),
             
                                                   -ground.frame.size.height + bonusPointsRune.frame.size.height * 3);
            [self.world addChild:bonusPointsRune];
        }
        
        if  (i % 6 == 1) {
            
            SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
            
            SKSpriteNode *bonusPointsRune = [self setBonusRuneWithFilepath:@"7_gf_set_5" andName:@"blueBonusRune"];
            bonusPointsRune.position = CGPointMake((i * ground.frame.size.width),
                                                   -ground.frame.size.height + bonusPointsRune.frame.size.height * 5);
            [self.world addChild:bonusPointsRune];
        }
    }
    
}

-(SKSpriteNode *) setBonusRuneWithFilepath: (NSString *)filepath andName:(NSString *)nodeName {
    SKSpriteNode *bonusRune = [SKSpriteNode spriteNodeWithImageNamed:filepath];
    bonusRune.xScale = 0.2;
    bonusRune.yScale = 0.2;
    bonusRune.name = nodeName;
    bonusRune.physicsBody.dynamic = NO;
    bonusRune.physicsBody.categoryBitMask = bonusCategory;
    
    return bonusRune;
}

// MARK:
-(SKSpriteNode *) setSnakeObstacleWithName:(NSString *)nodeName {
    
    SKTexture *snakeTexture = snakeFrames[0];
    SKSpriteNode *snake = [SKSpriteNode spriteNodeWithTexture:snakeTexture];
    snake.xScale = 0.6;
    snake.yScale = 0.6;
    snake.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(snake.frame.size.width/1.5 ,
                                                                          snake.frame.size.width/1.5)];
    snake.physicsBody.dynamic = YES;
    snake.physicsBody.allowsRotation = NO;
    snake.physicsBody.categoryBitMask = obstacleCategory;
    snake.zPosition = 3;
    snake.name = nodeName;

    [snake runAction:[SKAction repeatActionForever:
                      [SKAction animateWithTextures:snakeFrames
                                       timePerFrame:0.1f
                                             resize:YES
                                            restore:YES]] withKey:nodeName];
    return snake;
}

-(SKSpriteNode *) setTeleportDoorWithName:(NSString *)nodeName {
    
    SKTexture *fteleportexture = teleportFrames[0];
    SKSpriteNode *fteleportAnimationNode = [SKSpriteNode spriteNodeWithTexture:fteleportexture];
    fteleportAnimationNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(fteleportAnimationNode.frame.size.width/4,
                                                                                      fteleportAnimationNode.frame.size.height)];
    fteleportAnimationNode.physicsBody.dynamic = YES;
    fteleportAnimationNode.physicsBody.allowsRotation = NO;
    fteleportAnimationNode.physicsBody.categoryBitMask = obstacleCategory;
    fteleportAnimationNode.name = nodeName;
    
    [fteleportAnimationNode runAction:[SKAction repeatActionForever:
                                  [SKAction animateWithTextures:teleportFrames
                                                   timePerFrame:0.1f
                                                         resize:YES
                                                        restore:YES]] withKey:nodeName];
    
    return fteleportAnimationNode;
}

-(SKSpriteNode *) setFireObstacleWithName:(NSString *)nodeName {
    
    SKTexture *fireTexture = fireFrames[0];
    SKSpriteNode *fireAnimationNode = [SKSpriteNode spriteNodeWithTexture:fireTexture];
    fireAnimationNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(fireAnimationNode.frame.size.width/2,
                                                                                  fireAnimationNode.frame.size.width/2)];
    fireAnimationNode.physicsBody.dynamic = NO;
    fireAnimationNode.physicsBody.allowsRotation = NO;
    fireAnimationNode.physicsBody.categoryBitMask = obstacleCategory;
    fireAnimationNode.name = nodeName;
    
    [fireAnimationNode runAction:[SKAction repeatActionForever:
                              [SKAction animateWithTextures:fireFrames
                                               timePerFrame:0.1f
                                                     resize:YES
                                                    restore:YES]] withKey:@"fireObstacle"];
    
    return fireAnimationNode;
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
    ground.name = nodeName;
    
    return ground;
}

+(NSMutableArray *)createFireFrames: fireFrames {
    SKTextureAtlas *heroAnimatedAtlas = [SKTextureAtlas atlasNamed:@"Fire"];
    
    for (int i=0; i <= 3; i++) {
        NSString *textureName = [NSString stringWithFormat:@"Fire-%i", i];
        SKTexture *temp = [heroAnimatedAtlas textureNamed:textureName];
        [fireFrames addObject:temp];
    }
    
    return fireFrames;
}

+(NSMutableArray *)createSnakeFrames: snakeFrames {
    SKTextureAtlas *heroAnimatedAtlas = [SKTextureAtlas atlasNamed:@"Snake"];
    
    for (int i=5; i <= 8; i++) {
        NSString *textureName = [NSString stringWithFormat:@"snake-00%i", i];
        SKTexture *temp = [heroAnimatedAtlas textureNamed:textureName];
        [snakeFrames addObject:temp];
    }
    
    return snakeFrames;
}

+(NSMutableArray *)createTeleportFrames:teleportFrames {
    SKTextureAtlas *teleportAnimatedAtlas = [SKTextureAtlas atlasNamed:@"Teleport"];
    
    for (int i=5; i <= 8; i++) {
        NSString *textureName = [NSString stringWithFormat:@"Teleport-00%i", i];
        SKTexture *temp = [teleportAnimatedAtlas textureNamed:textureName];
        [teleportFrames addObject:temp];
    }
    
    return teleportFrames;
}

@end
