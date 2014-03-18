//
//  MoviesHomeViewController.m
//  MovieFinder
//
//  Created by Jessica Ko on 3/13/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "MoviesHomeViewController.h"
#import "MovieDetailViewController.h"
#import "MovieCell.h"
#import "AFNetworking.h"
#import "Movie.h"
#import "MBProgressHUD/MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesHomeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *movietable;
@property (strong, nonatomic) NSArray *movies;
- (void)fetchMovies;
- (void)onSearchButton;
@property (strong, nonatomic) UIView *networkError;
@property (strong, nonatomic) UILabel *errorMsg;
@end

@implementation MoviesHomeViewController

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
    
    self.navigationItem.title = @"movies";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"." style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButton)];

    self.movies = [[NSArray alloc] init];

    self.networkError = [[UIView alloc] initWithFrame:CGRectMake(0, -120, 320, 50)];
    self.networkError.backgroundColor = [UIColor colorWithRed:50/255.0 green:56/255.0 blue:66/255.0 alpha:1.0];
    
    self.errorMsg = [[UILabel alloc] initWithFrame:CGRectMake(110, -120, 320, 50)];
    [self.errorMsg setFont:[UIFont fontWithName: @"ProximaNovaSemiBold" size: 16]];
    [self.errorMsg setTextColor:[UIColor whiteColor]];
    self.errorMsg.text = @"Network error";
    
    
    [self fetchMovies];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.movietable addSubview:refreshControl];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
    [self fetchMovies];
}

- (void)fetchMovies
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [self.movietable addSubview:self.networkError];
    [self.movietable addSubview:self.errorMsg];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.movies = [Movie moviesWithArray:[responseObject objectForKey:@"movies"]];
        [self.movietable reloadData];
        
        [self.networkError setAlpha:0.0f];
        [self.errorMsg setAlpha:0.0f];
        [self.networkError setHidden:YES];
        [self.errorMsg setHidden:YES];
        
        NSLog(@"%@", self.movies);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [UIView animateWithDuration:0.7 animations:^{
            self.networkError.frame =  CGRectMake(0, -10, 320, 50);
            self.errorMsg.frame = CGRectMake(110, -10, 320, 50);
            [self.networkError setAlpha:1.0f];
            [self.errorMsg setAlpha:1.0f];
        } completion:^(BOOL finished) {
            [self.networkError setHidden:NO];
            [self.errorMsg setHidden:NO];
        }];
        NSLog(@"%@", @"Failed");
    }];
    [operation start];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.movies count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieDetailViewController *detailview = [[MovieDetailViewController alloc] initWithNibName:@"MovieDetailViewController" bundle:nil];
    detailview.movieDetail = [self.movies objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailview animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCell *cell = (MovieCell *)[tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    if (cell == nil) {
        cell = [[MovieCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MovieCell"];
    }
    
    Movie *movie = [self.movies objectAtIndex:indexPath.row];
    cell.title.text = movie.title;
    cell.desc.text = movie.synopsis;
    cell.cast.text = movie.cast;
    NSURL *url = [NSURL URLWithString:movie.imageurl];
    [cell.imageView setImageWithURL:url];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

- (void)onSearchButton {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
