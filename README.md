# Challenge elixir - bank app

This project was made for a challenge issued by Stone Pagamentos, using the Elixir programming language

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

#### Running with Docker-Compose

You can choose to run the project using Docker compose, which requires Docker to be installed on your machine. If it isn't please follow the instructions on provided on these links: 

Docker: https://docs.docker.com/install/
Docker Compose: https://docs.docker.com/compose/install/

#### Running without Docker

If you choose to run without docker, you must have elixir and phoenix installed on your machine, for that please follow the instructions provided on these links: 

Elixir: https://elixir-lang.org/install.html#unix-and-unix-like
Phoenix: https://hexdocs.pm/phoenix/installation.html#content

You will also need to install PostgreSQL, which is the database used, for that follow the instructions that can be found on:

PostgreSQL: https://www.postgresql.org/

### Installing

This step ins only necessary if you choose to run the project without using docker.
Please input the commands that follow to install the project and it's dependencies.

Install hex (Elixir package manager)

```
mix local.hex
```

Install rebar (Erlang build tool)

```
mix local.rebar 
```

Go to the Assets folders and install the npm dependencies

```
npm install
```

On the root of the project, get the dependencies and compile them

```
mix deps.get
mix deps.compile
```

Now go to the root of the bank app (apps/bank) and create the database

```
mix init
```

Dont forget to configure your database on the apps/bank/config/config.exs file before running the init task!

## Running the application

### With docker compose

After making sure docker and docker compose are properly installed, please run the following commands: 

```
sudo docker-compose build
sudo docker-compose up -d
```

After executing these commands, you now should be able o access the application at localhost:4000/login

ps: If running on older versions or on docker-tools on Windows systems, you may not be able to access it via localhost if not properly configured, so run $docker-machine env and look for the docker_host variable and see what ip it's using, and use that on the port 4000 to access the application

### Without docker compose

After installing the dependecies and creating the database, go to the root of the project and run 

```
mix phx.server
```

You should now be able to access it on localhost:4000

## Running the tests

To run the tests you have to run the application without Docker.
Just set the env variable MIX_ENV="test" and run 

```
mix test
```

dont forget to reset the MIX_ENV after running the tests if you with to run the application after it!

## Lint

This project uses credo, if you want to know more about it please follow this link: 
https://github.com/rrrene/credo

## Built With

* [Elixir](https://elixir-lang.org/) - The programming language
* [Phoenix](http://phoenixframework.org/) - The web framework used
* [PostgreSQL](https://www.postgresql.org/) - The database
