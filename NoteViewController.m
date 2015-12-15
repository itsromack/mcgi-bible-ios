//
//  NoteViewController.m
//  MCGI Bible
//
//  Created by Francisco Humarang on 8/11/15.
//  Copyright © 2015 MCGI Singapore. All rights reserved.
//
#import "PocketSwordAppDelegate.h"
#import "NoteViewController.h"
#import "FMDatabase.h"
@interface NoteViewController ()
{
    UITextView *textView ;
}
@end

@implementation NoteViewController
@synthesize folder_id,noteObj, note_id;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,screenWidth,screenHeight)];
    
    [self.view addSubview:textView];
    [textView becomeFirstResponder];

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem= saveButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [saveButton release];
    
    
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
     self.navigationItem.leftBarButtonItem = backButton;
     self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
     [backButton release];
    [self LoadNote];
}

-(void)backButtonPressed
{   [self saveNote];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveButtonPressed
{
    //save
    
    [self saveNote];
    
    [textView resignFirstResponder];
    
}
-(void)LoadNote
{
    
    NSString *databasePath = [[PocketSwordAppDelegate sharedAppDelegate] getDbPath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
   
    FMResultSet *results = [database executeQuery: [NSString stringWithFormat:@"select * from Notes where id = %d", self.noteObj.ID]];
    
    while([results next]) {
        textView.text = [results stringForColumn:@"note"];
        self.note_id =self.noteObj.ID;
    }
    
    [database close];
    
}
-(BOOL)isExist:(int)noteId{
    
    NSString *databasePath = [[PocketSwordAppDelegate sharedAppDelegate] getDbPath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
    BOOL exists=NO;
    FMResultSet *results = [database executeQuery: [NSString stringWithFormat:@"select * from Notes where id = %d", noteId]];
    
    while([results next]) {
        textView.text = [results stringForColumn:@"note"];
        exists=YES;
    }
    
    [database close];
    return exists;
}
-(void)saveNote
{
    
        NSString *databasePath = [[PocketSwordAppDelegate sharedAppDelegate] getDbPath];
        
    NSString *ref = textView.text;
    
        FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
        [database open];
    
        
        NSString *queryInsert = [NSString stringWithFormat:@"insert into Notes (note,folder_id, date_created) values ('%@','%d',date('now'))",
                                 ref,self.noteObj.folder_id];
    
    NSString *queryUpdate = [NSString stringWithFormat:@"update Notes set note='%@' where id=%d", ref,self.note_id];
    
    
    if ([self isExist:self.note_id]) {
         [database executeUpdate:queryUpdate];
    }else{
         [database executeUpdate:queryInsert];
    NSString *queryLast = @"SELECT MAX(id) FROM Notes";
        
      
        FMResultSet *results = [database executeQuery: queryLast];
        
        while([results next]) {
            self.note_id = [results  intForColumnIndex:0];
    }
        
        [database close];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
