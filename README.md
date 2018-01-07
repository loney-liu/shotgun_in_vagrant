# shotgun_in_vagrant
**Test OS**
- MacOS

**How to use**
- `mkdir sg` or whatever you like.
- `cd sg`
- `git clone https://github.com/loney-liu/shotgun_in_vagrant.git`
- `cd shotgun_in_vagrant`
- **Copy shotgun docker images to `images` folder (file formate please read `images/README.md`)**
- `vagrant up`
- Access 
  - shotgun: `http://127.0.0.1:8888`    
  - sec: `http://127.0.0.1:9999`
- Stop `vagrant halt`

**Change Version**
- `vagrant destroy shotgun_in_vagrant` 
- **Copy new shotgun docker images to `images` folder**
- Edit shotgun versions in script/shotgun_global
  - `APPVER="7.5.2.0"`
- `vagrant up`

**Rebuild Image**
- `vagrant halt`
- `vagrant up --provision`

**Tested version**
- *shotgun*
  - `7.5.2`
  - `7.4.3`
- *transcoder*
  - `transcoder-worker 8.2.5`
  - `transcoder-server 5.0.7`
- *sec*
  - `1.2.1`
