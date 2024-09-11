import pg from "pg"

export const pool = new pg.Pool({
    user: "postgres",
    host: "localhost",
    password: "123",
    database: "PolizaSeguro",
    port: "5432"
})

