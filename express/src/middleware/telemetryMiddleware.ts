import { Request, Response, NextFunction } from 'express';
import { context, trace, SpanStatusCode, metrics } from '@opentelemetry/api';

const tracer = trace.getTracer('express-application', '1.0.0');
const meter = metrics.getMeter('express-application');

const totalRequestsCounter = meter.createCounter('http_requests_total', {
  description: 'Total number of HTTP requests received',
});

const successfulRequestsCounter = meter.createCounter('http_requests_success', {
  description: 'Total number of successful (2xx and 3xx) HTTP responses sent by the server',
});

const failedRequestsCounter = meter.createCounter('http_requests_fail', {
  description: 'Total number of failed (4xx and 5xx) HTTP responses sent by the server',
});

export function telemetryMiddleware(req: Request, res: Response, next: NextFunction) {
  const safeHeaders = { ...req.headers };
  if (safeHeaders.authorization) {
    safeHeaders.authorization = '[REDACTED]';
  }

  const span = tracer.startSpan(`HTTP ${req.method}`, {
    attributes: {
      'http.method': req.method,
      'http.url': req.url,
      'http.path': req.path,
      'request.http.headers': JSON.stringify(safeHeaders),
    },
  }, context.active());

  context.with(trace.setSpan(context.active(), span), () => {
    totalRequestsCounter.add(1, {
      method: req.method,
      path: req.path,
      route: req.route?.path || 'unknown',
    });

    res.on('finish', () => {
      span.setAttribute('http.status_code', res.statusCode);
      span.setAttribute('response.http.headers', JSON.stringify(res.getHeaders()))
      if (res.statusCode >= 400) {
        span.setStatus({ code: SpanStatusCode.ERROR });
        failedRequestsCounter.add(1, {
          method: req.method,
          path: req.path,
          route: req.route?.path || 'unknown',
        });
      } else {
        span.setStatus({ code: SpanStatusCode.OK });
        successfulRequestsCounter.add(1, {
          method: req.method,
          path: req.path,
          route: req.route?.path || 'unknown',
        });
      }
      span.end();
    });

    next();
  });
}

