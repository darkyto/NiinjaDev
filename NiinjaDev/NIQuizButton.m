//
//  NIQuizButton.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 2/5/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import "NIQuizButton.h"

@implementation NIQuizButton


+(id)initWithFrameAndFalseValue :(CGRect) frame {
    
    NIQuizButton *btn = [[NIQuizButton alloc] initWithFrame:frame];
    btn.isTrue = 0;
    btn.backgroundColor = [UIColor redColor];
    btn.titleLabel.font = [UIFont fontWithName:@"Chalkduster" size:14];
    
    return  btn;
}

@end
