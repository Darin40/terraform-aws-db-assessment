WITH generated_bookings AS (
  SELECT
    gen_random_uuid() AS id,
    (ARRAY[
      '11111111-1111-1111-1111-111111111111',
      '22222222-2222-2222-2222-222222222222',
      '33333333-3333-3333-3333-333333333333',
      '44444444-4444-4444-4444-444444444444',
      '55555555-5555-5555-5555-555555555555'
    ])[1 + ((gs - 1) % 5)]::UUID AS org_id,
    format('hotel-%s', 1 + ((gs - 1) % 12)) AS hotel_id,
    (ARRAY['delhi', 'mumbai', 'bangalore', 'chennai', 'jaipur'])[1 + ((gs - 1) % 5)] AS city,
    CURRENT_DATE + ((gs - 1) % 20) AS checkin_date,
    CURRENT_DATE + ((gs - 1) % 20) + (1 + ((gs - 1) % 6)) AS checkout_date,
    ROUND((90 + ((gs * 17) % 400) + (((gs * 7) % 100) / 100.0))::NUMERIC, 2) AS amount,
    (ARRAY['confirmed', 'cancelled', 'pending', 'completed'])[1 + ((gs - 1) % 4)] AS status,
    NOW()
      - (((gs * 7) % 45) || ' days')::INTERVAL
      - (((gs * 13) % 24) || ' hours')::INTERVAL AS created_at
  FROM generate_series(1, 150) AS gs
)
INSERT INTO hotel_bookings (
  id,
  org_id,
  hotel_id,
  city,
  checkin_date,
  checkout_date,
  amount,
  status,
  created_at
)
SELECT
  id,
  org_id,
  hotel_id,
  city,
  checkin_date,
  checkout_date,
  amount,
  status,
  created_at
FROM generated_bookings;

INSERT INTO booking_events (booking_id, event_type, payload, created_at)
SELECT
  hb.id,
  'booking_created',
  jsonb_build_object(
    'seeded', true,
    'status', hb.status,
    'city', hb.city,
    'hotel_id', hb.hotel_id
  ),
  hb.created_at + INTERVAL '15 minutes'
FROM hotel_bookings hb
WHERE MOD(ABS(hashtext(hb.id::TEXT)), 2) = 0;

INSERT INTO booking_events (booking_id, event_type, payload, created_at)
SELECT
  hb.id,
  'status_checked',
  jsonb_build_object(
    'seeded', true,
    'current_status', hb.status,
    'org_id', hb.org_id
  ),
  hb.created_at + INTERVAL '2 hours'
FROM hotel_bookings hb
WHERE MOD(ABS(hashtext(hb.id::TEXT)), 3) = 0;
