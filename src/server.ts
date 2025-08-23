import app from "./app";
import env from "./config/env.config";

const PORT = env.PORT || 3000;

const server = app.listen(PORT, () => {
  console.log(`Server running on port: ${PORT}`);
});

export default server;
