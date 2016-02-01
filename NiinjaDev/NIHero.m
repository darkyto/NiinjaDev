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

+ (id)hero:(NSString *)heroType{
    
    // MLHero *hero = [MLHero spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(30, 30)];
    
    // Making hero with sprite atlas to walk, smaller pphysical size, assigning name
    NSMutableArray *walkFrames = [NSMutableArray array];
    if ([heroType  isEqual: @"greenman"]) {
        heroWalkingFrames = [self createWalkingFramesGreenMan: walkFrames];
    } else if ([heroType  isEqual: @"ninja"]) {
        heroWalkingFrames = [self createWalkingFramesNinja: walkFrames];
    }
    SKTexture *heroFrames = heroWalkingFrames[0];
    hero  = [NIHero spriteNodeWithTexture:heroFrames];
    [hero runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:heroWalkingFrames
                                      timePerFrame:0.1f
                                            resize:YES
                                           restore:YES]] withKey:@"walkingInPlaceHero"];
    hero.xScale = 0.8;
    hero.yScale = 0.8;
    hero.name = @"hero";
    
    
    // TODO : maybe the hero will pick a certain RUNE and it will change its density (heavier/lighter)
    // TODO : maybe the hero will pick a KALASHNIKOV to enable SHOOT option !?
    // hero.physicsBody.density = 1;
 
    CGSize smallerPhysicalSize = CGSizeMake(hero.frame.size.width/2, hero.frame.size.height/1.5 );
    hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:smallerPhysicalSize];
    hero.physicsBody.categoryBitMask = heroCategory;
    hero.physicsBody.allowsRotation = NO;
    hero.physicsBody.contactTestBitMask = obstacleCategory |
                                          (-groundCategory & -backgroundCategory );

    return hero;
}

-(void)start  {
    SKAction *incrementRight = [SKAction moveByX:0.6 y:0 duration:0.02];
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
    SKAction *incrementLeft = [SKAction moveByX:-20 y:0 duration:0];
    [hero runAction:incrementLeft];
    
    return;
}

-(void)jumpRight {
    [self.physicsBody applyImpulse:CGVectorMake(30, 80)];
    
    return;
}

-(void)jumpLeft {
    [self.physicsBody applyImpulse:CGVectorMake(-30, 80)];
    
    return;
}

-(void)makeHeroSmaller {
    [self animateSizerWithScale:0.4];
}

-(void)makeHeroLarger {
    [self animateSizerWithScale:0.8];
}

-(void) animateSizerWithScale:(double) scaleFactor {
    
    SKAction *scaleTo = [SKAction scaleTo:scaleFactor duration:1];

    [self runAction:scaleTo];
}

+(NSMutableArray *)createWalkingFramesGreenMan: walkFrames {
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

+(NSMutableArray *)createWalkingFramesNinja: walkFrames {
    SKTextureAtlas *heroAnimatedAtlas = [SKTextureAtlas atlasNamed:@"GreenManRed"];
    
    for (int i=0; i <= 3; i++) {
        NSString *textureName = [NSString stringWithFormat:@"red-greenman-0-%d", i];
        SKTexture *temp = [heroAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    for (int i=0; i <= 3; i++) {
        NSString *textureName = [NSString stringWithFormat:@"red-greenman-1-%d", i];
        SKTexture *temp = [heroAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    for (int i=0; i <= 3; i++) {
        NSString *textureName = [NSString stringWithFormat:@"red-greenman-2-%d", i];
        SKTexture *temp = [heroAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    for (int i=0; i <= 2; i++) {
        NSString *textureName = [NSString stringWithFormat:@"red-greenman-3-%d", i];
        SKTexture *temp = [heroAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    
    return walkFrames;
}


@end
