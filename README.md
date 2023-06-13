# Fullstack Developer Test

This project was developed for the [Umanni Fullstack Developer Test](https://github.com/umanni/Fullstack-Developer) using the Ruby-on-Rails.

## Stack

Ruby: 3.2.1, Is a dynamically typed, strong, multiparadigm interpreted programming language with automatic memory management, originally planned and developed in Japan in 1995 by Yukihiro "Matz" Matsumoto for use as a scripting language

Rails: 7.0.5, Is a free framework that promises to increase speed and ease in the development of database-oriented sites, since it is possible to create applications based on predefined structures.

Database: PostgreSQL, Is an object relational database management system, developed as an open source project

Redis: 7.0.11, In-memory data structure storage, used as an in-memory database

Sidekiq: 7.1.1, Is an open source background framework written in Ruby

Devise: 4.8.1, Devise is a flexible authentication solution for Rails based on Warden

Roo: 2.10.0, can access the contents of various spreadsheet files. It can handle *OpenOffice*, Excelx, *LibreOffice*, CSV

## Running the project

Make sure [docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04) and [docker-compose](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04) are installed on your machine

Then clone the project using

```bash
git clone https://github.com/igorcb/Fullstack-Developer.git

cd Fullstack-Developer
```

This will bring you all the project structure and its dependencies files, so after that run

```bash
docker-compose up -d
```

Create the database

```bash
docker-compose run web bundle exec rails db:create
```

Create database tables

```bash
docker-compose run web bundle exec rails db:migrate
```

Create a user **admin**

```bash
docker-compose run web bundle exec rails db:seed
```

Now you can access your web browser

```text
localhost:3000
```

You can login as **admin** using

```text
User: admin@example.com
Password: 123456
```

## Spreadsheet import (XLSX)

The upload file uses a standard excel spreadsheet, with columns "full_name", "email" and "role", the default for role must be (true or false). You can use **user_import.xlsx** in the root of the project as an example
