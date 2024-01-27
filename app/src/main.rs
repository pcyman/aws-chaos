use actix_web::{get,  App, HttpResponse, HttpServer, Responder};
use serde::Serialize;
use sysinfo::System;

#[derive(Serialize)]
struct SystemResponse {
    kernel: String,
    free_memory: u64,
    cpu_usage: f32
}

#[get("/healthcheck")]
async fn healthcheck() -> impl Responder {
    HttpResponse::Ok()
}

#[get("/")]
async fn system() -> impl Responder {
    let mut sys = System::new_all();
    sys.refresh_memory();
    sys.refresh_cpu_usage();
    sys.global_cpu_info().cpu_usage();

    let a = SystemResponse{
        kernel: System::kernel_version().unwrap(),
        free_memory: sys.available_memory() / 1000000, // in MB
        cpu_usage: sys.global_cpu_info().cpu_usage()
    };
    HttpResponse::Ok().json(a)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(system)
            .service(healthcheck)
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}
