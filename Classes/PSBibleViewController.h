//
//  PSBibleViewController.h
//  PocketSword
//
//  Created by Nic Carter on 3/11/09.
//  Copyright 2009 The CrossWire Bible Society. All rights reserved.
//

#import "PSModuleViewController.h"
#import "PSBookmarkFolderColourSelectorViewController.h"
#import "PSBookmark.h"
@class PSCommentaryViewController;

@interface PSBibleViewController : PSModuleViewController<PSBookmarkFolderColourSelectorDelegate> {

	PSCommentaryViewController	*commentaryView;
 
    UITextField *descriptionTextField;
    NSString *folder;
    NSString *originalFolder;
    PSBookmark *bookmarkBeingEdited;
}
@property (nonatomic, assign) NSString *rgbHexString;
@property (assign)			PSCommentaryViewController	*commentaryView;

@end
