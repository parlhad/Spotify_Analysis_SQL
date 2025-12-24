# 🎧 Spotify SQL Data Analysis Project

---

## How many rows are in the table?
```sql
SELECT COUNT(*) FROM spotify;
```

## How many albums are there?
```sql
SELECT COUNT(DISTINCT album) FROM spotify;
```

## How many artists are there?
```sql
SELECT COUNT(DISTINCT artist) FROM spotify;
```

## How many types of albums are there?
```sql
SELECT DISTINCT album_type FROM spotify;
```

## Find maximum and minimum song duration
```sql
SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;
```

## Find songs with zero duration
```sql
SELECT * 
FROM spotify
WHERE duration_min = 0;
```

## Delete songs with zero duration
```sql
DELETE FROM spotify
WHERE duration_min = 0;
```

## How many channels are there?
```sql
SELECT DISTINCT channel FROM spotify;
SELECT COUNT(DISTINCT channel) FROM spotify;
```

## Most played platforms
```sql
SELECT DISTINCT most_played_on FROM spotify;
```

---

## Q1 Retrieve the name of all tracks that have more than 1 billion streams
```sql
SELECT track 
FROM spotify
WHERE stream > 1000000000;
```

## Q2 List all the albums along with their respective artists
```sql
SELECT DISTINCT album, artist
FROM spotify
ORDER BY album;
```

## Q3 Get the total number of comments for tracks where licensed is TRUE
```sql
SELECT SUM(comments) AS total_comments
FROM spotify
WHERE licensed = TRUE;
```

## Q4 Find all tracks that belong to album type SINGLE
```sql
SELECT track
FROM spotify
WHERE album_type = 'single';
```

## Q5 Count the total number of tracks by each artist
```sql
SELECT artist, COUNT(track) AS total_no_song
FROM spotify
GROUP BY artist
ORDER BY total_no_song;
```

---

## Q6 Calculate the average danceability of each album
```sql
SELECT album,
       AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;
```

## Q7 Find the top 5 tracks with highest energy
```sql
SELECT track, energy
FROM spotify
GROUP BY track, energy
ORDER BY energy DESC
LIMIT 5;
```

## Q8 List tracks with total views and likes where official_video is TRUE
```sql
SELECT track,
       SUM(views) AS total_views,
       SUM(likes) AS total_likes
FROM spotify
WHERE official_video = TRUE
GROUP BY track;
```

## Q9 Calculate total views for each album and its tracks
```sql
SELECT album,
       track,
       SUM(views) AS total_views
FROM spotify
GROUP BY album, track
ORDER BY total_views DESC;
```

## Q10 Retrieve tracks streamed more on Spotify than YouTube
```sql
SELECT *
FROM (
    SELECT track,
           COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS streamed_on_youtube,
           COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS streamed_on_spotify
    FROM spotify
    GROUP BY track
) t
WHERE streamed_on_spotify > streamed_on_youtube
  AND streamed_on_youtube <> 0
ORDER BY streamed_on_spotify DESC
LIMIT 1;
```

---

## Q11 Find top 3 most viewed tracks for each artist using window function
```sql
WITH ranking_artist AS (
    SELECT artist,
           track,
           SUM(views) AS most_viewed,
           DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
    FROM spotify
    GROUP BY artist, track
)
SELECT *
FROM ranking_artist
WHERE rank <= 3;
```

## Q12 Find tracks where liveness is above average
```sql
SELECT track, liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```

## Q13 Calculate energy difference (max - min) for each album
```sql
WITH cte AS (
    SELECT album,
           MAX(energy) AS highest_energy,
           MIN(energy) AS lowest_energy
    FROM spotify
    GROUP BY album
)
SELECT album,
       highest_energy - lowest_energy AS energy_diff
FROM cte;
```

## Q14 Find top 5 artists based on average popularity having at least 3 songs
```sql
WITH ranking_artist AS (
    SELECT artist,
           track,
           SUM(stream) AS most_viewed,
           DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(stream) DESC) AS rank
    FROM spotify
    GROUP BY artist, track
)
SELECT DISTINCT artist
FROM ranking_artist
WHERE rank <= 3
ORDER BY artist
LIMIT 5;
```

## Q15 Identify songs where energy is above average and danceability is below average
```sql
SELECT track, artist, energy, danceability
FROM spotify
WHERE energy > (SELECT AVG(energy) FROM spotify)
  AND danceability < (SELECT AVG(danceability) FROM spotify);
```

## Q16 Classify songs based on duration
```sql
SELECT track,
       duration_min,
       CASE
           WHEN duration_min < 3 THEN 'Short'
           WHEN duration_min > 3 AND duration_min < 4.5 THEN 'Medium'
           ELSE 'Long'
       END AS classification_song
FROM spotify;
```

---
