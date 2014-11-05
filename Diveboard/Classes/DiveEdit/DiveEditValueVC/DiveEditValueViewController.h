//
//  DiveEditValueViewController.h
//  Diveboard
//
//  Created by VladimirKonstantinov on 9/17/14.
//  Copyright (c) 2014 threek. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    DiveEditValueTypeString = 1,
    DiveEditValueTypeNumber
};

typedef NSUInteger DiveEditValueType;

@protocol DiveEditValueViewControllerDelegate<NSObject>

@optional
-(void) didChangeValueForDiveEdit:(NSString*)value :(NSString*)selectedUnit;
-(void) didCancelValueForDiveEdit;


@end

@protocol DiveEditValueViewControllerDataSource <NSObject>

@required

- (NSString*) valueForDiveEdit;
- (NSString*) titleForDiveEdit;

@optional
- (NSArray*) arrUnitsForDiveEdit;
- (DiveEditValueType) valueTypeForDiveEdit;
- (NSString*) strSelUnitForDiveEdit;

@end

@interface DiveEditValueViewController : UIViewController
{
    IBOutlet UILabel* m_lblTitle;
    IBOutlet UITextField* m_txtValue;
    IBOutlet UIButton* m_btnUnit;
    IBOutlet UIImageView* m_imgTriangle;
    
}

-(IBAction)onCancel;
-(IBAction)onOk;
-(IBAction)onChangeUnit;
@property (nonatomic, assign) id<DiveEditValueViewControllerDelegate> delegate;
@property (nonatomic, assign) id<DiveEditValueViewControllerDataSource> dataSource;

@end
