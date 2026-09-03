# Hi, my name is Aykut 👋

This repository is a hands-on project where I explore how a traditional monolithic application can be prepared for a gradual transition to a more scalable and reliable architecture.

The project contains a fully functional e-commerce application built with Django and PostgreSQL. It includes a product catalog, shopping cart, order management, payment processing, user accounts, and sales reporting. The application currently runs as a single unit, which makes it a useful starting point for studying the challenges of moving from a monolith toward microservices.

## Project Goal

My goal is to improve the infrastructure around the application without changing its existing business logic. The work focuses on making the system easier to deploy, monitor, back up, update, secure, and scale.

Some of the main topics covered in this repository are:

- automated and zero-downtime deployments
- high availability and automatic scaling
- monitoring, logging, and alerting
- database and file backups with recovery testing
- secure management of secrets and access permissions
- service health checks and performance visibility
- isolating resource-heavy workloads such as reporting
- documenting the system so it can be maintained by others

The detailed infrastructure requirements are listed in [`tasks.md`](tasks.md).

## Running the Application

Docker and Docker Compose are required. The application and its setup instructions are located in the [`strangler-lab`](strangler-lab/) directory.

```bash
cd strangler-lab
docker compose up --build
```

After the containers start, the application is available at `http://localhost:8000`.

For sample data, test accounts, load-testing instructions, and more technical details, see the [application README](strangler-lab/README.md).

## Approach

There is no single correct solution for this project. The tools and architecture can evolve as long as they address the requirements in a clear, maintainable, and measurable way. The repository is intended to document that journey and the decisions made along the way.
