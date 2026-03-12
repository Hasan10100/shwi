# Base node image
FROM node:20-alpine AS build

# Set working directory for common dependencies
WORKDIR /app

# Copy root package files
COPY package*.json ./

# Copy backend and frontend package files
COPY backend/package*.json ./backend/
COPY frontend/package*.json ./frontend/

# Install all dependencies
RUN npm install
RUN cd backend && npm install
RUN cd frontend && npm install

# Copy source code
COPY backend ./backend
COPY frontend ./frontend

# Build frontend
WORKDIR /app/frontend
RUN npm run build

# Production image
FROM node:20-alpine AS production

WORKDIR /app

# Copy root package files
COPY package*.json ./

# Copy backend package files
COPY backend/package*.json ./backend/

# Install only production dependencies for the backend
RUN npm install --omit=dev
RUN cd backend && npm install --omit=dev

# Copy backend source code
COPY backend ./backend

# Copy built frontend dist to expected location
COPY --from=build /app/frontend/dist ./frontend/dist

# Expose backend port
EXPOSE 5000

# Set environment variable to production so backend serves frontend correctly
ENV NODE_ENV=production

# Start backend server
CMD ["npm", "start", "--prefix", "backend"]
