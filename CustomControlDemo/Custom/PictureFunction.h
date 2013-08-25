/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： PictureFunction.h
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

#import <Foundation/Foundation.h>

@protocol PictureFuntionDelegate<NSObject>
-(void)selectedPicture:(UIImage *)image;
@end

@interface PictureFunction : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    
	id<PictureFuntionDelegate>      _delegate;// the delegate
	UIViewController                *_presentViewController;
    
	BOOL                            _isCamera;
}

@property (nonatomic, assign)  id delegate;


//获取图片调用
-(void)takeAPhotoAtCurrentView:(UIViewController*)theController;
//拍照和从相册中获取照片
-(void)getCameraPictureInView:(UIViewController*)theController theSegment:(int)segment;
//选择照片
-(void)selectExistingPictureInView:(UIViewController*)theController theSegment:(int)segment;

@end
