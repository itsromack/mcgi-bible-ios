//
//  PSAboutScreenController.mm
//  PocketSword
//
//  Created by Nic Carter on 12/11/09.
//  Copyright 2009 The CrossWire Bible Society. All rights reserved.
//

#include <sys/types.h>
#include <sys/sysctl.h>

#import "PSAboutScreenController.h"
#import "PSModuleController.h"
#import "globals.h"

@implementation PSAboutScreenController

@synthesize aboutWebView;

+ (NSString*)generateAboutHTML
{
	static NSString *body = @"<div id=\"header\"></br>\n\
								 <div class=\"title\">MCGI Bible</div>\n\
                            <p></p>\n\
                            <p></p>\n\
                                </div>\n\
							 <div id=\"main\">\n\
								<p><strong>Developed by: </strong><br />\n\
									 MCGI Singapore.\n\
								</p>\n\
    <p>For any feedback or inquiries, please email us at <a href=\"mailto:inquiries@mcgi.org.sg\"> inquiries@mcgi.org.sg</a></p>\n\
                             <p class=\"section\"><strong>Explore MCGI apps and services:</strong>\
                             <ul><li><a href=\"https://mcgi.church/apps/\">Tablet &amp; Mobile Apps</a></li>\n\
                             <li><a href=\"http://www.mcgi.org/broadcasts/internet/\">Live broadcasts &amp; social media</a></li>\n\
                             <li><a href=\"http://www.mcgi.org/\">MCGI.org - The official website</a></li>\n\
                             <li><a href=\"https://mcgi.church/explore/\">Find out more</a></li></ul>\n\
                             </p></div>\n\
<br /><strong>&nbsp;&nbsp;&nbsp;Licenses</strong>\n\
    <div class=\"crosswire\">\n\
    <h3>PocketSword</h3>\n\
    <p>MCGI Bible was based on the PocketSword project written by Nick Carter under the GPL License</p>\n\
    \n\
    <p>PocketSword benefits from the following Open Source projects:<br />\n\
      <ul><li><a href=\"http://www.crosswire.org/sword/index.jsp\">The SWORD Project</a></li>\n\
      <li><a href=\"http://code.google.com/p/cocoahttpserver/\">CocoaHTTPServer</a></li>\n\
     <li><a href=\"https://github.com/zbyhoo/EGOTableViewPullRefresh\">zbyhoo's fork of EGOTableViewPullRefresh</a></li>\n\
    <li><a href=\"http://code.google.com/p/ziparchive/\">ZipArchive</a><l/i></ul><br />\n\
    </p>\
    </div>\n\
    <br />\n\
    <i><center><a href=\"https://bitbucket.org/niccarter/pocketsword/overview\">PocketSword on Bitbucket</a></center></i><br />\n\
    <br />&nbsp;<br />";
	
	
	return [NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\
			<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\"\n\
			\"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">\n\
			<html dir=\"ltr\" xmlns=\"http://www.w3.org/1999/xhtml\"\n\
			xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n\
			xsi:schemaLocation=\"http://www.w3.org/MarkUp/SCHEMA/xhtml11.xsd\"\n\
			xml:lang=\"en\" >\n\
			<meta name='viewport' content='width=device-width' />\n\
			<head>\n\
			<style type=\"text/css\">\n\
			html {\n\
				-webkit-text-size-adjust: none; /* Never autoresize text */\n\
			}\n\
			body {\n\
				color: black;\n\
				background-color: white;\n\
				font-size: 11pt;\n\
				font-family: %@;\n\
				line-height: 130%%;\n\
                margin: 0;\n\
			}\n\
			#header {\n\
                color: black;\n\
				border-bottom: solid 1px gray;\n\
				padding: 5px 5px 0 5px;\n\
                font-weight:bold;\n\
			}\n\
			#main {\n\
				padding: 8px;\n\
				text-align: left;\n\
			}\n\
            .section {\n\
                padding-top: 8px;\
            }\n\
			div.version {\n\
				font-size: 9pt;\n\
				text-align: center;\n\
			}\n\
			div.title {\n\
				font-size: 14pt;\n\
				text-align: center;\n\
			}\n\
			li {\n\
				padding-bottom: 8px;\n\
			}\n\
            i a {\n\
                text-decoration: none;\n\
            }\n\
			h2.headbar {\n\
				background-color : #660000;\n\
				color : #dddddd;\n\
				font-weight : bold;\n\
				font-size:1em;\n\
				padding-left:1em;\n\
			}\n\
            div.crosswire {\n\
            color: black;\n\
            background-color: white;\n\
            font-size: 11pt;\n\
            font-family: %@;\n\
            line-height: 130%%;\n\
            margin:10px;\n\
            }\n\
			</style>\n\
			</head>\n\
			<body><div>%@</div></body></html>", PSDefaultFontName, PSDefaultFontName,
			body];
}

- (void)loadView {
	CGFloat viewWidth = [[UIScreen mainScreen] bounds].size.width;
	CGFloat viewHeight = [[UIScreen mainScreen] bounds].size.height;
	
	UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
	
	UIWebView *wv = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
	wv.delegate = self;
	wv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	wv.backgroundColor = [UIColor whiteColor];
	NSString *html = @"<html><body bgcolor=\"white\">@nbsp;</body></html>";
	if([[NSUserDefaults standardUserDefaults] boolForKey:DefaultsNightModePreference]) {
		html = @"<html><body bgcolor=\"black\">@nbsp;</body></html>";
		wv.backgroundColor = [UIColor blackColor];
	}
	[wv loadHTMLString: html baseURL: nil];
	[baseView addSubview:wv];
	self.aboutWebView = wv;
	[wv release];
	
	self.view = baseView;
	[baseView release];
}

- (void)viewDidLoad {
	self.navigationItem.title = NSLocalizedString(@"AboutTitle", @"About");
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	UIBarButtonItem *emailUsBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"EmailUsButton", @"Email Us") style:UIBarButtonItemStyleBordered target:self action:@selector(emailFeedback:)];
	self.navigationItem.rightBarButtonItem = emailUsBarButtonItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
	[emailUsBarButtonItem release];

	[aboutWebView loadHTMLString:[PSAboutScreenController generateAboutHTML] baseURL:nil];
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (NSString *) platform {
	int mib[2];
	size_t len;
	char *machine;
	
	mib[0] = CTL_HW;
	mib[1] = HW_MACHINE;
	sysctl(mib, 2, NULL, &len, NULL, 0);
	machine = (char *)malloc(len);
	sysctl(mib, 2, machine, &len, NULL, 0);
	
	NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
	free(machine);
	return platform;
}

// thanks to erica https://github.com/erica/uidevice-extension
// Updates from http://theiphonewiki.com/wiki/Models
#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS"
#define IPHONE_4_NAMESTRING             @"iPhone 4"
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_5C_NAMESTRING            @"iPhone 5c"
#define IPHONE_5S_NAMESTRING            @"iPhone 5s"
#define IPHONE_6_NAMESTRING             @"iPhone 6"
#define IPHONE_6P_NAMESTRING            @"iPhone 6 Plus"
//#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_5G_NAMESTRING              @"iPod touch 5G"
//#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1G"
#define IPAD_2G_NAMESTRING              @"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"
#define IPAD_4G_NAMESTRING              @"iPad 4G"
#define IPAD_5G_NAMESTRING				@"iPad Air 1G"
//#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define IPAD_MINI_1G_NAMESTRING			@"iPad mini 1G"
#define IPAD_MINI_2G_NAMESTRING			@"iPad mini 2G"

//#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
//#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
//#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
//#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"

//#define IOS_FAMILY_UNKNOWN_DEVICE       @"Unknown iOS device"

#define SIMULATOR_NAMESTRING            @"iPhone Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator" // :)

- (NSString *) platformString
{
    NSString *platform = [self platform];
	
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return IFPGA_NAMESTRING;
	
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return IPHONE_1G_NAMESTRING;
    if ([platform isEqualToString:@"iPhone1,2"])    return IPHONE_3G_NAMESTRING;
    if ([platform hasPrefix:@"iPhone2"])            return IPHONE_3GS_NAMESTRING;
    if ([platform hasPrefix:@"iPhone3"])            return IPHONE_4_NAMESTRING;
    if ([platform hasPrefix:@"iPhone4"])            return IPHONE_4S_NAMESTRING;
    if ([platform hasPrefix:@"iPhone5,1"])            return IPHONE_5_NAMESTRING;
    if ([platform hasPrefix:@"iPhone5,2"])            return IPHONE_5_NAMESTRING;
    if ([platform hasPrefix:@"iPhone5,3"])            return IPHONE_5C_NAMESTRING;
    if ([platform hasPrefix:@"iPhone5,4"])            return IPHONE_5C_NAMESTRING;
    if ([platform hasPrefix:@"iPhone6,1"])            return IPHONE_5S_NAMESTRING;
    if ([platform hasPrefix:@"iPhone6,2"])            return IPHONE_5S_NAMESTRING;
	if ([platform hasPrefix:@"iPhone7,2"])            return IPHONE_6_NAMESTRING;
	if ([platform hasPrefix:@"iPhone7,1"])            return IPHONE_6P_NAMESTRING;
	
    // iPod
    if ([platform hasPrefix:@"iPod1"])              return IPOD_1G_NAMESTRING;
    if ([platform hasPrefix:@"iPod2"])              return IPOD_2G_NAMESTRING;
    if ([platform hasPrefix:@"iPod3"])              return IPOD_3G_NAMESTRING;
    if ([platform hasPrefix:@"iPod4"])              return IPOD_4G_NAMESTRING;
    if ([platform hasPrefix:@"iPod5"])              return IPOD_5G_NAMESTRING;
	
    // iPad
    if ([platform hasPrefix:@"iPad1"])              return IPAD_1G_NAMESTRING;
		// mini
    if ([platform hasPrefix:@"iPad2,5"] ||
		[platform hasPrefix:@"iPad2,6"] ||
		[platform hasPrefix:@"iPad2,7"])            return IPAD_MINI_1G_NAMESTRING;
	if ([platform hasPrefix:@"iPad4,4"] ||
		[platform hasPrefix:@"iPad4,5"] ||
		[platform hasPrefix:@"iPad4,6"])            return IPAD_MINI_2G_NAMESTRING;
	// iPad
    if ([platform hasPrefix:@"iPad2"])              return IPAD_2G_NAMESTRING;
    if ([platform hasPrefix:@"iPad3,4"] ||
		[platform hasPrefix:@"iPad3,5"] ||
		[platform hasPrefix:@"iPad3,6"])            return IPAD_4G_NAMESTRING;
    if ([platform hasPrefix:@"iPad3"])              return IPAD_3G_NAMESTRING;
	if ([platform hasPrefix:@"iPad4"])				return IPAD_5G_NAMESTRING;
    
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? SIMULATOR_IPHONE_NAMESTRING : SIMULATOR_IPAD_NAMESTRING;
    }
	
    return platform;
}


-(void)emailFeedback:(id)sender
{
    NSString *recipients = @"inquiries@mcgi.org.sg";
	
	NSString *subject =  @"MCGI Bible Feedback";
	
	if([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
		[mailComposeViewController setSubject:subject];
		[mailComposeViewController setToRecipients:[NSArray arrayWithObject:recipients]];
		mailComposeViewController.mailComposeDelegate = self;
        
        mailComposeViewController.navigationBar.barStyle = UIBarStyleDefault;
        
        mailComposeViewController.navigationBar.barTintColor = [UIColor whiteColor];
        mailComposeViewController.navigationBar.tintColor = [UIColor blackColor];
        
        [self.tabBarController presentModalViewController:mailComposeViewController animated:YES];
		[mailComposeViewController release];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self.tabBarController dismissModalViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if(navigationType == UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}
	return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[super viewDidUnload];
}

- (void)dealloc {
	self.aboutWebView = nil;
    [super dealloc];
}


@end
