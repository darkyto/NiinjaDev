//
//  GameViewController.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/29/16.
//  Copyright (c) 2016 iNick Iliev. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController 

@synthesize userChoiceHero;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    // skView.ignoresSiblingOrder = YES;
    
    // Create and configure the scene.

    GameScene *scene = [GameScene initWithSize:CGSizeMake(skView.frame.size.height, skView.frame.size.width) andUserChoiceHero:userChoiceHero];
    
    // SKScene *scene = [GameScene sceneWithSize:CGSizeMake(skView.frame.size.height, skView.frame.size.width)];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    NSLog(@"USER CHOICE HERE :  %@", userChoiceHero);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
