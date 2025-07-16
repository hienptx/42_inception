WordPress with PHP-FPM refers to running the WordPress application (which is written in PHP) using the PHP FastCGI Process Manager (PHP-FPM).

- WordPress: A popular open-source content management system (CMS) for building websites and blogs.
- PHP-FPM (FastCGI Process Manager): A PHP implementation designed to handle high loads efficiently. It manages pools of PHP worker processes and is commonly used with web servers like Nginx or Apache.

### Why use PHP-FPM with WordPress?

- PHP-FPM is faster and more efficient than running PHP as an Apache module.
- It allows better resource management and scalability.
- It is the recommended way to run PHP with Nginx (since Nginx cannot run PHP code directly).

### Typical stack:
Nginx (or Apache) → PHP-FPM → WordPress → MySQL

Summary:
"WordPress with PHP-FPM" means WordPress is served by a web server that passes PHP requests to PHP-FPM for processing.

## TLS Overview
TLS encrypts data transmitted between clients (browsers) and servers, ensuring:

- Confidentiality: Data can't be read by eavesdroppers
- Integrity: Data can't be modified without detection
- Authentication: Verification that you're communicating with the intended server

### TLSv1.2 (Released 2008)

- Widely supported: Compatible with older browsers and systems
- Mature protocol: Well-tested and stable
- Cipher suites: Supports various encryption algorithms (AES, ChaCha20, etc.)
- Hash algorithms: SHA-256, SHA-384
- Key exchange: RSA, ECDHE, DHE methods
- Handshake: Requires 2 round trips to establish connection

### TLSv1.3 (Released 2018)

- Improved security: Removed vulnerable cipher suites and algorithms
- Better performance: Only 1 round trip needed for handshake (faster connections)
- Perfect Forward Secrecy: Mandatory use of ephemeral key exchange
- Simplified cipher suites: Fewer, more secure options
- 0-RTT support: Can resume connections with zero round trips
- Stronger algorithms: ChaCha20-Poly1305, AES-GCM required

### Key Differences
FeatureTLSv1.2TLSv1.3Handshake speed2 round trips1 round tripSecurityGoodEnhancedCipher suitesMany optionsSimplified, secure-onlyForward secrecyOptionalMandatoryBrowser supportUniversalModern browsers
Why Both Are Important
TLSv1.2: Still needed for compatibility with older systems and browsers
TLSv1.3: Preferred for modern applications due to better security and performance
In Practice (NGINX example):
nginx# Support both for compatibility
ssl_protocols TLSv1.2 TLSv1.3;

# Only TLS 1.3 (most secure, but may break older clients)
ssl_protocols TLSv1.3;
Most modern setups use both to balance security and compatibility. TLS 1.3 is automatically used when both client and server support it, falling back to TLS 1.2 for older clients.

## 🔄 What Is FastCGI?
FastCGI is a protocol that allows a web server (like Nginx) to communicate with a backend process that handles dynamic content, such as PHP scripts.

In simple terms:
Nginx serves static files (HTML, CSS, images).

For dynamic PHP files (index.php, wp-login.php, etc), it forwards the request to PHP-FPM using FastCGI.

## Create self-signed certs
mkdir -p certs/
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout certs/privkey.pem \
  -out certs/fullchain.pem \
  -subj "/CN=hien.42.fr"