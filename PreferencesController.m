//
//  PreferencesController.m
//  MarkdownLive
//
//  Created by Akihiro Noguchi on 7/05/11.
//  Copyright 2011 Aki. All rights reserved.
//

#import "PreferencesController.h"
#import "PreferencesManager.h"

#define FONT_DISPLAY_FORMAT @"%@ %g pt."


@interface PreferencesController (Private)

- (void)updateFontDisplay;

@end

@implementation PreferencesController

- (void)awakeFromNib {
	[self updateFontDisplay];
}

- (IBAction)showFonts:(id)sender {
	NSFontManager *fontMan = [NSFontManager sharedFontManager];
	NSFont *currentFont = [PreferencesManager editPaneFont];
	[prefWindow makeFirstResponder:prefWindow];
	[fontMan setSelectedFont:currentFont isMultiple:NO];
	[fontMan orderFrontFontPanel:sender];
}

- (void)updateFontDisplay {
	NSString *fontName = [PreferencesManager editPaneFontName];
	float fontSize = [PreferencesManager editPaneFontSize];
	[fontPreviewField setStringValue:[NSString stringWithFormat:FONT_DISPLAY_FORMAT, fontName, fontSize]];
}

- (IBAction)resetEditPanePreferences:(id)sender {
	[PreferencesManager resetEditPanePreferences];
	[self updateFontDisplay];
	[[NSNotificationCenter defaultCenter] postNotificationName:kEditPaneFontNameChangedNotification
														object:nil];
}

- (void)changeFont:(id)sender {
	NSFont *newFont = [sender convertFont:[NSFont systemFontOfSize:0]];
	NSString *fontName = [newFont fontName];
	float fontSize = [newFont pointSize];
	
	if (newFont && fontName) {
		[PreferencesManager setEditPaneFontName:fontName];
		[PreferencesManager setEditPaneFontSize:fontSize];
		[fontPreviewField setStringValue:[NSString stringWithFormat:FONT_DISPLAY_FORMAT, fontName, fontSize]];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kEditPaneFontNameChangedNotification
															object:nil];
	}
}

- (NSUInteger)validModesForFontPanel:(NSFontPanel *)fontPanel {
	return (NSFontPanelFaceModeMask |
			NSFontPanelSizeModeMask |
			NSFontPanelCollectionModeMask);
	
}

@end
