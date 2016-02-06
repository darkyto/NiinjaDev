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

@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *GreenManButton;
@property (weak, nonatomic) IBOutlet UIButton *AlienNinjaButton;
@end

@implementation StartupViewController

static NSString *GAME_FONT = @"Chalkduster";

-(void) viewDidLoad {
    [super viewDidLoad];

    [self.GreenManButton setImage:[UIImage imageNamed:@"greenman-0-1"] forState:UIControlStateNormal];
    self.GreenManButton.titleLabel.font = [UIFont fontWithName:GAME_FONT size:12];

    [self.AlienNinjaButton setImage:[UIImage imageNamed:@"AllienNinja-5"] forState:UIControlStateNormal];
    self.AlienNinjaButton.titleLabel.font = [UIFont fontWithName:GAME_FONT size:12];
    
    self.DescriptionLabel.font = [UIFont fontWithName:GAME_FONT size:24];
    self.DescriptionLabel.lineBreakMode = YES;
    self.DescriptionLabel.text = @"Alien Troubles";
    // Do any additional setup after loading the view.
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    // User choice will lead to game with selected hero
    if ([[segue identifier] isEqualToString:@"GreenmanSegue"])
    {
        
        GameViewController *destViewController = segue.destinationViewController;
        destViewController.userChoiceHero = @"greenman";
        
    } else if ([[segue identifier] isEqualToString:@"NinjaSegue"])
    {
        
        GameViewController *destViewController = segue.destinationViewController;
        destViewController.userChoiceHero = @"ninja";
        
    }
    
}

@end
