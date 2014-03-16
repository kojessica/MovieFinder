//
//  MovieCell.h
//  MovieFinder
//
//  Created by Jessica Ko on 3/15/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
    @property (nonatomic, strong) UILabel *title;
    @property (nonatomic, strong) UILabel *desc;
    @property (nonatomic, strong) UILabel *cast;
    @property (nonatomic, strong) UIImageView *imageView;
@end
