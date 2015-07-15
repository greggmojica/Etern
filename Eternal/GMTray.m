//
//  GMTray.m
//  Eternal
//
//  Created by Gregg Mojica on 7/15/15.
//

#define GUTTER_WIDTH 100

#import "GMTray.h"

@interface GMTray ()

@property (nonatomic, strong) UIVisualEffectView *trayView;
@property (nonatomic, strong) NSLayoutConstraint *trayLeftEdgeConstraint;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, assign) BOOL gravityIsLeft;
@property (nonatomic, strong) UIAttachmentBehavior *panAttachmentBehavior;

@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *cellIdentifier;

@implementation GMTray

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"eternal"]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    
    [self setupTrayView];
    [self setupGestureRecognizers];
    
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    [self setupBehaviors];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

     self.tableView.backgroundColor = [UIColor clearColor];
     
     cellIdentifier = @"Cell";
    
}

-(void)setupStaticArray:(NSArray*)array {
     if (array == nil) {
          self.staticArray = @[@"Nothing Here!"];
     } else {
          self.staticArray = array;
     }
}

-(void)pan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint currentPoint = [recognizer locationInView:self.view];
    CGPoint xOnlyLocation = CGPointMake(currentPoint.x, self.view.center.y);
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.panAttachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:self.trayView attachedToAnchor:xOnlyLocation];
        [self.animator addBehavior:self.panAttachmentBehavior];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        self.panAttachmentBehavior.anchorPoint = xOnlyLocation;
    }
    else if ((recognizer.state == UIGestureRecognizerStateEnded) ||
             (recognizer.state == UIGestureRecognizerStateCancelled))
    {
        [self.animator removeBehavior:self.panAttachmentBehavior];
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat velocityThrowingThreshold = 500;
        
        if (ABS(velocity.x) > velocityThrowingThreshold)
        {
            BOOL isLeft = (velocity.x < 0);
            [self updateGravityIsLeft:isLeft];
        }
        else
        {
            BOOL isLeft = (self.trayView.frame.origin.x < self.view.center.x);
            [self updateGravityIsLeft:isLeft];
        }
    }
}

-(void)setupBehaviors
{
    UICollisionBehavior *edgeCollisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[self.trayView]];
    [edgeCollisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, GUTTER_WIDTH, 0, -self.view.bounds.size.width)];
    [self.animator addBehavior:edgeCollisionBehavior];
    
    // gravity
    self.gravity = [[UIGravityBehavior alloc]initWithItems:@[self.trayView]];
    [self.animator addBehavior:self.gravity];
    [self updateGravityIsLeft:self.gravityIsLeft];
}

-(void)updateGravityIsLeft:(BOOL)isLeft
{
    CGFloat angle = isLeft ? M_PI : 0;
    [self.gravity setAngle:angle magnitude:1.0];
}

-(void)setupGestureRecognizers
{
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    edgePan.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:edgePan];
    
    UIPanGestureRecognizer *trayPanRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.trayView addGestureRecognizer:trayPanRecognizer];
}

-(void)setupTrayView
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    self.trayView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    self.trayView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.trayView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.trayView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.trayView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.trayView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    self.trayLeftEdgeConstraint = [NSLayoutConstraint constraintWithItem:self.trayView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.view.frame.size.width];
    [self.view addConstraint:self.trayLeftEdgeConstraint];
  
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height - 30);
    
    [self.trayView addSubview:self.tableView];
    
    [self.view layoutIfNeeded];
}

-(void)closeButtonPressed:(id)sender
{
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]initWithItems:@[self.trayView] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.angle = 0;
    pushBehavior.magnitude = 200;
    
    [self updateGravityIsLeft:NO];
    
    [self.animator addBehavior:pushBehavior];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.animator removeAllBehaviors];
    if (self.trayView.frame.origin.x < self.view.center.x)
    {
        self.trayLeftEdgeConstraint.constant = GUTTER_WIDTH;
        self.gravityIsLeft = YES;
    }
    else
    {
        self.trayLeftEdgeConstraint.constant = size.width;
        self.gravityIsLeft = NO;
    }
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.view layoutIfNeeded];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self setupBehaviors];
    }];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma UItableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.staticArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
     if (cell == nil) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
     }
          cell.textLabel.text = [self.staticArray objectAtIndex:indexPath.row];
          cell.backgroundColor = [UIColor clearColor];
     
   
    return cell;
    
}

@end
