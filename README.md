# shotgun_in_vagrant
**Test OS**
- MacOS

**How to use**
- `mkdir sg` or whatever you like.
- `git clone https://github.com/loney-liu/shotgun_in_vagrant.git`
- `cd sg`
- **Copy shotgun docker images to `images` folder (file formate please read `images/README.md`)**
- `vagrant up`
- Access 
  - shotgun: `http://127.0.0.1:8888`    
  - sec: `http://127.0.0.1:9999`
- `vagrant halt`

**Change Version**
- `vagrant destroy shotgun_in_vagrant` 
- Copy shotgun docker images to images folder
- Edit shotgun versions in script/shotgun_global
  - `APPVER="7.5.2.0"`
- `vagrant up`

**Rebuild Image**
- `vagrant halt`
- `vagrant up --provision`

**Tested version**
*shotgun*
- `shotgun 7.5.2`
- `shotgun 7.4.3`
*transcoder*
- `transcoder-worker 8.2.5`
- `transcoder-worker 5.0.7`
*sec*
- `sec 1.2.1`
