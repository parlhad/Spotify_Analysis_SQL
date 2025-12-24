select * from spotify
--EDA 

-- HOW MANY ROWS ARE IN THE TABLE 
SELECT count(*) FROM spotify;

--HOW MANY NO.OF ALBUMS ARE THEIR
SELECT COUNT(DISTINCT album) from spotify;

-- HW MANY NO. OF ARTIST 
SELECT COUNT(DISTINCT artist) FROM spotify;

-- HOW MANY TYPES OF ALBUM 
SELECT DISTINCT album_type from spotify;

-- MAXIMUM & MINIMUN DURATI0N 

SELECT MAX(duration_min) from spotify;

SELECT MIN(duration_min) from spotify;

-- CHECKING AND DELETING THE 0 DURATION SONG DATA 

SELECT * FROM spotify 
where duration_min = 0;

DELETE  FROM spotify
WHERE duration_min = 0;

-- HOW MANY CHANELS ARE THEIR

SELECT DISTINCT channel FROM spotify;
SELECT count(DISTINCT channel) FROM spotify; --6673

--MOST PLAYED SONG ON 

SELECT  distinct most_played_on FROM spotify;

-----------------------

SELECT * FROM spotify;

------------Data Analysis Part 1 -----------

--Q1 RETRIVE THE NAME OF ALL TRACKS THAT HAVE MORE THAN 1 BILLION STREAMS.
  
SELECT track FROM spotify
where stream > 1000000000;

--Q2 LIST ALL THE ALBUM ALONG WITH THEIR RESPECTIVE ARTIST 

SELECT DISTINCT album,artist 
FROM spotify
order by album;

SELECT DISTINCT album 
FROM spotify
order by album;
-- Q3 GET THE TOTALE NUMBER Of COMMENTSFOR TRACKS WHERE LICENCESED = TRUE

SELECT 
SUM(comments) as totle_number
FROM spotify
WHERE licensed = true;


--Q4 FIND ALL THE TRACKS THAT BELONG TO THE ALBUM TYPE SINGLE .
SELECT track FROM spotify
WHERE album_type = 'single';

--Q5 COUNT THE TOTAL NUMBER OF TRACKS BY EACH ARTIST

SELECT artist,COUNT(track) as totale_no_song
FROM spotify
group by artist
order by totale_no_song; 

------------Data Analysis Part 2 -----------

--Q6 CALCULATE THE AVERAGE danceability OF EACH ALBUM.

SELECT  album,
AVG(danceability) AVG_danceability
FROM spotify 
GROUP BY album
ORDER BY AVG_danceability DESC ;

--Q7 FIND THE TOP 5 TRACK WITH HIGHEST ENERGY VALUE.

SELECT track,energy FROM spotify
group by track,energy
order by energy desc 
limit  5;

--Q8 LIST ALL THE TRACKS ALONG WITH THEIR VIEW AND LIKES WHERE OFFICIAL_VIDEO = TRUE.

SELECT 
track,
sum(views) as total_viws,
sum(likes) as total_likes
FROM spotify
WHERE official_video = 'true'
group by track;

--Q9 FOR ALL EACH ALBUM ,CALCULATE THE TOTAL NUMBER OF VIEWS OF ALL ASSOCIATED TRACKS.
SELECT album,
       track,
       SUM(views) as total_views
FROM spotify
group by album,track
order by total_views desc;

--Q10  RETRIVE THE TRACK NAME THAT HAVE BEEN STREAMED ON SPOTIFY MORE THAN A YOUTUBE 

SELECT track,most_played_on,stream
FROM spotify 
WHERE stream > (Select MAX(stream) as yt_mps 
                        FROM spotify
						where most_played_on = 'Youtube');

SELECT track,most_played_on,stream
FROM spotify
order by stream desc limit 5;
--2

SELECT  * FROM 
(
 SELECT 
 track,
  COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END ),0) as streamed_on_youtube,
  COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END ),0) as streamed_on_spotify
  FROM spotify
  GROUP BY track
) as t1
WHERE streamed_on_spotify > streamed_on_youtube
 AND streamed_on_youtube <> 0
 ORDER BY streamed_on_spotify desc limit 1;

						
---------part 3 ---------------------

----Q11  FIND THE TOP 3 MOST VIWED TRACKS FOR EACH ARTIST USING WINDOW FUNCTION

-- in this we want to show for ech artist top viwed track 
   --each artist and totale view for each track
   --track with h9iighest view for each artits ( top 3)
   --dense rank
   --cte & filter  rank <= 3

WITH ranking_artist 
AS (
 SELECT artist,
 track ,
 SUM(views) as most_viewed,
 DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank
FROM spotify
group by artist,track
order by artist , most_viewed DESC 
)
SELECT * 
FROM ranking_artist
WHERE rank <=3;

--Q 12 WRITE A QUERY TO FIND TRACKS WHERE LIVENESS SCORE IS ABOVE THE AVERAGE .
SELECT * 
FROM spotify

SELECT track,liveness 
FROM spotify
WHERE  liveness >  (SELECT AVG(liveness)
                            FROM spotify);

-- Q 13 use a WITH Clause  to calculate  the diffrence between the highest and lowest energy value for tracks
--in each album
WITH cte
as(
SELECT 
      album,
	  MAX(energy) As highest_energy,
	  MIN(energy) As lowest_energy
FROM spotify
group BY album
)
SELECT album,
       highest_energy - lowest_energy AS Enregy_Diff
FROM cte


----