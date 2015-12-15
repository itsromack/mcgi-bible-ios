//
//  NotesTableViewController.h
//  MCGI Bible
//
//  Created by Francisco Humarang on 8/11/15.
//  Copyright © 2015 MCGI Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesTableViewController : UITableViewController
{
    NSMutableArray *arrFolders;
    NSMutableArray *arrNotes;
   
    BOOL isAdding;
    NSString *parentFolders;
    BOOL displayAddFolderRow;
    NSIndexPath *rowToDelete;
    BOOL Editing;
}
@property (nonatomic,retain) NSMutableArray *arrFolders;
@property (nonatomic,retain) NSMutableArray *arrNotes;
@property (nonatomic,assign) BOOL isAdding;
@end
