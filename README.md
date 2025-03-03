# Line server app

## Functionality
```
- It fetches the content of the provided line index
- It limits the ammount of requests in general and for the specific endpoint
- It caches solicited lines for better performance
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
