//
//  EditTask.h
//  ScrumRemote
//
//  Created by Glauco Primo on 10/04/14.
//
//

#import <UIKit/UIKit.h>
#import "WebServiceRequest.h"

@interface EditTask : UIViewController<UIPickerViewDelegate>
{
    NSMutableArray *dataArray;
}


@property (nonatomic) int task_id;
@property (nonatomic, strong) NSString *task_title;
@property (nonatomic, strong) NSString *descricao;
@property (nonatomic, strong) NSString *tipo;

@property (nonatomic, strong) UITextField *txt_task_title;
@property (nonatomic, strong) UITextView *txt_descricao;
@property (nonatomic, strong) UIPickerView *pck_tipo;


@property (nonatomic, strong) IBOutlet UINavigationBar *navbar;

@end
