import app from "./app";
import env from "./config/env.config";

const PORT = env.PORT || 3000;

const DB_USER = "root";
const DB_PASSWORD = "example";
const DB_PORT = 27017;
const DB_HOST = "mongo";

const URL = `mongodb://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}`;

const server = app.listen(PORT, () => {
  console.log(`Server running on port: ${PORT}`);
});

export default server;
