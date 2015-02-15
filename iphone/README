# TiAdobeCreativeSDK
Titanium Module for photo editing using the Adobe Creative SDK (was the Aviary SDK).

Based on work by [@ludolphus](https://github.com/ludolphus/AviaryModule), [@alexshive](https://github.com/alexshive/AviaryModule), [@ghkim](https://github.com/ghkim/AviaryModule) and [@frederictedesco](https://github.com/frederictedesco/Adobe-Creative-Image-module-for-Titanium) (for the latest Adobe update)

I was getting some build errors (on the module at first, then the app) so decided to start from scratch and rename. 


- Added the Frameworks to the XCode project
- Extracted the CreativeSDK Foundation and Image framework .bundle files for Titanium app resources.  (Copy to platform/iphone/.. in your project root folder).

You will need to download the Adobe Creative SDK from https://creativesdk.adobe.com/downloads.html  (It's too big for github). Then copy the `AdobeCreativeSDKFoundation.framework` and `AdobeCreativeSDKImage.framework` files into the iphone folder to build the module. 

You can then open the frameworks and go into 'Resources' and copy out the `AdobeCreativeSDKFoundationResources.bundle` and `AdobeCreativeSDKImageResources.bundle` files which need to be placed in your APP_Project/platform/iphone folder for your app. 

- You will also need to edit the module.xconfig file to locate the Adobe Frameworks. 

- Install the module locally to the app (in modules/iphone/.. in your project root folder).


# Exmaple

~~~

var photo_editor = require("com.kosso.tiadobecreativesdk");

var image_blob = [ A TiBlob from the camera or album, for example ];

var edited_image;

// Editor tool options.
var tools = ['kAFEffects','kAFEnhance','kAFOrientation','kAFAdjust', 'kAFCrop','kAFSharpness','kAFText','kAFStickers','kAFDraw','kAFMeme','kAFFrames','kAFFocus'];

// Obtain an App Client ID from Adode https://creativesdk.adobe.com/myapps.html  - You will need an Adobe ID. 

var adobe_client_id = 'YOUR_ADOBE_CREATIVE_SDK_CLIENT_ID';
var adobe_client_secret = 'YOUR_ADOBE_CREATIVE_SDK_CLIENT_SECRET';

// Open the image in the Adobe CreativeSDK Image Editor
photo_editor.newImageEditor({apikey:adobe_client_id, secret: adobe_client_secret, image: image_blob, tools: tools});
 
// Fired when the editor is done 
photo_editor.addEventListener('avEditorFinished', function(e){

	Ti.API.info('avEditorFinished done: '+e.image);
	Ti.API.info('avEditorFinished size: '+e.image.length);

	if(e.image.length==0){
		Ti.API.info('photo editor ERROR!');
		return;
	}

	setTimeout(function(){
		edited_image = e.image;
		photo_editor = null;
	},150);		
});

~~~



