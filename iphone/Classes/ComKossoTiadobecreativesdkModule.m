/**
 * TiAdobeCreativeSDK
 *
 * Author: @Kosso 
 * With huge hat tips to github.com/ludolphus/AviaryModule and github.com/frederictedesco/Adobe-Creative-Image-module-for-Titanium  
 * Copyright (c) 2015
 */

#import "ComKossoTiadobecreativesdkModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"
#import <AdobeCreativeSDKFoundation/AdobeCreativeSDKFoundation.h>

@implementation ComKossoTiadobecreativesdkModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"9d04fcbb-30af-42d3-b500-011a457cff42";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.kosso.tiadobecreativesdk";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

-(NSDictionary *)convertResultDic:(UIImage *)result
{
    TiBlob *blob = [[[TiBlob alloc]initWithImage:result]autorelease];
    NSDictionary *obj = [NSDictionary dictionaryWithObjectsAndKeys:blob,@"image",nil];
    return obj;
}

-(UIImage *)convertToUIImage:(id)param
{
    UIImage *source = nil;
    if ([param isKindOfClass:[TiBlob class]]){
        source = [param image];
    }else if ([param isKindOfClass:[UIImage class]]){
        source = param;
    }
    return source;
}

-(void)newEditorController:(UIImage *)source
{
    
    editorController = [[AFPhotoEditorController alloc] initWithImage:source];
    [editorController setDelegate:self];
    
    [[TiApp app] showModalController: editorController animated: NO];
}

-(NSMutableArray *)convertToRealToolsKey:(NSArray *)toolsKey
{
    NSMutableArray *tools = [[[NSMutableArray alloc]initWithCapacity:[toolsKey count]]autorelease];
    for (NSString *key in toolsKey){
        NSString *lowcase = [key lowercaseString];
        NSString *realKey = [lowcase substringFromIndex:3];
        if ([realKey isEqualToString: @"adjustments"]) {
            realKey = @"adjust";
        }
        [tools addObject:realKey];
    }
    return tools;
}

-(void)newEditorController:(UIImage *)source withTools:(NSArray *)toolKey animated:(BOOL)animated purge:(BOOL)purge
{
    
    NSArray *tools = [self convertToRealToolsKey:toolKey];
    editorController = [[AFPhotoEditorController alloc]
                        initWithImage:source
                        ];
    [AdobeImageEditorCustomization setToolOrder:tools];
    if (purge) {
        [AdobeImageEditorCustomization purgeGPUMemoryWhenPossible:YES];
    }
    
    [editorController setDelegate:self];

    [[TiApp app] showModalController: editorController animated: animated];
}

#pragma Public APIs

-(void)newImageEditor:(id)params
{
    ENSURE_UI_THREAD_1_ARG(params);
    ENSURE_SINGLE_ARG(params, NSDictionary);
        
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[AdobeUXAuthManager sharedManager] setAuthenticationParametersWithClientID:[params objectForKey:@"apikey"] withClientSecret:[params objectForKey:@"secret"]];
        
    });    
    // Set Supported Orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray * supportedOrientations = @[@(UIInterfaceOrientationPortrait), @(UIInterfaceOrientationPortraitUpsideDown), @(UIInterfaceOrientationLandscapeLeft), @(UIInterfaceOrientationLandscapeRight)];
        [AFPhotoEditorCustomization setSupportedIpadOrientations:supportedOrientations];
    }
    
    UIImage *source = [self convertToUIImage:[params objectForKey:@"image"]];
    NSArray *tools = [NSArray arrayWithArray:(NSArray *)[params objectForKey:@"tools"]];
    BOOL animated = [TiUtils boolValue:@"animated" properties:params def:NO];
    BOOL purge = [TiUtils boolValue:@"purge" properties:params def:NO];
    [self newEditorController:source withTools:tools animated:animated purge:purge];
}

#define view_parentViewController(_view_) (([_view_ parentViewController] != nil || ![_view_ respondsToSelector:@selector(presentingViewController)]) ? [_view_ parentViewController] : [_view_ presentingViewController])

-(void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    [self fireEvent:@"avEditorFinished" withObject:[self convertResultDic:image]];
    
    if([view_parentViewController(editor) respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        [editor.presentingViewController dismissViewControllerAnimated:(NO) completion:nil];
    else if([view_parentViewController(editor) respondsToSelector:@selector(dismissModalViewControllerAnimated:)])
        [view_parentViewController(editor) dismissViewControllerAnimated:NO completion:nil];
    else
        NSLog(@"photoEditor avEditorFinished Error");
    
    [editor release];
}

-(void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    
    [self fireEvent:@"avEditorCancel" withObject:nil];
    
    if([view_parentViewController(editor) respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        [editor.presentingViewController dismissViewControllerAnimated:(NO) completion:nil];
    else if([view_parentViewController(editor) respondsToSelector:@selector(dismissModalViewControllerAnimated:)])
        [view_parentViewController(editor) dismissViewControllerAnimated:NO completion:nil];
    else
        NSLog(@"photoEditorCanceled avEditorCancel Error");
    
    [editor release];
}


@end
