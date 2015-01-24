//
//  ViewController.h
//  SimonSays
//
//  Created by Johnny on 2015-01-23.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


//
// Constants
//

#define SIMON_SAYS_BUTTON_COUNT 4


//
// Types
//

typedef NS_ENUM(uint, SimonSaysButtonID) {
	
	SimonSaysButton_None =		0,
	SimonSaysButton_Green =		1,
	SimonSaysButton_Red =		2,
	SimonSaysButton_Blue =		3,
	SimonSaysButton_Orange =	4
};


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

