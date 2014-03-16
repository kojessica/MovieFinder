//
//  MoviesHomeViewController.m
//  MovieFinder
//
//  Created by Jessica Ko on 3/13/14.
//  Copyright (c) 2014 Jessica Ko. All rights reserved.
//

#import "MoviesHomeViewController.h"
#import "MovieDetailViewController.h"
#import "AFNetworking.h"

@interface MoviesHomeViewController ()

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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"." style:UIBarButtonItemStylePlain target:self action:@selector(onSearchButton)];

    self.movies = [[NSArray alloc] init];
    [self fetchMovies];
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
    
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.movies = [responseObject objectForKey:@"movies"];
        [self.movietable reloadData];
        NSLog(@"%@", self.movies);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *title;
    UILabel *desc;
    UILabel *cast;
    NSDictionary *tempDictionary;
    UIView *whiteRoundedCornerView;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(10,-5,300,120)];
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
        //[title setText:[tempDictionary objectForKey:@"title"]];
        [whiteRoundedCornerView addSubview:title];

        desc = [[UILabel alloc] initWithFrame:CGRectMake(90, 28, 190, 70)];
        [desc setFont:[UIFont fontWithName: @"ProximaNovaRegular" size: 11]];
        //[desc setText:[tempDictionary objectForKey:@"synopsis"]];
        [desc setNumberOfLines:3];
        [whiteRoundedCornerView addSubview:desc];

        cast = [[UILabel alloc] initWithFrame:CGRectMake(90, 83, 190, 20)];
        [cast setFont:[UIFont fontWithName: @"ProximaNovaRegular" size: 11]];
        [cast setFont:[UIFont italicSystemFontOfSize:11]];
        //[cast setText:castString];
        [cast setTextColor:[UIColor colorWithRed:170/255 green:170/255 blue:170/255 alpha:1]];
        [cast setNumberOfLines:10];
        [whiteRoundedCornerView addSubview:cast];

        cell.layer.borderWidth = 0;
        [cell.contentView addSubview:whiteRoundedCornerView];
        [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
        [cell setBackgroundColor:[UIColor clearColor]];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    //set title, synopsis, cast, and title
    tempDictionary= [self.movies objectAtIndex:indexPath.row];
    title.text = [NSString stringWithFormat:@"%d", indexPath.row];
    desc.text = [tempDictionary objectForKey:@"synopsis"];
    
    NSArray *castArray = [tempDictionary objectForKey:@"abridged_cast"];
    NSMutableArray *castMutArray = [[NSMutableArray alloc] init];
    for (NSDictionary *cast in castArray) {
        [castMutArray addObject:[cast objectForKey:@"name"]];
    }
    NSString *castString = [castMutArray componentsJoinedByString:@", "];
    cast.text = castString;
    
    NSDictionary *poster = [tempDictionary objectForKey:@"posters"];
    NSString *thumbnail = [poster objectForKey:@"thumbnail"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbnail]];
    UIView *imageWrapper = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 52, 110)];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageWrapper addSubview:imageView];
    [whiteRoundedCornerView addSubview:imageWrapper];
    
    NSLog(@"%@", [tempDictionary objectForKey:@"title"]);

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
