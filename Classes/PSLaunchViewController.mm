    //
//  PSLaunchViewController.m
//  PocketSword
//
//  Created by Nic Carter on 27/01/11.
//  Copyright 2011 CrossWire Bible Society. All rights reserved.
//

#import "PSLaunchViewController.h"
#import "globals.h"
#import "PSModuleController.h"
#import "ZipArchive.h"
#import "PSResizing.h"
#import "SwordManager.h"
#import "SwordDictionary.h"

#define LOCALES_VERSION					@"loadedSWORDLocales-130708"
#define STRONGS_REAL_GREEK_VERSION		@"loadedBundledStrongsRealGreek-v1.4-121223"
#define KJV_VERSION						@"loadedKJV-v2.6.1"

@implementation PSLaunchViewController

@synthesize delegate;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIImage *defaultImg;
	CGRect aiFrame;
	int displayMultiplier = 1;
	if ([UIScreen mainScreen].scale > 1.1) {
		// Retina display
		displayMultiplier = 2;
		if([UIScreen mainScreen].scale > 2.1) {
			displayMultiplier = 3;
		}
	} else {
		// non-Retina display
	}
	
	if([PSResizing iPad]) {
		
		UIInterfaceOrientation uiOrientation = [[UIApplication sharedApplication] statusBarOrientation];
		if(uiOrientation == UIInterfaceOrientationLandscapeLeft || uiOrientation == UIInterfaceOrientationLandscapeRight) {
			defaultImg = [UIImage imageNamed:@"Default-Landscape~ipad.png"];
			aiFrame = CGRectMake(494, 370, 37, 37);
		} else {
			defaultImg = [UIImage imageNamed:@"Default-Portrait~ipad.png"];
			aiFrame = CGRectMake(366, 499, 37, 37);
		}
				
	} else {
		
		CGRect screenRect = [[UIScreen mainScreen] bounds];
		if(screenRect.size.height > 700) {
			// 5.5 inch display.
			defaultImg = [UIImage imageNamed:@"Default-736h.png"];
		} else if(screenRect.size.height > 600) {
			// 4.7 inch display.
			defaultImg = [UIImage imageNamed:@"Default-667h.png"];
		} else if(screenRect.size.height > 500) {
			// 4 inch display.
			defaultImg = [UIImage imageNamed:@"Default-568h.png"];
		} else {
			// 3.5 inch display.
			defaultImg = [UIImage imageNamed:@"Default.png"];
		}
		int x=0, y=0, w=[defaultImg size].width, h=[defaultImg size].height;
		CGImageRef imageRef = CGImageCreateWithImageInRect([defaultImg CGImage], CGRectMake(x, y*displayMultiplier, w*displayMultiplier, h*displayMultiplier));
		defaultImg = [UIImage imageWithCGImage:imageRef];
		CGImageRelease(imageRef);
		x = (int)(screenRect.size.width / 2.0f - (37.0f / 2.0f));
		y = (int)(screenRect.size.height / 2.0f - (37.0f / 2.0f));
		aiFrame = CGRectMake(x, y, 37, 37);
		
	}
	
	UIImageView *launchImgView = [[UIImageView alloc] initWithImage:defaultImg];
	UIActivityIndicatorView *activityInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityInd.hidesWhenStopped = NO;
	[launchImgView addSubview:activityInd];
	activityInd.frame = aiFrame;
	[activityInd startAnimating];
	[activityInd release];
	self.view = launchImgView;
	[launchImgView release];
}

+ (void)resetPreferences {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	PSModuleController *moduleManager = [PSModuleController defaultModuleController];
	DLog(@"\nResetting PocketSword");
	[defaults removeObjectForKey: @"reset_PocketSword"];
	[defaults removeObjectForKey: DefaultsLastRef];
	[defaults removeObjectForKey: DefaultsLastBible];
	[defaults removeObjectForKey: DefaultsLastCommentary];
	[defaults removeObjectForKey: DefaultsLastDictionary];
	[defaults removeObjectForKey: DefaultsFontNamePreference];
	[defaults removeObjectForKey: DefaultsNightModePreference];
	[defaults removeObjectForKey: DefaultsFontSizePreference];
	[defaults removeObjectForKey: DefaultsVPLPreference];
	[defaults removeObjectForKey: DefaultsRedLetterPreference];
	[defaults removeObjectForKey: DefaultsInsomniaPreference];
	[defaults removeObjectForKey: DefaultsModuleMaintainerModePreference];
	[defaults removeObjectForKey: @"bibleHistory"];
	[defaults removeObjectForKey: @"commentaryHistory"];
	[defaults removeObjectForKey: DefaultsModuleCipherKeysKey];
	[defaults removeObjectForKey: LOCALES_VERSION];
	[defaults removeObjectForKey: DefaultsKJVRemoved];
    
    [defaults removeObjectForKey: @"DefaultsangdatingbibliaRemoved"];
    [defaults removeObjectForKey: @"DefaultsSpaSEVRemoved"];
    [defaults removeObjectForKey: @"DefaultsPorARRemoved"];
 
   
    [defaults removeObjectForKey: @"DefaultsPorCapRemoved"];
   
    [defaults removeObjectForKey: @"DefaultsSpaRVRemoved"];
   
    [defaults removeObjectForKey: @"DefaultsSpaRVGRemoved"];
   
 
    
    [defaults removeObjectForKey: @"DefaultsSpaRV1909Removed"];
    [defaults removeObjectForKey: @"DefaultsAKJVRemoved"];
    [defaults removeObjectForKey: @"DefaultsGeneva1599Removed"];
    [defaults removeObjectForKey: @"DefaultsESVRemoved"];
    [defaults removeObjectForKey: @"DefaultsASVRemoved"];
    [defaults removeObjectForKey: @"DefaultsChiNCVsRemoved"];
    [defaults removeObjectForKey: @"DefaultsChiNCVtRemoved"];
    
    
	[defaults removeObjectForKey: DefaultsMHCCRemoved];
	[defaults removeObjectForKey: DefaultsStrongsRealGreekRemoved];
	[defaults removeObjectForKey: DefaultsStrongsRealHebrewRemoved];
	[defaults removeObjectForKey: DefaultsRobinsonRemoved];
	[defaults synchronize];
    
    NSArray *dicts = [[[PSModuleController defaultModuleController] swordManager] modulesForType: SWMOD_CATEGORY_DICTIONARIES];
	for(SwordDictionary *dict in dicts) {
		[dict removeCache];
	}
	
    NSArray *moduleList = [[[PSModuleController defaultModuleController] swordManager] listModules];
	for(SwordModule *mod in moduleList) {
		[mod resetPreferences];
	}
    [moduleManager setPrimaryBible: nil];
	[moduleManager setPrimaryCommentary: nil];
	[moduleManager setPrimaryDictionary: nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:NotificationRedisplayPrimaryBible object:nil];
}

- (void)startInitializingPocketSword {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	DLog(@"start the Launch configuring...");
	PSModuleController *moduleManager = [PSModuleController defaultModuleController];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// testing unlocking mechanism:
	//[defaults removeObjectForKey:DefaultsModuleCipherKeysKey];
	//[defaults synchronize];
	
	if([defaults boolForKey:@"reset_PocketSword"]) {
		[PSLaunchViewController resetPreferences];
	}
	
	BOOL kjv = [defaults boolForKey:KJV_VERSION];
	BOOL loadedLocales = [defaults boolForKey:LOCALES_VERSION];
	BOOL strongsAndMorph = [defaults boolForKey:@"loadedBundledStrongsAndMorph"];
	BOOL strongsRealGreek = [defaults boolForKey:STRONGS_REAL_GREEK_VERSION];
	BOOL removeModulePrefs = [defaults boolForKey:@"removedModulePreferences"];
    
    
    
    //additional bibles
    BOOL angdatingbiblia =[defaults boolForKey:@"angdatingbiblia"];
    
    BOOL SpaSEV =[defaults boolForKey:@"SpaSEV"];
    BOOL PorAR =[defaults boolForKey:@"PorAR"];
   // BOOL PorCapNT=[defaults boolForKey:@"PorCapNT"];
    BOOL PorCap=[defaults boolForKey:@"PorCap"];
   
    BOOL SpaRV=[defaults boolForKey:@"SpaRV"];
 
    BOOL SpaRVG=[defaults boolForKey:@"SpaVG"];
 
    
    BOOL SpaRV1909=[defaults boolForKey:@"SpaRV1909"];
    BOOL AKJV=[defaults boolForKey:@"AKJV"];
    BOOL Geneva1599=[defaults boolForKey:@"Geneva1599"];
    BOOL ESV=[defaults boolForKey:@"ESV"];
    BOOL ASV=[defaults boolForKey:@"ASV"];
    BOOL ChiNCVs=[defaults boolForKey:@"ChiNCVs"];
    BOOL ChiNCVt=[defaults boolForKey:@"ChiNCVt"];
 
    
    
    
	
	if ([[NSFileManager defaultManager] fileExistsAtPath: DEFAULT_BUILTIN_MODULE_PATH]) {
		//getting rid of the built-in module path, as it seems to cause broken
		NSString *kjvConf = [DEFAULT_BUILTIN_MODULE_PATH stringByAppendingPathComponent:@"mods.d/kjv.conf"];
		if([[NSFileManager defaultManager] fileExistsAtPath:kjvConf]) {
			NSString *kjvExtension = @"modules/texts/ztext/kjv";
			NSString *luceneExtension = [kjvExtension stringByAppendingPathComponent:@"lucene"];
			NSString *kjvLucene = [DEFAULT_BUILTIN_MODULE_PATH stringByAppendingPathComponent:luceneExtension];
			if([[NSFileManager defaultManager] fileExistsAtPath:kjvLucene]) {
				// to be nice, let's move their kjv lucene index across for them :P
				NSString *kjvNewLucene = [DEFAULT_MODULE_PATH stringByAppendingPathComponent:luceneExtension];
				[[NSFileManager defaultManager] createDirectoryAtPath: [DEFAULT_MODULE_PATH stringByAppendingPathComponent:kjvExtension] withIntermediateDirectories: YES attributes: NULL error: NULL];
				[[NSFileManager defaultManager] moveItemAtPath:kjvLucene toPath:kjvNewLucene error:NULL];
			}
		}
		
		// delete this old folder
		[[NSFileManager defaultManager] removeItemAtPath: DEFAULT_BUILTIN_MODULE_PATH error:nil];
		[moduleManager reload];
		kjv = NO;
		strongsAndMorph = NO;
		strongsRealGreek = NO;
	}
    
    //spanhish
    if(!SpaSEV)
    {
        [defaults synchronize];
        SwordModule *Module = [[moduleManager swordManager] moduleWithName:@"SpaSEV"];
        if(Module) {
            // if it's already installed, remove the search index because it will now be out of date
            [
             Module deleteSearchIndex];
        }
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"SpaSEV" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
        
        [defaults setBool: YES forKey:@"SpaSEV"];
        
    }
    
    //Tagalog
    if(!angdatingbiblia)
    {
        [defaults synchronize];
        SwordModule *angdatingbibliaModule = [[moduleManager swordManager] moduleWithName:@"angdatingbiblia"];
        if(angdatingbibliaModule) {
            // if it's already installed, remove the search index because it will now be out of date
            [angdatingbibliaModule deleteSearchIndex];
        }
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"angdatingbiblia" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
        
        [defaults setBool: YES forKey:@"angdatingbiblia"];
        
    }
   
    
 
    
    if(!PorAR)
    {
        [defaults synchronize];
        SwordModule *Module = [[moduleManager swordManager] moduleWithName:@"PorAR"];
        if(Module) {
            // if it's already installed, remove the search index because it will now be out of date
            [Module deleteSearchIndex];
        }
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"PorAR" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
        
        [defaults setBool: YES forKey:@"PorAR"];
        
    }
    
    if(!PorCap)
    {
        [defaults synchronize];
        SwordModule *Module = [[moduleManager swordManager] moduleWithName:@"PorCap"];
        if(Module) {
            // if it's already installed, remove the search index because it will now be out of date
            [Module deleteSearchIndex];
        }
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"PorCap" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
        
        [defaults setBool: YES forKey:@"PorCap"];
        
    }
    
 
    
    if(!SpaRV)
    {
        [defaults synchronize];
        SwordModule *Module = [[moduleManager swordManager] moduleWithName:@"SpaRV"];
        if(Module) {
            // if it's already installed, remove the search index because it will now be out of date
            [Module deleteSearchIndex];
        }
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"SpaRV" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
        
        [defaults setBool: YES forKey:@"SpaRV"];
        
    }
    
 
    
    if(!SpaRVG)
    {
        [defaults synchronize];
        SwordModule *Module = [[moduleManager swordManager] moduleWithName:@"SpaRVG"];
        if(Module) {
            // if it's already installed, remove the search index because it will now be out of date
            [Module deleteSearchIndex];
        }
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"SpaRVG" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
        
        [defaults setBool: YES forKey:@"SpaRVG"];
        
    }
    

    
    
    if(!SpaRV1909)
    {
        [defaults synchronize];
        SwordModule *Module = [[moduleManager swordManager] moduleWithName:@"SpaRV1909"];
        if(Module) {
            // if it's already installed, remove the search index because it will now be out of date
            [Module deleteSearchIndex];
        }
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"SpaRV1909" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
        
        [defaults setBool: YES forKey:@"SpaRV1909"];
        
    }
    
    if(!AKJV)
    {
        [defaults synchronize];
        SwordModule *Module = [[moduleManager swordManager] moduleWithName:@"AKJV"];
        if(Module) {
            // if it's already installed, remove the search index because it will now be out of date
            [Module deleteSearchIndex];
        }
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"AKJV" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
        
        [defaults setBool: YES forKey:@"AKJV"];
        
    }
    if(!Geneva1599)
    {
        [defaults synchronize];
        SwordModule *Module = [[moduleManager swordManager] moduleWithName:@"Geneva1599"];
        if(Module) {
            // if it's already installed, remove the search index because it will now be out of date
            [Module deleteSearchIndex];
        }
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"Geneva1599" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
        
        [defaults setBool: YES forKey:@"Geneva1599"];
        
    }
    
    if(!ESV)
    {
        [defaults synchronize];
        SwordModule *Module = [[moduleManager swordManager] moduleWithName:@"ESV"];
        if(Module) {
            // if it's already installed, remove the search index because it will now be out of date
            [Module deleteSearchIndex];
        }
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"ESV" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
        
        [defaults setBool: YES forKey:@"ESV"];
        
    }
    
    if(!ASV)
    {
        [defaults synchronize];
        SwordModule *Module = [[moduleManager swordManager] moduleWithName:@"ASV"];
        if(Module) {
            // if it's already installed, remove the search index because it will now be out of date
            [Module deleteSearchIndex];
        }
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"ASV" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
        
        [defaults setBool: YES forKey:@"ASV"];
        
    }
    
    if(!ChiNCVt)
    {
        [defaults synchronize];
        SwordModule *Module = [[moduleManager swordManager] moduleWithName:@"ChiNCVt"];
        if(Module) {
            // if it's already installed, remove the search index because it will now be out of date
            [Module deleteSearchIndex];
        }
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"ChiNCVt" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
        
        [defaults setBool: YES forKey:@"ChiNCVt"];
        
    }
    
    if(!ChiNCVs)
    {
        [defaults synchronize];
        SwordModule *Module = [[moduleManager swordManager] moduleWithName:@"ChiNCVs"];
        if(Module) {
            // if it's already installed, remove the search index because it will now be out of date
            [Module deleteSearchIndex];
        }
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"ChiNCVs" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
        
        [defaults setBool: YES forKey:@"ChiNCVs"];
        
    }
	
	if(!kjv) {
		[defaults synchronize];
		SwordModule *kjvModule = [[moduleManager swordManager] moduleWithName:@"KJV"];
		if(kjvModule) {
			// if it's already installed, remove the search index because it will now be out of date
			[kjvModule deleteSearchIndex];
		}
		[moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"KJV" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
		[moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"MHCC" ofType:@"zip"] ofType: commentary removeZip:NO internalModule:YES];
		[defaults setBool: YES forKey:KJV_VERSION];
	}
	
	if(!strongsAndMorph) {
		[moduleManager installModulesFromZip:[[NSBundle mainBundle] pathForResource:@"strongsrealhebrew" ofType:@"zip"] ofType:dictionary removeZip:NO internalModule:YES];
		[moduleManager installModulesFromZip:[[NSBundle mainBundle] pathForResource:@"Robinson" ofType:@"zip"] ofType:dictionary removeZip:NO internalModule:YES];
		[defaults setObject:@"Robinson" forKey:DefaultsMorphGreekModule];
		[defaults setObject:@"StrongsRealHebrew" forKey:DefaultsStrongsHebrewModule];
		[defaults setBool: YES forKey:@"loadedBundledStrongsAndMorph"];
		[defaults synchronize];
	}
	
	if(!strongsRealGreek) {
		//remove existing module, if it exists:
		if([[moduleManager swordManager] isModuleInstalled:@"StrongsRealGreek"]) {
			DLog(@"\nRemoving existing StrongsRealGreek module & updating...");
			[moduleManager removeModule:@"StrongsRealGreek"];
		} else {
			DLog(@"\nInstalling StrongsRealGreek for the first time...");
		}
		[moduleManager installModulesFromZip:[[NSBundle mainBundle] pathForResource:@"strongsrealgreek" ofType:@"zip"] ofType:dictionary removeZip:NO internalModule:YES];
		[defaults setBool: YES forKey:STRONGS_REAL_GREEK_VERSION];
		NSString *curSGM = [[NSUserDefaults standardUserDefaults] stringForKey:DefaultsStrongsGreekModule];
		if(!curSGM || [curSGM isEqualToString: NSLocalizedString(@"None", @"None")]) {
			[[NSUserDefaults standardUserDefaults] setObject: @"StrongsRealGreek" forKey:DefaultsStrongsGreekModule];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
	
    
    //********ADD ADDITIONAL BIBLES HERE...*****
	// Test if we need to reinstall the built-in modules?
	BOOL angdatingbibliaModule = [[moduleManager swordManager] isModuleInstalled:@"angdatingbiblia"];
	BOOL angdatingbibliaModuleRemoved = [defaults boolForKey:@"DefaultsangdatingbibliaRemoved"];

    
    BOOL PorARModule = [[moduleManager swordManager] isModuleInstalled:@"PorAR"];
    BOOL PorARModuleRemoved = [defaults boolForKey:@"DefaultsPorARRemoved"];
    
    BOOL SpaSEVModule = [[moduleManager swordManager] isModuleInstalled:@"SpaSEV"];
    BOOL SpaSEVModuleRemoved = [defaults boolForKey:@"DefaultsSpaSEVRemoved"];
    
    BOOL PorCapModule = [[moduleManager swordManager] isModuleInstalled:@"PorCap"];
    BOOL PorCapModuleRemoved = [defaults boolForKey:@"DefaultsPorCapRemoved"];
    
 
    
    BOOL SpaRVModule = [[moduleManager swordManager] isModuleInstalled:@"SpaRV"];
    BOOL SpaRVModuleRemoved = [defaults boolForKey:@"DefaultsSpaRVRemoved"];
    
 
    
    BOOL SpaRVGModule = [[moduleManager swordManager] isModuleInstalled:@"SpaRVG"];
    BOOL SpaRVGModuleRemoved = [defaults boolForKey:@"DefaultsSpaRVGRemoved"];
    

    
    
    BOOL SpaRV1909Module = [[moduleManager swordManager] isModuleInstalled:@"SpaRV1909"];
    BOOL SpaRV1909ModuleRemoved = [defaults boolForKey:@"DefaultsSpaRV1909Removed"];
    
    BOOL AKJVModule = [[moduleManager swordManager] isModuleInstalled:@"AKJV"];
    BOOL AKJVModuleRemoved = [defaults boolForKey:@"DefaultsAKJVRemoved"];
    
    BOOL Geneva1599Module = [[moduleManager swordManager] isModuleInstalled:@"Geneva1599"];
    BOOL Geneva1599ModuleRemoved = [defaults boolForKey:@"DefaultsGeneva1599Removed"];
    
    BOOL ESVModule = [[moduleManager swordManager] isModuleInstalled:@"ESV"];
    BOOL ESVModuleRemoved = [defaults boolForKey:@"DefaultsESVRemoved"];
    
    BOOL ASVModule = [[moduleManager swordManager] isModuleInstalled:@"ASV"];
    BOOL ASVModuleRemoved = [defaults boolForKey:@"DefaultsASVRemoved"];
    
    BOOL ChiNCVsModule = [[moduleManager swordManager] isModuleInstalled:@"ChiNCVs"];
    BOOL ChiNCVsModuleRemoved = [defaults boolForKey:@"DefaultsChiNCVsRemoved"];
    
    BOOL ChiNCVtModule = [[moduleManager swordManager] isModuleInstalled:@"ChiNCVt"];
    BOOL ChiNCVtModuleRemoved = [defaults boolForKey:@"DefaultsChiNCVtRemoved"];
    
    BOOL kjvModule = [[moduleManager swordManager] isModuleInstalled:@"KJV"];
    BOOL kjvModuleRemoved = [defaults boolForKey:DefaultsKJVRemoved];
	
	BOOL mhccModule = [[moduleManager swordManager] isModuleInstalled:@"MHCC"];
	BOOL mhccModuleRemoved = [defaults boolForKey:DefaultsMHCCRemoved];
	
	BOOL robinsonModule = [[moduleManager swordManager] isModuleInstalled:@"Robinson"];
	BOOL robinsonModuleRemoved = [defaults boolForKey:DefaultsRobinsonRemoved];
	
	BOOL strongsrealhebrewModule = [[moduleManager swordManager] isModuleInstalled:@"StrongsRealHebrew"];
	BOOL strongsrealhebrewModuleRemoved = [defaults boolForKey:DefaultsStrongsRealHebrewRemoved];
	
	BOOL strongsrealgreekModule = [[moduleManager swordManager] isModuleInstalled:@"StrongsRealGreek"];
	BOOL strongsrealgreekModuleRemoved = [defaults boolForKey:DefaultsStrongsRealGreekRemoved];
    
    
    if(!angdatingbibliaModule  && !angdatingbibliaModuleRemoved) {
        //reinstall the kjv module!
        DLog(@"reinstalling angdatingbibliaModuleRemoved");
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"angdatingbiblia" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
    }
    
    if(!PorARModule  && !PorARModuleRemoved) {
        //reinstall the kjv module!
        DLog(@"reinstalling PorAR");
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"PorAR" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
    }
    
    if(!SpaSEVModule  && !SpaSEVModuleRemoved) {
        //reinstall the kjv module!
        DLog(@"reinstalling spasev");
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"SpaSEV" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
    }
    
    if(!PorARModule  && !PorARModuleRemoved) {
        //reinstall the kjv module!
        DLog(@"reinstalling PorAR");
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"PorAR" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
    }
 
    if(!PorCapModule  && !PorCapModuleRemoved) {
        //reinstall the kjv module!
        DLog(@"reinstalling PorAR");
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"PorCap" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
    }
    
 
    
    if(!SpaRVModule  && !SpaRVModuleRemoved) {
        //reinstall the kjv module!
        DLog(@"reinstalling PorAR");
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"SpaRV" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
    }
    
 
    
    if(!SpaRVGModule  && !SpaRVGModuleRemoved) {
        //reinstall the kjv module!
        DLog(@"reinstalling PorAR");
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"SpaRVG" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
    }
    

    
    
    if(!SpaRV1909Module  && !SpaRV1909ModuleRemoved) {
        //reinstall the kjv module!
        DLog(@"reinstalling PorAR");
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"SpaRV1909" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
    }
    
    if(!AKJVModule  && !AKJVModuleRemoved) {
        //reinstall the kjv module!
        DLog(@"reinstalling PorAR");
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"AKJV" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
    }
    
    if(!Geneva1599Module  && !Geneva1599ModuleRemoved) {
        //reinstall the kjv module!
        DLog(@"reinstalling PorAR");
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"Geneva1599" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
    }
    if(!ESVModule  && !ESVModuleRemoved) {
        //reinstall the kjv module!
        DLog(@"reinstalling PorAR");
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"ESV" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
    }
    if(!ASVModule  && !ASVModuleRemoved) {
        //reinstall the kjv module!
        DLog(@"reinstalling PorAR");
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"ASV" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
    }
    
    if(!ChiNCVsModule  && !ChiNCVsModuleRemoved) {
        //reinstall the kjv module!
        DLog(@"reinstalling PorAR");
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"ChiNCVs" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
    }
    
    if(!ChiNCVtModule  && !ChiNCVtModuleRemoved) {
        //reinstall the kjv module!
        DLog(@"reinstalling PorAR");
        [moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"ChiNCVt" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
    }

	if(!kjvModule && !kjvModuleRemoved) {
		//reinstall the kjv module!
		DLog(@"reinstalling KJV");
		[moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"KJV" ofType:@"zip"] ofType: bible removeZip:NO internalModule:YES];
	}
	if(!mhccModule && !mhccModuleRemoved) {
		//reinstall the mhcc module!
		DLog(@"reinstalling MHCC");
		[moduleManager installModulesFromZip: [[NSBundle mainBundle] pathForResource:@"MHCC" ofType:@"zip"] ofType: commentary removeZip:NO internalModule:YES];
	}
	if(!robinsonModule && !robinsonModuleRemoved) {
		DLog(@"reinstalling Robinson");
		[moduleManager installModulesFromZip:[[NSBundle mainBundle] pathForResource:@"Robinson" ofType:@"zip"] ofType:dictionary removeZip:NO internalModule:YES];
	}
	if(!strongsrealgreekModule && !strongsrealgreekModuleRemoved) {
		DLog(@"reinstalling StrongsRealGreek");
		[moduleManager installModulesFromZip:[[NSBundle mainBundle] pathForResource:@"strongsrealgreek" ofType:@"zip"] ofType:dictionary removeZip:NO internalModule:YES];
	}
	if(!strongsrealhebrewModule && !strongsrealhebrewModuleRemoved) {
		DLog(@"reinstalling StrongsRealHebrew");
		[moduleManager installModulesFromZip:[[NSBundle mainBundle] pathForResource:@"strongsrealhebrew" ofType:@"zip"] ofType:dictionary removeZip:NO internalModule:YES];
	}
	
	
	if(!removeModulePrefs) {
		NSArray *moduleList = [[[PSModuleController defaultModuleController] swordManager] listModules];
		for(SwordModule *mod in moduleList) {
			[mod resetPreferences];
		}
		[defaults setBool: YES forKey:@"removedModulePreferences"];
		[defaults synchronize];
	}
	
	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
	NSString *swLocales = [[docPath stringByAppendingPathComponent:@"unused"] stringByAppendingPathComponent: @"locales.d"];
	//"install" the l10n strings into SWORD for the current locale.
    NSString *localePath = [docPath stringByAppendingPathComponent:@"locales.d"];
	
	// if there's an update for the locales or if iOS has removed our locales:
	if(!loadedLocales || ![[NSFileManager defaultManager] fileExistsAtPath: [docPath stringByAppendingPathComponent:@"unused"]]) {
		NSString *localesZIP = [[NSBundle mainBundle] pathForResource:@"locales.d" ofType:@"zip"];
		DLog(@"\n\n%@\n\n", localesZIP);
		[[NSFileManager defaultManager] removeItemAtPath: swLocales error:NULL];//delete it if it already exists
		[[NSFileManager defaultManager] removeItemAtPath: localePath error: NULL];//delete the currently installed ones, too.
		
		//unzip the archive
		ZipArchive *arch = [[ZipArchive alloc] init];
		[arch UnzipOpenFile:localesZIP];
		[arch UnzipFileTo:swLocales overWrite:YES];
		[arch UnzipCloseFile];
		[arch release];
		
		[defaults setBool: YES forKey:LOCALES_VERSION];
		[defaults synchronize];
		
		// make sure we're not backing up this folder, now that we're installing stuff in here...
		[PSResizing addSkipBackupAttributeToItemAtPath:[docPath stringByAppendingPathComponent:@"unused"]];
	}
	
	NSArray *availLocales = [NSLocale preferredLanguages];//the iPhone locale
	NSArray *currentlyInstalledStrings = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: localePath error: NULL];//currently installed SWORD locale
	NSString *lang = nil;//language we're going to use this time around
	NSString *loc = nil;//the SWORD loc we're going to use this time around
	BOOL haveLocale = NO;
	BOOL alreadyInstalled = NO;
	
	if([[availLocales objectAtIndex: 0] isEqualToString: @"en"]) {
		//do nothing if it's English.
		lang = @"en";
		alreadyInstalled = YES;
		haveLocale = YES;
	} else if(currentlyInstalledStrings && [currentlyInstalledStrings containsObject: [NSString stringWithFormat:@"%@-utf8.conf", [availLocales objectAtIndex: 0]]]) {
		//do nothing if it's the non-English locale we used last time.
		alreadyInstalled = YES;
		haveLocale = YES;
		lang = [availLocales objectAtIndex: 0];
	}
	
	NSArray *availStrings = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: swLocales error: NULL];
	NSEnumerator *iter = [availLocales objectEnumerator];
	while((loc = [iter nextObject]) && !haveLocale) {
		
		// replace "-" with "_" as SWORD and iOS use different ways of signifying locales...
		loc = [loc stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
		
		if([loc isEqualToString: @"en"]) {
			lang = loc;
			alreadyInstalled = YES;
			break;//default, do nothing.
		}
		
		if([currentlyInstalledStrings containsObject: [NSString stringWithFormat:@"%@-utf8.conf", loc]]) {
			//we do this because it could be the non-primary iPhone locale...
			alreadyInstalled = YES;
			lang = loc;
			break;
		}		
		// check if this locale is available in SWORD
		for(NSString *swLoc in availStrings) {
			//NSLog(@"loc: %@   swLoc: %@", loc, swLoc);
			if([swLoc hasPrefix: loc]) {
				haveLocale = YES;
				lang = swLoc;
				break;
			}
		}
		if(!haveLocale) {
			//perhaps we have something else we can fall back on?
			NSRange dashRange = [loc rangeOfString:@"_"];
			if(dashRange.location != NSNotFound) {
				loc = [loc substringToIndex:dashRange.location];
				// check if this modified locale is available in SWORD
				for(NSString *swLoc in availStrings) {
					//NSLog(@"loc: %@   swLoc: %@", loc, swLoc);
					if([swLoc hasPrefix: loc]) {
						haveLocale = YES;
						lang = swLoc;
						break;
					}
				}
			}
		}
	}
	if(!alreadyInstalled) {
		//NSLog(@"installing %@", lang);
		[[NSFileManager defaultManager] removeItemAtPath: localePath error: NULL];
		[[NSFileManager defaultManager] createDirectoryAtPath: localePath withIntermediateDirectories: NO attributes: nil error: NULL];
		if(haveLocale) {
			NSString *srcLocale = [swLocales stringByAppendingPathComponent: lang];
			NSString *dstLocale = [localePath stringByAppendingPathComponent: lang];
			[[NSFileManager defaultManager] copyItemAtPath: srcLocale toPath: dstLocale error: NULL];
			[SwordManager initLocale];
			[moduleManager reload];
		}
	} else {
		//NSLog(@"already installed %@", lang);
	}
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey: DefaultsInsomniaPreference]) {
		[UIApplication sharedApplication].idleTimerDisabled = YES;
	}

	[[NSFileManager defaultManager] removeItemAtPath: DEFAULT_MMM_PATH error:NULL];//delete our normal tmp folder...

	[(NSObject*)delegate performSelectorOnMainThread:@selector(finishedInitializingPocketSword:) withObject:self waitUntilDone:NO];
	
	[pool release];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
	//return [PSResizing shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations {
	if(![PSResizing iPad]) {
		return UIInterfaceOrientationMaskPortrait;
	}
	return [PSResizing supportedInterfaceOrientations];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	DLog(@"\nwe are about to rotate the launch view controller...");
	//[self loadView];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
