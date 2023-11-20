use music;

### who is the senior most employee based on job title?##
select * from employee order by levels desc limit 1 ;

### which country have the most invoices?##
select count(*) as number_of_invoices,billing_country from invoice group by billing_country order by number_of_invoices desc limit 1;
### what are the top 3 values of total invoice?
select * from invoice order by total desc limit 3;
#### which country has the best customer? Return both city name and sum ofall invoice total? 
select billing_city,sum(total) as total_invoice from invoice group by billing_city order by total_invoice ;
###Who is the best customer? Write a query to return first name of the customer who has spent the most money?
select first_name,customer.customer_id, sum(total) as total_invoice from customer inner join invoice on customer.customer_id = invoice.customer_id group by first_name, customer.customer_id order by total_invoice desc limit 1;

## write a query to return first name,email ,genre of all rock music listners.Return your list ordered alphabetically by email.
select distinct first_name,last_name,email,genre.name  from customer
 inner join invoice on customer.customer_id = invoice.customer_id 
 inner join invoice_line on invoice.invoice_id = invoice_line.invoice_id 
 inner join track on track.track_id= invoice_line.track_id 
 inner join genre on genre.genre_id = track.genre_id where genre.name ='Rock'  order by email ;
 
## Let's invite the artist who has written the most rock music in dataset. write a query to return the artist name and total track count of top 10 rock bands
select artist.name,count(artist.artist_id) as number_of_songs, artist.artist_id from artist 
inner join album2 on artist.artist_id = album2.artist_id 
inner join track on track.album_id =album2.album_id 
inner join genre on track.genre_id = genre.genre_id 
where genre.name= 'Rock' group by  artist.name,artist.artist_id  order by number_of_songs desc limit 10 ;
## Return all the track names that have a song length more than the average song length. Return name and millisecond of each track
select name, milliseconds from track where milliseconds > (select avg(milliseconds) from track) order by milliseconds desc;
###Find how much money spent by artist on each customer? write a query to return customer_name,artist_name and total_spent

select customer.customer_id as customer_id, first_name as customer_name ,artist.name as artist_name, sum(invoice_line.unit_price* invoice_line.quantity) as total_spent from invoice_line
  inner join track on invoice_line.track_id=track.track_id
  inner join album2 on album2.album_id = track.album_id
  inner join artist on album2.artist_id = artist.artist_id
 inner join  invoice on invoice.invoice_id= invoice_line.invoice_id
 inner join customer on customer.customer_id = invoice.customer_id 
 group by customer_name,artist_name,customer_id
 order by total_spent desc;
 

### Find out the most popular music genre in each country
 
select genre.genre_id,genre.name,customer.country,count(invoice_line.quantity) as no_of_purchases from genre 
inner join track on genre.genre_id = track.genre_id
inner join invoice_line on invoice_line.track_id=track.track_id
 inner join  invoice on invoice.invoice_id= invoice_line.invoice_id
 inner join customer on customer.customer_id = invoice.customer_id
 group by genre.name,customer.country ,genre.genre_id 
 order by no_of_purchases desc ;
 
 ##write a query that returns the country along with top customer and how much they spent.
 
  
 with cust as (  select customer. first_name ,invoice.billing_country ,sum(total) as total_spent from customer
 inner join invoice on  invoice.customer_id = customer.customer_id
 group by customer. first_name ,invoice.billing_country 
order by total_spent desc),
country as (
select   billing_country, max(total_spent) as max_spent from cust 
group by cust.billing_country)

 select cust.billing_country,cust.total_spent,cust.first_name from cust
 
 join country ms
 on cust.billing_country = ms.billing_country
 where cust.total_spent = ms.max_spent
 order by total_spent desc




 