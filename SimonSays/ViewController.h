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

typedef NS_ENUM(char, SimonSaysButtonID) {
	
	SimonSaysButton_None =		'\0',
	SimonSaysButton_Green =		'g',
	SimonSaysButton_Red =		'r',
	SimonSaysButton_Blue =		'b',
	SimonSaysButton_Orange =	'o'
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

