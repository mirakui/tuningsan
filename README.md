tuningsan
=========
https://speakerdeck.com/mirakui/quan-zi-dong-parametatiyuningusan

# How to run a demo
1. clone this repository
```
$ git clone https://github.com/mirakui/tuningsan.git
```

2. run unicorn
```
$ cp example/config/unicorn.conf.sample example/config/unicorn.conf
$ unicorn -D -c example/config/unicorn.conf example/config.ru
```

3. run tuningsan agent
```
$ bin/agent plans/demo_unicorn.yml
```

4. run tuningsan tuner (with another terminal window)
```
$ bin/tuner plans/demo_unicorn.yml
```

5. check out unicorn.conf tuned!
```
$ diff example/config/unicorn.conf.sample example/config/unicorn.conf
3c3
< worker_processes 1
---
> worker_processes 17
```
