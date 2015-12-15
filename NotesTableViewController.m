//
//  NotesTableViewController.m
//  MCGI Bible
//
//  Created by Francisco Humarang on 8/11/15.
//  Copyright © 2015 MCGI Singapore. All rights reserved.
//

#import "NotesTableViewController.h"
#import "NotesInFolderTableViewController.h"
#import "FMDatabase.h"
#import "NoteFolderObj.h"
#import "PocketSwordAppDelegate.h"
@interface NotesTableViewController ()
{
  
}
@end

@implementation NotesTableViewController
@synthesize arrNotes,arrFolders,isAdding;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    isAdding = NO;
    self.editing = NO;
    Editing = NO;
    parentFolders = nil;
    displayAddFolderRow = NO;
    
    self.arrFolders = [[NSMutableArray alloc]init];
    UIBarButtonItem *newFolderButton = [[UIBarButtonItem alloc] initWithTitle:@"New Folder" style:UIBarButtonItemStylePlain target:self action:@selector(newFolderButtonPressed)];
    self.navigationItem.rightBarButtonItem= newFolderButton;
       self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [newFolderButton release];
    
    /*
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed1)];
    self.navigationItem.rightBarButtonItem = editButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [editButton release];*/
   
    self.tableView.allowsSelectionDuringEditing = YES;
    
    [self LoadNoteFolders];
}
- (void)editButtonPressed1 {
    displayAddFolderRow = NO;
    if(!Editing) {
        displayAddFolderRow = YES;
        if(!self.isAdding) {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        }
        [self setEditing:NO animated:NO];//if the user has side-swiped to delete, remove that delete button first.
        [self setEditing:YES animated:YES];
        Editing = YES;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editButtonPressed1)];
        [self.navigationItem setRightBarButtonItem:doneButton animated:YES];
        [doneButton release];
    } else {
        [self setEditing:NO animated:YES];
        Editing = NO;
        if(!self.isAdding) {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        }
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed1)];
        [self.navigationItem setRightBarButtonItem:editButton animated:YES];
        [editButton release];
    }
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)] withRowAnimation:UITableViewRowAnimationMiddle];
    //[self.tableView reloadData];
}


-(void)LoadNoteFolders
{
    NSString *databasePath = [[PocketSwordAppDelegate sharedAppDelegate] getDbPath];
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
    FMResultSet *results = [database executeQuery:@"select * from NoteFolders"];
    
   
   [self.arrFolders removeAllObjects];
    
    while([results next]) {
       
        NSString *name = [results stringForColumn:@"name"];
        int ID =[results intForColumn:@"id"];
       NoteFolderObj *folderObj = [[NoteFolderObj alloc]init];
    
        
        folderObj.ID = ID;
        folderObj.name = name;
        [self.arrFolders addObject:folderObj];
    }
 
    
 
     // [folderObj release];
    [database close];
   [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)newFolderButtonPressed
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New Folder"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // optionally configure the text field
        textField.keyboardType = UIKeyboardTypeAlphabet;
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
handler:^(UIAlertAction *action) {
UITextField *textField = [alert.textFields firstObject];
    if (textField.text.length >0) {
        [self saveFolder:textField];
        [self LoadNoteFolders];
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Error", @"") message: NSLocalizedString(@"Note folder is required", @"Note folder is required.") delegate: self cancelButtonTitle: NSLocalizedString(@"Ok", @"") otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        
    }
    }];
    
    [alert addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                         
                                                     }];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)saveFolder:(UITextField*)textField
{
    NSString *databasePath = [[PocketSwordAppDelegate sharedAppDelegate] getDbPath];
    
    NSString *ref = textField.text;
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
  
    
    NSString *queryInsert = [NSString stringWithFormat:@"insert into NoteFolders (name) values ('%@')",
                             ref];
    
    [database executeUpdate:queryInsert];
    
    [database close];
    
    
}
-(void)deleteFolder:(NSString*)ref
{
    NSString *databasePath = [[PocketSwordAppDelegate sharedAppDelegate] getDbPath];
    
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
    NSString *queryDelete = [NSString stringWithFormat:@"delete from NoteFolders where name ='%@'", ref];
    
    [database executeUpdate:queryDelete];
    
   
    
    [database close];
    
     [self LoadNoteFolders];
}
#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
  
        return 1;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
        return self.arrFolders.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
       NSString *CellIdentifier =@"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
    }
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"folder.png"];
    NoteFolderObj *noteObj = [[NoteFolderObj alloc]init];
    
    noteObj= (NoteFolderObj*)[self.arrFolders objectAtIndex:indexPath.row];

    
    cell.textLabel.text = noteObj.name;
    // Configure the cell...
   // [noteObj release];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NoteFolderObj *noteObj = [[NoteFolderObj alloc]init];
    
    noteObj= (NoteFolderObj*)[self.arrFolders objectAtIndex:indexPath.row];
    
    NotesInFolderTableViewController *notes = [[NotesInFolderTableViewController alloc]initWithStyle:UITableViewStylePlain];
    notes.noteFolderObj = noteObj;
    [self.navigationController pushViewController:notes animated:YES];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];

    [noteObj release];
    [notes release];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleInsert;
    }
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NoteFolderObj *noteObj = [[NoteFolderObj alloc]init];
        
        noteObj= (NoteFolderObj*)[self.arrFolders objectAtIndex:indexPath.row];
        
        [self deleteFolder:noteObj.name];
       
      //  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
      
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void)dealloc
{
    [super dealloc];
    [self.arrFolders release];
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
