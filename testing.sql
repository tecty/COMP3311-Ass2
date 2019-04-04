-- select m.title, m.year, m.content_rating, r.imdb_score, namelist(g.genre)
-- from movie as m
-- join rating as r 
--     on r.movie_id = m.id
-- join genre as g 
--     on g.movie_id= m.id
-- where lower(title) like '%star war%' 
-- group by m.title, m.year, m.content_rating, r.imdb_score
-- order by m.year
-- ;


-- with g_movie as (
-- select movie_id, count(*)
-- from genre as g where g.genre in ('Action','Sci-Fi','Adventure') group by movie_id 
-- )
-- select distinct
-- m.title, m.year, m.content_rating, m.lang,
-- r.imdb_score, r.num_voted_users
-- from movie as m 
-- join rating as r on r.movie_id = m.id join g_movie as g on m.id = g.movie_id 
--   and g.count=3 where m.year >=2005 
-- and m.year<=2005
-- order by r.imdb_score desc, r.num_voted_users desc
-- limit 10;

-- select namelist(genre) 
-- from movie as m 
-- join genre as g 
--   on g.movie_id = m.id  
-- where lower(m.title)=lower('Happy Feet');


with g_movie as (
  select m.id, m.title, count(g2.*) as g_count from movie as m 
  left join genre as g2 
  on 
    g2.movie_id = m.id  and 
    g2.genre in 
    (select g.genre from genre as g 
    join movie as m 
    on 
      lower(m.title)=lower('Happy Feet') and
        m.id = g.movie_id
    )
  group by m.id, m.title
)

, k_movie as 
(
  select m.id, m.title, count(k2.*) as k_count from movie as m 
  left join keyword as k2 
  on 
    k2.movie_id = m.id  and 
    k2.keyword in 
    (select k.keyword from keyword as k 
    join movie as m 
    on 
      lower(m.title)=lower('Happy Feet') and
        m.id = k.movie_id
    )
  group by m.id, m.title
)

select 
  m.title, m.year, g.g_count, k.k_count, r.imdb_score, r.num_voted_users
from movie  as m 
-- similarity
join k_movie as k 
on k.id = m.id
join g_movie as g 
on g.id = m.id 
-- imdb rank and vote 
join rating as r
on r.movie_id = m.id 
where lower(m.title)<>lower('Happy Feet') 
order by 
  g.g_count desc,
  k.k_count desc,
  r.imdb_score desc,
  r.num_voted_users desc
;

-- select m.id, m.title, count(g2.*) as g_count from movie as m 
-- left join genre as g2 
-- on 
--   g2.movie_id = m.id  and 
--   g2.genre in 
--   (select g.genre from genre as g 
--   join movie as m 
--   on 
--     lower(m.title)=lower('Happy Feet') and
--       m.id = g.movie_id
--   )
-- group by m.id, m.title
-- ;