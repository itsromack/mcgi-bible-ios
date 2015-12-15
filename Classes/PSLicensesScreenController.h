//
//  PSLicensesScreenController.h
//  MCGIBible
//
//  Created by Daniel Salunga on 29/4/15.
//  Copyright (c) 2015 MCGI Singapore. All rights reserved.
//

#import <MessageUI/MessageUI.h>


@interface PSLicensesScreenController : UIViewController <UIWebViewDelegate> {
    UIWebView *licensesWebView;
}

@property (retain) UIWebView *licensesWebView;

+ (NSString*)generateLicensesHTML;

@end
