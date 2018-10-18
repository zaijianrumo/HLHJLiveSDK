//
//  HLHJNewLiveController.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewLiveController.h"

/** Controllers **/
#import "HLHJNewLiveListController.h"
#import "HLHJNewTVController.h"
#import "HLHJNewRadioController.h"

/** Model **/

/** Views**/

/** #define **/

@interface HLHJNewLiveController ()

///标题数组
@property (nonatomic, copy) NSArray  *titleArray;

@end

@implementation HLHJNewLiveController


#pragma mark - LifeCycle

- (instancetype)init {
    
    if (self = [super init]) {
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 18;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleColorSelected = [UIColor whiteColor];
        self.titleColorNormal = [[UIColor whiteColor]colorWithAlphaComponent:.8];
        self.automaticallyCalculatesItemWidths = YES;
//        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.showOnNavigationBar = YES;
    
    }
    return self;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - Delegate/DataSource Methods
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleArray.count;
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    
    switch (index) {
        case 0:
        {
            HLHJNewLiveListController *vc = [[HLHJNewLiveListController alloc] init];
            vc.native = YES;
            return vc;
            
        }break;
        case 1:
        {
            
            HLHJNewTVController *vc = [[HLHJNewTVController alloc] init];
            vc.native = YES;
            return vc;
            
        }break;
        case 2:
        {
            
            HLHJNewRadioController *vc = [[HLHJNewRadioController alloc] init];
            vc.native = YES;
            return vc;
            
        }break;
            
        default:{
            HLHJNewLiveListController *vc = [[HLHJNewLiveListController alloc] init];
            vc.native = YES;
            return vc;
        } break;
    }

}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titleArray[index];
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height);
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0,150, 40);
}

#pragma mark - Notification Methods

#pragma mark - KVO Methods

#pragma mark - Public Methods

#pragma mark - Private Methods

#pragma mark - Action Methods

#pragma mark - Getter Methods

#pragma mark - Setter Methods


- (NSArray *)titleArray {
    if (!_titleArray) {
//        if (ISHIDENRADIO) {
            _titleArray = @[@"直播",@"电视"];
//        }else {
//            _titleArray = @[@"直播",@"电视",@"广播"];
//        }
//         _titleArray = @[@"直播",@"电视",@"广播"];
    }
    return _titleArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
