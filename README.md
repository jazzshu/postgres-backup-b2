# Introduction

This repo provides a way to regularly backup a Postgres Database and store it in a Backblaze bucket.

It uses a Go program to implement a cron schedule using the "github.com/robfig/cron/v3" library.

The Go program is then compiled into an executable available at <https://github.com/jazzshuy/postgres-backup-b2/releases/download/v1.0.0/go-cron>.

Run the docker-compose image after you filled out the required template.env variables.

Freely taken and adapted from <https://github.com/ivoronin/go-cron>.
