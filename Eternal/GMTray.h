//
//  GMTray.h
//  DynamicTrayDemo
//
//  Created by Gregg Mojica on 7/15/15.
//

#import <UIKit/UIKit.h>

@interface GMTray : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *staticArray;

enum trayFormat {light, dark, extraLight};

-(void)setupStaticArray:(NSArray*)array;


@end
