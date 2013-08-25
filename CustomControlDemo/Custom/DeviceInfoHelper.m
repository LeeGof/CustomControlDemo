/*******************************************************************************
 * 版权所有 (C)2012用友软件股份有限公司
 * 
 * 文件名称： DeviceInfoHelper.m
 * 内容摘要： 获取设备信息。
 * 当前版本： v1.0
 * 作   者： 李高峰
 * 完成日期： 2012年9月3日
 * 说   明： 
 
 * 修改日期：
 * 版 本 号：
 * 修 改 人：
 * 修改内容：
 ******************************************************************************/

#import "DeviceInfoHelper.h"
#include <sys/socket.h> 
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation DeviceInfoHelper

+ (NSString *)getMacAddress
{
    int                     mib[6];
	size_t                  len;
	char                    *buf;
	unsigned char           *ptr;
	struct if_msghdr        *ifm;
	struct sockaddr_dl      *sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) 
    {
		printf("Error: if_nametoindex error/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) 
    {
		printf("Error: sysctl, take 1/n");
		return NULL;
	}
	
	if ((buf = malloc(len)) == NULL) 
    {
		printf("Could not allocate memory. error!/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) 
    {
		printf("Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
    
	NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
	free(buf);
	return [outstring uppercaseString];
}

@end
