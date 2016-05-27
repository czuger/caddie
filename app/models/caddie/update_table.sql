/* Don't forget to set the postgres sequence to cycle on production */
/* ALTER SEQUENCE caddie_crest_price_history_updates_id_seq CYCLE; */

/* TRUNCATE TABLE caddie_crest_price_history_updates; */

/* Insert new regions / items */
INSERT INTO caddie_crest_price_history_updates( eve_item_id, region_id, created_at, updated_at )
  SELECT eve_items.id, regions.id, now(), now()
  FROM eve_items, regions
  WHERE NOT EXISTS ( SELECT NULL FROM caddie_crest_price_history_updates WHERE eve_item_id = eve_items.id and region_id = regions.id );

/* Update all datas */
UPDATE caddie_crest_price_history_updates cphu
SET max_update = sub.mua, max_eve_item_create = sub.max_eve_item_create, max_region_create = sub.max_region_create
FROM (
SELECT DISTINCT eve_item_id, region_id, MAX( crest_price_histories.updated_at ) mua, MAX( eve_items.created_at ) max_eve_item_create, MAX( regions.created_at ) max_region_create
	FROM crest_price_histories, eve_items, regions
	WHERE eve_item_id = eve_items.id 
	AND region_id = regions.id
GROUP BY eve_item_id, region_id
) sub
WHERE cphu.eve_item_id = sub.eve_item_id
AND cphu.region_id = sub.region_id;

UPDATE caddie_crest_price_history_updates cphu SET max_date = GREATEST( max_update, max_eve_item_create, max_region_create );

UPDATE caddie_crest_price_history_updates cphu SET nb_days = ( CURRENT_DATE - max_date );

UPDATE caddie_crest_price_history_updates cphu
SET process_queue = 'DAILY', next_process_date = current_date, process_queue_priority = 1
WHERE nb_days <= 7;

UPDATE caddie_crest_price_history_updates cphu
SET process_queue = 'WEEKLY', next_process_date = date_trunc( 'week', ( current_date + ( interval '1 week' ) ) ), process_queue_priority = 2
WHERE nb_days <= 30 AND nb_days > 7;

UPDATE caddie_crest_price_history_updates cphu
SET process_queue = 'MONTHLY', next_process_date = date_trunc( 'month', ( current_date + ( interval '1 month' ) ) ), process_queue_priority = 3
WHERE nb_days > 30 OR nb_days IS NULL;