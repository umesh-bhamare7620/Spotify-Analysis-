
-- SPOTIFY ANALYSIS Querys

CREATE DATABASE spotify_db;

USE spotify_db;

CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- EDA

SELECT 
    COUNT(DISTINCT artist)
FROM
    spotify;
SELECT 
    COUNT(DISTINCT Album_type)
FROM
    spotify;

SELECT 
    MAX(duration_min)
FROM
    spotify;
SELECT 
    MIN(duration_min)
FROM
    spotify;


SELECT 
    *
FROM
    spotify
WHERE
    duration_min = 0;

DELETE FROM spottify 
WHERE
    duration_min = 0;
SELECT 
    *
FROM
    spotify
WHERE
    duration_min = 0;
 
SELECT DISTINCT
    channel
FROM
    spotify;

-- ----------------------------------------
-- Data Analysis -Easy Category
-- ----------------------------------------
-- 1. Retrieve the names of all tracks that have  mor than 1 bilion 1 streams.

SELECT 
    *
FROM
    spotify
WHERE
    stream > 1000000000;

-- Q 2 List all albums along with their respective artists.
SELECT DISTINCT
    album, artist
FROM
    spotify;

SELECT DISTINCT
    album
FROM
    spotify
ORDER BY 1;

SELECT DISTINCT
    artist
FROM
    spotify
ORDER BY 1;

-- Q 3 Get the total number of tracks where licensed = True
-- Select Distinct licensed FROM spotiyfy

SELECT 
    SUM(Comments) AS tottal_comments
FROM
    spotify
WHERE
    Licensed = 'true';

-- Q 4  Find all Tracks that belong to the album  type single.
SELECT 
    *
FROM
    spotify
WHERE
    album_type = 'single';

-- 5 Count the total number of tracks by each artist. 

SELECT 
    artist, COUNT(*) AS total_no_songs
FROM
    spotify
GROUP BY artist
ORDER BY 2;


-- -----------------------------
-- Meadium  Level 
-- -----------------------------

SELECT 
    album, AVG(danceability) AS avg_danceabIlity
FROM
    spotify
GROUP BY 1
ORDER BY 2 DESC;

-- Q 2 Find the top 5 tracks with the highest eneergy values.alter

SELECT 
    track, MAX(energy)
FROM
    spotify
GROUP BY 1
ORDER BY 2
LIMIT 5;

-- Q 3 List th e all tracks along with their views and likes where and likes where official_vidio = True.

SELECT 
    track, SUM(views) AS total_views, SUM(likes) AS total_likes
FROM
    spotify
WHERE
    official_video = 'True'
GROUP BY 1
ORDER BY 2 DESC;

-- Q 4 for each album , calculate the total views of all associated tracks
            
SELECT 
    album, track, SUM(views)
FROM
    spotify
GROUP BY 1 , 2
ORDER BY 3;

-- ----------------------
-- Advanced  problem
-- ---------------------- 

-- Q 11 Find the top  3 most_viewed tracks for each artist using window functions.
-- each artists an total view for each track 
-- track with highest view for each artist need top
-- dense rank
-- cte and filder rank <=3 

WITH ranking_artist AS (
    SELECT
        artist, 
        track,
        SUM(views) AS total_view,
        DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS track_rank 
    FROM spotify
    GROUP BY artist, track
)
SELECT * 
FROM ranking_artist
WHERE track_rank <= 3
ORDER BY artist, track_rank;


-- Q 12 Weithe a quary to find tracks where the liveness score is above  the average 
SELECT 
    track, artist, Liveness
FROM
    spotify
WHERE
    Liveness > (SELECT 
            AVG(Liveness)
        FROM
            spotify);

-- 13  
-- Use a with clause to  calculate the difference  between the  
-- highest  and lowest energy values for tracks  in each album.
WITH  cte
AS
(SELECT
album,
MAX(energy) AS highest_energy,
MIN(energy)  AS lowest_energery
FROM spotify
GROUP BY 1 
)
SELECT  
album,
highest_energy  - lowest_energery AS energy_diff
FROM cte
ORDER BY 2 DESC;


-- Query Optimization 

explain analyze -- 
SELECT 
    Artist, Track, Views
FROM
    spotify
WHERE
    artist = 'Gorillaz'
        AND most_playedon = 'Youtube'
ORDER BY stream DESC
LIMIT 25;

select * from spotify




