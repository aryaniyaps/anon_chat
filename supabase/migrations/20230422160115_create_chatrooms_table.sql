create table chatrooms (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(25),
    created_at TIMESTAMPTZ DEFAULT now()
);