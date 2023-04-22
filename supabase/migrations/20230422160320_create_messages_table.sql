create table messages (
    id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    chatroom_id uuid,
    owner_id uuid,
    content VARCHAR(25),
    created_at TIMESTAMPTZ DEFAULT now(),

    FOREIGN KEY (owner_id) REFERENCES users (id) ON DELETE SET NULL,
    FOREIGN KEY (chatroom_id) REFERENCES chatrooms (id) ON DELETE CASCADE
);