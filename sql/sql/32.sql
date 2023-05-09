-- Info, explore diff between made_date and date_made_date

SELECT guid,
  verbatim_date, 
  began_date, 
  made_date, 
  TO_CHAR(date_made_date::date, 'YYYY-MM-DD') as d_m_d, 
  TO_CHAR(entereddate::date, 'YYYY-MM-DD') as ed 
FROM flat WHERE 
  guid ~ 'UAM:Herb' AND 
  began_date != made_date AND
  began_date != '1800-01-01' AND
  made_date < TO_CHAR(date_made_date::date, 'YYYY-MM-DD') AND 
  TO_CHAR(date_made_date::date, 'YYYY-MM-DD')
    != TO_CHAR(entereddate::date, 'YYYY-MM-DD')
LIMIT 10;
