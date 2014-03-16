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
#import <MBProgressHUD/MBProgressHUD.h>

@interface MoviesHomeViewController ()
@property (weak, nonatomic) IBOutlet UIView *networkError;
@property (weak, nonatomic) IBOutlet UITableView *movietable;
@property (strong, nonatomic) NSArray *movies;
- (void)fetchMovies;
- (void)onSearchButton;
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
    self.networkError.alpha = 0.0f;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"." style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButton)];

    self.movies = [[NSArray alloc] init];
    [self fetchMovies];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.movietable addSubview:refreshControl];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
}

- (void)fetchMovies
{
    /*NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@", object);

        self.movies = [object objectForKey:@"movies"];
        [self.movietable reloadData];
    }];*/
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.movies = [Movie moviesWithArray:[responseObject objectForKey:@"movies"]];
        [self.movietable reloadData];
        NSLog(@"%@", self.movies);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIView animateWithDuration:0.7 animations:^{
            self.networkError.frame =  CGRectMake(0, 0, 320, 120);
            self.networkError.alpha = 1.0f;
        } completion:^(BOOL finished) {
            UILabel *errormsg = [[UILabel alloc] initWithFrame:CGRectMake(110, 32, 320, 120)];
            [errormsg setFont:[UIFont fontWithName: @"ProximaNovaSemiBold" size: 16]];
            [errormsg setTextColor:[UIColor whiteColor]];
            errormsg.text = @"Network Error";
            [self.networkError addSubview:errormsg];
        }];
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
    cell.imageView.image = movie.image;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

- (void)onSearchButton {
    //[self.navigationController pushViewController:[[MovieDetailViewController alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
