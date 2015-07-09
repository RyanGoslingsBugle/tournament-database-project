-- Table definitions for the tournament project.

-- Creates a new db

DROP DATABASE IF EXISTS tournament;

create database tournament;

\connect tournament;

-- Creates tables to insert player and match data

create table players (id serial primary key, name text);

create table matches (id serial primary key, winner_id integer, loser_id integer);

-- Creates views to manage match win/loss counting, generate player standings sorted by number of wins

create view match_wins as (select winner_id, coalesce(count(winner_id), 0) as number from matches group by winner_id);

create view match_losses as (select loser_id, coalesce(count(loser_id), 0) as number from matches group by loser_id);

create view standings as (select players.id, players.name, coalesce(match_wins.number, 0) as wins, coalesce(coalesce(match_wins.number, 0) + coalesce(match_losses.number, 0), 0) as played from players left join match_wins on players.id = match_wins.winner_id left join match_losses on players.id = match_losses.loser_id order by match_wins.number);