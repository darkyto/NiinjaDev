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
        SKTexture *heroFrame = heroWalkingFrames[0];
        hero  = [NIHero spriteNodeWithTexture:heroFrame];
        [hero runAction:[SKAction repeatActionForever:
                         [SKAction animateWithTextures:heroWalkingFrames
                                          timePerFrame:0.1f
                                                resize:YES
                                               restore:YES]] withKey:@"walkingInPlaceHero"];
        hero.xScale = 0.8;
        hero.yScale = 0.8;
        hero.name = @"greenman";
        CGSize physicalSize = CGSizeMake(hero.frame.size.width/2, hero.frame.size.height/1.5 );
        hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:physicalSize];
        
    } else if ([heroType  isEqual: @"ninja"]) {
        
        heroWalkingFrames = [self createWalkingFramesNinja: walkFrames];
        SKTexture *heroFrames = heroWalkingFrames[0];
        hero  = [NIHero spriteNodeWithTexture:heroFrames];
        [hero runAction:[SKAction repeatActionForever:
                         [SKAction animateWithTextures:heroWalkingFrames
                                          timePerFrame:0.1f
                                                resize:YES
                                               restore:YES]] withKey:@"walkingInPlaceHero"];
        hero.xScale = 0.4;
        hero.yScale = 0.4;
        hero.name = @"alienNinja";
        CGSize physicalSize = CGSizeMake(hero.frame.size.width, hero.frame.size.height);
        hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:physicalSize];
        
    }

    
    // TODO : maybe the hero will pick a certain RUNE and it will change its density (heavier/lighter)
    // TODO : maybe the hero will pick a KALASHNIKOV to enable SHOOT option !?
    // hero.physicsBody.density = 1;
 
    hero.physicsBody.categoryBitMask = heroCategory;
    hero.physicsBody.allowsRotation = NO;
    hero.physicsBody.contactTestBitMask = obstacleCategory |
                                          (-groundCategory & -backgroundCategory );

    return hero;
}

-(void)start  {
    SKAction *incrementRight = [SKAction moveByX:0.8 y:0 duration:0.02];
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
    SKAction *incrementLeft = [SKAction moveByX:-25 y:0 duration:0];
    [hero runAction:incrementLeft];
    
    return;
}

-(void)jumpRight {
    
    if ([hero.name  isEqual: @"greenman"]) {
        [self.physicsBody applyImpulse:CGVectorMake(30, 80)];
    } else if ([hero.name  isEqual: @"alienNinja"])  {
        [self.physicsBody applyImpulse:CGVectorMake(30, 50)];
    }

    
    return;
}

-(void)jumpLeft {
    if ([hero.name  isEqual: @"greenman"]) {
        [self.physicsBody applyImpulse:CGVectorMake(-30, 80)];
    } else if ([hero.name  isEqual: @"alienNinja"])  {
        [self.physicsBody applyImpulse:CGVectorMake(-30, 50)];
    }

    return;
}

-(void)makeHeroSmaller {
    if ([hero.name  isEqual: @"greenman"]) {
        [self animateSizerWithScale:0.4];
    } else if ([hero.name  isEqual: @"alienNinja"])  {
        [self animateSizerWithScale:0.2];
    }
    
}

-(void)makeHeroLarger {
    if ([hero.name  isEqual: @"greenman"]) {
        [self animateSizerWithScale:0.8];
    } else if ([hero.name  isEqual: @"alienNinja"])  {
        [self animateSizerWithScale:0.4];
    }

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
    SKTextureAtlas *heroAnimatedAtlas = [SKTextureAtlas atlasNamed:@"AlienNinja"];
    
    for (int i=1; i <= 9; i++) {
        NSString *textureName = [NSString stringWithFormat:@"AllienNinja-00%d", i];
        SKTexture *temp = [heroAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    for (int i=10; i <= 24; i++) {
        NSString *textureName = [NSString stringWithFormat:@"AllienNinja-0%d", i];
        SKTexture *temp = [heroAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }

    return walkFrames;
}


@end
