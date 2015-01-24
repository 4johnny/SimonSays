//
//  ViewController.m
//  SimonSays
//
//  Created by Johnny on 2015-01-23.
//  Copyright (c) 2015 Empath Solutions. All rights reserved.
//

#import "ViewController.h"


//
// Constants
//

#define BUTTON_ANIMATION_DURATION 2.0
#define BUTTON_ANIMATION_DELAY 1.0
#define BUTTON_ANIMATION_RELATIVE_DURATION (BUTTON_ANIMATION_DURATION / 2.0)

#define FLASH_COUNT_SUCCESS 1
#define FLASH_COUNT_FAILURE 3


//
// Interface
//


@interface ViewController ()

@property (nonatomic) int buttonClickCount;

@end


//
// Implementation
//


@implementation ViewController


//
// View Protocol Methods
//

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Do any additional setup after loading the view, typically from a nib.
	
	self.buttonSequence = [NSMutableArray array];
	self.buttonClickCount = 0;
}


-(void)viewWillAppear:(BOOL)animated {
	
	if (animated) return;
	
	[self startRound];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	
	// Dispose of any resources that can be recreated.
	
}


//
// Helper Methods
//


- (NSString*)simonSaysButtonStringWithID:(SimonSaysButtonID)buttonID {
	
	switch (buttonID) {
			
		case SimonSaysButton_Green:
			return @"Green";
			
		case SimonSaysButton_Red:
			return @"Red";
			
		case SimonSaysButton_Blue:
			return @"Blue";
			
		case SimonSaysButton_Orange:
			return @"Orange";
			
		default:
			return @"None";
	}
}


- (SimonSaysButtonID)simonSaysButtonIDWithNumber:(NSNumber*)number {
	
	return (SimonSaysButtonID)number.charValue;
}


- (NSNumber*)numberWithSimonSaysButtonID:(SimonSaysButtonID)buttonID {
	
	return [NSNumber numberWithChar:buttonID];
}


- (SimonSaysButtonID)randomSimonSaysButtonID {
	return (SimonSaysButtonID)(arc4random_uniform(SIMON_SAYS_BUTTON_COUNT) + 1);
}



//
// Game Methods
//

- (void)lightButton:(UIButton*)button {
	
	button.alpha = 1.0;
}


- (void)dimButton:(UIButton*)button {
	
	button.alpha = 0.5;
}


- (void)lightButtonWithID:(SimonSaysButtonID)buttonID {
	
	switch (buttonID) {
			
		case SimonSaysButton_Green:
			[self lightButton:self.greenButtonOutlet];
			return;
			
		case SimonSaysButton_Red:
			[self lightButton:self.redButtonOutlet];
			return;
			
		case SimonSaysButton_Blue:
			[self lightButton:self.blueButtonOutlet];
			return;
			
		case SimonSaysButton_Orange:
			[self lightButton:self.orangeButtonOutlet];
			return;
			
		default:
			return;
	}
}


- (void)dimButtonWithID:(SimonSaysButtonID)buttonID {
	
	switch (buttonID) {
			
		case SimonSaysButton_Green:
			[self dimButton:self.greenButtonOutlet];
			return;
			
		case SimonSaysButton_Red:
			[self dimButton:self.redButtonOutlet];
			return;
			
		case SimonSaysButton_Blue:
			[self dimButton:self.blueButtonOutlet];
			return;
			
		case SimonSaysButton_Orange:
			[self dimButton:self.orangeButtonOutlet];
			return;
			
		default:
			return;
	}
}


- (void)startRound {
	
	// Add random button to button sequence
	// TODO: Use NSValue non-retain wrapper around actual button objects.
	SimonSaysButtonID buttonID = [self randomSimonSaysButtonID];
	[self.buttonSequence addObject:[self numberWithSimonSaysButtonID:buttonID]];

	// Animate sequence of buttons.
	[UIView animateKeyframesWithDuration:BUTTON_ANIMATION_DURATION
								   delay:0.0 //BUTTON_ANIMATION_DELAY
								 options:(UIViewKeyframeAnimationOptions)0
							  animations:^{
								  
								  // For each button in sequence, animate by lighting and dimming it
								  for (int i = 0; i < self.buttonSequence.count; i++) {
									  
									  SimonSaysButtonID buttonID = [self simonSaysButtonIDWithNumber:self.buttonSequence[i]];
									  MDLog(@"Flash button: %@", [self simonSaysButtonStringWithID:buttonID]);
									  
									  [UIView addKeyframeWithRelativeStartTime:0.0
															  relativeDuration:BUTTON_ANIMATION_RELATIVE_DURATION
																	animations:^{
																		[self lightButtonWithID:buttonID];
																	}];
									  
									  [UIView addKeyframeWithRelativeStartTime:BUTTON_ANIMATION_RELATIVE_DURATION
															  relativeDuration:BUTTON_ANIMATION_RELATIVE_DURATION
																	animations:^{
																		[self dimButtonWithID:buttonID];
																	}];
								  }
								  
							  } completion:nil];
}


- (void)flashAllButtonsWithCount:(int)count {
	
	MDLog(@"Flash all buttons %d times", count);
	
}


- (void)buttonPressedWithID:(SimonSaysButtonID)buttonID {
	
	self.buttonClickCount++;
	SimonSaysButtonID sequenceButtonID =
	[self simonSaysButtonIDWithNumber:self.buttonSequence[self.buttonClickCount - 1]];
	
	// If pressed button is not consistent with sequence, reset game.
	if (buttonID != sequenceButtonID) {
		
		MDLog(@"Incorrect! Score: %d", self.buttonClickCount);
		[self flashAllButtonsWithCount:FLASH_COUNT_FAILURE];
		self.buttonClickCount = 0;
		[self.buttonSequence removeAllObjects];
		[self startRound];
		return;
	}
	
	// Pressed button is correct.
	// If player has not made it to end of sequence, continue playing
	if (self.buttonClickCount != self.buttonSequence.count) return;
	
	// Player has completed sequence successfully, so start a new round.
	MDLog(@"Correct! Score: %d", self.buttonClickCount);
	[self flashAllButtonsWithCount:FLASH_COUNT_SUCCESS];
	self.buttonClickCount = 0;
	[self startRound];
}


- (IBAction)greenButtonPressed {
	
	MDLog(@"Green Button Pressed");
	[self buttonPressedWithID:SimonSaysButton_Green];
}


- (IBAction)redButtonPressed {
	
	MDLog(@"Red Button Pressed");
	[self buttonPressedWithID:SimonSaysButton_Red];
}


- (IBAction)blueButtonPressed {
	
	MDLog(@"Blue Button Pressed");
	[self buttonPressedWithID:SimonSaysButton_Blue];
}


- (IBAction)orangeButtonPressed {
	
	MDLog(@"Orange Button Pressed");
	[self buttonPressedWithID:SimonSaysButton_Orange];
}


@end
