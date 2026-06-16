# AIDA

AIDA is an AI assistant platform that I started to better understand how modern AI applications are built.

Initially, the goal was simple: create a chatbot using OpenAI's API and provide custom context from Firestore. As I kept building, the project naturally grew into something much bigger. Instead of having a single hardcoded chatbot, users can create accounts, manage their own contexts, and build personalized AI assistants around their own knowledge and instructions.

The project has become a playground for learning and implementing real-world concepts such as authentication, authorization, backend architecture, database design, AI integration, and scalable application development.

---

## Tech Stack

`Flutter` · `Riverpod` · `Node.js` · `Express.js` · `Firebase Authentication` · `Cloud Firestore` · `OpenAI API` · `JWT` · `Resend`

---

## What AIDA Can Do

### AI Conversations

* Chat with an AI assistant powered by OpenAI models
* Generate responses using user-provided context
* Maintain conversation history
* Support personalized assistant behavior

### Authentication

* Email & Password Sign In
* Google Sign In
* JWT-based authorization
* OTP verification flow

### Context Management

Users can manage their own AI contexts:

* Create, read, update and delete context

These contexts are later used by the AI while generating responses.

### User Data

Authenticated users can:

* Save conversations
* Manage and customize contexts
* Access their personalized assistant setup

Guest users can still chat with the AI with default context, but their conversations aren't stored.

---

## Architecture

```text
Flutter
   │
   ▼
Firebase Authentication
   │
   ▼
Node.js Backend
   │
   ├── JWT Authorization
   ├── Context Management
   ├── Conversation Management
   ├── User Management
   │
   ▼
OpenAI API

Cloud Firestore
   ├── Users
   ├── Contexts
   └── Conversations
```

---

## Why I Built This

I wanted to understand what actually happens behind AI applications beyond simply calling an API.

While building AIDA, I have been exploring:

* Authentication and authorization
* Firestore database design
* Backend architecture
* REST APIs
* JWT authentication
* Email verification workflows
* Context engineering
* AI application development

The project continues to evolve as I learn new concepts and improve the system.

---

Built as part of my journey into mobile, backend, and AI application development.
