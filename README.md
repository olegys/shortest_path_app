# Shortest Path

A Flutter app that fetches grid pathfinding tasks, finds a shortest route for each one, and submits the results to the API.

## Features

- Uses breadth-first search to find the shortest route. Each move goes to one of the eight neighboring cells, and blocked cells are excluded from the route.
- Shows download and calculation progress while processing tasks.
- Displays each route on a zoomable grid and as a list of coordinates.
- Saves the API URL between launches.
- Sends results to the same URL used to fetch the tasks.

## Run

```sh
flutter pub get
flutter run
```

Enter the API URL on the first screen, or use the default. A custom URL is saved and prefilled the next time the app opens.

## Tests

```sh
flutter test
```

## Main packages

`flutter_bloc`, `get_it`, `go_router`, `dio`, `pretty_dio_logger`, `shared_preferences`, and `equatable`.
