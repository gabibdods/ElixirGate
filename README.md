# ElixirGate

# Self-Hosted WebHost Service with Elixir

### Description

- This project implements a self-hosted dynamic web hosting service using Elixir
- It allows you to deploy and manage web applications (Django, PHP, Node.js, etc.) from your own Ubuntu Server while ensuring HTTPS support and strong process isolation
- It leverages the Phoenix framework or Plug, along with Cloudflare Tunnel, to securely expose services without public IP exposure
- This project is tailored for private, single-user environments running on legacy hardware

---

## NOTICE

- Please read through this `README.md` to better understand the project's source code and setup instructions.
- Also, make sure to review the contents of the `License/` directory.
- Your attention to these details is appreciated — enjoy exploring the project!

---

## Problem Statement

- Developers who own legacy computers and want a private, secure, single-tenant environment to host personal web services face challenges with traditional VPS solutions due to cost, complexity, and over-provisioning
- This project provides a lightweight, secure, and extensible Elixir-based hosting solution to deploy and manage dynamic applications

---

## Project Goals

### Private Dynamic Web Hosting with Reverse Proxy

- Enable private web hosting for dynamic sites with HTTPS support and reverse proxy capabilities

### Leveraging Elixir for Supervision and Orchestration

- Learn and apply Elixir's strengths in supervision, fault tolerance, and service orchestration in a real-world project

---

## Tools, Materials & Resources

### Elixir Toolchain & Supporting Packages

- Elixir, Phoenix (or Plug), Cowboy/Bandit, Cloudflared, Systemd

### Hosting Platform and Deployment Environment

- Ubuntu Server, legacy computer hardware

### Technical Documentation and References

- Phoenix Framework Docs, Plug Router Docs, Cloudflare Tunnel Documentation

---

## Design Decision

### Framework Modularity via Plug vs Phoenix

- Use Plug or Phoenix depending on desired feature complexity (minimalist router vs full admin dashboard)

### HTTPS via Cloudflare Tunnel for Zero Exposure

- Use Cloudflare Tunnel instead of Let's Encrypt to offload HTTPS and avoid opening firewall ports

### Backend Orchestration via System Command Execution

- Employ `System.cmd/1` to orchestrate backend frameworks such as Django, Node.js, and PHP, enabling unified process management

---

## Features

### Multi-Framework Reverse Proxy

- Reverse proxy support for Django, PHP, and Node.js apps via defined endpoint paths

### Unified Static and Dynamic Routing Engine

- Static and dynamic content routing using Plug.Router or Phoenix endpoint definitions

### Optional Admin Dashboard for Control and Monitoring

- Optional admin interface for controlling services, viewing logs, and registering site definitions

---

## Block Diagram

```plaintext
                              ┌─────────────────────────────┐
                              │        Cloudflare DNS       │
                              └──────────────┬──────────────┘
                                             ↓
                                  ┌──────────┴──────────┐
                                  │   cloudflared       │
                                  │  (TLS termination)  │
                                  └──────────┬──────────┘
                                             ↓
                             ┌───────────────┴───────────────┐
                             │      Elixir Reverse Proxy      │
                             │  (Plug.Router or Phoenix App)  │
                             └────────┬──────────┬────────────┘
                                      ↓          ↓
                         ┌────────────┘   ┌────────────┐
                         ↓                ↓            ↓
                 ┌────────────┐   ┌────────────┐ ┌────────────┐
                 │ Django App │   │ Node App   │ │ PHP Server │
                 └────────────┘   └────────────┘ └────────────┘

```

---

## Functional Overview

- This system runs an Elixir-based reverse proxy service that listens on port 4000 and forwards HTTP requests to backend applications based on configured routes
- All external traffic is tunneled through Cloudflare for HTTPS
- It offers optional admin interfaces to register services, define ports, and monitor logs

---

## Challenges & Solutions

### Secure HTTPS without exposing public ports

- Cloudflare Tunnel (cloudflared) enables HTTPS without NAT or firewall modifications

### Managing heterogeneous application types

- Unified Elixir interface with service descriptors and System.cmd/1 abstracts away differences

---

## Lessons Learned

### Leveraging Elixir Supervision for External Process Management

- Elixir’s process supervision model provides a resilient base for orchestrating external systems

### Minimalist Proxying with Plug for Dynamic Routing

- Plug provides a powerful yet minimalist way to handle dynamic routing and proxying without unnecessary overhead

---

## Project Structure

```plaintext
root/
├── License/
│   ├── LICENSE.md
│   │
│   └── NOTICE.md
│
├── .gitattributes
│
├── .gitignore
│
└── README.md

```

---

## Future Enhancements

- Add support for service health monitoring and auto-restart
- Build a full Phoenix LiveView admin dashboard for runtime control
- Support service templates to simplify adding new backend apps
- Add remote management through authenticated API
- Integrate PostgreSQL or ETS-based configuration database
