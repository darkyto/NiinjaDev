//
//  GameViewController.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 1/29/16.
//  Copyright (c) 2016 iNick Iliev. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@implementation GameViewController 

@synthesize userChoiceHero;

@synthesize managedObjectContext;
@synthesize fetchedResultsController;

@synthesize players;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    GameScene *scene = [GameScene initWithSize:CGSizeMake(skView.frame.size.height, skView.frame.size.width) andUserChoiceHero:userChoiceHero];

    scene.scaleMode = SKSceneScaleModeAspectFill;

    [skView presentScene:scene];

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
