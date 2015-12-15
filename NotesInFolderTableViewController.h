//
//  NotesInFolderTableViewController.h
//  MCGI Bible
//
//  Created by Francisco Humarang on 8/11/15.
//  Copyright © 2015 MCGI Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteFolderObj.h"
@interface NotesInFolderTableViewController : UITableViewController
{
    NSMutableArray *arrFolders;
    NSMutableArray *arrNotes;
    NoteFolderObj *noteFolderObj;
}
@property (nonatomic,retain) NSMutableArray *arrFolders;
@property (nonatomic,retain) NSMutableArray *arrNotes;
@property (nonatomic, retain) NoteFolderObj *noteFolderObj;

@end
