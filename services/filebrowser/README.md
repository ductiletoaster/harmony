# FileBrowser Setup

A Docker-based setup for running [FileBrowser](https://filebrowser.org/), a lightweight web-based file manager that provides a clean interface for browsing, uploading, downloading, and managing files.

## About This Project

FileBrowser provides a **simple, web-based file management solution** that allows you to access and manage your files through a modern web interface. Perfect for managing shared storage, media files, and documents across your containerized environment.

### Key Features
- **Web-based interface** - Clean, modern UI accessible from any browser
- **File operations** - Upload, download, create, edit, and delete files
- **User management** - Built-in authentication and user permissions
- **Mobile friendly** - Responsive design works on all devices
- **Traefik integration** - Seamless reverse proxy setup
- **Lightweight** - Minimal resource usage

## Requirements

1. Install [Docker](http://docker.io).
2. (optional) Install [Docker-compose](http://docs.docker.com/compose/install/).
3. Clone this repository
4. Traefik proxy network (for reverse proxy access)

## Quick Start

### 1. Setup Environment
```bash
# Navigate to the service directory
cd services/filebrowser

# Create shared storage directory (if not exists)
mkdir -p ../../shared-storage
```

### 2. Start FileBrowser
```bash
# Start FileBrowser service
docker compose up -d
```

### 3. Access FileBrowser
Open your browser and navigate to:
- **Direct Access**: http://localhost:8334 (always available)
- **Traefik Proxy**: http://filebrowser.docker.localhost (requires Traefik setup)

### 4. Default Login
- **Username**: `admin`
- **Password**: `admin`

**⚠️ Important**: Change the default credentials immediately after first login!

## Configuration

### Environment Variables
- `PUID`: User ID for file permissions (default: 1000)
- `PGID`: Group ID for file permissions (default: 1000)
- `SHARED_STORAGE_PATH`: Path to shared storage directory (default: ../../shared-storage)

### File Access
FileBrowser provides access to:
- **Shared Storage**: Mounted at `/srv` in the container
- **Configuration**: Persistent config stored in Docker volume
- **Database**: User data and settings stored in Docker volume

### Customization
You can customize FileBrowser by:
1. Modifying user permissions and roles
2. Changing the default theme
3. Setting up custom commands
4. Configuring file sharing settings

## Project Structure

```
services/filebrowser/
├── docker-compose.yml          # Service deployment
├── README.md                   # This file
└── ../../shared-storage/       # Default file storage location
```

## Usage

### Daily Operations
1. **Start**: `docker compose up -d`
2. **Stop**: `docker compose down`
3. **Logs**: `docker compose logs -f`
4. **Update**: `docker compose pull && docker compose up -d`

### File Management
1. **Upload Files**: Drag and drop or use the upload button
2. **Create Folders**: Use the "New" button to create directories
3. **Edit Files**: Built-in editor for text files
4. **Share Files**: Generate shareable links for files
5. **Search**: Use the search function to find files quickly

### User Management
1. Access the settings panel
2. Create additional users with specific permissions
3. Set up folder-level access controls
4. Configure user quotas if needed

## Troubleshooting

### Common Issues
1. **Permission errors**: Check PUID/PGID match your user ID
2. **Port conflicts**: Change the external port mapping if 8334 is in use
3. **Storage not accessible**: Verify the shared storage path exists and is readable
4. **Traefik not accessible**: Ensure proxy network exists and Traefik is running
5. **Can't login**: Reset to default admin/admin and change password

### Logs and Debugging
```bash
# View logs
docker compose logs filebrowser

# Check container status
docker compose ps

# Access container shell
docker compose exec app sh

# Check file permissions
ls -la ../../shared-storage/
```

### Reset Configuration
```bash
# Stop service and remove volumes to reset
docker compose down
docker volume rm filebrowser_filebrowser_config filebrowser_filebrowser_database
docker compose up -d
```

## Security Considerations

1. **Change default password** - Always change admin/admin on first login
2. **Use HTTPS** - Enable TLS in Traefik for production use
3. **Limit network access** - Consider firewall rules for port 8334
4. **Regular backups** - Backup configuration and database volumes
5. **User permissions** - Follow principle of least privilege for additional users

## Integration with Other Services

FileBrowser works well with other services in this stack:
- **Traefik**: Automatic reverse proxy and SSL termination
- **ComfyUI**: Easy access to generated images and models
- **InvokeAI**: Browse and manage AI-generated content
- **Syncthing**: Web interface for synced files

## References
- [FileBrowser Official Documentation](https://filebrowser.org/)
- [FileBrowser Docker Hub](https://hub.docker.com/r/filebrowser/filebrowser)
- [FileBrowser GitHub Repository](https://github.com/filebrowser/filebrowser)
