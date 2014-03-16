//
//  MovieCell.m
//  MovieFinder
//
//  Created by Jessica Ko on 3/15/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

@synthesize title;
@synthesize desc;
@synthesize cast;
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(10,-5,300,120)];
        whiteRoundedCornerView.backgroundColor = [UIColor whiteColor];
        whiteRoundedCornerView.layer.masksToBounds = NO;
        whiteRoundedCornerView.layer.cornerRadius = 4.0;
        whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(0, 0);
        whiteRoundedCornerView.layer.shadowOpacity = 0.1;
        whiteRoundedCornerView.layer.shadowRadius = 0;
        whiteRoundedCornerView.layer.borderWidth = 1;
        
        whiteRoundedCornerView.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0] CGColor];
        whiteRoundedCornerView.layer.shadowColor =  [[UIColor blackColor] CGColor];

        title = [[UILabel alloc] initWithFrame:CGRectMake(90, 19, 190, 20)];
        [title setFont:[UIFont fontWithName: @"ProximaNovaRegular" size: 14]];
        
        desc = [[UILabel alloc] initWithFrame:CGRectMake(90, 28, 190, 70)];
        [desc setFont:[UIFont fontWithName: @"ProximaNovaRegular" size: 11]];
        [desc setNumberOfLines:3];

        cast = [[UILabel alloc] initWithFrame:CGRectMake(90, 83, 190, 20)];
        [cast setFont:[UIFont fontWithName: @"ProximaNovaRegular" size: 11]];
        [cast setFont:[UIFont italicSystemFontOfSize:11]];
        [cast setTextColor:[UIColor colorWithRed:170/255 green:170/255 blue:170/255 alpha:1]];
        [cast setNumberOfLines:10];

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 68, 95)];

        [whiteRoundedCornerView addSubview:title];
        [whiteRoundedCornerView addSubview:desc];
        [whiteRoundedCornerView addSubview:cast];
        [whiteRoundedCornerView addSubview:imageView];
        [self.contentView addSubview:whiteRoundedCornerView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
