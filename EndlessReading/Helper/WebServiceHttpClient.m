//
//  WebServiceHttpClient.m
//  TubeMogul
//
//  Created by Xiaodiao.Deng on 15/12/15.
//  Copyright © 2015年 Satinno. All rights reserved.
//

#import "WebServiceHttpClient.h"

#define WebServiceURLString @"http://www.ourgift.cn:8080"

@implementation WebServiceHttpClient


+ (WebServiceHttpClient *)sharedWebServiceHTTPClient
{
    static WebServiceHttpClient *_sharedWebServiceHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWebServiceHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:WebServiceURLString]];
        
    });
    
    return _sharedWebServiceHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        //initialize the object
        
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Accept"];
        self.requestSerializer = requestSerializer;
        
        //application/x-www-form-urlencoded
        
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        self.responseSerializer = responseSerializer;
        
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    
    return self;
}


/*
 2.	获取小说分类
 act = books.ctalog.get
 协议例子：
 www.ourgift.cn:8080/novel/api/index.php?act=books.ctalog.get
 返回字段说明：
 catalog_id 		分类ID
 catalog_name		分类名称
 */
-(void)getBooksCtalogWithParams:(NSDictionary*)parameters
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage))failure{
    [self GET:@"novel/api/index.php?act=books.ctalog.get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){

        if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
            success(operation, responseObject);
        }else{
            failure(operation, nil, [responseObject objectForKey:@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // error stuff here
        failure(operation, nil, @"请检查你的网络，并稍后重试");
    }];
}

/*
 3.	获取小说列表
 act = books.booksList.get
 协议例子：
 www.ourgift.cn:8080/novel/api/index.php?act=books.booksList.get&catalog_id=22&page=1
 
 参数说明:
 catalog_id		分类ID  按分类获取小说列表，则传递此参数的值
 search_key       搜索关键字   按关键字搜索小说列表  则需要传递此参数的值(汉字必须为UTF-8编码)
 page         	页数  非必填  默认为1
 page_size    		每页图书个数 非必填 默认为20
 */
-(void)getBooksListCtalogWithParams:(NSDictionary*)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage))failure{
    [self GET:@"novel/api/index.php?act=books.booksList.get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
            success(operation, responseObject);
        }else{
            failure(operation, nil, [responseObject objectForKey:@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // error stuff here
        failure(operation, nil, @"请检查你的网络，并稍后重试");
    }];
}

/*
 4.	获取小说详情
 act=books.bookDetail.get
 协议例子：
 www.ourgift.cn:8080/novel/api/index.php?act=books.bookDetail.get&book_id=7504
 参数说明：
 book_id			小说id 必填
 返回字段说明：
 book_id				小说id
 book_name		图书名称
 catalog_id		小说所属分类id
 catalog_name     小说所属分类名称
 description       小说简介
 zuozhe		    作者
 bookclick         阅读人数
 book_img         小说封面图片
 update_time       更新日期
 */
-(void)getBooksDetailWithParams:(NSDictionary*)parameters
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage))failure{
    [self GET:@"novel/api/index.php?act=books.bookDetail.get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
            success(operation, responseObject);
        }else{
            failure(operation, nil, [responseObject objectForKey:@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // error stuff here
        failure(operation, nil, @"请检查你的网络，并稍后重试");
    }];
}

/*
 5.	获取章节列表接口
 act=books.bookChapters.get
 协议例子：
 www.ourgift.cn:8080/novel/api/index.php?act=books.bookChapters.get&book_id=7504&page=5
 参数说明
 book_id			小说id 必填
 page         	页数  非必填  默认为1
 page_size    		每页数据个数 非必填  默认为50
 返回字段说明：
 chapter_id		章节id
 chapter_title		章节标题
 order_id			章节序列数（章节数）
 */
-(void)getBooksChaptersWithParams:(NSDictionary*)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage))failure{
    [self GET:@"novel/api/index.php?act=books.bookChapters.get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
            success(operation, responseObject);
        }else{
            failure(operation, nil, [responseObject objectForKey:@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // error stuff here
        failure(operation, nil, @"请检查你的网络，并稍后重试");
    }];
}

/*
 6.	获取小说章节内容接口
 act=books.bookChapterContent.get
 协议例子：
 www.ourgift.cn:8080/novel/api/index.php?act=books.bookChapterContent.get&chapter_id=7705&book_id=7504
 参数：
 book_id			小说ID  必填项
 chapter_id		章节ID  必填项
 返回字段说明：
 chapter_title             章节标题
 chapter_content          章节内容
 */
-(void)getBooksChapterContentWithParams:(NSDictionary*)parameters
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage))failure{
    [self GET:@"novel/api/index.php?act=books.bookChapterContent.get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
            success(operation, responseObject);
        }else{
            failure(operation, nil, [responseObject objectForKey:@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // error stuff here
        failure(operation, nil, @"请检查你的网络，并稍后重试");
    }];
}


/*8.	获取排行榜
 act= books.c hartsList.get
 说明：获取排行榜列表，数据有排行榜的名称等数据
 协议例子：
 http://www.ourgift.cn:8080/novel/api/index.php?act=books.chartsList.get
 参数：
 无
 返回字段说明：
 chart_key           排行榜关键字 作为参数获取排行榜下的小说列表
 chart_name         排行榜名称
 */
-(void)getBooksChartsListWithParams:(NSDictionary*)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage))failure{
    [self GET:@"novel/api/index.php?act=books.chartsList.get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
            success(operation, responseObject);
        }else{
            failure(operation, nil, [responseObject objectForKey:@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // error stuff here
        failure(operation, nil, @"请检查你的网络，并稍后重试");
    }];
}

/*
 9.	获取指定排行榜的小说列表
 说明：获取指定排行榜的小说列表
 act=books.chartsBookList.get
 协议例子：
 http://www.ourgift.cn:8080/novel/api/index.php?act=books.chartsBookList.get&chart_key=all_click&page=1
 
 参数：
 chart_key 		排行榜关键字，每个排行榜对应一个key  获取排行榜下的小说列表 此参数为必填
 page         	页数  非必填  默认为1
 page_size    		每页图书个数 非必填 默认为20
 */
-(void)getBooksChartsBookListWithParams:(NSDictionary*)parameters
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage))failure{
    [self GET:@"novel/api/index.php?act=books.chartsBookList.get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
            success(operation, responseObject);
        }else{
            failure(operation, nil, [responseObject objectForKey:@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // error stuff here
        failure(operation, nil, @"请检查你的网络，并稍后重试");
    }];
}

/*
 10.	获取“推荐”或“感兴趣”的小说列表
 说明：获取推荐的小说列表，或获取感兴趣的小说列表
 act=books.recommendBookList.get
 协议例子：
 推荐小说列表
 http://www.ourgift.cn:8080/novel/api/index.php?act=books.recommendBookList.get&list_type=recommend&page=1
 感兴趣小说列表
 http://www.ourgift.cn:8080/novel/api/index.php?act=books.recommendBookList.get&list_type=interest&page=1
 参数：
 list_type         获取推荐/感兴趣的小说列表 专用字段
	list_type值为recommend  则为获取“推荐”的小说列表
	list_type值为interest则为获取“感兴趣”的小说列表
 page         	页数  非必填  默认为1
 page_size    		每页图书个数 非必填 默认为20
 返回字段说明：
 book_id				小说id
 book_name		图书名称
 catalog_id		小说所属分类id
 catalog_name     小说所属分类名称
 description       小说简介
 zuozhe		    作者
 bookclick         阅读人数
 book_img         小说封面图片
 update_time       更新日期
 */
-(void)getBooksRecommendListWithParams:(NSDictionary*)parameters
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage))failure{
    [self GET:@"novel/api/index.php?act=books.recommendBookList.get" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
            success(operation, responseObject);
        }else{
            failure(operation, nil, [responseObject objectForKey:@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // error stuff here
        failure(operation, nil, @"请检查你的网络，并稍后重试");
    }];
}
@end
