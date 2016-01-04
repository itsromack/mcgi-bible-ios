//
//  NoteViewController.h
//  MCGI Bible
//
//  Created by Francisco Humarang on 8/11/15.
//  Copyright © 2015 MCGI Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteObj.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface NoteViewController : UIViewController<UITextViewDelegate>
{   int folder_id;
    NoteObj *noteObj;
    int note_id;
}
@property (nonatomic,assign)int folder_id;
@property (nonatomic,retain) NoteObj *noteObj;
@property (nonatomic,assign) int note_id;
@end
