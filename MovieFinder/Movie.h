//
//  Movie.h
//  MovieFinder
//
//  Created by Jessica Ko on 3/15/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *cast;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSDictionary *poster;
@property (nonatomic, strong) UIImage *originalposter;
- (id)initWithDictionary:(NSDictionary *)movies;
+ (NSArray *)moviesWithArray:(NSArray *)array;

@end
