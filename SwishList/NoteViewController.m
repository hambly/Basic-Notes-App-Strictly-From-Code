//
//  NoteViewController.m
//  SwishList
//
//  Created by Mark on 8/16/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NoteViewController.h"
#import "Note.h"

@interface NoteViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation NoteViewController

- (id) init {
	if (self = [super init]){
		_isVisible = NO;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.textView = [[UITextView alloc] init];
	self.textView.translatesAutoresizingMaskIntoConstraints = NO;
	self.textView.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14.0f];
	self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.textView.layer.borderWidth = 1.0f;
	[self.view addSubview:self.textView];
	
	NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_textView);
	
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textView]|"
																	  options:NSLayoutFormatAlignAllBottom
																	  metrics:nil
																		views:viewDictionary]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textView]|"
																	  options:NSLayoutFormatAlignAllLeft
																	  metrics:nil
																		views:viewDictionary]];
	
	
}

-(void) viewWillAppear:(BOOL)animated {
	[self.textView becomeFirstResponder];
	[self loadNote];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.textView resignFirstResponder];
	[self saveNote];
	
}

-(void) loadNote {
	if (self.note.content == nil){
		self.textView.text = [NSString stringWithFormat:@"%@\n",self.note.title];
	} else {
		self.textView.text = self.note.content;
	}
}

-(void) saveNote {
	self.note.content = self.textView.text;
	self.note.title =[[self.note.content componentsSeparatedByString: @"\n"] objectAtIndex:0];
}


@end
