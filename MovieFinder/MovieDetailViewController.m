//
//  MovieDetailViewController.m
//  MovieFinder
//
//  Created by Jessica Ko on 3/13/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "Movie.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = self.movieDetail.title;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backButton;
    
    [self showDetail];
}

- (void)showDetail
{
    NSDictionary *poster = self.movieDetail.poster;
    NSString *thumbnail = [poster objectForKey:@"original"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbnail]];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIImageView *movieImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 330, image.size.height/image.size.width*300)];
    movieImage.image = image;
    [self.view addSubview:movieImage];
    
    UIView *transparent = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 330, 1000)];
    transparent.layer.opacity = 0.9f;
    transparent.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:transparent];
    
    UILabel *summary = [[UILabel alloc] initWithFrame:CGRectMake(15, 350, 300, 20)];
    summary.text = self.movieDetail.synopsis;
    
    UILabel *summaryTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 320, 300, 20)];
    summaryTitle.text = @"Summary";

    UILabel *castTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 440, 300, 20)];
    castTitle.text = @"Cast";
    
    UILabel *cast = [[UILabel alloc] initWithFrame:CGRectMake(15, 470, 300, 20)];
    cast.text = self.movieDetail.cast;
    
    [summary setFont:[UIFont fontWithName: @"ProximaNovaRegular" size: 12]];
    [summary setNumberOfLines:5];
    [summary sizeToFit];
    [cast setFont:[UIFont fontWithName: @"ProximaNovaRegular" size: 12]];
    [cast setNumberOfLines:0];
    [cast sizeToFit];
    [self.view addSubview:summary];
    [self.view addSubview:summaryTitle];
    [self.view addSubview:cast];
    [self.view addSubview:castTitle];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
