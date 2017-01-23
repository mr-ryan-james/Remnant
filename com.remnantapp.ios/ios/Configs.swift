/*--------------------------
- PikLab -

created by FV iMAGINATION ©2015
for CodeCanyon.net

All rights reserved
----------------------------*/


import Foundation
import UIKit



// Edit the name below with the one you'll give to your version of this app
let APP_NAME = "PikLab"


// Edit the email address below with the one you'll use to receive feedbacks from users
let FEEDBACK_EMAIL_ADDRESS = "feedback@example.com"


// Replace the red string below with your App ID (you can grab it by clicking on More -> About This App in your iTunes Connect page). This is needed for the Rate-App feature
let APP_ID = "957290825"

// Replace the red link with your iTunes Store Account one (you can get it with iTunes app on your Mac)
let MY_ARTIST_APPSTORE_LINK = "https://itunes.apple.com/us/artist/francesco-franchini/id531495620"

// Replace the red string below with your own Instagram username (for the Inspirations button on the MainScreen)
let INSTAGRAM_USERNAME = "photolabapp"


// You can edit the sharing message and subject here:
let subjectText = "My Picture"
let messageText = "Hi there, check this pic out, I've made it with \(APP_NAME)"


// Replace the red string below with the Interstitial Unit ID you will create on http://apps.admob.com
let ADMOB_UNIT_ID = "ca-app-pub-9733347540588953/7805958028"


// If you'll add or remove some collage image from COLLAGE folder (into  Images.xcassets), you will also have to update the quantity of png's included in COLLAGE folder below:
let totalCollagesQty = 16



// ARRAY OF COLORS ( You can edit, add or remove custom Colors here)
let colorList = [
    UIColor.whiteColor(),
    UIColor.blackColor(),
    UIColor(red: 204.0/255.0, green: 208.0/255.0, blue: 217.0/255.0, alpha: 1.0),
    UIColor(red: 101.0/255.0, green: 109.0/255.0, blue: 120.0/255.0, alpha: 1.0),
    UIColor(red: 236.0/255.0, green: 136/255.0, blue: 192.0/255.0, alpha: 1.0),
    UIColor(red: 172.0/255.0, green: 146.0/255.0, blue: 237.0/255.0, alpha: 1.0),
    UIColor(red: 93.0/255.0, green: 155.0/255.0, blue: 236.0/255.0, alpha: 1.0),
    UIColor(red: 79.0/255.0, green: 192.0/255.0, blue: 232.0/255.0, alpha: 1.0),
    UIColor(red: 72.0/255.0, green: 207.0/255.0, blue: 174.0/255.0, alpha: 1.0),
    UIColor(red: 160.0/255.0, green: 212.0/255.0, blue: 104.0/255.0, alpha: 1.0),
    UIColor(red: 253.0/255.0, green: 207.0/255.0, blue: 85.0/255.0, alpha: 1.0),
    UIColor(red: 251.0/255.0, green: 110.0/255.0, blue: 82.0/255.0, alpha: 1.0),
    UIColor(red: 237.0/255.0, green: 85.0/255.0, blue: 100.0/255.0, alpha: 1.0),
    
    // You can add custom UIColors here...
]




// ARRAY OF FONTS (for the Text Editor)
var fontList = [
    "AvenirNext-DemiBold",
    "CFJacquesParizeau-Regular",
    "HussarGothic",
    "springtime_blues",
    "BebasNeue",
    "Noteworthy-Bold",
    "LemonMilk",
    "Comfortaa",
    "Lobster1.4",
    
    // You can add your own custom fonts here.....
    
]






// ------- GLOBAL VARIABLES (DO NOT EDIT THEM) ----------
//var pickedImage: UIImage?
var croppedImage: UIImage?
//var editedImage: UIImage?
//var mainScreen = UIScreen.mainScreen()



