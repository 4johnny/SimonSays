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

#define BUTTON_COUNT				4

#define BUTTON_ANIMATION_DURATION	0.5
#define BUTTON_ANIMATION_DELAY		0.0

#define BUTTON_LIGHT_ALPHA	1.0
#define BUTTON_DIM_ALPHA	0.5

#define FLASH_COUNT_SUCCESS	1
#define FLASH_COUNT_FAILURE	3


//
// Types
//

typedef NS_ENUM(uint, SimonSaysButtonID) {
	
	SimonSaysButton_None =		0, // For zero-based indexing
	SimonSaysButton_Green =		1,
	SimonSaysButton_Red =		2,
	SimonSaysButton_Blue =		3,
	SimonSaysButton_Orange =	4
};


//
// Interface
//


@interface ViewController ()

@property (nonatomic) int buttonCorrectClickCount;

@property (nonatomic, readonly) NSArray* buttonNames;

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
	
	// Button names same order as "SimonSaysButtonID" enum
	_buttonNames = @[
					 @"None",
					 @"Green",
					 @"Red",
					 @"Blue",
					 @"Orange"
					 ];
	
	self.buttonSequence = [NSMutableArray array];
	self.buttonCorrectClickCount = 0;
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


- (SimonSaysButtonID)simonSaysButtonIDWithNumber:(NSNumber*)number {
	
	return (SimonSaysButtonID)number.unsignedIntValue;
}


- (NSNumber*)numberWithSimonSaysButtonID:(SimonSaysButtonID)buttonID {
	
	return [NSNumber numberWithChar:buttonID];
}


- (SimonSaysButtonID)randomSimonSaysButtonID {
	
	return arc4random_uniform(BUTTON_COUNT) + 1; // Buttons start at 1
}



//
// Game Methods
//

- (void)lightButton:(UIButton*)button {
	
	button.alpha = BUTTON_LIGHT_ALPHA;
}


- (void)dimButton:(UIButton*)button {
	
	button.alpha = BUTTON_DIM_ALPHA;
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
	MDLog(@"Sequence button: %@", self.buttonNames[buttonID]);
	[self.buttonSequence addObject:[self numberWithSimonSaysButtonID:buttonID]];

	// Animate sequence of buttons.
	NSTimeInterval animationDuration = BUTTON_ANIMATION_DURATION * self.buttonSequence.count;
	NSTimeInterval relativeDuration = BUTTON_ANIMATION_DURATION / 2.0;
	[UIView animateKeyframesWithDuration:animationDuration
								   delay:BUTTON_ANIMATION_DELAY
								 options:(UIViewKeyframeAnimationOptions)0
							  animations:^{
								  
								  // For each button in sequence, animate by lighting and dimming it
								  for (int i = 0; i < self.buttonSequence.count; i++) {
									  
									  SimonSaysButtonID buttonID = [self simonSaysButtonIDWithNumber:self.buttonSequence[i]];
									  MDLog(@"Flash button: %@", self.buttonNames[buttonID]);
									  
									  [UIView addKeyframeWithRelativeStartTime:BUTTON_ANIMATION_DURATION * i
															  relativeDuration:relativeDuration
																	animations:^{
																		[self lightButtonWithID:buttonID];
																	}];
									  
									  [UIView addKeyframeWithRelativeStartTime:BUTTON_ANIMATION_DURATION * i + relativeDuration
															  relativeDuration:relativeDuration
																	animations:^{
																		[self dimButtonWithID:buttonID];
																	}];
								  }
								  
							  } completion:nil];
}


- (void)flashAllButtonsWithCount:(int)count {
	
}


- (void)buttonPressedWithID:(SimonSaysButtonID)buttonID {
	
	MDLog(@"Pressed button: %@", self.buttonNames[buttonID]);

	self.buttonCorrectClickCount++;
	SimonSaysButtonID sequenceButtonID =
	[self simonSaysButtonIDWithNumber:self.buttonSequence[self.buttonCorrectClickCount - 1]];
	
	// If pressed button is not consistent with sequence, reset game.
	if (buttonID != sequenceButtonID) {
		
		MDLog(@"Incorrect! Score: %d", self.buttonCorrectClickCount);
		MDLog(@"");
		[self flashAllButtonsWithCount:FLASH_COUNT_FAILURE];
		self.buttonCorrectClickCount = 0;
		[self.buttonSequence removeAllObjects];
		[self startRound];
		return;
	}
	
	// Pressed button is correct.
	// If player has not made it to end of sequence, continue playing
	if (self.buttonCorrectClickCount != self.buttonSequence.count) return;
	
	// Player has completed sequence successfully, so start a new round.
	MDLog(@"Correct! Score: %d", self.buttonCorrectClickCount);
	MDLog(@"");
	[self flashAllButtonsWithCount:FLASH_COUNT_SUCCESS];
	self.buttonCorrectClickCount = 0;
	[self startRound];
}


- (IBAction)greenButtonPressed {
	
	[self buttonPressedWithID:SimonSaysButton_Green];
}


- (IBAction)redButtonPressed {
	
	[self buttonPressedWithID:SimonSaysButton_Red];
}


- (IBAction)blueButtonPressed {

	[self buttonPressedWithID:SimonSaysButton_Blue];
}


- (IBAction)orangeButtonPressed {

	[self buttonPressedWithID:SimonSaysButton_Orange];
}


@end
