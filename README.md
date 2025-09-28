# RESTful API Andromeda Server

A boilerplate/starter project (RESTful APIs using Node.js, Express, and Mongoose) from <https://github.com/hagopj13/node-express-boilerplate>

## Andromeda image

- `andromeda` folder

## Multi-stage build

- The app is build with npm and Node

- The app runner is Andromeda

```sh
docker build -t dercilio/andromeda-express-app:0.1.0-draft43 .

docker run --name andromeda-express-app -p 8080:8080 dercilio/andromeda-express-app:0.1.0-draft43
```
