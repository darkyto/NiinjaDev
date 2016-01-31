//
//  MLHero.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/29/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import "NIHero.h"

@implementation NIHero

static const uint32_t heroCategory = 0x1 << 0;
static const uint32_t obstacleCategory = 0x1 << 1;
static const uint32_t groundCategory = 0x1 << 2;
static const uint32_t backgroundCategory = 0x1 << 3;

NIHero *hero;
NSArray *heroWalkingFrames;

+ (id)hero {    
    
    // MLHero *hero = [MLHero spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(30, 30)];
    
    // Making hero with sprite atlas to walk, smaller pphysical size, assigning name
    NSMutableArray *walkFrames = [NSMutableArray array];
    heroWalkingFrames = [self createWalkingFrames: walkFrames];
    SKTexture *heroFrames = heroWalkingFrames[0];
    hero  = [NIHero spriteNodeWithTexture:heroFrames];
    hero.xScale = 0.8;
    hero.yScale = 0.8;
    CGSize smallerPhysicalSize = CGSizeMake( hero.frame.size.height - 40 , hero.frame.size.width - 35);
    hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:smallerPhysicalSize];

    [hero runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:heroWalkingFrames
                                      timePerFrame:0.1f
                                            resize:YES
                                           restore:YES]] withKey:@"walkingInPlaceHero"];
    hero.name = @"hero";
    hero.physicsBody.categoryBitMask = heroCategory;
    hero.physicsBody.contactTestBitMask = obstacleCategory | (-groundCategory & -backgroundCategory);
    
    
    return hero;
}

-(void)start  {
    SKAction *incrementRight = [SKAction moveByX:0.5 y:0 duration:0.02];
    SKAction *moveRight = [SKAction repeatActionForever:incrementRight];
    [self runAction:moveRight];
}

-(void)stop {
    [self removeAllActions];
}

-(void)walkRight {
    SKAction *incrementRight = [SKAction moveByX:10 y:0 duration:0];
    [hero runAction:incrementRight];

    return;
}

-(void)walkLeft {
    SKAction *incrementLeft = [SKAction moveByX:-10 y:0 duration:0];
    [hero runAction:incrementLeft];
    
    return;
}

-(void)jumpRight {
    [self.physicsBody applyImpulse:CGVectorMake(50, 80)];
}

-(void)jumpLeft {
    [self.physicsBody applyImpulse:CGVectorMake(-50, 80)];
}


+(NSMutableArray *)createWalkingFrames: walkFrames {
    SKTextureAtlas *heroAnimatedAtlas = [SKTextureAtlas atlasNamed:@"GreenMan"];
    
    for (int i=0; i <= 3; i++) {
        NSString *textureName = [NSString stringWithFormat:@"greenman-0-%d", i];
        SKTexture *temp = [heroAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    for (int i=0; i <= 3; i++) {
        NSString *textureName = [NSString stringWithFormat:@"greenman-1-%d", i];
        SKTexture *temp = [heroAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    for (int i=0; i <= 3; i++) {
        NSString *textureName = [NSString stringWithFormat:@"greenman-2-%d", i];
        SKTexture *temp = [heroAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    for (int i=0; i <= 2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"greenman-3-%d", i];
        SKTexture *temp = [heroAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    
    return walkFrames;
}

@end
