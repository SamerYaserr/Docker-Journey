import express from "express";
import { Request, Response } from "express";
import { createClient } from "redis";

const app = express();

const REDIS_PORT = 6379;
const REDIS_HOST = "redis";

const redisClient = createClient({
  url: `redis://${REDIS_HOST}:${REDIS_PORT}`,
});

redisClient.on("error", (err) => console.log("Redis Client Error", err));
redisClient.on("connect", () => console.log("Connected to Redis"));
redisClient.connect();

app.get("/", async (req: Request, res: Response) => {
  await redisClient.set("reply", "Hello from Redis!");
  res.send("<h1> Hello Samora!</h1>");
});

app.get("/data", async (req: Request, res: Response) => {
  let message: string = "<h1> Hello Samora!</h1>";
  await redisClient.get("reply").then((reply) => {
    message = message + "<h2>" + reply + "</h2>";
  });

  res.send(message);
});
export default app;
