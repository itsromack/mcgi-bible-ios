//
//  NotesInFolderTableViewController.m
//  MCGI Bible
//
//  Created by Francisco Humarang on 8/11/15.
//  Copyright © 2015 MCGI Singapore. All rights reserved.
//

#import "NotesInFolderTableViewController.h"
#import "FMDatabase.h"
#import "PocketSwordAppDelegate.h"
#import "NoteViewController.h"
#import "NoteObj.h"
@interface NotesInFolderTableViewController ()

@end

@implementation NotesInFolderTableViewController
@synthesize noteFolderObj,arrFolders, arrNotes;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.title = noteFolderObj.name;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
 
    
    
      UIBarButtonItem *newNoteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self  action:@selector(newNoteButtonPressed)];
    
    
      self.navigationItem.rightBarButtonItem= newNoteButton;
      self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem= backButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [backButton release];
}
-(void)viewWillAppear:(BOOL)animated

{[super viewWillAppear:YES];
    self.arrNotes = [[NSMutableArray alloc]init];
    
    [self LoadNoteInFolders];
}
-(void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)newNoteButtonPressed
{
    NoteViewController *note = [[NoteViewController  alloc]init];
    
    
    note.folder_id = self.noteFolderObj.ID;
    
    note.noteObj.folder_id = self.noteFolderObj.ID;
    [self.navigationController pushViewController:note animated:YES];
   
    [note release];
}
-(void)LoadNoteInFolders
{
    
NSString *databasePath = [[PocketSwordAppDelegate sharedAppDelegate] getDbPath];
FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
    [self.arrNotes removeAllObjects];
    FMResultSet *results = [database executeQuery: [NSString stringWithFormat:@"select * from Notes where folder_id = %d", self.noteFolderObj.ID]];
    
    while([results next]) {
        NSString *note = [results stringForColumn:@"note"];
        NSString *date_created = [results stringForColumn:@"date_created"];
        int ID =[results intForColumn:@"id"];
        NoteObj *n = [[NoteObj alloc]init];
        
        n.note = note;
        n.ID = ID;
        n.date_created= date_created;
        
        [self.arrNotes addObject:n];
    }
    
    [database close];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.arrNotes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      
    NSString *CellIdentifier =@"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
    }
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
 
    NoteObj *_noteObj = [[NoteObj alloc]init];
    
    _noteObj= (NoteObj*)[self.arrNotes objectAtIndex:indexPath.row];
    
    
    NSString *fullString = _noteObj.note;
    NSString *prefix = nil;
    
    if ([fullString length] >= 300)
        prefix = [NSString stringWithFormat:@"%@...", [fullString substringToIndex:300]];
    else
        prefix = fullString;
    
    cell.textLabel.text =prefix;
    cell.detailTextLabel.text =  [NSString stringWithFormat:@"Date Created: %@",   _noteObj.date_created];
    
    // Configure the cell...
    // [noteObj release];
    
    return cell;
}


-(void)newFolderButtonPressed
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New Note"
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
                                                             [self  LoadNoteInFolders];
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
    
    
    
    NSString *queryInsert = [NSString stringWithFormat:@"insert into Notes (name) values ('%@')",
                             ref];
    
    [database executeUpdate:queryInsert];
    
    [database close];
    
    
}
-(void)deleteNote:(int)ID
{
    NSString *databasePath = [[PocketSwordAppDelegate sharedAppDelegate] getDbPath];
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
    NSString *queryDelete = [NSString stringWithFormat:@"delete from Notes where id =%d", ID];
    
    [database executeUpdate:queryDelete];
    
    
    
    [database close];
    
    [self LoadNoteInFolders];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NoteObj *_noteObj = [[NoteObj alloc]init];
    
    _noteObj= (NoteObj*)[self.arrNotes objectAtIndex:indexPath.row];
    
    NoteViewController *note = [[NoteViewController  alloc]init];
    note.note_id = _noteObj.ID;
    note.noteObj = _noteObj;
    note.folder_id = self.noteFolderObj.ID;
    
    [self.navigationController pushViewController:note animated:YES];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
   // [_noteObj release];
    
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
        NoteObj *noteObj = [[NoteObj alloc]init];
        
        noteObj= (NoteObj*)[self.arrNotes objectAtIndex:indexPath.row];
        
        [self deleteNote:noteObj.ID];
        
        //  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
-(void)dealloc
{
 [super dealloc];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
