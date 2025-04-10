import { Router, Request, Response } from 'express';
import { Task } from '../models/task';
import opentelemetry from '@opentelemetry/api';
import { trace, Span, context } from '@opentelemetry/api';
const router = Router();
let tasks: Task[] = [];

const tracer = opentelemetry.trace.getTracer(
  'express-application',
  '0.1.0',
);

router.post('/', (req: Request, res: Response) => {
  const task: Task = {
    id: tasks.length + 1,
    title: req.body.title,
    description: req.body.description,
    completed: false,
  };

  tasks.push(task);
  res.status(500).json({
    message: "internal server error"
  });
});

router.get('/', (req: Request, res: Response) => {
  const span = trace.getSpan(context.active());
  span?.addEvent('Something happened!');
  res.json(tasks);
});

router.get('/:id', (req: Request, res: Response) => {
  const task = tasks.find((t) => t.id === parseInt(req.params.id));

  if (!task) {
    res.status(404).send('Task not found');
  } else {
    res.json(task);
  }
});

router.put('/:id', (req: Request, res: Response) => {
  const task = tasks.find((t) => t.id === parseInt(req.params.id));

  if (!task) {
    res.status(404).send('Task not found');
  } else {
    task.title = req.body.title || task.title;
    task.description = req.body.description || task.description;
    task.completed = req.body.completed || task.completed;

    res.json(task);
  }
});

router.delete('/:id', (req: Request, res: Response) => {
  const index = tasks.findIndex((t) => t.id === parseInt(req.params.id));

  if (index === -1) {
    res.status(404).send('Task not found');
  } else {
    tasks.splice(index, 1);
    res.status(204).send();
  }
});
export default router;
