INSERT INTO tb_user (name, email, password)
SELECT 'Nina Brown', 'nina@gmail.com', '$2a$10$NYFZ/8WaQ3Qb6FCs.00jce4nxX9w7AkgWVsQCG6oUwTAcZqP9Flqu'
WHERE NOT EXISTS (
  SELECT 1 FROM tb_user WHERE email = 'nina@gmail.com'
);

INSERT INTO tb_user (name, email, password)
SELECT 'Leia Red', 'leia@gmail.com', '$2a$10$NYFZ/8WaQ3Qb6FCs.00jce4nxX9w7AkgWVsQCG6oUwTAcZqP9Flqu'
WHERE NOT EXISTS (
  SELECT 1 FROM tb_user WHERE email = 'leia@gmail.com'
);

INSERT INTO tb_role (role_name)
SELECT 'ROLE_OPERATOR'
WHERE NOT EXISTS (
  SELECT 1 FROM tb_role WHERE role_name = 'ROLE_OPERATOR'
);

INSERT INTO tb_role (role_name)
SELECT 'ROLE_ADMIN'
WHERE NOT EXISTS (
  SELECT 1 FROM tb_role WHERE role_name = 'ROLE_ADMIN'
);

INSERT INTO tb_user_role (user_id, role_id)
SELECT u.id, r.id
FROM tb_user u
JOIN tb_role r ON r.role_name = 'ROLE_OPERATOR'
WHERE u.email = 'nina@gmail.com'
  AND NOT EXISTS (
    SELECT 1
    FROM tb_user_role ur
    WHERE ur.user_id = u.id
      AND ur.role_id = r.id
  );

INSERT INTO tb_user_role (user_id, role_id)
SELECT u.id, r.id
FROM tb_user u
JOIN tb_role r ON r.role_name = 'ROLE_OPERATOR'
WHERE u.email = 'leia@gmail.com'
  AND NOT EXISTS (
    SELECT 1
    FROM tb_user_role ur
    WHERE ur.user_id = u.id
      AND ur.role_id = r.id
  );

INSERT INTO tb_user_role (user_id, role_id)
SELECT u.id, r.id
FROM tb_user u
JOIN tb_role r ON r.role_name = 'ROLE_ADMIN'
WHERE u.email = 'leia@gmail.com'
  AND NOT EXISTS (
    SELECT 1
    FROM tb_user_role ur
    WHERE ur.user_id = u.id
      AND ur.role_id = r.id
  );
