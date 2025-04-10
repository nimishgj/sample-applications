from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry import trace
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import (
    BatchSpanProcessor,
    ConsoleSpanExporter,

)
from opentelemetry.instrumentation.requests import RequestsInstrumentor
import requests

from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter

from .routers import post, user, auth, vote

trace.set_tracer_provider(
    TracerProvider(
        resource=Resource.create({"service.name": "fastapi-service"})
    )
)
trace.get_tracer_provider().add_span_processor(
    BatchSpanProcessor(OTLPSpanExporter(endpoint="http://0.0.0.0:4318/v1/traces"))
)
trace.get_tracer_provider().add_span_processor(
    BatchSpanProcessor(ConsoleSpanExporter())
)

app = FastAPI()
FastAPIInstrumentor.instrument_app(app)
RequestsInstrumentor().instrument()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(post.router)
app.include_router(user.router)
app.include_router(auth.router)
app.include_router(vote.router)


@app.get("/")
def root():
    return {"message": "Hello World"}

@app.get("/external")
def external():

    tracer = trace.get_tracer(__name__)
    parent_span = trace.get_current_span()

    with tracer.start_as_current_span("external-http-call", context=trace.set_span_in_context(parent_span)) as span:
        span.set_attribute("http.url", "https://infraspec.dev")
        response = requests.get("https://infraspec.dev")
        span.set_attribute("http.status_code", response.status_code)
        return {
            "status_code": response.status_code,
            "response_headers": dict(response.headers),
        }
