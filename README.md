# Eternal
A Simple Class for making Static UITableViews within a Sidebar

Eternal helps you be more efficent.

## Why Eternal?
Making static viewcontrollers is way too tedious - you have to include all the necessary delegate methods in order to set it up.  
## Installation
Eternal uses UIKitDynamics and makes use of a custom class, GMTray.

`#import "GMTray.h"` will do the trick.

## Usage
GMPush is incredible easy to use.  Take the most basic example of sending a push Notification:

  GMTray *tray = [[GMTray alloc]init];
    tray.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [tray setupStaticArray:@[@"Home",@"About",@"Information",@"Detail",@"Apps", @"Settings"]];
    
    [self addChildViewController:tray];
    [self.view addSubview:tray.view];
  
## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b newFeature`
3. Commit your changes: `git commit -am 'Detail your commit'`
4. Push to the branch: `git push origin newFeature`
5. Submit a pull request
6. You're done!
