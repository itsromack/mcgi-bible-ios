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
    TPKeyboardAvoidingScrollView *avoidingScroll;
    CGFloat defaultSize;
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
    
    
    defaultSize = textView.font.pointSize;
    avoidingScroll =[[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0,0,screenWidth,screenHeight) ];
    [self.view addSubview:avoidingScroll];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,screenWidth,screenHeight)];
    
    [avoidingScroll addSubview:textView];
    
    [textView becomeFirstResponder];
    
  //  textView.font = [UIFont systemFontOfSize:13];

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    //self.navigationItem.rightBarButtonItem= saveButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [saveButton release];
   
    UIView *myView= [[UIView alloc]initWithFrame:CGRectMake(0,0,200,30)];
    
    UIButton *btnFontBigger =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
  btnFontBigger.frame  = CGRectMake(65, 0, 35, 30);
    
    [btnFontBigger setTitle:@"Aa" forState:UIControlStateNormal];
    
    btnFontBigger.backgroundColor = [UIColor clearColor ];
    [btnFontBigger setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnFontBigger.font = [UIFont systemFontOfSize:28];
    [btnFontBigger addTarget:self action:@selector(biggerFont) forControlEvents:UIControlEventTouchUpInside];
    
    [myView addSubview:btnFontBigger];
    
    UIButton *btnFontSmaller =
    [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    btnFontSmaller.frame =  CGRectMake(100, 0, 35, 30);
    
   
    
    
    [btnFontSmaller  setTitle:@"Aa" forState:UIControlStateNormal];
    
    btnFontSmaller.backgroundColor = [UIColor clearColor ];
    [btnFontSmaller setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnFontSmaller.font = [UIFont systemFontOfSize:20];
    
    [btnFontSmaller addTarget:self action:@selector(smallerFont) forControlEvents:UIControlEventTouchUpInside];
    
    [myView addSubview:btnFontSmaller];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeSystem];
    btnDone.frame = CGRectMake(155, 0, 45, 30);
    [btnDone  setTitle:@"Done" forState:UIControlStateNormal];
    
    btnDone.backgroundColor = [UIColor clearColor ];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.font = [UIFont systemFontOfSize:17];
    [btnDone addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [myView addSubview:btnDone];
    
    
    
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:myView];
    
    
    self.navigationItem.rightBarButtonItem = customItem;
    [customItem release];
    
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
     self.navigationItem.leftBarButtonItem = backButton;
     self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
     [backButton release];
    [self LoadNote];
}
-(void)biggerFont
{
    CGFloat size = textView.font.pointSize;
   
    size = size + 2;
   
    size = textView.font.pointSize;
    
    int maxSize=30;
    if ([PSResizing iPad] ) {
        maxSize=36;
    }
    
    if ( size >= maxSize) {
        return;
    }else {
        textView.font = [UIFont systemFontOfSize:size
                         + 2];
        [textView setNeedsDisplay];
   
    }
   
}
-(void)smallerFont

{
    CGFloat size = textView.font.pointSize;
    size = size-2;
   size = textView.font.pointSize;
  
    if ( size < 9) {
        return;
    }else{

        textView.font = [UIFont systemFontOfSize:size-2];
     
        [textView setNeedsDisplay];
    }
  
    
    
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
    
    FMResultSet *results = [database executeQuery: [NSString stringWithFormat:@"select * from Notes where id = %d", self.note_id]];
    
    while([results next]) {
        textView.text = [results stringForColumn:@"note"];
        int size = [results intForColumn:@"font_size"];
        CGFloat fSize= (float)size;
        textView.font = [UIFont systemFontOfSize:fSize];
        
        //self.note_id =self.noteObj.ID;
    }
    [textView setNeedsDisplay];
    [database close];

}
-(BOOL)isExist:(int)noteId{
    
    NSString *databasePath = [[PocketSwordAppDelegate sharedAppDelegate] getDbPath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
    BOOL exists=NO;
    FMResultSet *results = [database executeQuery: [NSString stringWithFormat:@"select * from Notes where id = %d", noteId]];
    
    while([results next]) {
        //textView.text = [results stringForColumn:@"note"];
        exists=YES;
    }
    
    [database close];
    return exists;
}
-(void)saveNote
{
    
    
        NSString *ref = textView.text;
    

        
        NSString *databasePath = [[PocketSwordAppDelegate sharedAppDelegate] getDbPath];
        
        FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
        [database open];
    
    int size = (int)roundf(textView.font.pointSize);
    
        NSString *queryInsert = [NSString stringWithFormat:@"insert into Notes (note,folder_id, date_created, font_size) values ('%@','%d',date('now'), '%d' )",
                                 ref,self.folder_id,size]   ;
    
    NSString *queryUpdate = [NSString stringWithFormat:@"update Notes set note='%@', font_size='%d' where id=%d", ref,self.note_id, size];
    
    
    if ([self isExist:self.note_id]) {
         [database executeUpdate:queryUpdate];
    }else{
            if (ref.length> 0) {
         [database executeUpdate:queryInsert];
            }
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
