//
//  HighlightedVerseObject.h
//  MCGI Bible
//
//  Created by Francisco Humarang on 19/9/15.
//  Copyright (c) 2015 MCGI Singapore. All rights reserved.
//

//#import <Realm/Realm.h>
 
@interface HighlightedVerseObject : NSObject
@property (nonatomic,retain) NSString* ref;
@property (nonatomic, retain) NSString *rgbHexString;
 
@end

// This protocol enables typed collections. i.e.:
// RLMArray<HighlightedVerseObject>
 //RLM_ARRAY_TYPE(HighlightedVerseObject)
