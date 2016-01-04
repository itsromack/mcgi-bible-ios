//
//  PSBibleViewController.m
//  PocketSword
//
//  Created by Nic Carter on 3/11/09.
//  Copyright 2009 The CrossWire Bible Society. All rights reserved.
//

#import "PSBibleViewController.h"
#import "PSModuleController.h"
#import "PSTabBarControllerDelegate.h"
#import "SwordDictionary.h"
#import "PSBookmarkAddViewController.h"
#import "PSResizing.h"
#import "PSBookmarks.h"
#import "PSBookmark.h"
#import "PSCommentaryViewController.h"
#import "SwordManager.h"
#import "PSBookmarkFolderColourSelectorViewController.h"
#import "PSBookmarkObject.h"
#import "PSBookmarkFolder.h"
#import "HighlightedVerseObject.h"
#import "PocketSwordAppDelegate.h"
#import "FMDatabase.h"
PocketSwordAppDelegate *appDelegate;
@implementation PSBibleViewController


@synthesize commentaryView;
@synthesize rgbHexString;

- (id)init {
	self = [super init];
	if(self) {
		tabType = BibleTab;
	}
	return self;
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	NSString *buttonPressedTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
/*
    if([buttonPressedTitle isEqualToString:NSLocalizedString(@"VerseContextualMenuAddNote", @"")]) {
        
        //add a bookmark!
        NSString *refToBookmark = [PSModuleController createRefString:[PSModuleController getCurrentBibleRef]];
        PSBookmarksAddTableViewController *tableViewController = [[PSBookmarksAddTableViewController alloc] initWithBookAndChapterRef:refToBookmark andVerse:tappedVerse];
        UINavigationController *containingNavigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
        [tableViewController release];
        [self presentViewController:containingNavigationController animated:YES completion:nil];
        [containingNavigationController release];
        self.tappedVerse = nil;
        //
    }
    else */
    if([buttonPressedTitle isEqualToString:NSLocalizedString(@"VerseContextualMenuAddBookmark", @"")]) {
		
		//add a bookmark!
		NSString *refToBookmark = [PSModuleController createRefString:[PSModuleController getCurrentBibleRef]];
		PSBookmarksAddTableViewController *tableViewController = [[PSBookmarksAddTableViewController alloc] initWithBookAndChapterRef:refToBookmark andVerse:tappedVerse];
		UINavigationController *containingNavigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
		[tableViewController release];
		[self presentViewController:containingNavigationController animated:YES completion:nil];
		[containingNavigationController release];
		self.tappedVerse = nil;
		//
	}
    else if([buttonPressedTitle isEqualToString:NSLocalizedString(@"VerseContextualMenuCopy", @"")]) {
        
        NSString *refToShare= [PSModuleController createRefString:[PSModuleController getCurrentBibleRef]];
        
        NSString *verse = self.tappedVerse;
        
        NSString *ref = [NSString stringWithFormat:@"%@:%@", refToShare, verse];
        
        HighlightedVerseObject *highlitedObject = [[HighlightedVerseObject alloc]init];
        
        highlitedObject.ref = ref;
        
        
        [PocketSwordAppDelegate sharedAppDelegate].highlitedVerse = highlitedObject;
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationCopyVerse" object:nil];
        
        self.tappedVerse = nil;
        
    
        self.tappedVerse = nil;
        
    }  else if([buttonPressedTitle isEqualToString:NSLocalizedString(@"VerseContextualMenuHighlight", @"")]) {
        
        
        NSString *refToHighlight= [PSModuleController createRefString:[PSModuleController getCurrentBibleRef]];
        
        NSString *verse = self.tappedVerse;
        
        
      //  self.tappedVerse = nil;
        
        
        PSBookmarkFolderColourSelectorViewController *csvc = [[PSBookmarkFolderColourSelectorViewController alloc] initWithColorString:self.rgbHexString delegate:self];
     
        [self presentModalViewController:csvc animated:YES];
        
       // [self.navigationController pushViewController:csvc animated:YES];
        [csvc release];
        
    }else if([buttonPressedTitle isEqualToString:@"Share/Copy"]){//isEqualToString:NSLocalizedString(@"VerseContextualMenuCommentary", @"")]) {
		
		//switch to the equivalent commentary entry.
		//commentaryView.jsToShow = [NSString stringWithFormat:@"scrollToVerse(%@);\n", tappedVerse];
        NSString *refToShare= [PSModuleController createRefString:[PSModuleController getCurrentBibleRef]];
        
        NSString *verse = self.tappedVerse;
        
        NSString *ref = [NSString stringWithFormat:@"%@:%@", refToShare, verse];
	 
        HighlightedVerseObject *highlitedObject = [[HighlightedVerseObject alloc]init];
        
        highlitedObject.ref = ref;
      
        
        [PocketSwordAppDelegate sharedAppDelegate].highlitedVerse = highlitedObject;
        
        
      [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationShareVerse" object:nil];
        
        //*******share verse***********
        
        
        
		self.tappedVerse = nil;
		
	}

}

- (void)rgbHexColorStringDidChange:(NSString *)newColorHexString {
    self.rgbHexString = newColorHexString;
    
    
    NSString *refToBookmark = [PSModuleController createRefString:[PSModuleController getCurrentBibleRef]];
    
    NSString *verse = self.tappedVerse;
    
    NSString *ref = [NSString stringWithFormat:@"%@:%@", refToBookmark, verse];
 
    
    NSDate *date = [NSDate date];
    PSBookmark *bookmark = [[PSBookmark alloc] initWithName:ref dateAdded:date dateLastAccessed:date bibleReference:ref];
    bookmark.rgbHexString = newColorHexString;
    
    
  
    HighlightedVerseObject *highlitedObject = [[HighlightedVerseObject alloc]init];
    
    highlitedObject.ref = ref;
    highlitedObject.rgbHexString = newColorHexString;
    NSString *databasePath = [[PocketSwordAppDelegate sharedAppDelegate] getDbPath];
    
   [PocketSwordAppDelegate sharedAppDelegate].highlitedVerse = highlitedObject;
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
    NSString *queryDelete = [NSString stringWithFormat:@"delete from HighlitedVerses  where reference ='%@'", ref];
    
    [database executeUpdate:queryDelete];
    
    NSString *queryInsert = [NSString stringWithFormat:@"insert into HighlitedVerses values ('%@', '%@')",
                       ref, newColorHexString];
    
    [database executeUpdate:queryInsert];
 
    [database close];
    
    
    if([[PSModuleController createRefString:[PSModuleController getCurrentBibleRef]] isEqualToString:refToBookmark]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationHighlightChanged object:nil];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}


@end
