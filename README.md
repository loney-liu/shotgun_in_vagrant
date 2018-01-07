# shotgun_in_vagrant
**How to use**
- Copy shotgun docker images to images folder
- Edit shotgun versions in script/shotgun_global
  - `APPVER="7.4.3.0"`
- vagrant up --provision
- Access 
  - shotgun: `http://127.0.0.1:8888`    
  - sec: `http://127.0.0.1:9999`
- vagrant halt

**Tested version**

- `shotgun 7.5.2`
- `shotgun 7.4.3`
- `transcoder-worker 8.2.5`
- `transcoder-worker 5.0.7`
- `sec 1.2.1`
