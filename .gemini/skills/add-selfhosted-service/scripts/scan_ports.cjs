#!/usr/bin/env node

/**
 * Port Scanner Script for add-selfhosted-service Skill
 * Finds all fallback ports mapped in services/ directories and identifies the next available port >= 8100 (or >= 8500 in private repo).
 */

const fs = require('fs');
const path = require('path');

const CWD = process.cwd();
const isPrivate = CWD.includes('self-hosted-private');
const START_PORT = isPrivate ? 8500 : 8100;
const SERVICES_DIR = path.resolve(CWD, 'services');

function scanPorts() {
  if (!fs.existsSync(SERVICES_DIR)) {
    console.error(`Error: Services directory not found at ${SERVICES_DIR}`);
    process.exit(1);
  }

  const portsInUse = new Set();
  const serviceFiles = [];

  // Traverse the services directory for compose.yaml files
  try {
    const services = fs.readdirSync(SERVICES_DIR);
    for (const service of services) {
      const servicePath = path.join(SERVICES_DIR, service);
      if (fs.statSync(servicePath).isDirectory()) {
        const composePath = path.join(servicePath, 'compose.yaml');
        if (fs.existsSync(composePath)) {
          serviceFiles.push({ name: service, path: composePath });
        }
      }
    }
  } catch (err) {
    console.error('Error reading services directory:', err.message);
    process.exit(1);
  }

  // Regex to extract host ports from port bindings:
  // Matches expressions like:
  // - "8101:80"
  // - "${BIND_IP:-127.0.0.1}:8103:3000"
  // - '${BIND_IP:-127.0.0.1}:8100:3000'
  // - "${PIHOLE_WEB_PORT:-8087}:80/tcp"
  // - "${BIND_IP:-127.0.0.1}:${DUMBASSETS_PORT:-3030}:3000"
  const portRegex = /-\s*['"]?(?:[^\s:]+:)?(?:\$\{[A-Z_]+:-)?(\d+)\s*\}?:\d+['"]?/g;

  for (const file of serviceFiles) {
    try {
      const content = fs.readFileSync(file.path, 'utf8');
      let match;
      // Reset regex index for safety
      portRegex.lastIndex = 0;
      while ((match = portRegex.exec(content)) !== null) {
        const port = parseInt(match[1], 10);
        if (!isNaN(port)) {
          portsInUse.add(port);
        }
      }
    } catch (err) {
      console.error(`Error reading ${file.path}:`, err.message);
    }
  }

  // Find the next available port starting from the appropriate boundary
  let nextPort = START_PORT;
  while (portsInUse.has(nextPort)) {
    nextPort++;
  }

  // Print results
  console.log(`--- Port Scan Results (${isPrivate ? 'Private Repo' : 'Public Repo'}) ---`);
  console.log(`Fallback ports currently in use: [ ${Array.from(portsInUse).sort((a,b)=>a-b).join(', ')} ]`);
  console.log(`Next available sequential fallback port: ${nextPort}`);
  console.log('--------------------------------------------');

  return nextPort;
}

scanPorts();
