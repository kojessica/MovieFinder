//
//  Movie.m
//  MovieFinder
//
//  Created by Jessica Ko on 3/15/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)movie {
    self = [super init];
    if (self) {
        self.title = movie[@"title"];
        self.synopsis = movie[@"synopsis"];
        NSArray *castArray = movie[@"abridged_cast"];
        NSMutableArray *castMutArray = [[NSMutableArray alloc] init];
        for (NSDictionary *cast in castArray) {
            [castMutArray addObject:[cast objectForKey:@"name"]];
        }
        self.cast = [castMutArray componentsJoinedByString:@", "];
                      
        self.imageurl = [movie[@"posters"] objectForKey:@"thumbnail"];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageurl]];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        self.image = image;
        
        self.poster = movie[@"posters"];
        
        /*NSString *bigposter = [movie[@"posters"] objectForKey:@"original"];
        NSData *largeimageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:bigposter]];
        UIImage *largeimage = [[UIImage alloc] initWithData:largeimageData];
        self.originalposter = largeimage;*/

    }
    
    return self;
}

+ (NSArray *)moviesWithArray:(NSArray *)array {
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    
    for (NSDictionary *movie in array) {
        Movie *mov = [[Movie alloc] initWithDictionary:movie];
        [movies addObject:mov];
    }
    
    return movies;
}

@end
