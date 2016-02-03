//
//  StartupViewController.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 2/1/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import "StartupViewController.h"
#import "GameViewController.h"

@interface StartupViewController ()

@end

@implementation StartupViewController

-(void) viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"GreenmanSegue"])
    {
        
        GameViewController *destViewController = segue.destinationViewController;
        destViewController.userChoiceHero = @"greenman";
        
    } else if ([[segue identifier] isEqualToString:@"NInjaSegue"])
    {
        
        GameViewController *destViewController = segue.destinationViewController;
        destViewController.userChoiceHero = @"ninja";
        
    }
    
}

@end
