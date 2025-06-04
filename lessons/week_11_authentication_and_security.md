# Week 11: App Security: Authentication and Authorization

- [Week 11: App Security: Authentication and Authorization](#week-11-app-security-authentication-and-authorization)
  - [Authentication vs Authorization](#authentication-vs-authorization)
  - [Authentication for Web Applications](#authentication-for-web-applications)
    - [Authentication Methods](#authentication-methods)
    - [Security Best Practices: Password Authentication](#security-best-practices-password-authentication)
      - [Use secure password storage](#use-secure-password-storage)
      - [Enforce strong password policies](#enforce-strong-password-policies)
      - [Rate-limit authentication endpoints](#rate-limit-authentication-endpoints)
      - [Transport security](#transport-security)
      - [Email verification](#email-verification)
      - [Password Reset Security](#password-reset-security)
      - [Monitoring and Logging](#monitoring-and-logging)
      - [Avoid Common Pitfalls](#avoid-common-pitfalls)
  - [Stateless Vs Stateful Authentication](#stateless-vs-stateful-authentication)
    - [Stateful Authentication](#stateful-authentication)
    - [Stateless Authentication](#stateless-authentication)
  - [Implementing Session-based Authentication in Rails](#implementing-session-based-authentication-in-rails)

## Authentication vs Authorization

Authentication and Authorization are related, but separate concepts that can be easily confused.

| Concept        | Definition                                                                  |
| -------------- | --------------------------------------------------------------------------- |
| Authentication | Verifying **who the user is** (login, password check).                      |
| Authorization  | Verifying **what the user is allowed to do** (permissions, access control). |

> **Example**
>
> - Authentication: Logging in as `alice@example.com`
> - Authorization: Checking if Alice can edit a particular post.

## Authentication for Web Applications

Authentication is a constantly evolving field in today’s digital landscape.

### Authentication Methods

From traditional passwords to passkeys, OmniAuth, multi-factor authentication, and biometric verification, developers are continually adapting to ensure they can confidently verify who is accessing their applications. As threats grow more sophisticated, maintaining this assurance is critical to protecting user data and assets from malicious actors.

### Security Best Practices: Password Authentication

Email/Username and passwords remain the most popular choice. However, it is important to understand a few things about handling passwords in your web application.

#### Use secure password storage

Passwords must be stored using a strong hashing algorithm and should NEVER be stored as plain text.

#### Enforce strong password policies

The National Institute of Standards and Technology provides [explicit guidance](https://pages.nist.gov/800-63-3/sp800-63b.html) on enforcing strong password policies. These are:

- Minimum 8 characters in length
- Allow at least 64 characters in length
- Accept ASCII and Unicode characters
- Do not provide password hints
- "Compare against a list that contains values known to be commonly-used, expected, or compromised."
- Provide reason for rejection of new password that does not meet requirements
- Do not arbitrarily recommend changing passwords (eg. expiring pw after `n` days)
- Do not impose other composition rules (e.g., requiring mixtures of different character types or prohibiting consecutively repeated characters)
- Store passwords salted and hashed appropriately

#### Rate-limit authentication endpoints

- Implement rate-limiting on login attempts using [Rack::Attack](https://github.com/rack/rack-attack) or other rate-limiting middleware

#### Transport security

- Always use HTTPS to encrypt data in transit
- Secure cookies with `Secure`, `HttpOnly`, and `SameSite` attributes

#### Email verification

- Require users to verify their email during registration

#### Password Reset Security

- Use single-use, time-limited tokens for resetting passwords
- Invalid tokens after use
- Invalid sessions on password change

#### Monitoring and Logging

- Log authentication events (logins, failed logins, password changes)
- Track IP and User-Agent behavior with authentication events

#### Avoid Common Pitfalls

- Do not output secure information in logs or error messages
- Do not use `GET` requests on authentication endpoints
- Do not confirm the existence of a user on login or password reset errors

---

## Stateless Vs Stateful Authentication

As applications grow more complex and distributed, the way we manage user authentication must adapt accordingly. One of the fundamental architectural decisions developers face is whether to use **stateful** or **stateless** authentication.

Both approaches aim to verify and maintain a user’s identity across requests — but they do so in very different ways, each with its own trade-offs in terms of scalability, security, performance, and ease of implementation.

### Stateful Authentication

In stateful authentication, the server maintains **session** state — typically by storing a session identifier (like a session ID) in memory or a database after a user logs in. The client (usually a browser) holds a session cookie and sends it with each request, allowing the server to look up the session and authenticate the user.

**Sessions + Cookies**, which we will implement in our Rails application, is an example of Stateful Authentication

Pros:

- Simple to implement in server-rendered apps
- Easier to invalidate sessions (e.g., logging out, expiring sessions)
- Better control over session lifecycle and user behavior

Cons:

- Doesn’t scale easily across multiple servers unless you centralize session storage
- Requires session store management (memory, cache, or DB)

### Stateless Authentication

In stateless authentication, the server does not store any session information. Instead, all authentication data is self-contained in the token (e.g., **JWT**). The client includes the token in each request (typically via the `Authorization` header), and the server verifies the token's signature to authenticate.

**JSON Web Tokens (JWT)** are a common example of stateless authentication.

Pros:

- Horizontally scalable — no centralized session state required
- Ideal for APIs and microservices
- Reduces server-side memory or session store load

Cons:

- More complex token management (e.g., expiration, renewal, revocation)
- Cannot easily invalidate a token unless using a token blacklist or short TTL
- Larger payload size in each request (token must include all necessary data)
- Higher potential to be less secure

---

## Implementing Session-based Authentication in Rails

- Install the `bcrypt` Gem
- Add the `:password_digest` attribute to our `User` model with a migration
- Add `has_secure_password` to the `User` model
- Create a SessionsController
- Implement views