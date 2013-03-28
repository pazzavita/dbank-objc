//
//  NSPVFS.h
//  dbank-objc
//
//  Created by 江宇英 on 13-3-27.
//
//

#import "NSPClient.h"

@interface NSPVFS : NSPClient

/**
 * 列举子目录
 *
 * 参数      可选    类型                      说明
 * path      可选    string                   文件夹路径
 * fields    可选    string[]                 需要查询的文件属性数组
 * options   可选     map<string, object>     附加选项
 */
- (id)listDirectory:(NSString *)aPath;
- (id)listDirectory:(NSString *)aPath
         withFields:(NSArray *)fields;

/**
 * 复制文件
 *
 * 参数       可选    类型                   说明
 * files     必选    String[]               文件路径数组。该接口支持拷贝文件以及文件夹，文件夹会递归拷贝内容。
 * path      必选    String                 拷贝目标文件夹（文件）路径
 * attribute 可选    map<string, string>    默认为空，复制文件时的可选参数配置，这个以后可不断扩展。
 */
- (id)copyFile:(NSString *)aFilepath
        toPath:(NSString *)aPath;
- (id)copyFile:(NSString *)aFilepath
        toPath:(NSString *)aPath
withAttributes:(NSDictionary *)attributes;
- (id)copyFiles:(NSArray *)files
         toPath:(NSString *)aPath;
- (id)copyFiles:(NSArray *)files
         toPath:(NSString *)aPath
 withAttributes:(NSDictionary *)attributes;

/**
 * 移动文件
 *
 * 参数        可选    类型                   说明
 * files      必选    String[]               文件路径数组。该接口支持移动文件以及文件夹，文件夹会递归移动文件夹内容。
 * path       必选    string                 拷贝目标文件夹（文件）路径。
 * attribute  可选    map<string, string>    默认为空。移动文件(夹)时的可选参数配置，这个以后可不断扩展
 */
- (id)moveFileFrom:(NSString *)aFilepath
            toPath:(NSString *)aPath;
- (id)moveFileFrom:(NSString *)aFilepath
            toPath:(NSString *)aPath
    withAttributes:(NSDictionary *)attributes;
- (id)moveFilesFrom:(NSArray *)files
             toPath:(NSString *)aPath;
- (id)moveFilesFrom:(NSArray *)files
             toPath:(NSString *)aPath
     withAttributes:(NSDictionary *)attributes;

/**
 * 删除文件
 *
 * 参数       可选     类型                 说明
 * files     必选     string[]            文件路径数组
 * reserve   可选     boolean             删除文件或文件夹时是否保留，默认为false，直接删除文件或文件夹。如果为true的话，将文件或文件夹移动到系统回收站进行暂时保留。
 * attribute 可选     map<string,string>      对文件删除操作附加一些属性控制。
 */
- (id)deleteFile:(NSString *)aFilepath;
- (id)deleteFile:(NSString *)aFilepath
     withReverse:(BOOL)reverse;
- (id)deleteFile:(NSString *)aFilepath
     withReverse:(BOOL)reverse
  withAttributes:(NSDictionary *)attributes;

- (id)deleteFiles:(NSArray *)files;
- (id)deleteFiles:(NSArray *)files
      withReverse:(BOOL)reverse;
- (id)deleteFiles:(NSArray *)files
      withReverse:(BOOL)reverse
   withAttributes:(NSDictionary *)attributes;

/**
 * 创建文件或者目录
 *
 * 参数    可选    类型               说明
 * files  必选    nsp.VFS.File[]    文件对象数组。
 * path   可选    string            父文件夹路径。
 */
- (id)createFile:(NSString *)aFilepath
    atParentPath:(NSString *)aParentPath;
- (id)createFiles:(NSArray *)files
     atParentPath:(NSString *)aParentPath;

/**
 * 获取用户文件基本属性信息
 *
 * 参数       可选    类型        说明
 * files     必选    string[]    文件路径数组。
 * fields    可选    string[]    要查询的文件属性数组。“type,name”，两个属性，系统会自动返回，可以不用加入到列表中。
 */
- (id)attributesForFile:(NSString *)aFilepath
                withFields:(NSArray *)fields;
- (id)attributesForFiles:(NSArray *)files
                 withFields:(NSArray *)fields;

@end
