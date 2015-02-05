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

#define BUTTON_ANIMATION_DURATION	1.0
#define BUTTON_ANIMATION_DELAY		1.5

#define BUTTON_LIGHT_ALPHA	0.5
#define BUTTON_DIM_ALPHA	1.0

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
}


-(void)viewWillAppear:(BOOL)animated {
	
	if (animated) return;
	
	[self startRound];
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
	
	self.buttonCorrectClickCount = 0;
	
	// Add random button to button sequence
	SimonSaysButtonID buttonID = [self randomSimonSaysButtonID];
	MDLog(@"Sequence button: %@", self.buttonNames[buttonID]);
	[self.buttonSequence addObject:[self numberWithSimonSaysButtonID:buttonID]];
	
	// Animate sequence of buttons.
	
	NSTimeInterval animationDuration = BUTTON_ANIMATION_DURATION * self.buttonSequence.count;
	NSTimeInterval delay = BUTTON_ANIMATION_DELAY;
	double relativeDuration = 1.0 / (double)self.buttonSequence.count;
	MDLog(@"Sequence Count: %d, animation duration: %.2f, delay %.2f, relative duration: %.2f", (uint)self.buttonSequence.count, animationDuration, delay, relativeDuration);
	
	UIViewKeyframeAnimationOptions options =
	UIViewAnimationOptionLayoutSubviews |
	UIViewKeyframeAnimationOptionOverrideInheritedDuration |
	UIViewKeyframeAnimationOptionCalculationModeDiscrete;
	
	[UIView animateKeyframesWithDuration:animationDuration delay:delay options:options
							  animations:^{
								  
								  // For each button in sequence, animate by lighting and dimming it
								  for (int i = 0; i < self.buttonSequence.count; i++) {
									  
									  SimonSaysButtonID buttonID = [self simonSaysButtonIDWithNumber:self.buttonSequence[i]];
									  double relativeStartTime = relativeDuration * i;
									  
									  MDLog(@"Key frames: button %@, time: %.2f, duration: %.2f", self.buttonNames[buttonID], relativeStartTime, relativeDuration);
									  
									  // Light Button
									  [UIView addKeyframeWithRelativeStartTime:relativeStartTime
															  relativeDuration:relativeDuration / 2.0
																	animations:^{
																		[self lightButtonWithID:buttonID];
																	}];
									  
									  // Dim Button
									  relativeStartTime += relativeDuration / 2.0;
									  [UIView addKeyframeWithRelativeStartTime:relativeStartTime
															  relativeDuration:relativeDuration / 2.0
																	animations:^{
																		[self dimButtonWithID:buttonID];
																	}];
								  }
							  } // animations
							  completion:nil
	 ]; // animateKeyframes
}


- (void)flashAllButtonsWithCount:(int)count {
	
	NSTimeInterval animationDuration = BUTTON_ANIMATION_DURATION;
	NSTimeInterval delay = 0.0;
	double relativeDuration = 1.0 / (double)count;
	MDLog(@"Flash Count: %d, animation duration: %.2f, delay: %.2f, relative duration: %.2f", count, animationDuration, delay, relativeDuration);
	
	UIViewKeyframeAnimationOptions options =
	UIViewAnimationOptionLayoutSubviews |
	UIViewKeyframeAnimationOptionOverrideInheritedDuration |
	UIViewKeyframeAnimationOptionCalculationModeDiscrete;
	
	[UIView animateKeyframesWithDuration:animationDuration delay:delay options:options
							  animations:^{
								  
								  for (int i = 0; i < count; i++) {
									  
									  double relativeStartTime = relativeDuration * i;
									  
									  MDLog(@"Key frames: time: %.2f, duration: %.2f", relativeStartTime, relativeDuration);
									  
									  // Light all buttons
									  [UIView addKeyframeWithRelativeStartTime:relativeStartTime
															  relativeDuration:relativeDuration / 2.0
																	animations:^{
																		[self lightButtonWithID:SimonSaysButton_Green];
																		[self lightButtonWithID:SimonSaysButton_Red];
																		[self lightButtonWithID:SimonSaysButton_Blue];
																		[self lightButtonWithID:SimonSaysButton_Orange];
																	}];
									  
									  // Dim all buttons
									  relativeStartTime += relativeDuration / 2.0;
									  [UIView addKeyframeWithRelativeStartTime:relativeStartTime
															  relativeDuration:relativeDuration / 2.0
																	animations:^{
																		[self dimButtonWithID:SimonSaysButton_Green];
																		[self dimButtonWithID:SimonSaysButton_Red];
																		[self dimButtonWithID:SimonSaysButton_Blue];
																		[self dimButtonWithID:SimonSaysButton_Orange];
																	}];
								  }
								  
							  } // animations
	 
							  completion:^(BOOL finished) {
								  
								  // Start next round
								  // NOTE: Explicitly controls animations to be in correct sequence
								  [self performSelectorOnMainThread:@selector(startRound) withObject:nil waitUntilDone:NO];
							  } // completion
	 ]; // animateKeyframes
}


- (void)buttonPressedWithID:(SimonSaysButtonID)buttonID {
	
	MDLog(@"Pressed button: %@", self.buttonNames[buttonID]);
	
	SimonSaysButtonID sequenceButtonID =
	[self simonSaysButtonIDWithNumber:self.buttonSequence[self.buttonCorrectClickCount]];
	
	// If pressed button is not consistent with sequence, reset game.
	if (buttonID != sequenceButtonID) {
		
		MDLog(@"Incorrect! Score: %d", self.buttonCorrectClickCount);
		MDLog(@"");
		
		// Reset game
		[self.buttonSequence removeAllObjects];
		
		// Flash buttons and start next round
		// NOTE: Explicitly controls animations to be in correct sequence
		[self flashAllButtonsWithCount:FLASH_COUNT_FAILURE];
		
		return;
	}
	
	// Pressed button is correct.
	
	// If player has not made it to end of sequence, continue playing.
	self.buttonCorrectClickCount++;
	if (self.buttonCorrectClickCount != self.buttonSequence.count) return;
	
	// Player has completed sequence successfully, so start a new round.
	MDLog(@"Correct! Score: %d", self.buttonCorrectClickCount);
	MDLog(@"");
	
	// Flash buttons and start next round
	// NOTE: Explicitly controls animations to be in correct sequence
	[self flashAllButtonsWithCount:FLASH_COUNT_SUCCESS];
}


- (IBAction)greenButtonDown {
	[self lightButton:self.greenButtonOutlet];
}


- (IBAction)greenButtonUp {
	[self dimButton:self.greenButtonOutlet];
	[self buttonPressedWithID:SimonSaysButton_Green];
}


- (IBAction)greenButtonOutside {
	[self dimButton:self.greenButtonOutlet];
}


- (IBAction)redButtonDown {
	[self lightButton:self.redButtonOutlet];
}


- (IBAction)redButtonUp {
	[self dimButton:self.redButtonOutlet];
	[self buttonPressedWithID:SimonSaysButton_Red];
}


- (IBAction)redButtonOutside {
	[self dimButton:self.redButtonOutlet];
}


- (IBAction)blueButtonDown {
	[self lightButton:self.blueButtonOutlet];
}


- (IBAction)blueButtonUp {
	[self dimButton:self.blueButtonOutlet];
	[self buttonPressedWithID:SimonSaysButton_Blue];
}


- (IBAction)blueButtonOutside {
	[self dimButton:self.blueButtonOutlet];
}


- (IBAction)orangeButtonDown {
	[self lightButton:self.orangeButtonOutlet];
}


- (IBAction)orangeButtonUp {
	[self dimButton:self.orangeButtonOutlet];
	[self buttonPressedWithID:SimonSaysButton_Orange];
}


- (IBAction)orangeButtonOutside {
	[self dimButton:self.orangeButtonOutlet];
}


@end
