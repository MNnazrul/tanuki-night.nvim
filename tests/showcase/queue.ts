import { EventEmitter } from "node:events";

const MAX_RETRIES = 3;

export interface Job<T> {
  id: string;
  payload: T;
  attempts: number;
}

export class Queue<T> extends EventEmitter {
  private jobs: Job<T>[] = [];

  async run(handler: (job: Job<T>) => Promise<void>): Promise<void> {
    for (const job of this.jobs) {
      try {
        await handler(job);
        this.emit("done", job.id);
      } catch (err) {
        if (++job.attempts < MAX_RETRIES) this.jobs.push(job);
        else this.emit("failed", `${job.id}: ${err}`);
      }
    }
  }
}
