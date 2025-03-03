# Line server app

## Functionality
```
- It fetches the content of the provided line index
- It limits the ammount of requests in general and for the specific endpoint
- It caches solicited lines for better performance
- It uses a model TextFile to hold some business logic and Services to fetch data and cache data
```

## App description
```
- This is Ruby 3.2 and a Rails 7.2.1 monolith app
```

## Dependencies
```
- Rspec
- Rack-attack
```

## Running the app
Clone this repo:
```
$ git clone git@github.com:{USER_NAME}/line-server-app.git
```
Make the Shell Scripts Executable:

Navigate to the root folder of your cloned app (where build.sh and run.sh are located). You should be in the same directory as the .sh files. Run the following commands in the terminal inside this directory to make the scripts executable:
```
$ chmod +x build.sh
$ chmod +x run.sh
```
Run the Build Script passing the .txt file you want to search upon:
```
$ ./build.sh yourfile.txt
```

Run the server:
```
$ ./run.sh
```

## Running tests
```
$ bundle exec rspec
```

## How this app works
```
1- for small files it makes sequential search
2- for big files it perform search concurrently into chunks
3- for even bigger files the best strategy would be to use indexing (e.g., Lucene, Elasticsearch) or binary search on sorted data
4- for just a few users this app uses in-memory caching for frequently accessed data
5- for 10,000 users It implements file chunking for large data, leverage caching for API responses and I would distribute load across multiple servers
6- for 1,000,000 users I would use load balancing, optimize file storage (e.g., cloud storage), and implement distributed caching and asynchronous processing.
```

## Improvements
```
1- proper testing for the file handling
2- Redis for caching
3- Sidekiq for asynchronous processing
4- Cloud for file storage
```
