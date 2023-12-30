create database music_database;
use music_database;
-- Q1: who is the senior most employee based on job title?
select * from employee;
select * from employee
order by levels desc
limit 1;

-- Q2: which countries have the most invoices?
select * from invoice;
select billing_country, count(billing_country) from invoice
group by billing_country
order by count(billing_country) desc;

-- Q3: what are top 3 values of total invoice
select (total) from invoice
order by total desc
limit 3;

-- Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice total. Return both the city name & sum of all invoice totals
select * from invoice;
select billing_city,sum(total)as Invoice_toal from invoice
group by billing_city
order by sum(total) desc
limit 1;

-- Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the 
-- person who has spent the most money

select customer.customer_id,customer.first_name,customer.last_name,sum(invoice.total )as total from customer
inner join invoice
on customer.customer_id=invoice.customer_id
group by customer.customer_id,customer.first_name,customer.last_name
order by total desc
limit 1;

-- Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A

select customer.email,customer.first_name,customer.last_name,genre.name  from customer
inner join invoice on customer.customer_id=invoice.customer_id
inner join invoice_line on invoice_line.invoice_id=invoice.invoice_id
inner join track on track.track_id=invoice_line.track_id
inner join genre on genre.genre_id=track.genre_id
where genre.name="rock"
order by email;


-- Q7: Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands

select artist.artist_id,artist.name,count(artist.artist_id)from artist
inner join album2 on album2.artist_id=artist.artist_id
inner join track on track.album_id=album2.album_id
inner join genre on genre.genre_id=track.genre_id
where genre.name like "rock"
group by artist.artist_id,artist.name
order by count(artist.artist_id) desc
limit 10;

-- Q8: Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. 
-- Order by the song length with the longest songs listed first. 

select name,milliseconds from track
where milliseconds>(select avg(milliseconds) from track)
order by milliseconds desc;

-- Q9: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent

with best_selling_artist as (
select artist.artist_id as artist_id,artist.name as artist_name,sum(invoice_line.unit_price*invoice_line.quantity)as total_sales 
from invoice_line
join track on track.track_id=invoice_line.track_id
join album2 on album2.album_id=track.album_id
join artist on artist.artist_id = album2.artist_id
group by artist_id,artist_name
order by total_sales desc
limit 1
)
select customer.customer_id,customer.first_name, customer.last_name, best_selling_artist.artist_name,sum(invoice_line.unit_price*invoice_line.quantity) as amount_spent
from invoice
join customer on customer.customer_id=invoice.customer_id
join invoice_line on invoice_line.invoice_id=invoice.invoice_id 
join track on track.track_id=invoice_line.track_id
join album2 on album2.album_id=track.album_id
join best_selling_artist on best_selling_artist.artist_id=album2.artist_id
group by 1,2,3,4
order by 5 desc;

-- Q10: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest
-- amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is
-- shared return all Genres
with most_popular_genre as (
select customer.country,genre.genre_id,genre.name as genre,count(invoice_line.quantity) as Purchases,row_number() over(partition by customer.country order by count(invoice_line.quantity)desc) as row_no
from customer
join invoice on invoice.customer_id=customer.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id
group by genre.genre_id,genre,customer.country
order by customer.country asc, purchases desc
)
select * from most_popular_genre
where row_no <=1;

-- Q11: Write a query that determines the customer that has spent the most on music for each county. Write a query that returns the country along
-- with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount

with Spent_most_on_country as(
select customer.first_name,customer.last_name,invoice.billing_country,sum(invoice.total), row_number() over(partition by invoice.billing_country order by sum(invoice.total)desc)as row_no
from customer 
join invoice on customer.customer_id=invoice.customer_id
group by customer.first_name,customer.last_name,invoice.billing_country
order by invoice.billing_country asc,sum(invoice.total) desc
)
select * from Spent_most_on_country
where row_no <=1;




















