import './utils/telemetry';
import express, { Request, Response, NextFunction } from 'express';
import cors from 'cors'; // 👈 import cors
import taskRoutes from './routes/task';

import { telemetryMiddleware } from './middleware/telemetryMiddleware';

const app = express();
const port = 3005;

app.use(cors({
  origin: '*', // Allow all origins
  exposedHeaders: '*', // Expose all headers to browser (optional)
}));


app.use(express.json());
app.use(telemetryMiddleware);
app.use('/tasks', taskRoutes);

app.get('/', (req: Request, res: Response) => {
  res.send('Hello, TypeScript Express!');
});

app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error(err.stack);
  res.status(500).send('Something went wrong');
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});

