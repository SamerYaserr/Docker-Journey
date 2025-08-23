import express from "express";
import { Request, Response } from "express";

const app = express();

app.get("/", (req: Request, res: Response) =>
  res.send("<h1> Hello Samora!</h1>")
);

export default app;
