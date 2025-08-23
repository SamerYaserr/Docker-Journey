import dotenv from "dotenv";
import env from "env-var";

dotenv.config({ path: "./.env", quiet: true });

export default {
  PORT: env.get("PORT").required().asPortNumber(),
};
