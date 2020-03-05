# Plex (Dockerized)

This is a project that puts [Plex](https://www.plex.tv/) inside a container and is specifically designed to work with
[this](https://github.com/sonofborge/dockerize-traefik) Traefik project.

## Requirements

*   [Docker](https://docs.docker.com/install/)
*   [Docker Compose](https://docs.docker.com/compose/install/)
*   A linux box to deploy to ;)

## Up and Running

1.  Pull down the repo

    ```sh
    git clone https://github.com/sonofborge/dockerize-plex.git plex
    ```

1.  Create and modify `.env` for your needs.

    ```sh
    cp .env.example .env
    ```

    **Note:**

    You will need to generate a plex claim code to add to your `.env` file,
    which can be done at
    [this](https://www.plex.tv/claim/)
    url.

1.  Run Docker Compose

    ```sh
    docker-compose up -d
    ```

If all went well,
you should now be running Plex inside a container behind your
[Traefik reverse proxy](https://github.com/sonofborge/dockerize-traefik).

## Add Content from a Network Share

Assuming you are using Network Attached Storage (NAS) to house the content you want Plex to serve,
you will need to make some additional changes to the host in order to share that content with the Plex shared volume.

### On the NAS

1.  Enable [Network File System (NFS)](https://help.ubuntu.com/lts/serverguide/network-file-system.html).
    For [OpenMediaVault](https://www.openmediavault.org/),
    assuming you've set up shared folders,
    click on **Services > NFS**

1.  Next, click on **Shares** then click the **Add** button.

1.  Fill out the form.
    Select the **Shared Folder** you want available to the server and enter the server IP under **Client**.
    **Privilege** should be "Read only".
    Under **Extra options**, add `subtree_check,insecure,no_root_squash`.

### On the Host Server

1.  Ensure that the `nfs-common` library is installed.
    If not,
    install it.

    ```sh
    sudo apt update && sudo apt install nfs-common
    ```

1.  Now we need to edit `/etc/fstab` and tell it where it can find the network shared folders.
    Add the following line,
    substituting the NAS local IP and the name of the shared files:

    ```sh
    ...
    192.168.1.<XXX>:/export/<share_name> /media/nas/<share_name> nfs auto,defaults,nofail 0 0
    ```

    Add as many shares as that you want Plex to have access to,
    save,
    and exit.

1.  Next,
    make the `<share_name>` files on the Host system,
    otherwise it will complain that the directory doesn't exist:

    ```sh
    sudo mkdir /media/nas/<share_name>
    ```

1.  Finally,
    mount the drives.

    ```sh
    sudo mount -a
    ```

Your media should now be shared with the docker volume and available on the host at `/media/nas`.
