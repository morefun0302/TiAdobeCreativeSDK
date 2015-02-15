/**
 * TiAdobeCreativeSDK
 *
 * Created by Kosso
 * Copyright (c) 2015 . All rights reserved.
 */

#import "TiModule.h"
#import <AdobeCreativeSDKImage/AdobeCreativeSDKImage.h>

@interface ComKossoTiadobecreativesdkModule : TiModule <AdobeUXImageEditorViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    AdobeUXImageEditorViewController *editorController;
}

@end
