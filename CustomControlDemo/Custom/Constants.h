/*
 *  Constants.h
 *  Dyrs
 *
 *  Created by Wang Shuguang on 11-12-24.
 *  Copyright 2011 Jinher Software. All rights reserved.
 *
 */

#pragma mark - UIViewTag常量集合

#define LOADING_MASK_GRAYVIEWTAG 10
#define LOADING_MASK_VIEWTAG 11

#pragma mark - 系统常用配置
#define NETWORK_TIMEOUT 30

#pragma mark - 数据库相关变量
#define DB_NAME @"demo.db"
#define TABLE_USER @"user"

#pragma mark - 配置文件变量
#define CONFIG_FILE_NAME @"config"
#define GETFILEFULLPATH(fileName) [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]]

#pragma mark - Document文件夹
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#pragma mark - 富文本框的标签
#define RICHTEXTVIEW_TAG_DEFAULT @"default"
#define RICHTEXTVIEW_TAG_IMAGE @"image"
#define RICHTEXTVIEW_TAG_BULLET @"bullet"
#define RICHTEXTVIEW_TAG_PAGE @"page"
#define RICHTEXTVIEW_TAG_LINK @"link"
#define RICHTEXTVIEW_TAG_COLOR @"color"
#define RICHTEXTVIEW_TAG_TITLE @"title"
#define RICHTEXTVIEW_TAG_FIRSTLETTER @"firstletter"
#define RICHTEXTVIEW_TAG_BOLD @"bold"
#define RICHTEXTVIEW_TAG_ITALIC @"italic"
#define RICHTEXTVIEW_TAG_DATAURL @"url"
#define RICHTEXTVIEW_TAG_DATANAME @"RichTextDataName"
#define RICHTEXTVIEW_TAG_DATAFRAME @"RichTextDataFrame"
#define RICHTEXTVIEW_TAG_DATAATTRIBUTES @"RichTextDataAttributes"
