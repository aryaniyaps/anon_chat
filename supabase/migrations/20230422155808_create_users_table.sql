create table users (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    username VARCHAR(25),
    created_at TIMESTAMPTZ DEFAULT now()
);