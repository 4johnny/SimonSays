//
//  ViewController.h
//  SimonSays
//
//  Created by Johnny on 2015-01-23.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


//
// Interface
//

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *greenButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *redButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *blueButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *orangeButtonOutlet;

@property (nonatomic, strong) NSMutableArray* buttonSequence;

-(void) startRound;


@end

