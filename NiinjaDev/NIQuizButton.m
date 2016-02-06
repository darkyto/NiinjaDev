//
//  NIQuizButton.m
//  NiinjaDev
//
//  Created by Nikolay Plamenov Iliev on 2/5/16.
//  Copyright © 2016 iNick Iliev. All rights reserved.
//

#import "NIQuizButton.h"

@implementation NIQuizButton


+(id)buttonWithFalseValue {
    NIQuizButton *btn = [NIQuizButton buttonWithType:UIButtonTypeCustom];
    btn.isTrue = 0;
    return  btn;
}

@end
