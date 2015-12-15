//
//  NoteObj.h
//  MCGI Bible
//
//  Created by Francisco Humarang on 14/11/15.
//  Copyright © 2015 MCGI Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteObj : NSObject

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *note;
@property (nonatomic, assign) int ID;
@property (nonatomic, retain) NSString *date_created;
@property (nonatomic, assign) int folder_id;
@end
