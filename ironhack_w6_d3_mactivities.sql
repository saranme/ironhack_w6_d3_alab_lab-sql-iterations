/* IRONHACK W6 D3 Mactivities
Create a procedure that takes as an input a district name and outputs 
the total loss in that district. Try it with "Kutna Hora".
*/
Use sakila;
delimiter //
create procedure number_of_rows_proc (out param1 int) -- Within paretheses the OUTPUT of the procedure
begin
select COUNT(*) into param1 from address;
end;
//
delimiter ;
-- Creating an stored procedure
delimiter //
create procedure number_of_rows_proc (out param1 int) -- Within paretheses the OUTPUT of the procedure
begin
select COUNT(*) into param1 from bank.account;
end;
//
delimiter ;

call number_of_rows_proc(@x);
select @x as 'Number_of_accounts';
--
drop procedure if exists loss_per_district;
delimiter //
create procedure loss_per_district (in param1 varchar(20), out param2 float) -- Within paretheses the OUTPUT of the procedure
begin
select SUM(p.amount) total_loss, a.district
from rental r
join payment p
on r.rental_id = p.rental_id
JOIN customer c
ON c.customer_id = p.customer_id
JOIN address a
ON a.address_id = c.address_id
where r.return_date is null and (a.district  COLLATE utf8mb4_general_ci = param1)
GROUP BY 2;
end;
//
delimiter ;

call loss_per_district('Nagasaki',@x);
select @x as 'Kutna Hora';
--
/*
drop procedure if exists total_loss;

delimiter //
create procedure total_loss (in param1 char(50),out param2 float)
begin
  select round(sum(l.amount - l.payments),2) into param2 from district as d
  join account as a 
  on d.a1 = a.district_id
  join loan as l using (account_id)
  where d.a2 COLLATE utf8mb4_general_ci = param1;
end;
//
delimiter ;

call total_loss('Kutna Hora',@x);
select round(@x,2) as loss_per_kutna_hora;
*/

drop procedure if exists loss_per_district;
delimiter //
create procedure loss_per_district (in param1 varchar(20), out param2 float) -- Within paretheses the OUTPUT of the procedure
begin
select SUM(p.amount) into param2
from rental r
join payment p
on r.rental_id = p.rental_id
JOIN customer c
ON c.customer_id = p.customer_id
JOIN address a
ON a.address_id = c.address_id
where r.return_date is null and (a.district  COLLATE utf8mb4_general_ci = param1)
GROUP BY a.district;
end;
//
delimiter ;

call loss_per_district('California',@x);
select @x as 'California';

/* Activity 02*/
drop procedure if exists total_loss;

delimiter //
create procedure total_loss ()
begin
  declare param2 char(50);
  select round(sum(l.amount - l.payments),2) into param2 
  from district as d
  join account as a 
  on d.a1 = a.district_id
  join loan as l using (account_id);
  select param2;
end;
//
delimiter ;

call total_loss();

show procedure status;
show function status;

show procedure status where Db = 'sakila';
#########

drop procedure if exists average_loss_proc;

delimiter //
create procedure average_loss_proc ()
begin
  declare avg_loss float default 0.0; -- Declaring a variable inside the procedure. With default we set the default value.
  select round((sum(amount) - sum(payments))/count(*), 2) into avg_loss
  from bank.loan
  where status = "B";
  select avg_loss;
  set avg_loss = 0.0; -- Reseting the value
end;
//
delimiter ;

call average_loss_proc();

show procedure status;
show function status;

show procedure status where Db = 'bank';
