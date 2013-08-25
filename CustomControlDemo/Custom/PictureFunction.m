/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： PictureFunction.m
 * 内容摘要： 图片获取类。
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年9月17日
 * 说   明： 
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import "PictureFunction.h"

@implementation PictureFunction
@synthesize delegate = _delegate;

/*******************************************************************************
 * 方法名称：getWeatherBySync:
 * 功能描述：获取图片调用
 * 备   注：判断此设备是否支持拍照功能
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (void)takeAPhotoAtCurrentView:(UIViewController*)theController
{
	_presentViewController = theController;
	//判断 是否有摄像功能
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
		_isCamera = NO;
        UIActionSheet * actsheet = [[UIActionSheet alloc]initWithTitle:@"获取图片" 
                                                              delegate:self 
                                                     cancelButtonTitle:@"取消" 
                                                destructiveButtonTitle:nil 
                                                     otherButtonTitles:@"从图片库获取",nil];
        [actsheet showInView:_presentViewController.view];
        [actsheet release ];
    }
    else
    {
		_isCamera = YES;
        UIActionSheet * actsheet = [[UIActionSheet alloc]initWithTitle:@"获取图片" 
                                                              delegate:self 
                                                     cancelButtonTitle:@"取消" 
                                                destructiveButtonTitle:nil 
                                                     otherButtonTitles:@"拍照",@"从相册获取",@"从图片库获取",nil];
        [actsheet showInView:_presentViewController.view];
        [actsheet release ];
    }
}

/*******************************************************************************
 * 方法名称：actionSheet:clickedButtonAtIndex:
 * 功能描述：点击不同的按钮 出现提示
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{  
	if(_isCamera)
	{
		if(buttonIndex == 0 )
		{
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
            {
				[self getCameraPictureInView:_presentViewController theSegment:1];
			}
            else
            {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备不支持拍照" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
				[alert show];
				[alert release];
			}
		}
        else if (buttonIndex == 1)
        {
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
            {
				
				[self getCameraPictureInView:_presentViewController theSegment:2];
			} 
            else
            {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"相册中没有可选图片" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
				[alert show];
				[alert release];
			}
		}
        else if (buttonIndex == 2) 
        {
			[self selectExistingPictureInView:_presentViewController theSegment:2];
		}
	}
    else 
    {
		if(buttonIndex == 0 )
        {
            [self selectExistingPictureInView:_presentViewController theSegment:1];
        }
	}
	
}

/*******************************************************************************
 * 方法名称：getCameraPictureInView:theSegment:
 * 功能描述：拍摄照片，获取新图片
 * 备   注：有拍摄功能调用此方法
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (void)getCameraPictureInView:(UIViewController*)theController theSegment:(int)segment
{
	_presentViewController = theController;
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.delegate = self;
    picker.allowsEditing = YES;
    //判断是拍照还是从相册获取图片
    picker.sourceType = (segment == 1) ? (UIImagePickerControllerSourceTypeCamera) : (UIImagePickerControllerSourceTypeSavedPhotosAlbum);
    [_presentViewController presentModalViewController:picker animated:YES];
}

/*******************************************************************************
 * 方法名称：selectExistingPictureInView:theSegment:
 * 功能描述：获取现有图片
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
- (void)selectExistingPictureInView:(UIViewController*)theController theSegment:(int)segment
{
	_presentViewController = theController;
    //判断是否有照片
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [_presentViewController presentModalViewController:picker animated:YES];
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了！" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

/*******************************************************************************
 * 方法名称：imagePickerController:didFinishPickingImage:editingInfo:
 * 功能描述：获取选择图片
 * 输入参数：
    picker：指向之前常见的uiimagePickerController的指针
    image：包含用户所选照片的UIImage实例
    editingInfo：如果允许编辑，并且用户裁剪或缩放了图片，就会传递此参数
 * 输出参数：
 ******************************************************************************/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //将图片放入到imageView中
	if([_delegate respondsToSelector:@selector(selectedPicture:)])
	{
		[_delegate selectedPicture:image];
	}
    
    [picker dismissModalViewControllerAnimated:YES];
}

/*******************************************************************************
 * 方法名称：imagePickerControllerDidCancel:
 * 功能描述：用户取消选择调用
 * 备   注：用户已经结束使用选取器，并且已经没有任何图片
 * 输入参数：
 * 输出参数：
 ******************************************************************************/
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)dealloc
{
	[_delegate release];
    [_presentViewController release];
	_presentViewController = nil;
    
    [super dealloc];
}

@end
