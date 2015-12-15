/*
	PocketSword - a frontend for viewing SWORD project modules on the iPhone and iPod Touch
	Copyright (C) 2008-2010 CrossWire Bible Society

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along
	with this program; if not, write to the Free Software Foundation, Inc.,
	51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#import <QuartzCore/QuartzCore.h>
#import "PSTabBarControllerDelegate.h"
#import "SearchWebView.h"
#import "PSHistoryController.h"
#import "NavigatorSources.h"
#import "PSModuleSelectorController.h"
#import "PSPreferencesController.h"
#import "PSBookmarksNavigatorController.h"
#import "PSBookmarks.h"
#import "PSSearchHistoryItem.h"
#import "SwordModule.h"
#import "PSModuleController.h"
#import "PocketSwordAppDelegate.h"
#import "PSBibleViewController.h"
#import "PSCommentaryViewController.h"
#import "PSRefSelectorController.h"
#import "PSWebView.h"
#import "PSDevotionalViewController.h"
#import "SwordManager.h"
#import "SwordDictionary.h"
#import "PSAboutScreenController.h"
#import "PSLicensesScreenController.h"
#import "NotesTableViewController.h"
#import "PSBookmarkFolder.h"
#define INFO_LANDSCAPE_HEIGHT 100.0
#define INFO_PORTRAIT_HEIGHT 160.0
#define INFO_IPAD_LANDSCAPE_HEIGHT 200.0
#define INFO_IPAD_PORTRAIT_HEIGHT 260.0

@implementation PSTabBarControllerDelegate

@synthesize savedSearchHistoryItem, savedSearchResultsTab, bibleTabController, commentaryTabController, devotionalTabController, tabBarController;

- (id)init {
	self = [super init];
	if(self) {
		
		UITabBarController *tbc = [[UITabBarController alloc] init];
		tbc.delegate = self;
        self.tabBarController = tbc;
 	 	//[self tabColorChanged];
		[tbc release];
		
		[self nightModeChanged];
		[PSModuleController defaultModuleController];//init
		
		NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:6];
		// Order of the tabs:
		// 00: Bible fin
		// 01: Commentary
		// 02: Dictionary
		// 03: Bookmarks
		// 04: Daily Devotionals
		// 05: Downloads
		// 06: Preferences
		// 07: About
		 //08: License
		if([tabBarController.tabBar respondsToSelector:@selector(isTranslucent)]) {// iOS 7 only
			UIColor *tintColor = [UIColor whiteColor];
 	//		UIColor *tintColor = [UIColor blackColor];
            //UIColor *barTintColor = [UIColor  whiteColor];
		 //	UIColor *barTintColor = [UIColor blackColor];
			//UIColor *barTintColor = [UIColor blackColor];//0,118,174
            
            UIColor *barTintColor =  [PSBookmarkFolder colorFromHexString:@"#0084ca"]; // [UIColor colorWithRed:0 green:(118/255) blue:(174/255) alpha:1];
           // UIColor *barTintColor = [UIColor whiteColor];
			
			[[UINavigationBar appearance] setTintColor:barTintColor];
			//[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Pocket Blue Background.png"] forBarMetrics:UIBarMetricsDefault];
			[[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
			[[UINavigationBar appearance] setBarTintColor:barTintColor];
		//	[[UIToolbar appearance] setTintColor:tintColor];
			//[[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"Pocket Blue Background.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
		//	[[UIToolbar appearance] setBarTintColor:barTintColor];
		//	[[UITabBar appearance] setTintColor:tintColor];
			//[[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"Pocket Blue Background TabBar.png"]];
			//[[UITabBar appearance] setBarTintColor:barTintColor];
			//NSLog(@"%f", self.tabBarController.tabBar.frame.size.height);
            
            //tabBarController.tabBar.barTintColor = [PSBookmarkFolder colorFromHexString:@"#00629b"];

            tabBarController.tabBarController.tabBar.tintColor =  [UIColor whiteColor];
        }
		/*
		//add the Commentary Tab.
		PSCommentaryViewController *cvc = [[PSCommentaryViewController alloc] init];
		cvc.title = CommentaryTabTitleString;
		[cvc view];//load the view before we continue!
		[cvc setDelegate:self];
		UINavigationController *cTab = [[UINavigationController alloc] initWithRootViewController:cvc];
		cTab.navigationBar.barStyle = UIBarStyleBlack;
		[tabs insertObject:cTab atIndex:0];
		self.commentaryTabController = cvc;
		[cTab release];
		[cvc release];
         
         */
		
		//add the Bible Tab.
		// Do this second because we need the commentary tab to initialise the Bible tab!
		PSBibleViewController *bvc = [[PSBibleViewController alloc] init];
		bvc.title = BibleTabTitleString;
		[bvc view];//load the view before we continue!
		[bvc setDelegate:self];
		bvc.commentaryView = commentaryTabController;
		UINavigationController *bTab = [[UINavigationController alloc] initWithRootViewController:bvc];
	//	 bTab.navigationBar.barStyle = UIBarStyleBlack;
		[tabs insertObject:bTab atIndex:0];
		self.bibleTabController = bvc;
		[bTab release];
		[bvc release];
		
		//add the Dictionary Tab.
		/*PSDictionaryViewController *dictionaryViewController = [[PSDictionaryViewController alloc] initWithStyle:UITableViewStyleGrouped];
		dictionaryViewController.delegate = self;
		UINavigationController *dictionaryTab = [[UINavigationController alloc] initWithRootViewController:dictionaryViewController];
		dictionaryTab.navigationBar.barStyle = UIBarStyleBlack;
		UITabBarItem *dTBI = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TabBarTitleDictionary", @"Dictionary") image:[UIImage imageNamed:@"dictionary.png"] tag:99];
		dictionaryTab.tabBarItem = dTBI;*/
		
        /*
		[tabs insertObject:dictionaryTab atIndex:1];
		[dictionaryViewController release];
		[dictionaryTab release];
         */
        
        NotesTableViewController *notesViewController = [[NotesTableViewController alloc]initWithStyle:UITableViewStylePlain];
        
        UINavigationController *notesTab = [[UINavigationController alloc] initWithRootViewController:notesViewController];
        notesTab.navigationBar.barStyle = UIBarStyleBlack;
        //NSLocalizedString(@"TabBarTitleDictionary", @"Dictionary")
        
      
        
        UITabBarItem *dTBI = [[UITabBarItem alloc] initWithTitle:@"Notes" image:[UIImage imageNamed:@"dictionary.png"] tag:99];
        
       
        
      
        notesTab.tabBarItem = dTBI;
        
        [tabs insertObject:notesTab atIndex:1];
        [notesViewController release];
        [notesTab release];
        
		
		//add the bookmarks tab.
		[PSBookmarks importBookmarksFromV2];
		PSBookmarksNavigatorController *bookmarksViewController = [[PSBookmarksNavigatorController alloc] initWithStyle:UITableViewStyleGrouped];
		UINavigationController *bookmarksTab = [[UINavigationController alloc] initWithRootViewController:bookmarksViewController];
		bookmarksTab.navigationBar.barStyle = UIBarStyleBlack;
		//UITabBarItem *tbI = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:0];
        
        UITabBarItem *tbI = [[UITabBarItem alloc] initWithTitle: @"Bookmark" image:[UIImage imageNamed:@"bookmark.png"] tag:787];
      
       
		bookmarksTab.tabBarItem = tbI;
        //[tbI release];
        [tabs insertObject:bookmarksTab atIndex:2];
		[bookmarksViewController release];
		[bookmarksTab release];
		
        /*
		//add the Daily Devotionals tab.
		PSDevotionalViewController *devoViewController = [[PSDevotionalViewController alloc] init];
		[devoViewController setDelegate:self];
		self.devotionalTabController = devoViewController;
		UITabBarItem *devotionalTBI = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TabBarTitleDevotional", @"Devotional") image:[UIImage imageNamed:@"Daily-Devotional.png"] tag:0];
		if([PSResizing iPad]) {
			UINavigationController *devoIPadTab = [[UINavigationController alloc] initWithRootViewController:devoViewController];
			devoIPadTab.navigationBar.barStyle = UIBarStyleBlack;
			devoIPadTab.tabBarItem = devotionalTBI;
			[tabs insertObject:devoIPadTab atIndex:4];
			[devoIPadTab release];
			devoIPadTab = nil;
		} else {
			devoViewController.tabBarItem = devotionalTBI;
			[tabs insertObject:devoViewController atIndex:4];
		}
		[devotionalTBI release];
		[devoViewController release];
         */
		
		//add the Downloads tab.
        
        /*HIDE DOWNLOAD TABS TEMPORARILY
		NavigatorSources *downloadsViewController = [[NavigatorSources alloc] initWithStyle:UITableViewStyleGrouped];
		UITabBarItem *downloadsTabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:522];
		//if([PSResizing iPad]) {//comment out since view will not be on 
			UINavigationController *downloadsIPadTab = [[UINavigationController alloc] initWithRootViewController:downloadsViewController];
			downloadsIPadTab.navigationBar.barStyle = UIBarStyleBlack;
			downloadsIPadTab.tabBarItem = downloadsTabBarItem;
			[tabs insertObject:downloadsIPadTab atIndex:3];
			[downloadsIPadTab release];
			downloadsIPadTab = nil;
		//} else {
            
			//downloadsViewController.tabBarItem = downloadsTabBarItem;
			//[tabs insertObject:downloadsViewController atIndex:3];
		//}
		[downloadsTabBarItem release];
		[downloadsViewController release];
		*/
		//add the Preferences tab.
		PSPreferencesController *preferencesViewController = [[PSPreferencesController alloc] initWithStyle:UITableViewStyleGrouped];
		UITabBarItem *preferencesTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TabBarTitlePreferences", @"Preferences") image:[UIImage imageNamed:@"gear-24.png"] tag:9];
        
      
		//if([PSResizing iPad]) {
			UINavigationController *preferencesIPadTab = [[UINavigationController alloc] initWithRootViewController:preferencesViewController];
			preferencesIPadTab.navigationBar.barStyle = UIBarStyleBlack;
			preferencesIPadTab.tabBarItem = preferencesTabBarItem;
			[tabs insertObject:preferencesIPadTab atIndex:3];
			[preferencesIPadTab release];
		//} else {
		//	preferencesViewController.tabBarItem = preferencesTabBarItem;
		//	[tabs insertObject:preferencesViewController atIndex:3];
		//}
		[preferencesTabBarItem release];
		[preferencesViewController release];
		
		//add the About tab.
		PSAboutScreenController *aboutViewController = [[PSAboutScreenController alloc] init];
		UITabBarItem *aboutTBI = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TabBarTitleAbout", @"About") image:[UIImage imageNamed:@"About.png"] tag:2323];
       
        
		if([PSResizing iPad]) {
			UINavigationController *aboutIPadTab = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
			aboutIPadTab.navigationBar.barStyle = UIBarStyleBlack;
			aboutIPadTab.tabBarItem = aboutTBI;
			[tabs insertObject:aboutIPadTab atIndex:4];
			[aboutIPadTab release];
		} else {
			//aboutViewController.tabBarItem = aboutTBI;
			//[tabs insertObject:aboutViewController atIndex:4];
            
            UINavigationController *aboutIPadTab = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
            aboutIPadTab.navigationBar.barStyle = UIBarStyleBlack;
            aboutIPadTab.tabBarItem = aboutTBI;
            [tabs insertObject:aboutIPadTab atIndex:4];
            [aboutIPadTab release];
		}
		[aboutTBI release];
		[aboutViewController release];
        
        //add the Licenses tab.
      /*  PSLicensesScreenController *licensesViewController = [[PSLicensesScreenController alloc] init];
        UITabBarItem *licensesTBI = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TabBarTitleLicenses", @"Licenses") image:[UIImage imageNamed:@"Licenses.png"] tag:232];
        if([PSResizing iPad]) {
            UINavigationController *licensesIPadTab = [[UINavigationController alloc] initWithRootViewController:licensesViewController];
            licensesIPadTab.navigationBar.barStyle = UIBarStyleBlack;
            licensesIPadTab.tabBarItem = licensesTBI;
            [tabs insertObject:licensesIPadTab atIndex:5];
            [licensesIPadTab release];
        } else {
            licensesViewController.tabBarItem = licensesTBI;
            [tabs insertObject:licensesViewController atIndex:5];
        }
        [licensesTBI release];
        [licensesViewController release];*/

		
		[tabBarController setViewControllers:tabs animated:NO];
		tabs = nil;

		tabBarController.customizableViewControllers = nil;
		tabBarController.selectedIndex = 0;
		tabBarController.moreNavigationController.navigationBar.barStyle = UIBarStyleBlack;
		tabBarController.moreNavigationController.topViewController.navigationItem.rightBarButtonItem = nil;
		tabBarController.delegate = self;
		
				
		[[NSNotificationCenter defaultCenter] postNotificationName:NotificationNewPrimaryBible object:nil];
		NSString *lastRef = [PSModuleController getCurrentBibleRef];
		
		if ([PocketSwordAppDelegate sharedAppDelegate].urlToOpen == nil) {
			[self displayChapter:lastRef withPollingType:BibleViewPoll restoreType:RestoreScrollPosition];
		} else {
			[PocketSwordAppDelegate sharedAppDelegate].urlToOpen = nil;
			[self displayChapter:lastRef withPollingType:BibleViewPoll restoreType:RestoreVersePosition];
		}
				
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redisplayChapterWithDefaults) name:NotificationResetBibleAndCommentaryView object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redisplayBibleChapter) name:NotificationRedisplayPrimaryBible object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redisplayCommentaryChapter) name:NotificationRedisplayPrimaryCommentary object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMultiList) name:NotificationToggleMultiList object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleModulesList:) name:NotificationToggleModuleList object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleNavigation) name:NotificationToggleNavigation object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideInfo) name:NotificationHideInfoPane object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInfoWithNotification:) name:NotificationShowInfoPane object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rotateInfo:) name:NotificationRotateInfoPane object:nil];
				
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addModuleButtonPressed) name:NotificationShowDownloadsTab object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayCommentaryTabViaNotification) name:NotificationShowCommentaryTab object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayBibleTabViaNotification) name:NotificationShowBibleTab object:nil];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViewWithSelectedBookChapterVerse:) name:NotificationUpdateSelectedReference object:nil];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nightModeChanged) name:NotificationNightModeChanged object:nil];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redisplayBibleChapterAfterBookmarksChange) name:NotificationBookmarksChanged object:nil];
 		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabColorChanged) name:NotificationBarColorChanged object:nil];
		
	}
	return self;
}

 - (void)tabColorChanged {
 	if([tabBarController.tabBar respondsToSelector:@selector(isTranslucent)]) {
 	tabBarController.tabBar.translucent = [PSTabBarControllerDelegate getBarTranslucentDefault];
 		tabBarController.tabBar.barTintColor = [PSTabBarControllerDelegate getBarColorDefault];
 		tabBarController.tabBar.tintColor = [UIColor whiteColor];
 	}
 }

- (void)nightModeChanged {
	BOOL nightMode = [[NSUserDefaults standardUserDefaults] boolForKey:DefaultsNightModePreference];
	UIColor *backgroundColor = (nightMode) ? [UIColor blackColor] : [UIColor whiteColor];
	[(((PocketSwordAppDelegate*) [UIApplication sharedApplication].delegate).window) setBackgroundColor:backgroundColor];
}

- (void)setTabTitle:(NSString *)newTitle ofTab:(ShownTab)tab
{	
	if(tab == BibleTab) {
		[bibleTabController setTabTitle:newTitle];
	} else if(tab == CommentaryTab) {
		[commentaryTabController setTabTitle:newTitle];
	}
}

- (void)setEnabledBibleNextButton:(BOOL)enabled
{
	[bibleTabController setEnabledNextButton:enabled];
}

- (void)setEnabledBiblePreviousButton:(BOOL)enabled
{
	[bibleTabController setEnabledPreviousButton:enabled];
}

- (void)setEnabledCommentaryNextButton:(BOOL)enabled
{
	[commentaryTabController setEnabledNextButton:enabled];
}

- (void)setEnabledCommentaryPreviousButton:(BOOL)enabled
{
	[commentaryTabController setEnabledPreviousButton:enabled];
}

- (void)searchDidFinish:(PSSearchHistoryItem *)newSearchHistoryItem {
	if([[bibleTabController webView] isDescendantOfView:tabBarController.selectedViewController.view]) {
		self.savedSearchResultsTab = BibleTab;
	} else if([[bibleTabController webView] isDescendantOfView:tabBarController.selectedViewController.view]) {
		self.savedSearchResultsTab = CommentaryTab;
	}
	self.savedSearchHistoryItem = newSearchHistoryItem;
}

- (void)toggleMultiList:(id)sender {
	[self toggleMultiList];
}

- (void)toggleMultiList {
//	[self highlightSearchTerm: @"and" forTab: BibleTab];
	
	//if([multiListController.view superview]) {
	if(multiListController) {
		[tabBarController dismissModalViewControllerAnimated:YES];
		multiListController = nil;
	} else {
		
		multiListController = [[UITabBarController alloc] init];
//		if([multiListController.tabBar respondsToSelector:@selector(isTranslucent)]) {
//			[multiListController.tabBar setTranslucent:[PSTabBarControllerDelegate getBarTranslucentDefault]];
//			[multiListController.tabBar setBarTintColor:[PSTabBarControllerDelegate getBarColorDefault]];
//		}
		PSHistoryController *historyController = [[PSHistoryController alloc] init];
		PSModuleSearchController *searchController = [[PSModuleSearchController alloc] init];
		UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchController];
		searchNavigationController.navigationBar.barStyle = UIBarStyleBlack;
		searchNavigationController.title = NSLocalizedString(@"SearchTitle", @"");
		UINavigationController *historyNavigationController = [[UINavigationController alloc] initWithRootViewController:historyController];
		historyNavigationController.navigationBar.barStyle = UIBarStyleBlack;
		multiListController.delegate = searchController;
		searchController.delegate = self;
		NSArray* controllers = [NSArray arrayWithObjects:historyNavigationController, searchNavigationController, nil];
		multiListController.viewControllers = controllers;
		
		if([[bibleTabController webView] isDescendantOfView:tabBarController.selectedViewController.view] || bibleTabController.isFullScreen) {
			[historyController setListType:BibleTab];
			[searchController setListType:BibleTab];
			if(savedSearchResultsTab == BibleTab && savedSearchHistoryItem && savedSearchHistoryItem.results) {
				//restore the previous search term:
				[searchController setSearchHistoryItem:savedSearchHistoryItem];
				//[multiListController setSelectedViewController:searchNavigationController];
			} else if(savedSearchHistoryItem && savedSearchHistoryItem.searchTerm) {
				[searchController setSearchHistoryItem:savedSearchHistoryItem];
				self.savedSearchHistoryItem = nil;
				[multiListController setSelectedViewController:searchNavigationController];
			}
		} else {
			[historyController setListType:CommentaryTab];
			[searchController setListType:CommentaryTab];
			if(savedSearchResultsTab == CommentaryTab && savedSearchHistoryItem && savedSearchHistoryItem.results) {
				//restore the previous search term:
				[searchController setSearchHistoryItem:savedSearchHistoryItem];
				//[multiListController setSelectedViewController:searchNavigationController];
			}
		}
		
		if([[NSUserDefaults standardUserDefaults] integerForKey:DefaultsLastMultiListTab] == SearchTab) {
			[multiListController setSelectedViewController:searchNavigationController];
		}
		[tabBarController presentModalViewController:multiListController animated:YES];
		[searchNavigationController release];
		[historyNavigationController release];
		[historyController release];
		[searchController release];
		[multiListController release];
	}
	
}

- (void)toggleModulesList:(NSNotification *)notification {
	if(notification) {
		[self toggleModulesListAnimated:YES withModule:[notification object] fromButton:nil];
	} else {
		[self toggleModulesListAnimated:YES withModule:nil fromButton:nil];
	}
}

- (void)toggleModulesListFromButton:(id)sender {
	[self toggleModulesListAnimated:YES withModule:nil fromButton:(id)sender];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)poController {
	if(moduleSelectorViewController) {
		moduleSelectorViewController = nil;
	}
	if(refNavigationController) {
		refSelectorController = nil;
		refNavigationController = nil;
	}
	[popoverController release];
	popoverController = nil;
}

- (void)toggleModulesListAnimated:(BOOL)animated withModule:(SwordModule *)swordModule fromButton:(id)sender {
    BOOL iPad = [PSResizing iPad];
	if(moduleSelectorViewController || [popoverController isPopoverVisible]) {
		 if(iPad) {
             [popoverController dismissPopoverAnimated:YES];
		 } else {
			[tabBarController dismissModalViewControllerAnimated:animated];
		  }
		moduleSelectorViewController = nil;
	} else {
		moduleSelectorViewController = [[[PSModuleSelectorController alloc] initWithNibName:nil bundle:nil] autorelease];
		UINavigationController *modSelectorNavController = [[[UINavigationController alloc] initWithRootViewController:moduleSelectorViewController] autorelease];
		modSelectorNavController.navigationBar.barStyle = UIBarStyleBlack;

		if(iPad) {
			popoverController = [[UIPopoverController alloc] initWithContentViewController:modSelectorNavController];
			[popoverController setDelegate:self];
		}
		//set the module selector to use the correct module type.
		if([[bibleTabController webView] isDescendantOfView:tabBarController.selectedViewController.view]) {
			[moduleSelectorViewController setListType:BibleTab];
		} else if([[commentaryTabController webView] isDescendantOfView:tabBarController.selectedViewController.view]) {
			[moduleSelectorViewController setListType:CommentaryTab];
		} else if([[devotionalTabController devotionalWebView] isDescendantOfView:tabBarController.selectedViewController.view]) {
			[moduleSelectorViewController setListType:DevotionalTab];
		} else {
			[moduleSelectorViewController setListType:DictionaryTab];
		}
		if(sender) {
			[popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		} else {
			DLog(@"We should only be calling toggleModulesList with a sender now!");
			CGRect theSpot = CGRectMake(50, ([[UIScreen mainScreen] bounds].size.width-50), 10, 10);
			[popoverController presentPopoverFromRect:theSpot inView:tabBarController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}

		if(!iPad) {
			[tabBarController presentModalViewController:modSelectorNavController animated:animated];
		} else {
			[popoverController setPopoverContentSize:moduleSelectorViewController.contentSizeForViewInPopover animated:NO];
		}
	}
}

//- (UITabBarController *)tabBarController {
//	return tabBarController;
//}

- (void)addModuleButtonPressed {
	[self setShownTabTo:DownloadsTab];
}

- (void)displayCommentaryTabViaNotification {
	[self setShownTabTo:CommentaryTab];
}

- (void)displayBibleTabViaNotification {
	[self setShownTabTo:BibleTab];
}

- (void)toggleNavigation {
    BOOL iPad = [PSResizing iPad];
	if(refNavigationController || [popoverController isPopoverVisible]) {
        if(!iPad) {
            [tabBarController dismissModalViewControllerAnimated:YES];
        } else {
            [popoverController dismissPopoverAnimated:YES];
        }
		refSelectorController = nil;
		refNavigationController = nil;
	} else {
		if([[bibleTabController webView] isDescendantOfView:tabBarController.selectedViewController.view]) {
			// bible tab
			if(![[PSModuleController defaultModuleController] primaryBible]) {
                //no Bible selected, so ignore...
			   return;
            }
			refSelectorController = [[[PSRefSelectorController alloc] initWithStyle:UITableViewStylePlain] autorelease];
            [refSelectorController setupNavigation];
			refNavigationController = [[[UINavigationController alloc] initWithRootViewController:refSelectorController] autorelease];
			refNavigationController.navigationBar.barStyle = UIBarStyleBlack;
            if(!iPad) {
                [refSelectorController willShowNavigation];
                [tabBarController presentModalViewController:refNavigationController animated:YES];
            } else {
				popoverController = [[UIPopoverController alloc] initWithContentViewController:refNavigationController];
				[popoverController setDelegate:self];
				UIView *viewToPresentPopoverFrom = [bibleTabController titleSegmentedControl];
				CGRect rect = viewToPresentPopoverFrom.frame;
				rect.origin.x = 0;
				rect.origin.y = 0;
				[popoverController presentPopoverFromRect:rect inView:viewToPresentPopoverFrom permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
                [refSelectorController willShowNavigation];
            }
		} else if([[commentaryTabController webView] isDescendantOfView:tabBarController.selectedViewController.view]) {
			// commentary tab
            if(!([[PSModuleController defaultModuleController] primaryCommentary])) {
                //no Commentary selected, so ignore...
                return;
            }
			refSelectorController = [[PSRefSelectorController alloc] initWithStyle:UITableViewStylePlain];
            [refSelectorController setupNavigation];
			refNavigationController = [[UINavigationController alloc] initWithRootViewController:refSelectorController];
			refNavigationController.navigationBar.barStyle = UIBarStyleBlack;
            if(!iPad) {
                [refSelectorController willShowNavigation];
                [tabBarController presentModalViewController:refNavigationController animated:YES];
            } else {
				popoverController = [[UIPopoverController alloc] initWithContentViewController:refNavigationController];
				[popoverController setDelegate:self];
				UIView *viewToPresentPopoverFrom = [commentaryTabController titleSegmentedControl];
				CGRect rect = viewToPresentPopoverFrom.frame;
				rect.origin.x = 0;
				rect.origin.y = 0;
				[popoverController presentPopoverFromRect:rect inView:viewToPresentPopoverFrom permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
                [refSelectorController willShowNavigation];
            }
        }
	}
}

- (void)updateViewWithSelectedBookChapterVerse:(NSNotification *)notification {
	NSDictionary *bcv = nil;
	if(notification) {
		bcv = [notification object];
	}
	if(!bcv) return;
	
	NSString *bookNameString = [bcv objectForKey:BookNameString];
	NSInteger chapter = [(NSString*)[bcv objectForKey:ChapterString] integerValue];
	NSInteger verse = [(NSString*)[bcv objectForKey:VerseString] integerValue];
	[self updateViewWithSelectedBookName:bookNameString chapter:chapter verse:verse];
}

- (void)updateViewWithSelectedBookName:(NSString*)bookNameString chapter:(NSInteger)chapter verse:(NSInteger)verse {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	sword::LocaleMgr *lmgr = sword::LocaleMgr::getSystemLocaleMgr();
	NSString *bookName = [NSString stringWithCString:lmgr->translate([bookNameString cStringUsingEncoding:NSUTF8StringEncoding], "en") encoding:NSUTF8StringEncoding];
	NSString *verseString = [NSString stringWithFormat:@"%ld", (long)verse];
	NSString *ref = [bookName stringByAppendingFormat: @" %ld", (long)chapter];
	PSModuleController *moduleController = [PSModuleController defaultModuleController];
	NSString *currentRef = [PSModuleController getCurrentBibleRef];
	if([currentRef isEqualToString:ref]) {
		//we only need to move to the selected verse rather than reload the whole chapter
		NSString *javascript = [NSString stringWithFormat:@"scrollToVerse(%@);", verseString];
		[bibleTabController scrollToVerse:verse];
		[[bibleTabController webView] stringByEvaluatingJavaScriptFromString:javascript];
		[commentaryTabController scrollToVerse:verse];
		[[commentaryTabController webView] stringByEvaluatingJavaScriptFromString:javascript];
		if([moduleController primaryBible]) {
			[self setTabTitle: [NSString stringWithFormat:@"%@:%@", ref, verseString] ofTab:BibleTab];
		}
		if([moduleController primaryCommentary]) {
			[self setTabTitle: [NSString stringWithFormat:@"%@:%@", ref, verseString] ofTab:CommentaryTab];
		}
	} else {
		
		if([[bibleTabController webView] isDescendantOfView:tabBarController.selectedViewController.view]) {
			// bible tab
			[[NSUserDefaults standardUserDefaults] setObject: verseString forKey: DefaultsBibleVersePosition];
			[[NSUserDefaults standardUserDefaults] setObject: verseString forKey: DefaultsCommentaryVersePosition];
			[[NSUserDefaults standardUserDefaults] synchronize];
			[self displayChapter:ref withPollingType:BibleViewPoll restoreType:RestoreVersePosition];
			//[[NSNotificationCenter defaultCenter] postNotificationName:NotificationAddBibleHistoryItem object:nil];
			[PSHistoryController addHistoryItem:BibleTab];
		} else if([[commentaryTabController webView] isDescendantOfView:tabBarController.selectedViewController.view]) {
			// commentary tab
			[[NSUserDefaults standardUserDefaults] setObject: verseString forKey: DefaultsBibleVersePosition];
			[[NSUserDefaults standardUserDefaults] setObject: verseString forKey: DefaultsCommentaryVersePosition];
			[[NSUserDefaults standardUserDefaults] synchronize];
			[self displayChapter:ref withPollingType:CommentaryViewPoll restoreType:RestoreVersePosition];
			//[[NSNotificationCenter defaultCenter] postNotificationName:NotificationAddCommentaryHistoryItem object:nil];
			[PSHistoryController addHistoryItem:CommentaryTab];
		} else {
			//something tab???
			[[NSUserDefaults standardUserDefaults] setObject: verseString forKey: DefaultsBibleVersePosition];
			[[NSUserDefaults standardUserDefaults] setObject: verseString forKey: DefaultsCommentaryVersePosition];
			[[NSUserDefaults standardUserDefaults] synchronize];
			[self displayChapter:ref withPollingType:NoViewPoll restoreType:RestoreVersePosition];
		}
	}
	
	[pool release];
}

- (void)dealloc {
	self.savedSearchHistoryItem = nil;
	[moduleSelectorViewController release];
	[popoverController release];
    [super dealloc];
}

+ (void)displayTitle:(NSString*)title {
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:(((PocketSwordAppDelegate*) [UIApplication sharedApplication].delegate).window) animated:YES];
	hud.mode = MBProgressHUDModeText;
	hud.labelText = [PSModuleController createRefString:title];
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:0.75];
}

- (void)redisplayChapterWithDefaults {
	NSString *ref = [PSModuleController getCurrentBibleRef];
	[self displayChapter:ref withPollingType:NoViewPoll restoreType:RestoreVersePosition];
}

- (void)redisplayBibleChapterAfterBookmarksChange {
	bibleTabController.refToShow = nil;
	bibleTabController.jsToShow = nil;
	[self redisplayChapter:BibleViewPoll restore:RestoreScrollPosition];
}

- (void)redisplayBibleChapter {
	bibleTabController.refToShow = nil;
	bibleTabController.jsToShow = nil;
	[self redisplayChapter:BibleViewPoll restore:RestoreVersePosition];
}

- (void)redisplayCommentaryChapter {
	
    //[commentaryTitle setTitle: NSLocalizedString(@"None", @"None")];
    commentaryTabController.refToShow = nil;
	commentaryTabController.jsToShow = nil;
	
    [self redisplayChapter:CommentaryViewPoll restore:RestoreVersePosition];
}

- (void)redisplayChapter:(PollingType)pollingType restore:(RestorePositionType)position {
    
NSString *ref = [PSModuleController getCurrentBibleRef];
[self displayChapter:ref withPollingType:pollingType restoreType:position];

}

- (void)displayChapter:(NSString *)ref withPollingType:(PollingType)polling restoreType:(RestorePositionType)position {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	NSMutableString *bibleJavascript = [NSMutableString stringWithString:@""];
	NSMutableString *commentaryJavascript = [NSMutableString stringWithString:@""];
    
    NSString *versePosition = [[NSUserDefaults standardUserDefaults] stringForKey: DefaultsBibleVersePosition];
	switch(position) {
		case RestoreScrollPosition:
		{
			NSString *scrollPosition = [[NSUserDefaults standardUserDefaults] stringForKey: @"bibleScrollPosition"];
			if(scrollPosition) {
				[bibleJavascript appendFormat:@"scrollToPosition(%@);\n", scrollPosition];
			}
			scrollPosition = [[NSUserDefaults standardUserDefaults] stringForKey: @"commentaryScrollPosition"];
			if(scrollPosition) {
				[commentaryJavascript appendFormat:@"scrollToPosition(%@);\n", scrollPosition];
			}
		}
			break;
		case RestoreVersePosition:
		{
			if(versePosition) {
				[bibleJavascript appendFormat:@"scrollToVerse(%@);\n", versePosition];
				[bibleTabController setVerseToShow:[versePosition integerValue]];
			}
			versePosition = [[NSUserDefaults standardUserDefaults] stringForKey: DefaultsCommentaryVersePosition];
			if(versePosition) {
				[commentaryJavascript appendFormat:@"scrollToVerse(%@);\n", versePosition];
				[commentaryTabController setVerseToShow:[versePosition integerValue]];
			}
		}
			break;
		case RestoreNoPosition:
		default:
			break;
	}
	
	switch(polling) {
		case BibleViewPoll:
		{
			[bibleJavascript appendString:@"startDetLocPoll();\n"];
			NSString *bText = [[PSModuleController defaultModuleController] getBibleChapter:ref withExtraJS:bibleJavascript];
			[[bibleTabController webView] loadHTMLString: bText baseURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
			//NSLog(@"%@", bText);
			commentaryTabController.refToShow = ref;
			commentaryTabController.jsToShow = commentaryJavascript;
		}
			break;
		case CommentaryViewPoll:
		{
			[commentaryJavascript appendString:@"startDetLocPoll();\n"];
			NSString *cText = [[PSModuleController defaultModuleController] getCommentaryChapter:ref withExtraJS:commentaryJavascript];
			[[commentaryTabController webView] loadHTMLString: cText baseURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
			//NSLog(@"%@", cText);
			bibleTabController.refToShow = ref;
			bibleTabController.jsToShow = bibleJavascript;
		}
			break;
		case NoViewPoll:
		default:
		{
			commentaryTabController.refToShow = ref;
			commentaryTabController.jsToShow = commentaryJavascript;
			bibleTabController.refToShow = ref;
			bibleTabController.jsToShow = bibleJavascript;
		}
			break;
	}

	NSString *cVersePosition = @"1";
	if(versePosition) {
		cVersePosition = [NSString stringWithString:versePosition];
	} else {
		versePosition = @"1";
	}
	switch(position) {
		case RestoreScrollPosition:
		{
			cVersePosition = [[NSUserDefaults standardUserDefaults] stringForKey: DefaultsCommentaryVersePosition];
			if(!cVersePosition)
				cVersePosition = @"1";
		}
			break;
		case RestoreVersePosition:
		{
		}
			break;
		case RestoreNoPosition:
		{
			versePosition = @"1";
			cVersePosition = @"1";
		}
		default:
			break;
	}
	
	NSString *titleString = [NSString stringWithFormat:@"%@:%@", [PSModuleController createRefString:ref], versePosition];
	if([[PSModuleController defaultModuleController] primaryBible]) {
		[self setTabTitle: titleString ofTab:BibleTab];
	}
	titleString = [NSString stringWithFormat:@"%@:%@", [PSModuleController createRefString:ref], cVersePosition];
	if([[PSModuleController defaultModuleController] primaryCommentary]) {
		[self setTabTitle: titleString ofTab:CommentaryTab];
	}
	
	NSString *currentRef = [PSModuleController getCurrentBibleRef];
	if ([currentRef isEqualToString: [PSModuleController getLastRefAvailable]]) {
		[self setEnabledBibleNextButton: NO];
		[self setEnabledBiblePreviousButton: YES];
		[self setEnabledCommentaryNextButton: NO];
		[self setEnabledCommentaryPreviousButton: YES];
	} else if ([currentRef isEqualToString: [PSModuleController getFirstRefAvailable]]) {
		[self setEnabledBibleNextButton: YES];
		[self setEnabledBiblePreviousButton: NO];
		[self setEnabledCommentaryNextButton: YES];
		[self setEnabledCommentaryPreviousButton: NO];
	} else {
		[self setEnabledBibleNextButton: YES];
		[self setEnabledBiblePreviousButton: YES];
		[self setEnabledCommentaryNextButton: YES];
		[self setEnabledCommentaryPreviousButton: YES];
	}
	
	[pool release];
}

// Use this to show the modal view (pops-up from the bottom)
// try a time of 0.7 to start with...
+ (void) showModal:(UIView*)modalView withTiming:(float)time
{
	UIWindow* mainWindow = (((PocketSwordAppDelegate*) [UIApplication sharedApplication].delegate).window);
	
	CGSize modalSize = modalView.bounds.size;
	//CGPoint middleCenter = modalView.center;
	CGSize offSize = [UIScreen mainScreen].bounds.size;
	CGFloat width, height;
	CGPoint offScreenCenter, middleCenter;
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
		width = offSize.width;
		height = offSize.height;
		offScreenCenter = CGPointMake(width / 2.0f, height * 1.5f);
		middleCenter = CGPointMake(width / 2.0f, height - (modalSize.height / 2.0f));
	} else {
		UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
		if([UIApplication sharedApplication].statusBarHidden) {
			interfaceOrientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
		}
		if(interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			offScreenCenter = CGPointMake(offSize.height - (offSize.height * 1.5), offSize.height / 2.0);
			middleCenter = CGPointMake((modalSize.height / 2.0), offSize.height / 2.0);
		} else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
			offScreenCenter = CGPointMake((offSize.height * 1.5), offSize.height / 2.0);
			middleCenter = CGPointMake(offSize.width - (modalSize.height / 2.0), offSize.height / 2.0);
		} else if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height - (offSize.height * 1.5));
			middleCenter = CGPointMake(modalSize.width / 2.0, (modalSize.height / 2.0));
		} else /*if(interfaceOrientation == UIInterfaceOrientationPortrait)*/ {
			// assume normal portrait otherwise. :P
			width = offSize.width;
			height = offSize.height;
			offScreenCenter = CGPointMake(width / 2.0f, height * 1.5f);
			middleCenter = CGPointMake(width / 2.0f, height - (modalSize.height / 2.0f));
		}
	}
	modalView.center = offScreenCenter; // we start off-screen
	[mainWindow addSubview:modalView];
	
	// Show it with a transition effect
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:time]; // animation duration in seconds
	modalView.center = middleCenter;
	[UIView commitAnimations];
}

- (void) showInfoModal:(UIView*)modalView withTiming:(float)time
{
	UIWindow* mainWindow = (((PocketSwordAppDelegate*) [UIApplication sharedApplication].delegate).window);
	
	CGSize modalSize = modalView.bounds.size;
	//CGPoint middleCenter = modalView.center;
	CGSize offSize = [UIScreen mainScreen].bounds.size;
	CGFloat width, height;
	CGPoint offScreenCenter, middleCenter;
	UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
	if([UIApplication sharedApplication].statusBarHidden) {
		interfaceOrientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
		if(bibleTabController.isFullScreen) {
			interfaceOrientation = bibleTabController.interfaceOrientation;
		} else if(commentaryTabController.isFullScreen) {
			interfaceOrientation = commentaryTabController.interfaceOrientation;
		}
	}
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
		width = offSize.width;
		height = offSize.height;
		offScreenCenter = CGPointMake(width / 2.0, height * 1.5);
		middleCenter = CGPointMake(modalSize.width / 2.0, height - (modalSize.height / 2.0));
	} else {
		if(interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			offScreenCenter = CGPointMake(offSize.height - (offSize.height * 1.5), offSize.height / 2.0);
			middleCenter = CGPointMake((modalSize.height / 2.0), offSize.height / 2.0);
		} else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
			offScreenCenter = CGPointMake((offSize.height * 1.5), offSize.height / 2.0);
			middleCenter = CGPointMake(offSize.width - (modalSize.height / 2.0), offSize.height / 2.0);
		} else if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height - (offSize.height * 1.5));
			middleCenter = CGPointMake(modalSize.width / 2.0, (modalSize.height / 2.0));
		} else /*if(interfaceOrientation == UIInterfaceOrientationPortrait)*/ {
			width = offSize.width;
			height = offSize.height;
			offScreenCenter = CGPointMake(width / 2.0, height * 1.5);
			middleCenter = CGPointMake(modalSize.width / 2.0, height - (modalSize.height / 2.0));
		}
	}
	modalView.center = offScreenCenter; // we start off-screen
	[mainWindow addSubview:modalView];
	
	// Show it with a transition effect
	[UIView beginAnimations:nil context:nil];
	//[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:time]; // animation duration in seconds
	modalView.center = middleCenter;
	[UIView commitAnimations];
}

// Use this to slide the semi-modal view back down.
+ (void) hideModal:(UIView*) modalView withTiming:(float)time
{
	CGSize offSize = [UIScreen mainScreen].bounds.size;
	CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
		//should work under iOS 8 & later!
	} else {
		UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
		if([UIApplication sharedApplication].statusBarHidden) {
			interfaceOrientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];;
		}
		//UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
		if(interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			offScreenCenter = CGPointMake(offSize.height - (offSize.height * 1.5), offSize.height / 2.0);
		} else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
			offScreenCenter = CGPointMake((offSize.height * 1.5), offSize.height / 2.0);
		} else if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height - (offSize.height * 1.5));
		}
	}
	[UIView beginAnimations:nil context:modalView];
	[UIView setAnimationDuration:time];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDidStopSelector:@selector(hideModalEnded:finished:context:)];
	modalView.center = offScreenCenter;
	[UIView commitAnimations];
}

- (void) hideInfoModal:(UIView*) modalView withTiming:(float)time
{
	CGSize offSize = [UIScreen mainScreen].bounds.size;
	CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
	UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
	if([UIApplication sharedApplication].statusBarHidden) {
		interfaceOrientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];;
		if(bibleTabController.isFullScreen) {
			interfaceOrientation = bibleTabController.interfaceOrientation;
		} else if(commentaryTabController.isFullScreen) {
			interfaceOrientation = commentaryTabController.interfaceOrientation;
		}
	}
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
		//should work under iOS 8 & later!
	} else {
		if(interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			offScreenCenter = CGPointMake(offSize.height - (offSize.height * 1.5), offSize.height / 2.0);
		} else if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
			offScreenCenter = CGPointMake((offSize.height * 1.5), offSize.height / 2.0);
		} else if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height - (offSize.height * 1.5));
		}
	}
	[UIView beginAnimations:nil context:modalView];
	[UIView setAnimationDuration:time];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDidStopSelector:@selector(hideInfoModalEnded:finished:context:)];
	modalView.center = offScreenCenter;
	[UIView commitAnimations];
}

+ (void) hideModalEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	UIView* modalView = (UIView *)context;
	[modalView removeFromSuperview];
}

- (void) hideInfoModalEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	UIView* modalView = (UIView *)context;
	[modalView removeFromSuperview];
}

// Use this to slide the semi-modal view back down.
+ (void) hideModalAndRelease:(UIView*) modalView withTiming:(float)time
{
	CGSize offSize = [UIScreen mainScreen].bounds.size;
	CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
	[UIView beginAnimations:nil context:modalView];
	[UIView setAnimationDuration:time];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDidStopSelector:@selector(hideModalAndReleaseEnded:finished:context:)];
	modalView.center = offScreenCenter;
	[UIView commitAnimations];
}

+ (void) hideModalAndReleaseEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	UIView* modalView = (UIView *)context;
	[modalView removeFromSuperview];
	[modalView release];
}

- (void)highlightSearchTerm:(NSString*)term forTab:(ShownTab)tab {
	switch(tab) {
		case BibleTab:
			[[bibleTabController webView] highlightAllOccurencesOfString: term];
			break;
		case CommentaryTab:
			[[commentaryTabController webView] highlightAllOccurencesOfString: term];
			break;
        case DictionaryTab:
        case DevotionalTab:
        case DownloadsTab:
        case PreferencesTab:
        default:
            break;
	}
}

- (void)showInfoWithNotification:(NSNotification *)notification {
	if(notification) {
		[self showInfo:[notification object]];
	}
}

- (void)showInfo:(NSString *)infoString {
	if(![infoView superview]) {
		//need to show the info pane
		CGSize screen = [[UIScreen mainScreen] bounds].size;
		
		infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen.width, INFO_PORTRAIT_HEIGHT)];
		infoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		UIImageView *infoTopBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup-top-bar.png"]];
		infoTopBar.backgroundColor = [UIColor darkGrayColor];
		if([infoTopBar respondsToSelector:@selector(tintColor)]) {
			infoTopBar.image = nil;
			infoTopBar.alpha = 0.99f;
		}
		infoTopBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		infoTopBar.frame = CGRectMake(0, 0, screen.width, 20);
		[infoView addSubview:infoTopBar];
		[infoTopBar release];
		UIButton *closeImgButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		closeImgButton.tintColor = [UIColor whiteColor];
		[closeImgButton setImage:[UIImage imageNamed:@"popup-down-button.png"] forState:UIControlStateNormal];
		closeImgButton.frame = CGRectMake(10, 0, 20, 20);
		[closeImgButton addTarget:self action:@selector(hideInfo) forControlEvents:UIControlEventTouchUpInside];
		closeImgButton.showsTouchWhenHighlighted = YES;
		[infoView addSubview:closeImgButton];
		UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
		clearButton.frame = CGRectMake(0, 0, 40, 25);
		[clearButton addTarget:self action:@selector(hideInfo) forControlEvents:UIControlEventTouchUpInside];
		clearButton.showsTouchWhenHighlighted = YES;
		[infoView addSubview:clearButton];
		infoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, screen.width, (INFO_PORTRAIT_HEIGHT - 20))];
		infoWebView.delegate = self;
		infoWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		infoWebView.backgroundColor = ([[NSUserDefaults standardUserDefaults] boolForKey:DefaultsNightModePreference] ? [UIColor blackColor] : [UIColor whiteColor]);
		[infoView addSubview:infoWebView];
		[infoWebView release];
		
		
		UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;//tabBarController.interfaceOrientation;
		if([UIApplication sharedApplication].statusBarHidden) {
			//we are in fullscreen mode in the Bible or Commentary tab.
			interfaceOrientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
			if(bibleTabController.isFullScreen) {
				interfaceOrientation = bibleTabController.interfaceOrientation;
			} else if(commentaryTabController.isFullScreen) {
				interfaceOrientation = commentaryTabController.interfaceOrientation;
			}
		}
		BOOL deviceIsPad = [PSResizing iPad];
		if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
			infoView.transform = CGAffineTransformIdentity;
			infoView.frame = CGRectMake(0, 0, screen.width, ((deviceIsPad) ? INFO_IPAD_PORTRAIT_HEIGHT : INFO_PORTRAIT_HEIGHT));
		} else {
			if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
				infoView.transform = CGAffineTransformIdentity;
				infoView.frame = CGRectMake(0, 0, screen.height, ((deviceIsPad) ? INFO_IPAD_LANDSCAPE_HEIGHT : INFO_LANDSCAPE_HEIGHT));
				infoView.transform = CGAffineTransformMakeRotation(3.0 * M_PI / 2.0);
			} else if(interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
				infoView.transform = CGAffineTransformIdentity;
				infoView.frame = CGRectMake(0, 0, screen.height, ((deviceIsPad) ? INFO_IPAD_LANDSCAPE_HEIGHT : INFO_LANDSCAPE_HEIGHT));
				infoView.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
			} else if(interfaceOrientation == UIInterfaceOrientationPortrait) {
				infoView.transform = CGAffineTransformIdentity;
				infoView.frame = CGRectMake(0, 0, screen.width, ((deviceIsPad) ? INFO_IPAD_PORTRAIT_HEIGHT : INFO_PORTRAIT_HEIGHT));
			} else if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
				infoView.transform = CGAffineTransformIdentity;
				infoView.transform = CGAffineTransformMakeRotation(2.0 * M_PI / 2.0);
				infoView.frame = CGRectMake(0, 0, screen.width, ((deviceIsPad) ? INFO_IPAD_PORTRAIT_HEIGHT : INFO_PORTRAIT_HEIGHT));
			}
		}
		[self showInfoModal: infoView withTiming: 0.3];
	}
	
	[infoWebView loadHTMLString: infoString baseURL: nil];
	
}

- (void)rotateInfo:(NSNotification *)notification {
	if([infoView superview]) {//only rotate if it's displayed!
		[UIView beginAnimations:@"rotateInfo" context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3];
		
		CGSize screen = [[UIScreen mainScreen] bounds].size;
		UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;//tabBarController.interfaceOrientation;
		if([UIApplication sharedApplication].statusBarHidden) {
			//interfaceOrientation = tabBarController.interfaceOrientation;
			interfaceOrientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
		}
		BOOL deviceIsPad = [PSResizing iPad];
		CGFloat info_portrait_height = ((deviceIsPad) ? INFO_IPAD_PORTRAIT_HEIGHT : INFO_PORTRAIT_HEIGHT);
		if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
			infoView.transform = CGAffineTransformIdentity;
			infoView.frame = CGRectMake(0, (screen.height - info_portrait_height), screen.width, info_portrait_height);
		} else {
			CGFloat x,y;
			CGFloat info_landscape_height = ((deviceIsPad) ? INFO_IPAD_LANDSCAPE_HEIGHT : INFO_LANDSCAPE_HEIGHT);// 200 || 100
			if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
				infoView.transform = CGAffineTransformIdentity;
				x = screen.width - (0.5f * screen.height) - (0.5f * info_landscape_height);
				y = (0.5 * screen.height) - (0.5 * info_landscape_height);
				infoView.frame = CGRectMake(x, y, screen.height, info_landscape_height);
				infoView.transform = CGAffineTransformMakeRotation(3.0 * M_PI / 2.0);
			} else if(interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
				infoView.transform = CGAffineTransformIdentity;
				x = 0.5 * info_landscape_height - 0.5 * screen.height;
				y = (0.5 * screen.height) - (0.5 * info_landscape_height);
				infoView.frame = CGRectMake(x, y, screen.height, info_landscape_height);
				infoView.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
			} else if(interfaceOrientation == UIInterfaceOrientationPortrait) {
				infoView.transform = CGAffineTransformIdentity;
				infoView.frame = CGRectMake(0, (screen.height - info_portrait_height), screen.width, info_portrait_height);
			} else if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
				infoView.transform = CGAffineTransformIdentity;
				infoView.frame = CGRectMake(0, 0, screen.width, info_portrait_height);
				infoView.transform = CGAffineTransformMakeRotation(2.0 * M_PI / 2.0);
			}
		}
		
		[UIView commitAnimations];
	}
}

- (void)hideInfo {
	[self hideInfoModal: infoView withTiming: 0.3];
	[infoView release];
	infoView = nil;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	BOOL load = YES;
	
	//NSLog(@"  Info Pane: requestString: %@", [[request URL] absoluteString]);
	NSDictionary *rData = [PSModuleController dataForLink: [request URL]];
	NSString *entry = nil;
	
	if([[[request URL] scheme] isEqualToString:@"bible"]) {
		//our internal reference to say this is a Bible verse to display in the Bible tab
		if(rData && [[rData objectForKey:ATTRTYPE_ACTION] isEqualToString:@"showRef"]) {
			//error checking, should always get here...
			[self setShownTabTo:BibleTab];
			NSString *ref = [rData objectForKey:ATTRTYPE_VALUE];
			NSArray *comps = [ref componentsSeparatedByString:@":"];

			if([comps count] > 1) {
				//we have a verse
				[[NSUserDefaults standardUserDefaults] setObject: [comps objectAtIndex:1] forKey: DefaultsBibleVersePosition];
				[[NSUserDefaults standardUserDefaults] synchronize];
				ref = [comps objectAtIndex:0];//just the book & ch
				[self displayChapter: ref withPollingType: BibleViewPoll restoreType: RestoreVersePosition];
			} else {
				[self displayChapter: ref withPollingType: BibleViewPoll restoreType: RestoreNoPosition];
			}
			[PSHistoryController addHistoryItem:BibleTab];

			return NO;
		}
	} else if([[[request URL] scheme] isEqualToString:@"search"]) {
		NSString *strongsSearchTerm = [[request URL] host];
		if([strongsSearchTerm rangeOfString:@"H"].location != NSNotFound) {
			NSMutableString *hebrew = [NSMutableString stringWithFormat:@"lemma:%@", strongsSearchTerm];
			if([strongsSearchTerm characterAtIndex:1] == '0') {
				// need to also search without the '0' present
				NSMutableString *extraSearchTerm = [strongsSearchTerm mutableCopy];
				[extraSearchTerm deleteCharactersInRange:NSMakeRange(1, 1)];
				[hebrew appendFormat:@" || lemma:%@", extraSearchTerm];
				[extraSearchTerm release];
			} else {
				// need to also search with the '0' present
				NSMutableString *extraSearchTerm = [strongsSearchTerm mutableCopy];
				[extraSearchTerm insertString:@"0" atIndex:1];
				[hebrew appendFormat:@" || lemma:%@", extraSearchTerm];
				[extraSearchTerm release];
			}
			self.savedSearchHistoryItem = nil;
			PSSearchHistoryItem *shi = [[PSSearchHistoryItem alloc] init];
			shi.searchTerm = hebrew;
			self.savedSearchHistoryItem = shi;
			[shi release];
		} else {
			self.savedSearchHistoryItem = nil;
			PSSearchHistoryItem *shi = [[PSSearchHistoryItem alloc] init];
			shi.searchTerm = [NSString stringWithFormat:@"lemma:%@", strongsSearchTerm];
			self.savedSearchHistoryItem = shi;
			[shi release];
		}
		savedSearchHistoryItem.searchTermToDisplay = strongsSearchTerm;
		savedSearchHistoryItem.strongsSearch = YES;
		[self hideInfo];
		[self toggleMultiList];

		return NO;
	}
	
	if(rData && [[rData objectForKey:ATTRTYPE_ACTION] isEqualToString:@"showRef"]) {
		//
		// it's a Bible ref or dictionary entry to show.
		//
		NSString *mod = [rData objectForKey:ATTRTYPE_MODULE];
		BOOL isABibleRef = NO;
		if(mod) {
			SwordModule *modToUse = [[SwordManager defaultManager] moduleWithName:mod];
			if(!modToUse || modToUse.type == bible || modToUse.type == commentary) {
				isABibleRef = YES;
			} else {
				// Should be a dictionary entry:
				SwordDictionary *swordDictionary = (SwordDictionary*)[[SwordManager defaultManager] moduleWithName: mod];
				BOOL strongs = NO;
				BOOL greekStrongs = YES;
				if(swordDictionary) {
					entry = [swordDictionary entryForKey:[rData objectForKey:ATTRTYPE_VALUE]];
					
					NSString *strongsSearchTerm = @"";
					if([swordDictionary hasFeature: SWMOD_CONF_FEATURE_GREEKDEF] && [swordDictionary hasFeature: SWMOD_CONF_FEATURE_HEBREWDEF]) {
						// should already have a prefix
						strongsSearchTerm = [rData objectForKey:ATTRTYPE_VALUE];
						strongs = YES;
					} else if([swordDictionary hasFeature: SWMOD_CONF_FEATURE_GREEKDEF]) {
						NSMutableString *greek = [[rData objectForKey:ATTRTYPE_VALUE] mutableCopy];
						while([greek characterAtIndex:0] == '0') {
							[greek deleteCharactersInRange:NSMakeRange(0, 1)];
						}
						strongsSearchTerm = [NSString stringWithFormat:@"G%@", greek];
						[greek release];
						greek = nil;
						strongs = YES;
					} else if([swordDictionary hasFeature: SWMOD_CONF_FEATURE_HEBREWDEF]) {
						greekStrongs = NO;
						NSMutableString *hebrew = [[rData objectForKey:ATTRTYPE_VALUE] mutableCopy];
						while([hebrew characterAtIndex:0] == '0') {
							[hebrew deleteCharactersInRange:NSMakeRange(0, 1)];
						}
						strongsSearchTerm = [NSString stringWithFormat:@"H0%@", hebrew];
						[hebrew release];
						hebrew = nil;
						strongs = YES;
					}
					if(strongs) {
						entry = [NSString stringWithFormat:@"%@<div style=\"text-align: right\"><a href=\"search://%@\">%@</a></div>", entry, strongsSearchTerm, NSLocalizedString(@"StrongsSearchFindAll", @"")];
					}
					//DLog(@"\n%@ = %@\n", mod, entry);
				} else {
					entry = [NSString stringWithFormat: @"<p style=\"color:grey;text-align:center;font-style:italic;\">%@ %@</p>", mod, NSLocalizedString(@"ModuleNotInstalled", @"is not installed.")];
				}

				NSString *fontName = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultsFontNamePreference];
				if(strongs && greekStrongs) {
					[[NSUserDefaults standardUserDefaults] setObject:PSGreekStrongsFontName forKey:DefaultsFontNamePreference];
				} else if(strongs && !greekStrongs) {
					[[NSUserDefaults standardUserDefaults] setObject:PSHebrewStrongsFontName forKey:DefaultsFontNamePreference];
				} else {
					[[NSUserDefaults standardUserDefaults] setObject:StrongsFontName forKey:DefaultsFontNamePreference];
				}
				[[NSUserDefaults standardUserDefaults] synchronize];
				entry = [PSModuleController createInfoHTMLString: entry usingModuleForPreferences:mod];
				[[NSUserDefaults standardUserDefaults] setObject:fontName forKey:DefaultsFontNamePreference];
				[[NSUserDefaults standardUserDefaults] synchronize];
			}
		} else {
			// Bible ref:
			isABibleRef = YES;
		}
		
		if(isABibleRef) {
			// handle ref:
			SwordModule *modToUse;
			if(mod && ![mod isEqualToString:@""]) {
				modToUse = [[SwordManager defaultManager] moduleWithName:mod];
			} else {
				modToUse = [[PSModuleController defaultModuleController] primaryBible];
			}
			if(mod && !modToUse) {
				entry = [NSString stringWithFormat: @"<p style=\"color:grey;text-align:center;font-style:italic;\">%@ %@</p>", mod, NSLocalizedString(@"ModuleNotInstalled", @"is not installed.")];
				entry = [PSModuleController createInfoHTMLString: entry usingModuleForPreferences:nil];
			} else {
				id attributeValue = [modToUse attributeValueForEntryData:rData cleanFeed:NO];
				if([attributeValue isMemberOfClass:[NSString class]]) {
					entry = [PSModuleController createInfoHTMLString: (NSString*)attributeValue usingModuleForPreferences:[[[PSModuleController defaultModuleController] primaryBible] name]];
				} else if([attributeValue isKindOfClass:[NSArray class]]) {
					NSMutableString *tmpEntry = [@"" mutableCopy];
					for(NSDictionary *dict in (NSArray*)attributeValue) {
						NSString *curRef = [PSModuleController createRefString: [dict objectForKey:SW_OUTPUT_REF_KEY]];
						[tmpEntry appendFormat:@"<b><a href=\"bible:///%@\">%@</a>:</b> ", curRef, curRef];
						[tmpEntry appendFormat:@"%@<br />", [dict objectForKey:SW_OUTPUT_TEXT_KEY]];
					}
					//DLog(@"\n%@\n", tmpEntry);
					if(![tmpEntry isEqualToString:@""]) {//"[ ]" appear in the TEXT_KEYs where notes should appear, so we remove them here!
						entry = [[tmpEntry stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
						entry = [PSModuleController createInfoHTMLString: entry usingModuleForPreferences:[modToUse name]];
					}
					[tmpEntry release];
				}
			}
		}
		
	} else if(rData && [[rData objectForKey:ATTRTYPE_ACTION] isEqualToString:@"showNote"]) {
		if([[rData objectForKey:ATTRTYPE_TYPE] isEqualToString:@"n"]) {//footnote
			entry = (NSString*)[[[PSModuleController defaultModuleController] primaryBible] attributeValueForEntryData:rData];
			entry = [PSModuleController createInfoHTMLString: entry usingModuleForPreferences:[[[PSModuleController defaultModuleController] primaryBible] name]];
		} else if([[rData objectForKey:ATTRTYPE_TYPE] isEqualToString:@"x"]) {//x-reference
			NSArray *array = (NSArray*)[[[PSModuleController defaultModuleController] primaryBible] attributeValueForEntryData:rData];
			NSMutableString *tmpEntry = [@"" mutableCopy];
			for(NSDictionary *dict in array) {
				NSString *curRef = [PSModuleController createRefString: [dict objectForKey:SW_OUTPUT_REF_KEY]];
				[tmpEntry appendFormat:@"<b><a href=\"bible:///%@\">%@</a>:</b> ", curRef, curRef];
				[tmpEntry appendFormat:@"%@<br />", [dict objectForKey:SW_OUTPUT_TEXT_KEY]];
			}
			if(![tmpEntry isEqualToString:@""]) {//"[ ]" appear in the TEXT_KEYs where notes should appear, so we remove them here!
				entry = [[tmpEntry stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
				entry = [PSModuleController createInfoHTMLString: entry usingModuleForPreferences:[[[PSModuleController defaultModuleController] primaryBible] name]];
			}
			[tmpEntry release];
		}
	}
	
	if(entry) {
		entry = [entry stringByReplacingOccurrencesOfString:@"*x" withString:@"x"];
		entry = [entry stringByReplacingOccurrencesOfString:@"*n" withString:@"n"];
		[self showInfo: entry];
		load = NO;
	} else {
		if(rData) {
			//DLog(@"\nempty entry && action = %@", [rData objectForKey:ATTRTYPE_ACTION]);
		} else {
			//DLog(@"rData is nil && entry is nil");
		}
	}
	
	[pool release];
	return load; // Return YES to make sure regular navigation works as expected.
	
}

- (void)setShownTabTo:(ShownTab)tab {
	switch(tab) {
		case BibleTab:
		{
			for(UIViewController* uivc in tabBarController.viewControllers) {
				if([uivc.title isEqualToString:BibleTabTitleString]) {
					tabBarController.selectedViewController = uivc;
				}
			}
		}
			break;
		case CommentaryTab:
		{
			for(UIViewController* uivc in tabBarController.viewControllers) {
				if([uivc.title isEqualToString:CommentaryTabTitleString]) {
					tabBarController.selectedViewController = uivc;
				}
			}
		}
			break;
		case DownloadsTab:
		{
			//for(UIViewController *uivc in tabBarController.viewControllers) {
			 	//if([uivc isKindOfClass:[NavigatorSources class]]) {
                    tabBarController.selectedIndex= 3;
			//		break;
				//}
			//}
		}
			break;
		case PreferencesTab:
		{
			for(UIViewController *uivc in tabBarController.viewControllers) {
				if([uivc isKindOfClass:[PSPreferencesController class]]) {
					tabBarController.selectedViewController = uivc;
					break;
				}
			}
		}
			break;
        case DictionaryTab:
        case DevotionalTab:
        default:
            break;
	}
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+ (UIColor *)getBarColorDefault {
	
	NSString *colorHexString =  @"#191919";//[[NSUserDefaults standardUserDefaults] stringForKey: DefaultsBarColor];
	if (!colorHexString) {
		colorHexString = [PSBookmarkFolder hexStringFromColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
		[[NSUserDefaults standardUserDefaults] setObject: colorHexString forKey: DefaultsBarColor];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	return [PSBookmarkFolder colorFromHexString:colorHexString];
	
}

+ (void)setBarColorDefault:(UIColor*)color {
	if(!color) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:DefaultsBarColor];
	} else {
		[[NSUserDefaults standardUserDefaults] setObject:[PSBookmarkFolder hexStringFromColor:color] forKey:DefaultsBarColor];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationBarColorChanged object:nil];
}

+ (BOOL)getBarTranslucentDefault {
	return [[NSUserDefaults standardUserDefaults] boolForKey: DefaultsBarTranslucent];
}

+ (void)setBarTranslucentDefault:(BOOL)translucent {
	[[NSUserDefaults standardUserDefaults] setBool:translucent forKey:DefaultsBarTranslucent];
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationBarColorChanged object:nil];
}

@end

@implementation PSLoadingViewController

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [PSResizing shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}


@end
