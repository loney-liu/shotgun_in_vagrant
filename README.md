# shotgun_in_vagrant

1. Copy shotgun docker images to images folder
2. Edit shotgun versions in script/shotgun_global
3. vagrant up --provision
4. Access 
   - Shotgun: http://127.0.0.1:8888    
   - SEC: http://127.0.0.1:9999
5. vagrant halt

*Tested*

- `shotgun 7.5.2`
- `shotgun 7.4.3`
- `transcoder-worker 8.2.5`
- `transcoder-worker 5.0.7`
- `sec 1.2.1`
